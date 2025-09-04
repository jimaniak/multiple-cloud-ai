#!/bin/bash

# AWS ECS Deployment Script
# Deploy the same LLM setup on AWS for redundancy or cost comparison

set -e

# Configuration
AWS_REGION="us-east-1"
CLUSTER_NAME="llm-cluster"
SERVICE_NAME="llm-service"
TASK_FAMILY="llm-task"
ECR_REPO="llm-repo"
MODEL_NAME="phi3:mini"

echo "🚀 Deploying LLM to AWS ECS..."

# Create ECR repository
aws ecr create-repository --repository-name $ECR_REPO --region $AWS_REGION || true

# Get ECR login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$AWS_REGION.amazonaws.com

# Build and push Docker image
ECR_URI=$(aws sts get-caller-identity --query Account --output text).dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
docker build -t $ECR_URI ./docker/
docker push $ECR_URI

# Create ECS cluster
aws ecs create-cluster --cluster-name $CLUSTER_NAME --region $AWS_REGION || true

# Create task definition
cat > task-definition.json << EOF
{
    "family": "$TASK_FAMILY",
    "networkMode": "awsvpc",
    "requiresCompatibilities": ["FARGATE"],
    "cpu": "2048",
    "memory": "4096",
    "executionRoleArn": "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/ecsTaskExecutionRole",
    "containerDefinitions": [
        {
            "name": "llm-container",
            "image": "$ECR_URI",
            "portMappings": [
                {
                    "containerPort": 8080,
                    "protocol": "tcp"
                }
            ],
            "environment": [
                {
                    "name": "OLLAMA_MODEL",
                    "value": "$MODEL_NAME"
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/llm-service",
                    "awslogs-region": "$AWS_REGION",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]
}
EOF

# Register task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json --region $AWS_REGION

echo "✅ AWS deployment configuration created!"
echo "📋 Next steps:"
echo "1. Create VPC and subnets if not exists"
echo "2. Create security groups"
echo "3. Create ECS service"
echo "4. Set up Application Load Balancer"
