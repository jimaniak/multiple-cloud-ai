# 🏢 Team Authentication Setup Guide

This guide helps you set up secure team access to your AI Assistant with multiple authentication options.

## 🎯 **Authentication Options for Teams**

### **Option 1: TOTP (Authenticator Apps) - Recommended**
- ✅ **Most Secure**: Time-based codes change every 30 seconds
- ✅ **Works Offline**: No internet required for codes
- ✅ **Universal**: Works with Google Auth, Microsoft Auth, Authy, 1Password
- ✅ **Cost**: Free

### **Option 2: OAuth (Google/Microsoft)**
- ✅ **Easy Setup**: Users login with existing accounts
- ✅ **SSO Integration**: Works with company accounts
- ✅ **User Management**: Centralized through OAuth provider
- ✅ **Cost**: Free (with usage limits)

### **Option 3: Enterprise SSO**
- ✅ **Enterprise Grade**: SAML, OIDC support
- ✅ **Active Directory**: Integrates with company systems
- ✅ **Compliance**: Meets enterprise security requirements
- ✅ **Cost**: Varies by provider

## 🔧 **Implementation Options**

### **Level 1: Basic Security (Start Here)**
```javascript
// Simple username + TOTP
const authMethods = {
    username: true,
    totp: true,
    oauth: false
};
```

### **Level 2: OAuth Integration**
```javascript
// Add OAuth providers
const authMethods = {
    username: true,
    totp: true,
    google: true,
    microsoft: true
};
```

### **Level 3: Enterprise SSO**
```javascript
// Full enterprise integration
const authMethods = {
    username: true,
    totp: true,
    google: true,
    microsoft: true,
    saml: true,
    oidc: true
};
```

## 🏗️ **Backend Integration**

### **Required Backend Endpoints**

#### **1. User Management**
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
GET  /api/auth/user
```

#### **2. TOTP Management**
```
POST /api/auth/totp/setup
POST /api/auth/totp/verify
POST /api/auth/totp/disable
```

#### **3. OAuth Endpoints**
```
GET  /auth/google
GET  /auth/google/callback
GET  /auth/microsoft
GET  /auth/microsoft/callback
```

#### **4. Team Management**
```
GET  /api/team/members
POST /api/team/invite
PUT  /api/team/role
DELETE /api/team/remove
```

### **Database Schema (Example)**

```sql
-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255),
    totp_secret VARCHAR(32),
    totp_enabled BOOLEAN DEFAULT FALSE,
    role VARCHAR(50) DEFAULT 'user',
    team_id UUID,
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

-- Teams table
CREATE TABLE teams (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    plan VARCHAR(50) DEFAULT 'basic',
    max_users INTEGER DEFAULT 10,
    created_at TIMESTAMP DEFAULT NOW()
);

-- OAuth accounts
CREATE TABLE oauth_accounts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    provider VARCHAR(50) NOT NULL,
    provider_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

## 🔐 **Security Configuration**

### **Environment Variables**
```bash
# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=24h

# OAuth Configuration
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
MICROSOFT_CLIENT_ID=your-microsoft-client-id
MICROSOFT_CLIENT_SECRET=your-microsoft-client-secret

# TOTP Configuration
TOTP_ISSUER=Team AI Assistant
TOTP_WINDOW=1

# Rate Limiting
AUTH_RATE_LIMIT=5
AUTH_RATE_WINDOW=900000

# Session Configuration
SESSION_SECRET=your-session-secret
SESSION_MAX_AGE=86400000
```

### **Security Headers**
```javascript
// Express.js example
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.setHeader('Strict-Transport-Security', 'max-age=31536000');
    next();
});
```

## 👥 **Team Roles & Permissions**

### **Role Definitions**

#### **Admin**
- ✅ Full access to AI assistant
- ✅ Manage team members
- ✅ View usage analytics
- ✅ Configure team settings
- ✅ Access billing information

#### **Member**
- ✅ Full access to AI assistant
- ✅ View team activity (limited)
- ❌ Cannot manage members
- ❌ Cannot view billing

#### **Viewer**
- ✅ Read-only access to AI assistant
- ✅ Can ask questions but limited responses
- ❌ Cannot view team activity
- ❌ Cannot manage anything

### **Permission Matrix**
| Feature | Admin | Member | Viewer |
|---------|-------|--------|--------|
| Chat with AI | ✅ | ✅ | ✅ (limited) |
| View history | ✅ | ✅ | Own only |
| Team analytics | ✅ | Basic | ❌ |
| Invite users | ✅ | ❌ | ❌ |
| Billing | ✅ | ❌ | ❌ |

## 🚀 **Quick Setup Steps**

### **Step 1: Choose Your Auth Method**
```bash
# For basic TOTP setup
cp web/team-secure.html web/index.html

# Configure authentication in your backend
```

### **Step 2: Set Up OAuth (Optional)**
```bash
# Google OAuth
1. Go to Google Cloud Console
2. Create OAuth 2.0 credentials
3. Add your domain to authorized origins
4. Update client ID in HTML file
```

### **Step 3: Configure Your LLM Service**
```bash
# Update config.env
ALLOW_UNAUTHENTICATED=false

# Deploy with authentication
./deploy/cloud-run-deploy.sh
```

### **Step 4: Set Up User Management**
```bash
# Create admin user
POST /api/auth/register
{
    "email": "admin@yourcompany.com",
    "name": "Team Admin",
    "password": "secure-password",
    "role": "admin"
}
```

## 💰 **Cost Considerations**

### **Authentication Costs**
- **TOTP**: Free (just storage for secrets)
- **Google OAuth**: Free (up to limits)
- **Microsoft OAuth**: Free (up to limits)
- **Enterprise SSO**: $5-50/user/month

### **Infrastructure Costs**
- **Database**: $10-50/month
- **Authentication service**: $0-100/month
- **Session storage**: $5-20/month

## 🔍 **Monitoring & Analytics**

### **Key Metrics to Track**
- Login attempts (successful/failed)
- TOTP verification rates
- Session duration
- Team usage patterns
- Security incidents

### **Alerts to Set Up**
- Multiple failed login attempts
- Unusual login locations
- TOTP setup failures
- High authentication latency

## 🆘 **Troubleshooting**

### **Common Issues**

**TOTP codes not working:**
- Check device time synchronization
- Verify secret key was entered correctly
- Allow for time skew (±30 seconds)

**OAuth redirect errors:**
- Verify redirect URLs in OAuth config
- Check domain authorization
- Ensure HTTPS in production

**Session issues:**
- Check JWT secret configuration
- Verify token expiration settings
- Clear browser cache/cookies

## 📚 **Next Steps**

1. **Week 1**: Implement basic TOTP authentication
2. **Week 2**: Add OAuth integration
3. **Week 3**: Set up team management
4. **Week 4**: Add usage analytics
5. **Month 2**: Consider enterprise SSO if needed

This setup provides enterprise-grade security while keeping costs reasonable for team usage!
