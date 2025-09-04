# Quick Setup Instructions for Your LLM Deployment

## 🚀 Getting Started (15 minutes)

### Step 1: Prepare Your Google Cloud Project
```bash
# Install Google Cloud CLI if not already installed
# Visit: https://cloud.google.com/sdk/docs/install

# Authenticate with your Google account
gcloud auth login

# Create a new project (or use existing)
gcloud projects create your-llm-project-id
gcloud config set project your-llm-project-id

# Enable billing (required for Cloud Run)
# Go to: https://console.cloud.google.com/billing
```

### Step 2: Deploy Your First LLM
```bash
# Clone or download the files to your local machine
# Navigate to the project directory

# Make the deployment script executable
chmod +x deploy/cloud-run-deploy.sh

# Edit the deployment script with your project ID
# Replace "your-project-id" in deploy/cloud-run-deploy.sh

# Run the deployment
./deploy/cloud-run-deploy.sh
```

### Step 3: Test Your LLM
```bash
# Install Python dependencies
pip install -r requirements.txt

# Set your service URL (you'll get this from the deployment)
export LLM_SERVICE_URL="https://your-service-url.run.app"

# Test the LLM
python api/llm-client.py
```

## 💰 Cost Optimization Tips

### Immediate Cost Savings
1. **Use the smallest model first**: Start with `phi3:mini` (3.8B parameters)
2. **Set memory limits**: Use 2-4GB RAM initially
3. **Configure auto-scaling**: Min instances = 0, Max = 3
4. **Monitor usage**: Set up billing alerts at $25, $50

### Model Recommendations by Use Case

| Use Case | Model | RAM Needed | Est. Cost/Month |
|----------|--------|------------|-----------------|
| Personal Assistant | phi3:mini | 2GB | $5-15 |
| Business Q&A | llama2:7b | 4GB | $15-40 |
| Code Generation | codellama:7b | 4GB | $20-50 |
| Advanced Tasks | mistral:7b | 6GB | $30-80 |

## 🔧 Customization Options

### 1. Switch Models
```bash
# Update the model in your deployment
export OLLAMA_MODEL="llama2:7b"
# Redeploy with new model
```

### 2. Add Authentication
```python
# Add to your Cloud Run service
gcloud run services update llm-service \
    --remove-env-vars=ALLOW_UNAUTHENTICATED
```

### 3. Custom Domain
```bash
# Map your domain to the service
gcloud run domain-mappings create \
    --service=llm-service \
    --domain=your-domain.com
```

## 📊 Monitoring Setup

### 1. Cost Monitoring
```bash
# Set up billing alerts
python monitoring/cost-monitor.py
```

### 2. Performance Monitoring
- Check Cloud Run metrics in Google Cloud Console
- Monitor response times and error rates
- Set up uptime checks

## 🚨 Important Notes

1. **Free Tier**: Google Cloud gives $300 credit for new accounts
2. **Billing**: Always set up billing alerts to avoid surprises
3. **Security**: Don't expose your LLM publicly without authentication
4. **Scaling**: Start small and scale based on actual usage

## 🆘 Troubleshooting

### Common Issues
1. **"Permission denied"**: Run `gcloud auth login`
2. **"Billing not enabled"**: Enable billing in Cloud Console
3. **"Service not found"**: Check your project ID and region
4. **High costs**: Reduce max instances or use smaller model

### Getting Help
- Check Google Cloud Run documentation
- Monitor logs: `gcloud run logs tail llm-service`
- Test locally first with Docker

## 📈 Next Steps After Basic Setup

1. **Week 1**: Monitor costs and usage patterns
2. **Week 2**: Experiment with different models
3. **Month 1**: Add authentication and custom features
4. **Month 2**: Consider fine-tuning for your specific needs

Remember: Start simple, monitor costs, and scale gradually based on your actual needs!
