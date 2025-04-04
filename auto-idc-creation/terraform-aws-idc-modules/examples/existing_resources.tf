provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Example 1: Add an existing user to an existing group
module "add_existing_user_to_group" {
  source = "../modules/user_group_assignment"

  identity_store_id = local.identity_store_id
  
  # Specify the username of an existing user
  user_name = "existing.user"
  
  # Specify the name of an existing group
  group_name = "existing-group"
}

# Example 2: Assign an existing permission set to an existing user for multiple accounts
module "assign_existing_permission_to_user" {
  source = "../modules/account_assignment"

  instance_arn = local.instance_arn
  
  # Specify the name of an existing permission set
  permission_set_name = "existing-permission-set"
  
  # Get the user ID of an existing user
  principal_id = data.aws_identitystore_user.existing_user.user_id
  principal_type = "USER"
  
  # Specify multiple account IDs
  account_ids = "123456789012, 234567890123"
}

# Data source to look up an existing user
data "aws_identitystore_user" "existing_user" {
  identity_store_id = local.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = "existing.user"
  }
}

# Example 3: Assign an existing group to multiple accounts with an existing permission set
module "assign_existing_group_to_accounts" {
  source = "../modules/group_account_assignment"

  instance_arn = local.instance_arn
  identity_store_id = local.identity_store_id
  
  # Specify the name of an existing group
  group_name = "existing-group"
  
  # Specify the name of an existing permission set
  permission_set_name = "existing-permission-set"
  
  # Specify multiple account IDs
  account_ids = "123456789012, 234567890123, 345678901234"
}

# Example 4: Assign multiple existing groups to accounts with permission sets
locals {
  group_assignments = [
    {
      group_name = "existing-group-1"
      permission_set_name = "existing-permission-set-1"
      account_ids = "123456789012, 234567890123"
    },
    {
      group_name = "existing-group-2"
      permission_set_name = "existing-permission-set-2"
      account_ids = "123456789012, 345678901234"
    },
    {
      group_name = "existing-group-3"
      permission_set_name = "existing-permission-set-1"
      account_ids = "234567890123, 345678901234"
    }
  ]
}

module "bulk_assign_existing_groups" {
  source = "../modules/group_account_assignment"
  for_each = { for idx, assignment in local.group_assignments : "${assignment.group_name}-${assignment.permission_set_name}" => assignment }
  
  instance_arn = local.instance_arn
  identity_store_id = local.identity_store_id
  
  # Use existing group names
  group_name = each.value.group_name
  
  # Use existing permission set names
  permission_set_name = each.value.permission_set_name
  
  # Specify account IDs
  account_ids = each.value.account_ids
}

# Example 5: Add multiple existing users to an existing group
locals {
  users_to_add = [
    "existing.user1",
    "existing.user2",
    "existing.user3"
  ]
}

module "add_multiple_users_to_group" {
  source = "../modules/user_group_assignment"
  for_each = toset(local.users_to_add)
  
  identity_store_id = local.identity_store_id
  
  # Use existing usernames
  user_name = each.value
  
  # Use an existing group
  group_name = "existing-group"
}
