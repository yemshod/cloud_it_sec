/**
 * # IAM Policies Module
 *
 * This module creates custom IAM policies that can be attached to roles.
 */

# Create custom IAM policies
resource "aws_iam_policy" "pri_policies" {
  for_each = { for policy in var.policies : policy.name => policy }

  name        = "pri-${each.key}"
  description = each.value.description
  policy      = each.value.policy_document
  
  tags = merge(
    {
      Name = "pri-${each.key}"
    },
    var.tags,
    each.value.tags
  )
}
