#!/usr/bin/env python3
"""
Simple Python client for interacting with your deployed LLM
"""

import requests
import json
import os
from typing import Optional, Dict, Any

class LLMClient:
    def __init__(self, base_url: str, model_name: str = "phi3:mini"):
        """
        Initialize the LLM client
        
        Args:
            base_url: The URL of your deployed LLM service
            model_name: The name of the model to use
        """
        self.base_url = base_url.rstrip('/')
        self.model_name = model_name
        
    def generate(self, prompt: str, stream: bool = False, **kwargs) -> Dict[str, Any]:
        """
        Generate text using the LLM
        
        Args:
            prompt: The input prompt
            stream: Whether to stream the response
            **kwargs: Additional parameters for the model
            
        Returns:
            The model's response
        """
        url = f"{self.base_url}/api/generate"
        
        payload = {
            "model": self.model_name,
            "prompt": prompt,
            "stream": stream,
            **kwargs
        }
        
        try:
            response = requests.post(url, json=payload, timeout=300)
            response.raise_for_status()
            
            if stream:
                return self._handle_stream_response(response)
            else:
                return response.json()
                
        except requests.exceptions.RequestException as e:
            return {"error": f"Request failed: {str(e)}"}
    
    def chat(self, messages: list, **kwargs) -> Dict[str, Any]:
        """
        Chat with the LLM using conversation format
        
        Args:
            messages: List of message dictionaries with 'role' and 'content'
            **kwargs: Additional parameters
            
        Returns:
            The model's response
        """
        url = f"{self.base_url}/api/chat"
        
        payload = {
            "model": self.model_name,
            "messages": messages,
            **kwargs
        }
        
        try:
            response = requests.post(url, json=payload, timeout=300)
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            return {"error": f"Request failed: {str(e)}"}
    
    def _handle_stream_response(self, response):
        """Handle streaming response"""
        full_response = ""
        for line in response.iter_lines():
            if line:
                try:
                    data = json.loads(line.decode('utf-8'))
                    if 'response' in data:
                        full_response += data['response']
                        print(data['response'], end='', flush=True)
                except json.JSONDecodeError:
                    continue
        return {"response": full_response}
    
    def list_models(self) -> Dict[str, Any]:
        """List available models"""
        url = f"{self.base_url}/api/tags"
        
        try:
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            return {"error": f"Request failed: {str(e)}"}

def main():
    """Example usage"""
    # Replace with your actual service URL
    service_url = os.getenv("LLM_SERVICE_URL", "http://localhost:8080")
    
    client = LLMClient(service_url)
    
    # Test basic generation
    print("🤖 Testing LLM generation...")
    response = client.generate("Explain quantum computing in simple terms.")
    
    if "error" in response:
        print(f"❌ Error: {response['error']}")
    else:
        print(f"✅ Response: {response.get('response', 'No response')}")
    
    # Test chat format
    print("\n💬 Testing chat format...")
    messages = [
        {"role": "user", "content": "What are the benefits of cloud computing?"}
    ]
    
    chat_response = client.chat(messages)
    if "error" in chat_response:
        print(f"❌ Error: {chat_response['error']}")
    else:
        print(f"✅ Chat Response: {chat_response}")

if __name__ == "__main__":
    main()
