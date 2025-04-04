locals {
  # Convert comma-separated account IDs to a list
  account_ids = [for s in split(",", var.account_ids) : trimspace(s)]
  
  # If permission_set_arn is provided, use it directly; otherwise, look up the permission set by name
  permission_set_arn = var.permission_set_arn != null ? var.permission_set_arn : data.aws_ssoadmin_permission_set.this[0].arn
}

data "aws_ssoadmin_permission_set" "this" {
  count         = var.permission_set_arn == null ? 1 : 0
  instance_arn  = var.instance_arn
  name          = var.permission_set_name
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each           = toset(local.account_ids)
  
  instance_arn       = var.instance_arn
  permission_set_arn = local.permission_set_arn
  
  principal_id   = var.principal_id
  principal_type = var.principal_type
  
  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}
