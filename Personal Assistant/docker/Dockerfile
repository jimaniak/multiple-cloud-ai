# Dockerfile for LLM deployment on Google Cloud Run
FROM ollama/ollama:latest

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_PORT=8080

# Create necessary directories
RUN mkdir -p /root/.ollama

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose port for Cloud Run
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/api/tags || exit 1

# Start Ollama server
CMD ["/startup.sh"]
