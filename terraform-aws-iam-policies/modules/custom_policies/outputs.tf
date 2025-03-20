output "policies" {
  description = "Map of IAM policies created"
  value = {
    for name, policy in aws_iam_policy.pri_policies : name => {
      name = policy.name
      arn  = policy.arn
      id   = policy.id
    }
  }
}
