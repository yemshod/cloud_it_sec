provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  
  # Define users in a list for bulk creation
  users = [
    {
      user_name   = "jane.smith"
      display_name = "Jane Smith"
      given_name  = "Jane"
      family_name = "Smith"
      email       = "jane.smith@example.com"
    },
    {
      user_name   = "bob.johnson"
      display_name = "Bob Johnson"
      given_name  = "Bob"
      family_name = "Johnson"
      email       = "bob.johnson@example.com"
    }
  ]
  
  # Define groups in a list for bulk creation
  groups = [
    {
      group_name  = "pri-admins"
      description = "Administrators group"
    },
    {
      group_name  = "pri-readonly"
      description = "Read-only access group"
    }
  ]
  
  # Define user-group assignments
  user_group_assignments = [
    {
      user_name  = "jane.smith"
      group_name = "pri-admins"
    },
    {
      user_name  = "bob.johnson"
      group_name = "pri-readonly"
    }
  ]
  
  # Define permission sets
  permission_sets = [
    {
      name        = "admin-access"
      description = "Administrator access"
      policy_type = "AWS_MANAGED"
      policy_name = "AdministratorAccess"
    },
    {
      name        = "readonly-access"
      description = "Read-only access"
      policy_type = "AWS_MANAGED"
      policy_name = "ReadOnlyAccess"
    }
  ]
  
  # Define group-account assignments
  group_account_assignments = [
    {
      group_name          = "pri-admins"
      permission_set_name = "admin-access"
      account_ids         = "123456789012, 234567890123"
    },
    {
      group_name          = "pri-readonly"
      permission_set_name = "readonly-access"
      account_ids         = "123456789012, 234567890123, 345678901234"
    }
  ]
}

# Bulk create users
module "bulk_create_users" {
  source   = "../modules/user"
  for_each = { for user in local.users : user.user_name => user }
  
  identity_store_id = local.identity_store_id
  user_name         = each.value.user_name
  display_name      = each.value.display_name
  given_name        = each.value.given_name
  family_name       = each.value.family_name
  email             = each.value.email
}

# Bulk create groups
module "bulk_create_groups" {
  source   = "../modules/group"
  for_each = { for group in local.groups : group.group_name => group }
  
  identity_store_id = local.identity_store_id
  group_name        = each.value.group_name
  description       = each.value.description
}

# Bulk add users to groups
module "bulk_user_group_assignments" {
  source   = "../modules/user_group_assignment"
  for_each = { for assignment in local.user_group_assignments : "${assignment.user_name}-${assignment.group_name}" => assignment }
  
  identity_store_id = local.identity_store_id
  user_name         = each.value.user_name
  group_name        = each.value.group_name
  
  depends_on = [module.bulk_create_users, module.bulk_create_groups]
}

# Bulk create permission sets
module "bulk_create_permission_sets" {
  source   = "../modules/permission_set"
  for_each = { for ps in local.permission_sets : ps.name => ps }
  
  instance_arn        = local.instance_arn
  permission_set_name = each.value.name
  description         = each.value.description
  policy_type         = each.value.policy_type
  policy_name         = each.value.policy_name
}

# Bulk assign groups to accounts
module "bulk_group_account_assignments" {
  source   = "../modules/group_account_assignment"
  for_each = { for assignment in local.group_account_assignments : "${assignment.group_name}-${assignment.permission_set_name}" => assignment }
  
  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = each.value.group_name
  permission_set_name = each.value.permission_set_name
  account_ids         = each.value.account_ids
  
  depends_on = [module.bulk_create_groups, module.bulk_create_permission_sets]
}
