# Quick LlamaCPP Docker

A lightweight, efficient Docker setup to host local LLMs and Embedding models using the high-performance [llama.cpp](https://github.com/ggml-org/llama.cpp) server.

It provides an OpenAI-compatible API for both Chat (Qwen 2.5) and Embeddings (all-MiniLM-L6-v2), making it perfect for integration with tools like **n8n**, **Flowise**, or custom apps.

## 🚀 Features

*   **Chat Model:** [Qwen 2.5 3B Instruct](https://huggingface.co/Qwen/Qwen2.5-3B-Instruct) (Fast, smart, and low memory usage).
*   **Embedding Model:** [all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) (Standard for RAG applications).
*   **OpenAI Compatible:** Drop-in replacement for OpenAI API endpoints.
*   **Easy Setup:** Single script to build images and download models.

## 🛠️ Setup

### 1. Prerequisites
*   Docker & Docker Compose installed on your machine.
*   Approx **3 GB** of free disk space for models.

### 2. Installation
Run the setup script. This will build the customized Docker image and download the GGUF models automatically.

```bash
chmod +x setup.sh
./setup.sh
```

### 3. Start Services
Spin up the containers.

```bash
docker compose up -d
```

This starts two services:
*   **Chat API:** `http://localhost:8080`
*   **Embeddings API:** `http://localhost:8081`

---

## 📖 Usage Examples

### Chat Completion (Port 8080)
Works with OpenAI's `/v1/chat/completions` endpoint.

**cURL:**
```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      { "role": "system", "content": "You are a helpful assistant." },
      { "role": "user", "content": "Explain quantum computing in one sentence." }
    ]
  }'
```

### Embeddings (Port 8081)
Works with OpenAI's `/v1/embeddings` endpoint.

**cURL:**
```bash
curl http://localhost:8081/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "input": "The food was delicious and the waiter..."
  }'
```

---

## 🔗 Connecting to n8n (Docker)

If you are running **n8n** in a Docker container on the same machine, you cannot use `localhost`. You must use the host's Docker IP (usually `172.17.0.1` on Linux).

### Chat Node (OpenAI Chat Model)
*   **Base URL:** `http://172.17.0.1:8080/v1`
*   **API Key:** `sk-no-key-required` (Enter anything, it's ignored)
*   **Model:** `qwen` (or leave default)

### Embeddings Node (OpenAI Embeddings)
*   **Base URL:** `http://172.17.0.1:8081/v1`
*   **API Key:** `sk-no-key-required`

---

## 📁 Project Structure

*   `Dockerfile`: Minimal build of llama.cpp server.
*   `docker-compose.yml`: Orchestrates the Chat and Embedding services.
*   `setup.sh`: Automates building and model downloading.
*   `models/`: Directory where `.gguf` models are stored (ignored by git).
