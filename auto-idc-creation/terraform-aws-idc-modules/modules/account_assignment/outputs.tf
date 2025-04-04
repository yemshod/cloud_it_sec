output "account_assignments" {
  description = "Map of account assignments created"
  value       = aws_ssoadmin_account_assignment.this
}

output "permission_set_arn" {
  description = "The ARN of the permission set assigned"
  value       = local.permission_set_arn
}

output "principal_id" {
  description = "The ID of the principal assigned"
  value       = var.principal_id
}

output "principal_type" {
  description = "The type of principal assigned"
  value       = var.principal_type
}

output "account_ids" {
  description = "The list of AWS account IDs assigned"
  value       = local.account_ids
}
