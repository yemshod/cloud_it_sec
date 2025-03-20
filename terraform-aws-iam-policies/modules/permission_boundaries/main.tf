/**
 * # Permission Boundaries Module
 *
 * This module creates permission boundary policies that can be referenced by AWS Identity Center permission sets.
 */

locals {
  # Create a map of permission boundary names to their configurations
  permission_boundaries_map = { for pb in var.permission_boundaries : pb.name => pb }
}

# Create permission boundary policies
resource "aws_iam_policy" "pri_permission_boundaries" {
  for_each = local.permission_boundaries_map

  name        = "pri-${each.key}-permission-boundary"
  description = each.value.description
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = each.value.policy_statements
  })
  
  tags = merge(
    {
      Name = "pri-${each.key}-permission-boundary"
    },
    var.tags,
    each.value.tags
  )
}
