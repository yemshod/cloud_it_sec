provider "aws" {
  region = var.region
  # Uncomment and use for cross-account deployment
  # assume_role {
  #   role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  # }
}

module "iam_roles" {
  source = "../../modules/roles"

  roles = [
    {
      name               = "CloudAdminRole"
      description        = "Role for Cloud Administrators"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.cloud_admin_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
      inline_policies = {}
    },
    {
      name               = "NetworkAdminRole"
      description        = "Role for Network Administrators"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.network_admin_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
      ]
      inline_policies = {
        "AdditionalNetworkPermissions" = data.aws_iam_policy_document.network_admin_additional.json
      }
    },
    {
      name               = "LZAdminRole"
      description        = "Role for Landing Zone Administrators"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.lz_admin_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
      inline_policies = {
        "LZSpecificPermissions" = data.aws_iam_policy_document.lz_admin_specific.json
      }
    },
    {
      name               = "SecurityViewerRole"
      description        = "Role for Security Viewers"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.security_viewer_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/SecurityAudit",
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ]
      inline_policies = {}
    },
    {
      name               = "ViewOnlyRole"
      description        = "Role for View-Only Access"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.view_only_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ]
      inline_policies = {}
    },
    {
      name               = "DBARole"
      description        = "Role for Database Administrators"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.dba_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
        "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
        "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
      ]
      inline_policies = {
        "DBASpecificPermissions" = data.aws_iam_policy_document.dba_specific.json
      }
    }
  ]

  enable_permission_boundaries = true
  
  tags = var.tags
}

# Trust policy for assuming roles via AWS SSO
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["identitystore.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.organization_id]
    }
  }
}

# Permission boundary policies
data "aws_iam_policy_document" "cloud_admin_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
  
  statement {
    effect    = "Deny"
    actions   = [
      "organizations:*",
      "account:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "network_admin_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = [
      "ec2:*",
      "elasticloadbalancing:*",
      "route53:*",
      "cloudfront:*",
      "apigateway:*"
    ]
    resources = ["*"]
  }
  
  statement {
    effect    = "Deny"
    actions   = [
      "ec2:DeleteVpc",
      "ec2:DeleteSubnet",
      "organizations:*",
      "iam:*User*",
      "iam:*Group*",
      "iam:*Role*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "network_admin_additional" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:DescribeLogGroups",
      "logs:GetLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lz_admin_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
  
  statement {
    effect    = "Deny"
    actions   = [
      "organizations:LeaveOrganization",
      "organizations:DeleteOrganization",
      "organizations:RemoveAccountFromOrganization"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lz_admin_specific" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudformation:*",
      "servicecatalog:*",
      "config:*",
      "cloudtrail:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "security_viewer_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = [
      "config:Get*",
      "config:List*",
      "config:Describe*",
      "cloudtrail:Get*",
      "cloudtrail:Describe*",
      "cloudtrail:LookupEvents",
      "guardduty:Get*",
      "guardduty:List*",
      "securityhub:Get*",
      "securityhub:List*",
      "securityhub:Describe*",
      "inspector:Get*",
      "inspector:List*",
      "inspector:Describe*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "view_only_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*",
      "ec2:Describe*",
      "rds:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "s3:Get*",
      "s3:List*"
    ]
    resources = ["*"]
  }
  
  statement {
    effect    = "Deny"
    actions   = [
      "s3:GetObject"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "dba_permission_boundary" {
  statement {
    effect    = "Allow"
    actions   = [
      "rds:*",
      "dynamodb:*",
      "redshift:*",
      "elasticache:*",
      "dax:*",
      "docdb:*",
      "neptune:*"
    ]
    resources = ["*"]
  }
  
  statement {
    effect    = "Deny"
    actions   = [
      "rds:DeleteDBInstance",
      "rds:DeleteDBCluster",
      "dynamodb:DeleteTable",
      "redshift:DeleteCluster"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "dba_specific" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:DescribeLogGroups",
      "logs:GetLogEvents",
      "sns:ListTopics",
      "sns:ListSubscriptions"
    ]
    resources = ["*"]
  }
}
