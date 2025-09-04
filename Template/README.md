# LLM Deployment Template

This template provides everything you need to deploy your own Large Language Model on Google Cloud Platform.

## 🚀 **Quick Setup**

### **1. Copy this template**
```bash
cp -r Template "My-New-LLM-Instance"
cd "My-New-LLM-Instance"
```

### **2. Configure your deployment**
```bash
# Copy the example config
cp config.env.example config.env

# Edit with your actual values
nano config.env  # or use any text editor
```

### **3. Required Configuration**
Edit `config.env` and update these values:

```bash
# REQUIRED: Your Google Cloud Project ID
PROJECT_ID=your-actual-project-id

# REQUIRED: Unique service name for this instance
SERVICE_NAME=my-llm-service

# OPTIONAL: Choose your model
MODEL_NAME=phi3:mini  # or llama2:7b, mistral:7b, etc.
```

### **4. Deploy**
```bash
# Make sure you have gcloud CLI installed and authenticated
gcloud auth login

# Deploy your LLM
./deploy/cloud-run-deploy.sh
```

## 🧠 **Model Options**

| Model | Size | RAM Needed | Best For | Cost Level |
|-------|------|------------|----------|------------|
| `phi3:mini` | 3.8B | 2-4GB | Personal use, learning | $ |
| `llama2:7b` | 7B | 4-8GB | General purpose | $$ |
| `llama2:13b` | 13B | 8-16GB | Advanced tasks | $$$ |
| `mistral:7b` | 7B | 4-8GB | High quality responses | $$ |
| `codellama:7b` | 7B | 4-8GB | Code generation | $$ |

## 💰 **Expected Costs**

- **Personal use**: $5-20/month
- **Small business**: $30-100/month
- **Medium business**: $100-500/month

*Costs depend on usage, model size, and configuration*

## 🔧 **Customization**

### **Resource Configuration**
Adjust in `config.env`:
```bash
MEMORY=4Gi      # 2Gi for light use, 8Gi for heavy
CPU=2           # 1-4 cores
MAX_INSTANCES=5 # Maximum concurrent instances
```

### **Authentication**
```bash
ALLOW_UNAUTHENTICATED=true   # Public access
ALLOW_UNAUTHENTICATED=false  # Requires authentication
```

## 🛠️ **Available Scripts**

- `deploy/cloud-run-deploy.sh` - Basic Google Cloud Run deployment
- `deploy/multi-model-deploy.sh` - Deploy multiple models at once
- `deploy/environment-deploy.sh` - Environment-specific deployment
- `api/llm-client.py` - Python client for testing

## 📊 **Testing Your Deployment**

After deployment:

```bash
# Install Python dependencies
pip install -r requirements.txt

# Set your service URL (from deployment output)
export LLM_SERVICE_URL="https://your-service-url.run.app"

# Test your LLM
python api/llm-client.py
```

## 🔒 **Security Notes**

- ✅ `config.env` is automatically ignored by git
- ✅ Never commit real project IDs or credentials
- ✅ Use `config.env.example` for sharing templates
- ✅ Each instance should have its own `config.env`

## 🆘 **Troubleshooting**

### **Common Issues:**

**"config.env not found"**
- Copy `config.env.example` to `config.env`
- Update with your actual project ID

**"Permission denied"**
- Run `gcloud auth login`
- Make sure billing is enabled

**"Service already exists"**
- Change `SERVICE_NAME` in `config.env`
- Or delete existing service in Google Cloud Console

## 📚 **Documentation**

- [Main Documentation](../README.md)
- [Cost Analysis](../docs/cost-analysis.md)
- [Security Guidelines](../SECURITY.md)

---

**Ready to deploy?** Follow the Quick Setup steps above!
