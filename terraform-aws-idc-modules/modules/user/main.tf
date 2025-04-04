resource "aws_identitystore_user" "this" {
  identity_store_id = var.identity_store_id

  display_name = var.display_name
  user_name    = var.user_name
  name {
    given_name  = var.given_name
    family_name = var.family_name
  }
  emails {
    value   = var.email
    primary = true
  }
}
