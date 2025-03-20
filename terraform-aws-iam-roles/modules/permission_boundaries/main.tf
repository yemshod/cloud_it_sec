/**
 * # Permission Boundaries Module
 *
 * This module creates permission boundary policies that can be applied to IAM roles.
 */

# Create permission boundary policies
resource "aws_iam_policy" "pri_permission_boundaries" {
  for_each = { for pb in var.permission_boundaries : pb.name => pb }

  name        = "pri-${each.key}-permission-boundary"
  description = each.value.description
  policy      = each.value.policy_document
  
  tags = merge(
    {
      Name = "pri-${each.key}-permission-boundary"
    },
    var.tags,
    each.value.tags
  )
}
