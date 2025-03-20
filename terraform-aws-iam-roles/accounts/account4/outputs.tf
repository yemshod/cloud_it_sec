output "roles" {
  description = "Map of IAM roles created"
  value       = module.iam_roles.roles
}

output "permission_boundaries" {
  description = "Map of permission boundary policies created"
  value       = module.iam_roles.permission_boundaries
}
