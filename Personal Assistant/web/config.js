// Vercel serverless function to securely serve Personal Assistant configuration
// This keeps your API tokens secure while making them available to your web interface

export default function handler(req, res) {
    // Only allow GET requests
    if (req.method !== 'GET') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    // Basic security - only allow requests from your domain
    const allowedOrigins = [
        'https://ai.lowrys.org',
        'https://lowrys-ai-platform.vercel.app',
        'http://localhost:3000', // For local development
        'http://localhost:8000'
    ];

    const origin = req.headers.origin;
    if (origin && allowedOrigins.includes(origin)) {
        res.setHeader('Access-Control-Allow-Origin', origin);
    }

    res.setHeader('Access-Control-Allow-Methods', 'GET');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Return configuration from environment variables
    const config = {
        // Hugging Face configuration
        hf: {
            endpointUrl: process.env.HF_ENDPOINT_URL || '',
            modelName: process.env.HF_MODEL_NAME || 'tgi',
            // Note: API token is NOT included for security
        },
        
        // Feature flags
        features: {
            autoConnect: process.env.AUTO_CONNECT === 'true',
            toolsEnabled: process.env.TOOLS_ENABLED !== 'false',
            encryptionEnabled: process.env.ENCRYPTION_ENABLED === 'true',
            databaseEnabled: process.env.DATABASE_ENABLED === 'true'
        },
        
        // UI configuration
        ui: {
            theme: process.env.UI_THEME || 'auto',
            title: process.env.UI_TITLE || 'Personal Assistant AI',
            subtitle: process.env.UI_SUBTITLE || 'Your intelligent companion powered by your own private LLM'
        },

        // Security note
        security: {
            note: 'API token must be configured separately for security',
            tokenRequired: true
        }
    };

    // Return configuration
    res.status(200).json(config);
}