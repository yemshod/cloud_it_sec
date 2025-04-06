locals {
  # Load JSON configurations
  users_json            = fileexists("${path.module}/json/users.json") ? jsondecode(file("${path.module}/json/users.json")) : {}
  groups_json           = fileexists("${path.module}/json/groups.json") ? jsondecode(file("${path.module}/json/groups.json")) : {}
  permission_sets_json  = fileexists("${path.module}/json/permission_sets.json") ? jsondecode(file("${path.module}/json/permission_sets.json")) : {}
  
  # Alternatively, define resources directly in Terraform
  users = merge(local.users_json, {
    # Add users directly here if needed
    # example = {
    #   user_name    = "john.doe"
    #   display_name = "John Doe"
    #   given_name   = "John"
    #   family_name  = "Doe"
    #   email        = "john.doe@example.com"
    # }
  })
  
  groups = merge(local.groups_json, {
    # Add groups directly here if needed
    # example = {
    #   group_name  = "pri-developers"
    #   description = "Developer group"
    # }
  })
  
  permission_sets = merge(local.permission_sets_json, {
    # Add permission sets directly here if needed
    # example = {
    #   name        = "developer-access"
    #   description = "Developer access permission set"
    #   policy_type = "AWS_MANAGED"
    #   policy_name = "PowerUserAccess"
    #   permission_boundary_type = "AWS_MANAGED"
    #   permission_boundary_name = "PowerUserAccess"
    # }
  })
  
  # User-group assignments
  user_group_assignments_json = fileexists("${path.module}/json/user_group_assignments.json") ? jsondecode(file("${path.module}/json/user_group_assignments.json")) : {}
  
  user_group_assignments = merge(local.user_group_assignments_json, {
    # Add user-group assignments directly here if needed
    # "user1-group1" = {
    #   user_name  = "john.doe"
    #   group_name = "pri-developers"
    # }
  })
  
  # Account assignments for permission sets
  account_assignments_json = fileexists("${path.module}/json/account_assignments.json") ? jsondecode(file("${path.module}/json/account_assignments.json")) : {}
  
  account_assignments = merge(local.account_assignments_json, {
    # Add account assignments directly here if needed
    # "group1-permission1" = {
    #   group_name          = "pri-developers"
    #   permission_set_name = "developer-access"
    #   account_ids         = "123456789012,234567890123"
    # }
  })
}

# Create users
module "users" {
  source = "../modules/user"
  for_each = local.users
  
  identity_store_id = local.identity_store_id
  user_name         = each.value.user_name
  display_name      = each.value.display_name
  given_name        = each.value.given_name
  family_name       = each.value.family_name
  email             = each.value.email
}

# Create groups
module "groups" {
  source = "../modules/group"
  for_each = local.groups
  
  identity_store_id = local.identity_store_id
  group_name        = each.value.group_name
  description       = each.value.description
}

# Create permission sets
module "permission_sets" {
  source = "../modules/permission_set"
  for_each = local.permission_sets
  
  instance_arn        = local.instance_arn
  permission_set_name = each.value.name
  description         = each.value.description
  policy_type         = each.value.policy_type
  policy_name         = each.value.policy_name
  
  # Optional parameters with defaults
  session_duration = lookup(each.value, "session_duration", "PT8H")
  relay_state      = lookup(each.value, "relay_state", "")
  
  # Permission boundary (optional)
  permission_boundary_type = lookup(each.value, "permission_boundary_type", "NONE")
  permission_boundary_name = lookup(each.value, "permission_boundary_name", "")
  permission_boundary_path = lookup(each.value, "permission_boundary_path", "/")
  
  # Inline policy (optional)
  inline_policy = lookup(each.value, "inline_policy", null)
}

# Add users to groups
module "user_group_assignments" {
  source = "../modules/user_group_assignment"
  for_each = local.user_group_assignments
  
  identity_store_id = local.identity_store_id
  user_name         = each.value.user_name
  group_name        = each.value.group_name
  
  depends_on = [module.users, module.groups]
}

# Assign groups to accounts with permission sets
module "account_assignments" {
  source = "../modules/group_account_assignment"
  for_each = local.account_assignments
  
  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = each.value.group_name
  permission_set_name = each.value.permission_set_name
  account_ids         = each.value.account_ids
  
  depends_on = [module.groups, module.permission_sets]
}
