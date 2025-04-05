provider "aws" {
  region = "us-east-1"
  # Uncomment to use a specific profile
  # profile = "your-profile"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}
