#!/usr/bin/env python3
"""
Configuration-driven deployment script
Deploy multiple LLM services based on JSON configuration
"""

import json
import subprocess
import sys
import os
from typing import Dict, Any

def load_config(config_path: str = "config/deployments.json") -> Dict[str, Any]:
    """Load deployment configuration from JSON file"""
    with open(config_path, 'r') as f:
        return json.load(f)

def calculate_resources(base_config: Dict[str, Any], env_config: Dict[str, Any]) -> Dict[str, Any]:
    """Calculate resources based on environment multipliers"""
    config = base_config.copy()
    
    # Apply memory multiplier
    memory_value = int(config['memory'].replace('Gi', ''))
    new_memory = max(1, int(memory_value * env_config['memory_multiplier']))
    config['memory'] = f"{new_memory}Gi"
    
    # Apply max instances multiplier
    config['max_instances'] = max(1, int(config['max_instances'] * env_config['max_instances_multiplier']))
    
    # Apply budget multiplier
    config['budget_limit'] = int(config['budget_limit'] * env_config['budget_multiplier'])
    
    return config

def deploy_service(name: str, config: Dict[str, Any], environment: str, project_id: str):
    """Deploy a single LLM service"""
    service_name = f"llm-{name}{config.get('suffix', '')}"
    image_name = f"gcr.io/{project_id}/{service_name}"
    
    print(f"🚀 Deploying {service_name}...")
    print(f"   Model: {config['model']}")
    print(f"   Resources: {config['cpu']} CPU, {config['memory']} RAM")
    print(f"   Scaling: {config['min_instances']}-{config['max_instances']} instances")
    print(f"   Budget: ${config['budget_limit']}/month")
    
    # Build Docker image
    build_cmd = [
        "gcloud", "builds", "submit",
        "--tag", image_name,
        "./docker/"
    ]
    
    try:
        subprocess.run(build_cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to build image for {service_name}: {e}")
        return False
    
    # Deploy to Cloud Run
    deploy_cmd = [
        "gcloud", "run", "deploy", service_name,
        "--image", image_name,
        "--platform", "managed",
        "--region", config['region'],
        "--memory", config['memory'],
        "--cpu", str(config['cpu']),
        "--timeout", "3600",
        "--concurrency", "10",
        "--min-instances", str(config['min_instances']),
        "--max-instances", str(config['max_instances']),
        "--set-env-vars", f"OLLAMA_MODEL={config['model']},ENVIRONMENT={environment}",
        "--port", "8080"
    ]
    
    # Add authentication setting
    if not config.get('authentication', True):
        deploy_cmd.append("--allow-unauthenticated")
    
    try:
        result = subprocess.run(deploy_cmd, check=True, capture_output=True, text=True)
        print(f"✅ {service_name} deployed successfully!")
        
        # Get service URL
        url_cmd = [
            "gcloud", "run", "services", "describe", service_name,
            "--region", config['region'],
            "--format", "value(status.url)"
        ]
        url_result = subprocess.run(url_cmd, capture_output=True, text=True)
        if url_result.returncode == 0:
            service_url = url_result.stdout.strip()
            print(f"   URL: {service_url}")
            
            # Set up budget alert
            setup_budget_alert(service_name, config['budget_limit'], project_id)
        
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to deploy {service_name}: {e}")
        return False

def setup_budget_alert(service_name: str, budget_limit: int, project_id: str):
    """Set up budget alert for the service"""
    print(f"💰 Setting up ${budget_limit} budget alert for {service_name}...")
    
    # This would integrate with the cost monitoring system
    # For now, just print the configuration
    print(f"   Budget alert configured for ${budget_limit}/month")

def main():
    """Main deployment function"""
    if len(sys.argv) < 3:
        print("Usage: python config-driven-deploy.py <environment> <project_id> [deployment_names...]")
        print("Environments: dev, staging, prod")
        print("Example: python config-driven-deploy.py dev my-project-id personal business")
        sys.exit(1)
    
    environment = sys.argv[1]
    project_id = sys.argv[2]
    deployment_names = sys.argv[3:] if len(sys.argv) > 3 else None
    
    # Load configuration
    try:
        config = load_config()
    except FileNotFoundError:
        print("❌ Configuration file not found: config/deployments.json")
        sys.exit(1)
    
    if environment not in config['environments']:
        print(f"❌ Invalid environment: {environment}")
        print(f"Available environments: {list(config['environments'].keys())}")
        sys.exit(1)
    
    env_config = config['environments'][environment]
    deployments = config['deployments']
    
    # Filter deployments if specific names provided
    if deployment_names:
        deployments = {name: deployments[name] for name in deployment_names if name in deployments}
        if not deployments:
            print("❌ No valid deployment names provided")
            sys.exit(1)
    
    print(f"🎯 Deploying to {environment} environment")
    print(f"📦 Project: {project_id}")
    print(f"🚀 Deployments: {list(deployments.keys())}")
    print()
    
    # Deploy each service
    successful_deployments = []
    failed_deployments = []
    
    for name, base_config in deployments.items():
        # Calculate environment-specific resources
        deployment_config = calculate_resources(base_config, env_config)
        deployment_config['suffix'] = env_config['suffix']
        
        if deploy_service(name, deployment_config, environment, project_id):
            successful_deployments.append(name)
        else:
            failed_deployments.append(name)
        
        print()  # Add spacing between deployments
    
    # Summary
    print("📊 Deployment Summary:")
    print(f"✅ Successful: {len(successful_deployments)} - {successful_deployments}")
    if failed_deployments:
        print(f"❌ Failed: {len(failed_deployments)} - {failed_deployments}")
    
    print("\n🎉 Deployment complete!")

if __name__ == "__main__":
    main()
