output "account_assignments" {
  description = "Map of account assignments created"
  value       = aws_ssoadmin_account_assignment.this
}

output "permission_set_arn" {
  description = "The ARN of the permission set assigned"
  value       = local.permission_set_arn
}

output "group_id" {
  description = "The ID of the group assigned"
  value       = local.group_id
}

output "account_ids" {
  description = "The list of AWS account IDs assigned"
  value       = local.account_ids
}
