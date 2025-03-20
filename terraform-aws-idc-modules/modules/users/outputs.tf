output "users" {
  description = "Map of created users and their IDs"
  value       = { for k, v in aws_identitystore_user.pri_users : k => v.user_id }
}
