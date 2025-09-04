#!/bin/bash

# Google Cloud Run Deployment Script for LLM
# Make sure you have gcloud CLI installed and authenticated

set -e

# Load configuration from config.env file
if [ -f "config.env" ]; then
    echo "📋 Loading configuration from config.env..."
    source config.env
else
    echo "❌ config.env file not found! Please create it first."
    echo "💡 Copy config.env.example to config.env and update with your values."
    echo ""
    echo "Quick setup:"
    echo "  cp config.env.example config.env"
    echo "  nano config.env  # Edit with your project ID"
    echo ""
    exit 1
fi

# Validate required configuration
if [ "$PROJECT_ID" = "your-project-id-here" ] || [ -z "$PROJECT_ID" ]; then
    echo "❌ Please update PROJECT_ID in config.env with your actual Google Cloud project ID"
    exit 1
fi

if [ "$SERVICE_NAME" = "your-service-name" ] || [ -z "$SERVICE_NAME" ]; then
    echo "❌ Please update SERVICE_NAME in config.env with a unique service name"
    exit 1
fi

# Derived configuration
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "🎯 Deployment Configuration:"
echo "  Project ID: $PROJECT_ID"
echo "  Service Name: $SERVICE_NAME"
echo "  Region: $REGION"
echo "  Model: $MODEL_NAME"
echo "  Resources: $CPU CPU, $MEMORY RAM"
echo ""

echo "🚀 Starting LLM deployment to Google Cloud Run..."

# Set the project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "📋 Enabling required APIs..."
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Build and push the Docker image
echo "🔨 Building Docker image..."
gcloud builds submit --tag $IMAGE_NAME ./docker/

# Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
DEPLOY_CMD="gcloud run deploy $SERVICE_NAME \
    --image $IMAGE_NAME \
    --platform managed \
    --region $REGION \
    --memory $MEMORY \
    --cpu $CPU \
    --timeout $TIMEOUT \
    --concurrency $CONCURRENCY \
    --min-instances $MIN_INSTANCES \
    --max-instances $MAX_INSTANCES \
    --set-env-vars OLLAMA_MODEL=$MODEL_NAME \
    --port 8080"

# Add authentication setting based on config
if [ "$ALLOW_UNAUTHENTICATED" = "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --allow-unauthenticated"
fi

# Execute deployment
eval $DEPLOY_CMD

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")

echo "✅ Deployment complete!"
echo "🌐 Service URL: $SERVICE_URL"
echo "📊 Test your LLM: curl -X POST $SERVICE_URL/api/generate -d '{\"model\":\"$MODEL_NAME\",\"prompt\":\"Hello, world!\"}'"

# Set up basic monitoring
echo "📈 Setting up basic monitoring..."
gcloud alpha monitoring policies create --policy-from-file=monitoring/alert-policy.yaml
