#!/bin/bash

# Script to deploy IAM roles to multiple AWS accounts using Terraform workspaces

# List of accounts to deploy to
ACCOUNTS=("account1" "account2" "account3" "account4" "account5")

# Initialize Terraform
terraform init

# Loop through each account and apply
for account in "${ACCOUNTS[@]}"; do
  echo "Deploying to $account..."
  
  # Select or create workspace
  terraform workspace select $account || terraform workspace new $account
  
  # Apply with auto-approve (remove -auto-approve for production use)
  terraform apply -auto-approve
  
  echo "Deployment to $account completed."
  echo "----------------------------------------"
done

# Switch back to default workspace
terraform workspace select default

echo "All deployments completed successfully!"
