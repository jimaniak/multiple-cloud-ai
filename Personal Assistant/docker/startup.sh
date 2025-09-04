#!/bin/bash

# Set up environment
export OLLAMA_HOST=0.0.0.0
export OLLAMA_PORT=8080

# Start Ollama server in background
echo "Starting Ollama server..."
ollama serve &
OLLAMA_PID=$!

# Wait for server to be ready
echo "Waiting for Ollama server to start..."
for i in {1..60}; do
    if curl -s http://localhost:8080/api/tags > /dev/null 2>&1; then
        echo "Ollama server is ready!"
        break
    fi
    echo "Waiting... attempt $i/60"
    sleep 2
done

# Pull the model
MODEL_NAME=${OLLAMA_MODEL:-"phi3:mini"}
echo "Pulling model: $MODEL_NAME"
ollama pull $MODEL_NAME

echo "Model ready. Server is running on port 8080"
echo "Health check endpoint: http://localhost:8080/api/tags"

# Keep the container running and monitor Ollama process
wait $OLLAMA_PID
