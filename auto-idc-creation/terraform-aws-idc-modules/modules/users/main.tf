resource "aws_identitystore_user" "pri_users" {
  for_each = { for user in var.users : user.username => user }

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id

  display_name = each.value.display_name
  user_name    = each.value.username

  emails {
    primary = true
    value   = each.value.email
  }
}

data "aws_ssoadmin_instance" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_ssoadmin_instances" "this" {}
