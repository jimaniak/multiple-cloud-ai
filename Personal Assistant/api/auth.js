// Vercel serverless function for secure token management
// This handles API token storage and retrieval securely

export default function handler(req, res) {
    // CORS headers
    const allowedOrigins = [
        'https://ai.lowrys.org',
        'https://lowrys-ai-platform.vercel.app',
        'http://localhost:3000',
        'http://localhost:8000'
    ];

    const origin = req.headers.origin;
    if (origin && allowedOrigins.includes(origin)) {
        res.setHeader('Access-Control-Allow-Origin', origin);
    }

    res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    // Handle preflight requests
    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    // GET: Verify token access (without exposing the token)
    if (req.method === 'GET') {
        const hasToken = !!process.env.HF_API_TOKEN;
        return res.status(200).json({
            configured: hasToken,
            endpointUrl: process.env.HF_ENDPOINT_URL || '',
            message: hasToken ? 'API token is configured' : 'API token needs configuration'
        });
    }

    // POST: Validate provided token against stored token
    if (req.method === 'POST') {
        const { token } = req.body;
        
        if (!token) {
            return res.status(400).json({ error: 'Token required' });
        }

        // Simple token validation (in production, use proper auth)
        const isValid = token === process.env.HF_API_TOKEN;
        
        if (isValid) {
            return res.status(200).json({ 
                valid: true, 
                message: 'Token validated successfully',
                config: {
                    endpointUrl: process.env.HF_ENDPOINT_URL,
                    modelName: process.env.HF_MODEL_NAME || 'tgi'
                }
            });
        } else {
            return res.status(401).json({ 
                valid: false, 
                message: 'Invalid token' 
            });
        }
    }

    return res.status(405).json({ error: 'Method not allowed' });
}
