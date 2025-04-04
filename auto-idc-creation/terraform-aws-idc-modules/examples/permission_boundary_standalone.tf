provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Example: Add a permission boundary to an existing permission set using the standalone module
module "add_boundary_to_existing_permission_set" {
  source = "../modules/permission_boundary"

  instance_arn        = local.instance_arn
  permission_set_name = "existing-permission-set"
  boundary_type       = "AWS_MANAGED"
  boundary_name       = "PowerUserAccess"
}

# Example: Add a customer managed permission boundary to an existing permission set
module "add_custom_boundary_to_existing_permission_set" {
  source = "../modules/permission_boundary"

  instance_arn        = local.instance_arn
  permission_set_name = "another-existing-permission-set"
  boundary_type       = "CUSTOMER_MANAGED"
  boundary_name       = "CustomPermissionBoundary"
  boundary_path       = "/custom/path/"
}
