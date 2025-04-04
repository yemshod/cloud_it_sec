output "groups" {
  description = "Map of created groups and their IDs"
  value       = { for k, v in aws_identitystore_group.pri_groups : k => v.group_id }
}
