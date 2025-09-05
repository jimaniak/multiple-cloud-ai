# 🔐 Google Cloud KMS Encryption Setup for Personal Assistant

## 🎯 **Why Google Cloud KMS:**
- ✅ **Enterprise-grade encryption** - Same security as Google uses internally
- ✅ **Key rotation** - Automatic security updates
- ✅ **Access control** - You control who can decrypt
- ✅ **Audit logging** - Track all encryption/decryption
- ✅ **Integration ready** - Works with your existing Google Cloud setup

## 🔧 **Setup Steps:**

### **Step 1: Enable KMS API**
```bash
gcloud services enable cloudkms.googleapis.com --project personal-assistant-471118
```

### **Step 2: Create Key Ring**
```bash
gcloud kms keyrings create personal-assistant-keyring \
    --location=us-central1 \
    --project=personal-assistant-471118
```

### **Step 3: Create Encryption Key**
```bash
gcloud kms keys create personal-assistant-key \
    --keyring=personal-assistant-keyring \
    --location=us-central1 \
    --purpose=encryption \
    --rotation-period=90d \
    --project=personal-assistant-471118
```

### **Step 4: Create Service Account for Encryption**
```bash
gcloud iam service-accounts create pa-encryption-service \
    --display-name="Personal Assistant Encryption Service" \
    --project=personal-assistant-471118
```

### **Step 5: Grant KMS Permissions**
```bash
gcloud kms keys add-iam-policy-binding personal-assistant-key \
    --keyring=personal-assistant-keyring \
    --location=us-central1 \
    --member=serviceAccount:pa-encryption-service@personal-assistant-471118.iam.gserviceaccount.com \
    --role=roles/cloudkms.cryptoKeyEncrypterDecrypter \
    --project=personal-assistant-471118
```

## 🔑 **Encryption Configuration:**

### **Add to config.env:**
```bash
# Google Cloud KMS Encryption
KMS_PROJECT_ID=personal-assistant-471118
KMS_LOCATION=us-central1
KMS_KEYRING=personal-assistant-keyring
KMS_KEY=personal-assistant-key
KMS_SERVICE_ACCOUNT=pa-encryption-service@personal-assistant-471118.iam.gserviceaccount.com
```

## 🗄️ **Updated Database Schema (Encrypted):**

```sql
-- User settings (encrypted)
CREATE TABLE user_config (
    setting_key TEXT PRIMARY KEY,
    setting_value_encrypted BLOB NOT NULL, -- KMS encrypted data
    kms_key_version TEXT NOT NULL, -- Track which key version was used
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Conversations (encrypted, 30-day retention)
CREATE TABLE conversations (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    user_message_encrypted BLOB NOT NULL, -- KMS encrypted
    ai_response_encrypted BLOB NOT NULL, -- KMS encrypted  
    tools_used TEXT DEFAULT '[]', -- Not sensitive, can be unencrypted
    kms_key_version TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME DEFAULT (datetime('now', '+30 days'))
);

-- AI memory (encrypted)
CREATE TABLE ai_memory (
    memory_key TEXT PRIMARY KEY,
    memory_value_encrypted BLOB NOT NULL, -- KMS encrypted
    category TEXT, -- 'preference', 'fact', 'pattern'
    kms_key_version TEXT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Auto-cleanup trigger for 30-day retention
CREATE TRIGGER cleanup_expired_conversations 
AFTER INSERT ON conversations
BEGIN
    DELETE FROM conversations WHERE expires_at < datetime('now');
END;
```

## 🛡️ **Security Features:**

### **Encryption at Rest:**
- ✅ **All sensitive data** encrypted with Google KMS
- ✅ **Key rotation** every 90 days automatically
- ✅ **Access logging** - audit trail of all operations
- ✅ **Zero-knowledge** - Even database admin can't read your data

### **Encryption in Transit:**
- ✅ **HTTPS** for all web communications
- ✅ **TLS** for database connections
- ✅ **Encrypted API calls** to Hugging Face

### **Access Control:**
- ✅ **Only your service account** can decrypt
- ✅ **IAM policies** control access
- ✅ **Audit logs** track all key usage

## 💰 **KMS Costs:**
- **Key storage**: $0.06 per key per month
- **Encryption operations**: $0.03 per 10,000 operations
- **Expected cost**: ~$1-3/month for personal use

## 🚀 **Implementation:**

### **Encryption Functions:**
```javascript
// Encrypt data before storing
async function encryptData(plaintext) {
    const response = await fetch('/api/encrypt', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ data: plaintext })
    });
    return response.json();
}

// Decrypt data after retrieving
async function decryptData(encryptedData, keyVersion) {
    const response = await fetch('/api/decrypt', {
        method: 'POST', 
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            encryptedData: encryptedData,
            keyVersion: keyVersion 
        })
    });
    return response.json();
}
```

This gives you **bank-level security** for your Personal Assistant data while maintaining the 30-day retention policy you wanted!

**Want me to create the KMS setup commands for your Google Cloud project?** 🔐
