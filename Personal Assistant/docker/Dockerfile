# Dockerfile for LLM deployment on Google Cloud Run with pre-built model
FROM ollama/ollama:latest

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_PORT=8080
ENV PORT=8080

# Create necessary directories
RUN mkdir -p /root/.ollama

# Start Ollama in background and pre-download the model
RUN ollama serve & \
    sleep 10 && \
    ollama pull phi3:mini && \
    pkill ollama

# Copy optimized startup script
COPY startup-prebuilt.sh /startup.sh
RUN chmod +x /startup.sh

# Expose port for Cloud Run
EXPOSE 8080

# Start Ollama server (model already downloaded)
CMD ["/startup.sh"]
