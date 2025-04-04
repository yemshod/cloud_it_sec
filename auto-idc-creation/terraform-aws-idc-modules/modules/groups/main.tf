resource "aws_identitystore_group" "pri_groups" {
  for_each = { for group in var.groups : group.name => group }

  identity_store_id = data.aws_ssoadmin_instance.this.identity_store_id
  display_name      = each.value.name
  description       = each.value.description
}

data "aws_ssoadmin_instance" "this" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_ssoadmin_instances" "this" {}
