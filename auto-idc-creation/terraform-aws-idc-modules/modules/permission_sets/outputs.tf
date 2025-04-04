output "permission_sets" {
  description = "Map of created permission sets and their ARNs"
  value       = { for k, v in aws_ssoadmin_permission_set.pri_permission_sets : k => v.arn }
}
