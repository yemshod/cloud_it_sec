output "membership_id" {
  description = "The ID of the group membership"
  value       = aws_identitystore_group_membership.this.membership_id
}

output "user_id" {
  description = "The ID of the user added to the group"
  value       = local.user_id
}

output "group_id" {
  description = "The ID of the group the user was added to"
  value       = local.group_id
}
