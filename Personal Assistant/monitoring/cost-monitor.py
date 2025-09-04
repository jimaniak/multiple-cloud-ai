#!/usr/bin/env python3
"""
Cost monitoring script for Google Cloud LLM deployment
"""

import os
import json
from datetime import datetime, timedelta
from google.cloud import billing_v1
from google.cloud import monitoring_v3
import smtplib
from email.mime.text import MimeText

class CostMonitor:
    def __init__(self, project_id: str, billing_account_id: str):
        self.project_id = project_id
        self.billing_account_id = billing_account_id
        self.billing_client = billing_v1.CloudBillingClient()
        self.monitoring_client = monitoring_v3.MetricServiceClient()
        
    def get_current_month_cost(self) -> float:
        """Get current month's spending"""
        try:
            # This is a simplified example - you'll need to implement
            # the actual billing API calls based on your needs
            project_name = f"projects/{self.project_id}"
            
            # Get billing info (simplified)
            # In practice, you'd use the Cloud Billing API
            # to get detailed cost breakdowns
            
            return 0.0  # Placeholder
            
        except Exception as e:
            print(f"Error getting cost data: {e}")
            return 0.0
    
    def check_cost_threshold(self, threshold: float = 100.0) -> bool:
        """Check if costs exceed threshold"""
        current_cost = self.get_current_month_cost()
        return current_cost > threshold
    
    def send_alert(self, message: str, email: str = None):
        """Send cost alert"""
        if email:
            self._send_email_alert(message, email)
        else:
            print(f"🚨 COST ALERT: {message}")
    
    def _send_email_alert(self, message: str, email: str):
        """Send email alert (configure with your SMTP settings)"""
        # Configure these with your email settings
        smtp_server = os.getenv("SMTP_SERVER", "smtp.gmail.com")
        smtp_port = int(os.getenv("SMTP_PORT", "587"))
        sender_email = os.getenv("SENDER_EMAIL")
        sender_password = os.getenv("SENDER_PASSWORD")
        
        if not all([sender_email, sender_password]):
            print("Email credentials not configured")
            return
        
        msg = MimeText(message)
        msg['Subject'] = "LLM Cost Alert"
        msg['From'] = sender_email
        msg['To'] = email
        
        try:
            with smtplib.SMTP(smtp_server, smtp_port) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                server.send_message(msg)
            print("Alert email sent successfully")
        except Exception as e:
            print(f"Failed to send email: {e}")

def create_budget_alert(project_id: str, budget_amount: float = 50.0):
    """Create a budget alert in Google Cloud"""
    
    budget_config = {
        "displayName": f"LLM Budget Alert - ${budget_amount}",
        "budgetFilter": {
            "projects": [f"projects/{project_id}"],
        },
        "amount": {
            "specifiedAmount": {
                "currencyCode": "USD",
                "units": str(int(budget_amount))
            }
        },
        "thresholdRules": [
            {
                "thresholdPercent": 0.5,  # 50%
                "spendBasis": "CURRENT_SPEND"
            },
            {
                "thresholdPercent": 0.8,  # 80%
                "spendBasis": "CURRENT_SPEND"
            },
            {
                "thresholdPercent": 1.0,  # 100%
                "spendBasis": "CURRENT_SPEND"
            }
        ]
    }
    
    print("Budget configuration created. Apply this using gcloud CLI:")
    print("gcloud billing budgets create --billing-account=BILLING_ACCOUNT_ID \\")
    print(f"  --display-name='LLM Budget Alert' \\")
    print(f"  --budget-amount={budget_amount} \\")
    print("  --threshold-percent=50,80,100")

def main():
    """Main monitoring function"""
    project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
    billing_account = os.getenv("BILLING_ACCOUNT_ID")
    alert_email = os.getenv("ALERT_EMAIL")
    
    if not project_id:
        print("Please set GOOGLE_CLOUD_PROJECT environment variable")
        return
    
    monitor = CostMonitor(project_id, billing_account)
    
    # Check costs
    if monitor.check_cost_threshold(50.0):  # $50 threshold
        monitor.send_alert(
            f"LLM costs have exceeded $50 this month for project {project_id}",
            alert_email
        )
    
    # Create budget alert configuration
    create_budget_alert(project_id, 50.0)

if __name__ == "__main__":
    main()
