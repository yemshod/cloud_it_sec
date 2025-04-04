resource "aws_identitystore_group" "this" {
  identity_store_id = var.identity_store_id
  display_name      = var.group_name
  description       = var.description
}
