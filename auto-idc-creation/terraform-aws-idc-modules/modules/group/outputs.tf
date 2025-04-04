output "group_id" {
  description = "The ID of the created group"
  value       = aws_identitystore_group.this.group_id
}

output "identity_store_id" {
  description = "The ID of the Identity Store"
  value       = var.identity_store_id
}

output "group_name" {
  description = "The name of the created group"
  value       = aws_identitystore_group.this.display_name
}
