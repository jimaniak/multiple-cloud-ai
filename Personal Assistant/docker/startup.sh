#!/bin/bash

# Start Ollama server in background
ollama serve &

# Wait for server to be ready
echo "Waiting for Ollama server to start..."
while ! curl -s http://localhost:8080/api/tags > /dev/null; do
    sleep 2
done

echo "Ollama server is ready!"

# Pull the default model (you can change this)
MODEL_NAME=${OLLAMA_MODEL:-"phi3:mini"}
echo "Pulling model: $MODEL_NAME"
ollama pull $MODEL_NAME

echo "Model ready. Server is running on port 8080"

# Keep the container running
wait
