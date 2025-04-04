provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Example 1: Create a new permission set with an AWS managed permission boundary
module "permission_set_with_aws_boundary" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "developer-with-boundary"
  description         = "Developer access with permission boundary"
  policy_type         = "AWS_MANAGED"
  policy_name         = "PowerUserAccess"
  
  # Add permission boundary
  permission_boundary_type = "AWS_MANAGED"
  permission_boundary_name = "PowerUserAccess"
}

# Example 2: Create a new permission set with a customer managed permission boundary
module "permission_set_with_customer_boundary" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "admin-with-boundary"
  description         = "Admin access with custom permission boundary"
  policy_type         = "AWS_MANAGED"
  policy_name         = "AdministratorAccess"
  
  # Add customer managed permission boundary
  permission_boundary_type = "CUSTOMER_MANAGED"
  permission_boundary_name = "CustomPermissionBoundary"
  permission_boundary_path = "/custom/path/"
}

# Example 3: Add a permission boundary to an existing permission set
# Note: This requires first importing the existing permission set into Terraform state
# terraform import module.existing_permission_set.aws_ssoadmin_permission_set.this arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-1234567890abcdef

module "existing_permission_set" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "existing-permission-set"
  description         = "Existing permission set with added boundary"
  
  # Keep existing policy (assuming it's already attached)
  policy_type         = "NONE"
  
  # Add permission boundary
  permission_boundary_type = "AWS_MANAGED"
  permission_boundary_name = "ViewOnlyAccess"
}

# Example 4: Assign a permission set with boundary to a group
module "assign_bounded_permission_set" {
  source = "../modules/group_account_assignment"

  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = "existing-group"
  permission_set_name = module.permission_set_with_aws_boundary.permission_set_name
  account_ids         = "123456789012, 234567890123"
  
  depends_on = [module.permission_set_with_aws_boundary]
}
