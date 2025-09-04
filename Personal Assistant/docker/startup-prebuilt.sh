#!/bin/bash

# Optimized startup script for pre-built model
echo "Starting Personal Assistant with pre-built Phi-3 Mini model..."

# Set up environment
export OLLAMA_HOST=0.0.0.0
export OLLAMA_PORT=8080

# Start Ollama server (model already downloaded during build)
echo "Starting Ollama server..."
ollama serve &
OLLAMA_PID=$!

# Wait for server to be ready (should be fast since model is pre-downloaded)
echo "Waiting for Ollama server to start..."
for i in {1..30}; do
    if curl -s http://localhost:8080/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama server is ready!"
        break
    fi
    echo "Waiting... attempt $i/30"
    sleep 1
done

# Verify model is available
echo "Checking available models..."
ollama list

echo "🚀 Personal Assistant ready on port 8080"
echo "📊 Health check: http://localhost:8080/api/tags"
echo "🤖 Model: phi3:mini (pre-loaded)"

# Keep the container running
wait $OLLAMA_PID
