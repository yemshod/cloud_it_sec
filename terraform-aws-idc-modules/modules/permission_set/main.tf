resource "aws_ssoadmin_permission_set" "this" {
  name             = "pri-${var.permission_set_name}"
  description      = var.description
  instance_arn     = var.instance_arn
  session_duration = var.session_duration
  relay_state      = var.relay_state
  tags             = var.tags
}

# Attach AWS managed policy if specified
resource "aws_ssoadmin_managed_policy_attachment" "aws_managed" {
  count              = var.policy_type == "AWS_MANAGED" ? 1 : 0
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/${var.policy_name}"
}

# Attach customer managed policy if specified
resource "aws_ssoadmin_customer_managed_policy_attachment" "customer_managed" {
  count              = var.policy_type == "CUSTOMER_MANAGED" ? 1 : 0
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  customer_managed_policy_reference {
    name = var.policy_name
    path = var.policy_path
  }
}

# Attach inline policy if specified
resource "aws_ssoadmin_permission_set_inline_policy" "inline" {
  count              = var.policy_type == "INLINE" && var.inline_policy != null ? 1 : 0
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.inline_policy
}
