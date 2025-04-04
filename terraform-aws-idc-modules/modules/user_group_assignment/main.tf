locals {
  # If user_id is provided, use it directly; otherwise, look up the user by username
  user_id = var.user_id != null ? var.user_id : data.aws_identitystore_user.this[0].user_id
  
  # If group_id is provided, use it directly; otherwise, look up the group by name
  group_id = var.group_id != null ? var.group_id : data.aws_identitystore_group.this[0].group_id
}

data "aws_identitystore_user" "this" {
  count = var.user_id == null ? 1 : 0
  
  identity_store_id = var.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = var.user_name
  }
}

data "aws_identitystore_group" "this" {
  count = var.group_id == null ? 1 : 0
  
  identity_store_id = var.identity_store_id
  
  filter {
    attribute_path  = "DisplayName"
    attribute_value = var.group_name
  }
}

resource "aws_identitystore_group_membership" "this" {
  identity_store_id = var.identity_store_id
  group_id          = local.group_id
  member_id         = local.user_id
}
