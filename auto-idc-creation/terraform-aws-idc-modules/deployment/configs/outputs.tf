# Output the created resources for reference

# Users
output "users" {
  description = "Created users"
  value = {
    for k, v in module.users : k => {
      user_id = v.user_id
      name    = v.user_name
    }
  }
}

# Groups
output "groups" {
  description = "Created groups"
  value = {
    for k, v in module.groups : k => {
      group_id = v.group_id
      name     = v.group_name
    }
  }
}

# Permission Sets
output "permission_sets" {
  description = "Created permission sets"
  value = {
    for k, v in module.permission_sets : k => {
      arn  = v.permission_set_arn
      name = v.permission_set_name
    }
  }
}

# User-Group Assignments
output "user_group_assignments" {
  description = "User-group assignments"
  value = keys(module.user_group_assignments)
}

# Account Assignments
output "account_assignments" {
  description = "Account assignments"
  value = keys(module.account_assignments)
}

# Existing Resource Assignments (if any exist)
output "existing_user_group_assignments" {
  description = "Existing user-group assignments"
  value = keys(module.existing_user_group_assignments)
  # This might be empty if no existing assignments are defined
}

output "existing_account_assignments" {
  description = "Existing account assignments"
  value = keys(module.existing_account_assignments)
  # This might be empty if no existing assignments are defined
}

output "existing_permission_boundaries" {
  description = "Permission boundaries added to existing permission sets"
  value = keys(module.existing_permission_boundaries)
  # This might be empty if no existing boundaries are defined
}
