output "permission_set_arn" {
  description = "The ARN of the permission set"
  value       = aws_ssoadmin_permission_set.this.arn
}

output "permission_set_id" {
  description = "The ID of the permission set"
  value       = aws_ssoadmin_permission_set.this.id
}

output "permission_set_name" {
  description = "The name of the permission set"
  value       = aws_ssoadmin_permission_set.this.name
}

output "permission_boundary_attached" {
  description = "Whether a permission boundary was attached to the permission set"
  value       = var.permission_boundary_type != "NONE"
}
