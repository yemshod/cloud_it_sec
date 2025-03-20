output "permission_boundaries" {
  description = "Map of permission boundary policies created"
  value = {
    for name, policy in aws_iam_policy.pri_permission_boundaries : name => {
      name = policy.name
      arn  = policy.arn
      id   = policy.id
    }
  }
}
