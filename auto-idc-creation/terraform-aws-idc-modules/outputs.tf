output "users" {
  description = "Map of created users and their IDs"
  value       = module.users.users
}

output "groups" {
  description = "Map of created groups and their IDs"
  value       = module.groups.groups
}

output "permission_sets" {
  description = "Map of created permission sets and their ARNs"
  value       = module.permission_sets.permission_sets
}
