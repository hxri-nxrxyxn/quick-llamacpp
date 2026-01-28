FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential cmake git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/ggml-org/llama.cpp .

# STATIC BUILD (Keep this exactly as we had it)
RUN cmake -B build \
    -DGGML_NATIVE=OFF \
    -DGGML_AVX=ON \
    -DGGML_AVX2=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF

RUN cmake --build build --config Release -j$(nproc)

# Runtime Stage
FROM debian:bookworm-slim

# Install dependencies (removed python3 as it was for the vision wrapper)
RUN apt-get update && apt-get install -y \
    libgomp1 ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/build/bin/llama-server /usr/local/bin/llama-server
COPY --from=builder /app/build/bin/llama-quantize /usr/local/bin/llama-quantize

VOLUME /models
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/llama-server"]