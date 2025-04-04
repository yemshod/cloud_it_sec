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
