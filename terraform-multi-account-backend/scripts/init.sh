
#!/bin/bash
set -e

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: $0 <env>"
  exit 1
fi

cd envs/$ENV
terraform init -backend-config="$ENV.s3.backend"
