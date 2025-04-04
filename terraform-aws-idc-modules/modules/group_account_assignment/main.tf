locals {
  # Convert comma-separated account IDs to a list
  account_ids = [for s in split(",", var.account_ids) : trimspace(s)]
  
  # If group_id is provided, use it directly; otherwise, look up the group by name
  group_id = var.group_id != null ? var.group_id : data.aws_identitystore_group.this[0].group_id
  
  # If permission_set_arn is provided, use it directly; otherwise, look up the permission set by name
  permission_set_arn = var.permission_set_arn != null ? var.permission_set_arn : data.aws_ssoadmin_permission_set.this[0].arn
}

data "aws_identitystore_group" "this" {
  count = var.group_id == null ? 1 : 0
  
  identity_store_id = var.identity_store_id
  
  filter {
    attribute_path  = "DisplayName"
    attribute_value = var.group_name
  }
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
  
  principal_id   = local.group_id
  principal_type = "GROUP"
  
  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}
