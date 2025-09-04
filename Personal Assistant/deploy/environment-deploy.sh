#!/bin/bash

# Environment-based Deployment Script
# Deploy to different environments with appropriate configurations

set -e

ENVIRONMENT=${1:-"dev"}  # dev, staging, prod
PROJECT_ID="your-project-id"

# Environment-specific configurations
case $ENVIRONMENT in
    "dev")
        REGION="us-central1"
        MEMORY="2Gi"
        CPU="1"
        MIN_INSTANCES="0"
        MAX_INSTANCES="2"
        MODEL="phi3:mini"
        ALLOW_UNAUTH="--allow-unauthenticated"
        ;;
    "staging")
        REGION="us-central1"
        MEMORY="4Gi"
        CPU="2"
        MIN_INSTANCES="0"
        MAX_INSTANCES="3"
        MODEL="llama2:7b"
        ALLOW_UNAUTH="--allow-unauthenticated"
        ;;
    "prod")
        REGION="us-east1"
        MEMORY="8Gi"
        CPU="4"
        MIN_INSTANCES="1"
        MAX_INSTANCES="10"
        MODEL="llama2:13b"
        ALLOW_UNAUTH=""  # Require authentication in production
        ;;
    *)
        echo "❌ Invalid environment. Use: dev, staging, or prod"
        exit 1
        ;;
esac

SERVICE_NAME="llm-service-${ENVIRONMENT}"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "🚀 Deploying to ${ENVIRONMENT} environment..."
echo "📋 Configuration:"
echo "  - Region: $REGION"
echo "  - Memory: $MEMORY"
echo "  - CPU: $CPU"
echo "  - Model: $MODEL"
echo "  - Instances: $MIN_INSTANCES-$MAX_INSTANCES"

# Build image
gcloud builds submit --tag $IMAGE_NAME ./docker/

# Deploy with environment-specific settings
gcloud run deploy $SERVICE_NAME \
    --image $IMAGE_NAME \
    --platform managed \
    --region $REGION \
    $ALLOW_UNAUTH \
    --memory $MEMORY \
    --cpu $CPU \
    --timeout 3600 \
    --concurrency 10 \
    --min-instances $MIN_INSTANCES \
    --max-instances $MAX_INSTANCES \
    --set-env-vars OLLAMA_MODEL=$MODEL,ENVIRONMENT=$ENVIRONMENT \
    --port 8080

# Set up environment-specific monitoring
if [ "$ENVIRONMENT" = "prod" ]; then
    echo "📊 Setting up production monitoring..."
    # Add production-specific alerts and monitoring
fi

SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")
echo "✅ ${ENVIRONMENT} deployment complete: $SERVICE_URL"
