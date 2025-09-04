# 📋 Template Usage Guide

## 🎯 **How to Create New LLM Instances**

Your `Template` folder contains everything needed to deploy a new LLM instance. Here's how to use it:

### **Step 1: Copy the Template**
1. **Copy** the entire `Template` folder
2. **Rename** it based on your use case:
   - `Personal-Assistant` ✅ (you already created this!)
   - `Business-Analytics`
   - `Code-Helper`
   - `Creative-Writer`
   - `Customer-Support`
   - etc.

### **Step 2: Customize the Configuration**
For each new instance, edit these key files:

#### **Required Edit: `deploy/cloud-run-deploy.sh`**
```bash
# Line 9: Change to your Google Cloud Project ID
PROJECT_ID="your-actual-project-id"

# Line 10: Give it a unique service name
SERVICE_NAME="personal-assistant"  # or "business-analytics", etc.

# Line 13: Choose the right model for your use case
MODEL_NAME="phi3:mini"  # See model options below
```

#### **Optional: Customize Resources**
```bash
# Line 37-42: Adjust resources based on your needs
--memory 4Gi      # 2Gi for light use, 8Gi for heavy use
--cpu 2           # 1 for light use, 4 for heavy use
--max-instances 5 # 2 for personal, 10 for business
```

### **Step 3: Deploy**
```bash
# Navigate to your new instance folder
cd "Personal Assistant"  # or whatever you named it

# Run the deployment
./deploy/cloud-run-deploy.sh
```

## 🧠 **Model Selection Guide**

### **For Personal Assistant:**
- **Model**: `phi3:mini` or `llama2:7b`
- **Memory**: 2-4GB
- **Best for**: General questions, daily tasks, learning

### **For Business Analytics:**
- **Model**: `llama2:7b` or `llama2:13b`
- **Memory**: 4-8GB  
- **Best for**: Data analysis, reports, business insights

### **For Code Helper:**
- **Model**: `codellama:7b` or `codellama:13b`
- **Memory**: 4-8GB
- **Best for**: Code generation, debugging, documentation

### **For Creative Writing:**
- **Model**: `mistral:7b` or `llama2:7b`
- **Memory**: 4-6GB
- **Best for**: Content creation, storytelling, marketing copy

### **For Customer Support:**
- **Model**: `llama2:7b` (fine-tune with your data)
- **Memory**: 4-8GB
- **Best for**: FAQ responses, ticket handling, chat support

## 💰 **Cost Planning by Instance**

### **Personal Use Instances:**
- **Personal Assistant**: $5-15/month
- **Code Helper**: $10-25/month
- **Creative Writer**: $8-20/month

### **Business Use Instances:**
- **Customer Support**: $30-80/month
- **Business Analytics**: $40-120/month
- **Content Generator**: $25-60/month

## 🔄 **Template Maintenance**

### **Updating the Template:**
When you want to improve the base template:
1. Make changes in the `Template` folder
2. Copy updated files to existing instances as needed
3. Redeploy instances that need updates

### **Version Control:**
Consider adding version numbers to your template:
```
Template-v1.0/
Template-v1.1/
etc.
```

## 📊 **Instance Management**

### **Recommended Naming Convention:**
- `Personal-Assistant` (your daily AI helper)
- `Business-Analytics` (data analysis and insights)
- `Code-Helper` (programming assistance)
- `Creative-Writer` (content generation)
- `Customer-Support` (business customer service)

### **Project Organization:**
Each instance can use:
- **Same Google Cloud Project**: Easier billing, shared quotas
- **Separate Projects**: Complete isolation, separate billing

## 🚀 **Quick Deployment Checklist**

For each new instance:
- [ ] Copy Template folder
- [ ] Rename folder appropriately
- [ ] Edit `PROJECT_ID` in deployment script
- [ ] Edit `SERVICE_NAME` to be unique
- [ ] Choose appropriate `MODEL_NAME`
- [ ] Adjust memory/CPU if needed
- [ ] Run deployment script
- [ ] Test with Python client
- [ ] Set up cost monitoring

## 💡 **Pro Tips**

1. **Start Small**: Begin with Phi-3 Mini for all instances, upgrade as needed
2. **Monitor Costs**: Each instance has independent cost tracking
3. **Shared Resources**: Use the same Google Cloud project to share free tier benefits
4. **Gradual Scaling**: Start with minimal resources, scale up based on actual usage
5. **Backup Template**: Keep the original Template folder unchanged as your master copy

Ready to deploy your Personal Assistant? Just edit that one line in the deployment script with your Google Cloud Project ID and you're good to go!
