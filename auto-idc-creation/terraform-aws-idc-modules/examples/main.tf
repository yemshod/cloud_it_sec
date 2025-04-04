provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Create a user
module "create_user" {
  source = "../modules/user"

  identity_store_id = local.identity_store_id
  user_name         = "john.doe"
  display_name      = "John Doe"
  given_name        = "John"
  family_name       = "Doe"
  email             = "john.doe@example.com"
}

# Create a group
module "create_group" {
  source = "../modules/group"

  identity_store_id = local.identity_store_id
  group_name        = "pri-developers"
  description       = "Group for developers"
}

# Add user to group
module "add_user_to_group" {
  source = "../modules/user_group_assignment"

  identity_store_id = local.identity_store_id
  user_name         = module.create_user.user_name
  group_name        = module.create_group.group_name

  depends_on = [module.create_user, module.create_group]
}

# Create a permission set
module "create_permission_set" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "developer-access"
  description         = "Developer access permission set"
  policy_type         = "AWS_MANAGED"
  policy_name         = "PowerUserAccess"
}

# Assign permission set to an account for a user
module "assign_permission_to_account" {
  source = "../modules/account_assignment"

  instance_arn        = local.instance_arn
  permission_set_name = module.create_permission_set.permission_set_name
  principal_id        = module.create_user.user_id
  principal_type      = "USER"
  account_ids         = "123456789012, 234567890123"

  depends_on = [module.create_permission_set, module.create_user]
}

# Assign group to an account with permission set
module "assign_group_to_account" {
  source = "../modules/group_account_assignment"

  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = module.create_group.group_name
  permission_set_name = module.create_permission_set.permission_set_name
  account_ids         = "123456789012, 234567890123"

  depends_on = [module.create_permission_set, module.create_group]
}
