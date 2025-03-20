/**
 * # IAM Roles Module
 *
 * This module creates IAM roles with attached policies and permission boundaries.
 */

locals {
  # Create a map of role names to their configurations
  roles_map = { for role in var.roles : role.name => role }
}

# Create the IAM roles
resource "aws_iam_role" "pri_roles" {
  for_each = local.roles_map

  name                 = "pri-${each.key}"
  description          = each.value.description
  assume_role_policy   = each.value.assume_role_policy
  permissions_boundary = var.enable_permission_boundaries ? aws_iam_policy.pri_permission_boundary[each.key].arn : null
  
  tags = merge(
    {
      Name = "pri-${each.key}"
    },
    var.tags,
    each.value.tags
  )
}

# Create permission boundaries for each role
resource "aws_iam_policy" "pri_permission_boundary" {
  for_each = var.enable_permission_boundaries ? local.roles_map : {}

  name        = "pri-${each.key}-permission-boundary"
  description = "Permission boundary for ${each.key}"
  policy      = each.value.permission_boundary_policy
}

# Attach managed policies to roles
resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each = {
    for policy in flatten([
      for role_name, role in local.roles_map : [
        for policy_arn in role.managed_policy_arns : {
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : "${policy.role_name}-${basename(policy.policy_arn)}" => policy
  }

  role       = aws_iam_role.pri_roles[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

# Create and attach inline policies to roles
resource "aws_iam_role_policy" "inline_policy_attachments" {
  for_each = {
    for policy in flatten([
      for role_name, role in local.roles_map : [
        for policy_name, policy_doc in role.inline_policies : {
          role_name   = role_name
          policy_name = policy_name
          policy_doc  = policy_doc
        }
      ]
    ]) : "${policy.role_name}-${policy.policy_name}" => policy
  }

  name   = "pri-${each.value.policy_name}"
  role   = aws_iam_role.pri_roles[each.value.role_name].name
  policy = each.value.policy_doc
}
