output "roles" {
  description = "Map of IAM roles created"
  value       = module.iam_roles.roles
}

output "permission_boundaries" {
  description = "Map of permission boundary policies created"
  value       = module.iam_roles.permission_boundaries
}

output "current_account" {
  description = "Current AWS account being processed"
  value       = var.account_ids[terraform.workspace]
}
