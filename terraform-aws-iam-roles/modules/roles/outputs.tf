output "roles" {
  description = "Map of IAM roles created"
  value = {
    for name, role in aws_iam_role.pri_roles : name => {
      name = role.name
      arn  = role.arn
      id   = role.id
    }
  }
}

output "permission_boundaries" {
  description = "Map of permission boundary policies created"
  value = var.enable_permission_boundaries ? {
    for name, policy in aws_iam_policy.pri_permission_boundary : name => {
      name = policy.name
      arn  = policy.arn
      id   = policy.id
    }
  } : {}
}
