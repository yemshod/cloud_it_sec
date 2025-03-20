output "cloud_admin_policies" {
  description = "Cloud Admin Policies"
  value       = module.cloud_admin_policies.policies
}

output "network_admin_policies" {
  description = "Network Admin Policies"
  value       = module.network_admin_policies.policies
}

output "lz_admin_policies" {
  description = "Landing Zone Admin Policies"
  value       = module.lz_admin_policies.policies
}

output "security_viewer_policies" {
  description = "Security Viewer Policies"
  value       = module.security_viewer_policies.policies
}

output "view_only_policies" {
  description = "View Only Policies"
  value       = module.view_only_policies.policies
}

output "dba_policies" {
  description = "Database Administrator Policies"
  value       = module.dba_policies.policies
}

output "permission_boundaries" {
  description = "Permission Boundaries"
  value       = module.permission_boundaries.permission_boundaries
}

output "current_account" {
  description = "Current AWS account being processed"
  value       = var.account_ids[terraform.workspace]
}
