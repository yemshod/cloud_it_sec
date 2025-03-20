/**
 * # Custom IAM Policies Module
 *
 * This module creates custom IAM policies in target accounts that can be referenced by AWS Identity Center permission sets.
 */

locals {
  # Create a map of policy names to their configurations
  policies_map = { for policy in var.policies : policy.name => policy }
  
  # Split large policies into chunks if needed due to IAM policy size limitations
  policy_chunks = flatten([
    for policy_name, policy in local.policies_map : [
      for idx, chunk in policy.split_policy == true ? chunklist(policy.policy_statements, policy.chunk_size) : [[]] : {
        name        = policy.split_policy ? "${policy_name}-part${idx + 1}" : policy_name
        description = policy.description
        statements  = policy.split_policy ? chunk : policy.policy_statements
        tags        = policy.tags
      } if length(chunk) > 0 || !policy.split_policy
    ]
  ])
}

# Create the IAM policies
resource "aws_iam_policy" "pri_policies" {
  for_each = { for idx, policy in local.policy_chunks : policy.name => policy }

  name        = "pri-${each.key}"
  description = each.value.description
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = each.value.statements
  })
  
  tags = merge(
    {
      Name = "pri-${each.key}"
    },
    var.tags,
    each.value.tags
  )
}
