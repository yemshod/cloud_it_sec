locals {
  # Load JSON configurations for existing resources
  existing_user_group_assignments_json = fileexists("${path.module}/json/existing_user_group_assignments.json") ? jsondecode(file("${path.module}/json/existing_user_group_assignments.json")) : {}
  existing_account_assignments_json    = fileexists("${path.module}/json/existing_account_assignments.json") ? jsondecode(file("${path.module}/json/existing_account_assignments.json")) : {}
  existing_permission_boundaries_json  = fileexists("${path.module}/json/existing_permission_boundaries.json") ? jsondecode(file("${path.module}/json/existing_permission_boundaries.json")) : {}
  
  # Alternatively, define assignments directly in Terraform
  existing_user_group_assignments = merge(local.existing_user_group_assignments_json, {
    # Add user-group assignments directly here if needed
    # "existing-user1-group1" = {
    #   user_name  = "existing.user"
    #   group_name = "existing-group"
    # }
  })
  
  existing_account_assignments = merge(local.existing_account_assignments_json, {
    # Add account assignments directly here if needed
    # "existing-group1-permission1" = {
    #   group_name          = "existing-group"
    #   permission_set_name = "existing-permission-set"
    #   account_ids         = "123456789012,234567890123"
    # }
  })
  
  existing_permission_boundaries = merge(local.existing_permission_boundaries_json, {
    # Add permission boundary assignments directly here if needed
    # "existing-permission-set1" = {
    #   permission_set_name = "existing-permission-set"
    #   boundary_type       = "AWS_MANAGED"
    #   boundary_name       = "PowerUserAccess"
    #   boundary_path       = "/"  # Only needed for CUSTOMER_MANAGED
    # }
  })
}

# Add existing users to existing groups
module "existing_user_group_assignments" {
  source = "../modules/user_group_assignment"
  for_each = local.existing_user_group_assignments
  
  identity_store_id = local.identity_store_id
  user_name         = each.value.user_name
  group_name        = each.value.group_name
}

# Assign existing groups to accounts with existing permission sets
module "existing_account_assignments" {
  source = "../modules/group_account_assignment"
  for_each = local.existing_account_assignments
  
  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = each.value.group_name
  permission_set_name = each.value.permission_set_name
  account_ids         = each.value.account_ids
}

# Add permission boundaries to existing permission sets
module "existing_permission_boundaries" {
  source = "../modules/permission_boundary"
  for_each = local.existing_permission_boundaries
  
  instance_arn        = local.instance_arn
  permission_set_name = each.value.permission_set_name
  boundary_type       = each.value.boundary_type
  boundary_name       = each.value.boundary_name
  boundary_path       = lookup(each.value, "boundary_path", "/")
}
