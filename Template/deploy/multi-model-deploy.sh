#!/bin/bash

# Multi-Model Deployment Script
# Deploy multiple specialized LLMs for different use cases

set -e

PROJECT_ID="your-project-id"
REGION="us-central1"

# Define your models and their purposes
declare -A MODELS=(
    ["personal-assistant"]="phi3:mini"
    ["business-analyst"]="llama2:7b"
    ["code-helper"]="codellama:7b"
    ["creative-writer"]="mistral:7b"
)

echo "🚀 Deploying multiple LLM services..."

for SERVICE_NAME in "${!MODELS[@]}"; do
    MODEL_NAME="${MODELS[$SERVICE_NAME]}"
    IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"
    
    echo "📦 Building and deploying ${SERVICE_NAME} with ${MODEL_NAME}..."
    
    # Build image for this specific model
    gcloud builds submit --tag $IMAGE_NAME ./docker/ \
        --substitutions=_MODEL_NAME=$MODEL_NAME
    
    # Deploy to Cloud Run with model-specific configuration
    gcloud run deploy $SERVICE_NAME \
        --image $IMAGE_NAME \
        --platform managed \
        --region $REGION \
        --allow-unauthenticated \
        --memory 4Gi \
        --cpu 2 \
        --timeout 3600 \
        --concurrency 10 \
        --min-instances 0 \
        --max-instances 3 \
        --set-env-vars OLLAMA_MODEL=$MODEL_NAME \
        --port 8080 \
        --tag $SERVICE_NAME
    
    # Get service URL
    SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
    echo "✅ ${SERVICE_NAME} deployed: $SERVICE_URL"
done

echo "🎉 All models deployed successfully!"
echo "📋 Service URLs:"
for SERVICE_NAME in "${!MODELS[@]}"; do
    SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
    echo "  ${SERVICE_NAME}: $SERVICE_URL"
done
