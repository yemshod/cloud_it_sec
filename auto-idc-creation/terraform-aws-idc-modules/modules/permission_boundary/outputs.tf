output "permission_set_arn" {
  description = "The ARN of the permission set"
  value       = local.permission_set_arn
}

output "boundary_type" {
  description = "The type of permission boundary attached"
  value       = var.boundary_type
}

output "boundary_name" {
  description = "The name of the permission boundary policy attached"
  value       = var.boundary_name
}
