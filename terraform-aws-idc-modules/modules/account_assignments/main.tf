locals {
  # Flatten account assignments for easier iteration
  flattened_assignments = flatten([
    for assignment in var.account_assignments : [
      for account_id in assignment.account_ids : {
        permission_set_name = assignment.permission_set_name
        account_id         = account_id
        principal_type     = assignment.principal_type
        principal_name     = assignment.principal_name
      }
    ]
  ])
}

resource "aws_ssoadmin_account_assignment" "pri_assignments" {
  for_each = {
    for idx, assignment in local.flattened_assignments :
    "${assignment.permission_set_name}-${assignment.account_id}-${assignment.principal_name}" => assignment
  }

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.permission_sets[each.value.permission_set_name].arn

  principal_id   = each.value.principal_type == "GROUP" ? data.aws_identitystore_group.groups[each.value.principal_name].id : data.aws_identitystore_user.users[each.value.principal_name].id
  principal_type = each.value.principal_type

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}

data "aws_ssoadmin_permission_set" "permission_sets" {
  for_each = toset([for assignment in var.account_assignments : assignment.permission_set_name])

  instance_arn = data.aws_ssoadmin_instances.this.arns[0]
  name         = "pri-${each.key}"
}

data "aws_identitystore_group" "groups" {
  for_each = toset([
    for assignment in var.account_assignments :
    assignment.principal_name if assignment.principal_type == "GROUP"
  ])

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  
  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.key
  }
}

data "aws_identitystore_user" "users" {
  for_each = toset([
    for assignment in var.account_assignments :
    assignment.principal_name if assignment.principal_type == "USER"
  ])

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = each.key
  }
}

data "aws_ssoadmin_instance" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_ssoadmin_instances" "this" {}
