output "user_id" {
  description = "The ID of the created user"
  value       = aws_identitystore_user.this.user_id
}

output "identity_store_id" {
  description = "The ID of the Identity Store"
  value       = var.identity_store_id
}

output "user_name" {
  description = "The username of the created user"
  value       = aws_identitystore_user.this.user_name
}
