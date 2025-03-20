resource "aws_identitystore_group_membership" "pri_memberships" {
  for_each = { for idx, membership in var.memberships : "${membership.username}-${membership.groupname}" => membership }

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  
  group_id  = data.aws_identitystore_group.groups[each.value.groupname].id
  member_id = data.aws_identitystore_user.users[each.value.username].id
}

data "aws_identitystore_user" "users" {
  for_each = toset([for membership in var.memberships : membership.username])

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = each.key
  }
}

data "aws_identitystore_group" "groups" {
  for_each = toset([for membership in var.memberships : membership.groupname])

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  
  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.key
  }
}

data "aws_ssoadmin_instance" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_ssoadmin_instances" "this" {}
