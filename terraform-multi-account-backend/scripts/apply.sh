
#!/bin/bash
set -e

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: $0 <env>"
  exit 1
fi

cd envs/$ENV
terraform apply -var-file="terraform.tfvars"
