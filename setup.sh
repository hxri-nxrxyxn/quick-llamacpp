#!/bin/bash
set -e

# Config
IMAGE_NAME="local-llama-server:latest"
MODEL_DIR="./models"

echo "📂 Ensuring directory structure..."
mkdir -p "$MODEL_DIR"

# 1. Build Docker Image (Skip if exists)
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "🔨 Building Docker image..."
    docker build -t "$IMAGE_NAME" .
else
    echo "✅ Docker image exists. Skipping build."
fi

# 2. Download Qwen 2.5 3B (Bartowski Repo - Safe Link)
# We use the Q4_K_M version (~2.0 GB).
if [ ! -f "$MODEL_DIR/qwen2.5-3b-instruct-q4_k_m.gguf" ]; then
    echo "⬇️  Downloading Qwen 2.5 3B..."
    wget -c -O "$MODEL_DIR/qwen2.5-3b-instruct-q4_k_m.gguf" \
        https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF/resolve/main/Qwen2.5-3B-Instruct-Q4_K_M.gguf
    else
        echo "✅ Qwen 3B model already exists."
    fi
    
    # 3. Download all-MiniLM-L6-v2 (Embedding Model)
    if [ ! -f "$MODEL_DIR/all-MiniLM-L6-v2-f16.gguf" ]; then
        echo "⬇️  Downloading all-MiniLM-L6-v2..."
        wget -c -O "$MODEL_DIR/all-MiniLM-L6-v2-f16.gguf" \
        https://huggingface.co/second-state/All-MiniLM-L6-v2-Embedding-GGUF/resolve/main/all-MiniLM-L6-v2-ggml-model-f16.gguf
    else
        echo "✅ all-MiniLM-L6-v2 model already exists."
    fi
    
    echo "🎉 Setup complete! Running with Qwen 3B and all-MiniLM-L6-v2."