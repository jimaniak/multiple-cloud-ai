# 🤖 Personal Assistant - Lowrys.org

A powerful, mobile-optimized Personal AI Assistant with tool integration, deployed on Vercel.

## 🚀 **Live Demo**
Visit: [pa.lowrys.org](https://pa.lowrys.org)

## ✨ **Features**

### 📱 **Mobile-First Design**
- Responsive design for all devices
- PWA (Progressive Web App) - installable as native app
- Touch-optimized interface
- Dark/light mode support

### 🛠️ **Powerful Tools**
- 🔍 Web Search
- 🧮 Calculator  
- 📅 Calendar Management
- 📧 Email Assistance
- 🌤️ Weather Information
- 📝 Notes & Documentation
- ✅ Task Management
- 💻 Code Generation
- 🎨 Image Analysis
- 🌍 Translation

### 🔧 **Configurable**
- Connect to your own LLM service
- Adjustable creativity (temperature)
- Response length control
- Model selection (Phi-3, Llama2, etc.)

## 🏗️ **Deployment on Vercel**

### **Prerequisites**
1. GitHub account
2. Vercel account (free)
3. Your own deployed LLM service (from the deployment scripts)

### **Deploy to Vercel Steps:**

#### **1. Push to GitHub**
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial Personal Assistant setup"

# Add GitHub remote
git remote add origin https://github.com/yourusername/personal-assistant.git
git push -u origin main
```

#### **2. Connect to Vercel**
1. Go to [vercel.com](https://vercel.com)
2. Sign in with GitHub
3. Click "New Project"
4. Import your GitHub repository
5. Configure project:
   - **Project Name**: `personal-assistant-lowrys`
   - **Framework Preset**: Other
   - **Root Directory**: `Personal Assistant`
   - **Build Command**: (leave empty)
   - **Output Directory**: `web`

#### **3. Set Custom Domain**
1. In Vercel dashboard, go to your project
2. Click "Settings" → "Domains"
3. Add domain: `pa.lowrys.org`
4. Configure DNS:
   ```
   Type: CNAME
   Name: pa
   Value: cname.vercel-dns.com
   ```

#### **4. Environment Variables (Optional)**
If you want to pre-configure settings:
```
DEFAULT_LLM_URL=https://your-llm-service.run.app
DEFAULT_MODEL=phi3:mini
```

## 🔧 **Local Development**

### **Setup**
```bash
# Clone repository
git clone https://github.com/yourusername/personal-assistant.git
cd personal-assistant/Personal\ Assistant

# Serve locally (any method)
python -m http.server 8000
# or
npx serve web
# or
php -S localhost:8000 -t web
```

### **Testing**
1. Open `http://localhost:8000`
2. Configure your LLM service URL in settings
3. Test connection and chat functionality

## 📁 **Project Structure**
```
Personal Assistant/
├── web/
│   ├── mobile-pa.html          # Main PWA application
│   ├── manifest.json           # PWA manifest
│   ├── sw.js                   # Service worker
│   ├── google-auth-team.html   # Team authentication
│   └── index.html              # Basic interface
├── vercel.json                 # Vercel configuration
├── config.env                  # LLM service configuration
├── deploy/                     # LLM deployment scripts
└── README.md                   # This file
```

## ⚙️ **Configuration**

### **LLM Service Setup**
1. Deploy your LLM using the provided scripts
2. Get your service URL (e.g., `https://personal-assistant-xyz.run.app`)
3. Configure in the web interface settings

### **Vercel Configuration**
The `vercel.json` file handles:
- Static file serving
- Custom routing
- PWA manifest serving
- Service worker configuration
- Cache headers

## 🔒 **Security**

### **Authentication Options**
- Basic username/password + TOTP
- Google Authenticator integration
- Team management for business use
- Owner-controlled user management

### **Privacy**
- Your own private LLM (no data sent to third parties)
- Client-side chat history storage
- Configurable data retention
- HTTPS encryption

## 🚀 **Performance**

### **Optimizations**
- Single HTML file deployment
- Minimal external dependencies
- Service worker caching
- Efficient mobile rendering
- Progressive enhancement

### **PWA Features**
- Offline capability
- Install prompts
- Native app experience
- Background sync (future)

## 🛠️ **Customization**

### **Branding**
- Update colors in CSS variables
- Modify icons and manifest
- Change title and descriptions
- Add custom tools

### **Tools**
Add new tools by:
1. Adding to `tools` object in JavaScript
2. Creating tool card in HTML
3. Implementing tool logic

## 📊 **Analytics & Monitoring**

### **Built-in Monitoring**
- Connection status indicators
- Error handling and reporting
- Usage statistics (local storage)
- Performance metrics

### **External Monitoring**
- Vercel Analytics (automatic)
- Custom analytics integration
- Error tracking services

## 🆘 **Troubleshooting**

### **Common Issues**

**"Cannot connect to LLM service"**
- Check service URL in settings
- Verify LLM deployment is running
- Test connection in settings panel

**"PWA not installing"**
- Ensure HTTPS (Vercel provides this)
- Check manifest.json is accessible
- Verify service worker registration

**"Tools not working"**
- Check LLM service supports tool context
- Verify model has sufficient capabilities
- Test with simpler prompts first

## 🔄 **Updates**

### **Automatic Deployment**
- Push to GitHub main branch
- Vercel automatically deploys
- Zero-downtime updates
- Rollback capability

### **Version Management**
- Service worker handles caching
- Automatic cache invalidation
- Progressive updates

## 📝 **Contributing**

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 **License**

MIT License - see LICENSE file for details.

---

**Ready to deploy?** Follow the Vercel deployment steps above and you'll have your Personal Assistant live at pa.lowrys.org in minutes! 🎉
