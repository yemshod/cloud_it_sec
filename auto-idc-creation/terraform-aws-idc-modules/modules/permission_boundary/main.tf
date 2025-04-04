locals {
  # If permission_set_arn is provided, use it directly; otherwise, look up the permission set by name
  permission_set_arn = var.permission_set_arn != null ? var.permission_set_arn : data.aws_ssoadmin_permission_set.this[0].arn
}

data "aws_ssoadmin_permission_set" "this" {
  count         = var.permission_set_arn == null ? 1 : 0
  instance_arn  = var.instance_arn
  name          = var.permission_set_name
}

resource "aws_ssoadmin_permission_set_permissions_boundary" "this" {
  instance_arn       = var.instance_arn
  permission_set_arn = local.permission_set_arn
  
  # For AWS managed permission boundary
  dynamic "managed_policy_arn" {
    for_each = var.boundary_type == "AWS_MANAGED" ? [1] : []
    content {
      value = "arn:aws:iam::aws:policy/${var.boundary_name}"
    }
  }
  
  # For customer managed permission boundary
  dynamic "customer_managed_policy_reference" {
    for_each = var.boundary_type == "CUSTOMER_MANAGED" ? [1] : []
    content {
      name = var.boundary_name
      path = var.boundary_path
    }
  }
}
