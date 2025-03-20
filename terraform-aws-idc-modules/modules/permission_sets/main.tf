resource "aws_ssoadmin_permission_set" "pri_permission_sets" {
  for_each = { for ps in var.permission_sets : ps.name => ps }

  name             = "pri-${each.value.name}"
  description      = each.value.description
  instance_arn     = data.aws_ssoadmin_instances.this.arns[0]
  session_duration = each.value.session_duration
  
  tags = merge(
    {
      Name = "pri-${each.value.name}"
    },
    each.value.tags
  )
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_managed" {
  for_each = {
    for ps in var.permission_sets : ps.name => ps
    if ps.policy_type == "AWS_MANAGED"
  }

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.pri_permission_sets[each.key].arn
  managed_policy_arn = "arn:aws:iam::aws:policy/${each.value.policy_name}"
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "customer_managed" {
  for_each = {
    for ps in var.permission_sets : ps.name => ps
    if ps.policy_type == "CUSTOMER_MANAGED"
  }

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.pri_permission_sets[each.key].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = "/"
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline" {
  for_each = {
    for ps in var.permission_sets : ps.name => ps
    if ps.policy_type == "INLINE"
  }

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.pri_permission_sets[each.key].arn
  inline_policy      = each.value.policy_name
}

data "aws_ssoadmin_instances" "this" {}
