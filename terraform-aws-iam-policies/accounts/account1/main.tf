provider "aws" {
  region = var.region
  # Uncomment and use for cross-account deployment
  # assume_role {
  #   role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  # }
}

# Custom IAM Policies for CloudAdminRole
module "cloud_admin_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "CloudAdminPolicy"
      description = "Policy for Cloud Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "organizations:LeaveOrganization",
            "organizations:DeleteOrganization",
            "organizations:RemoveAccountFromOrganization",
            "account:CloseAccount"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Custom IAM Policies for NetworkAdminRole
module "network_admin_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "NetworkAdminPolicy"
      description = "Policy for Network Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "ec2:*",
            "elasticloadbalancing:*",
            "route53:*",
            "cloudfront:*",
            "apigateway:*",
            "acm:*",
            "globalaccelerator:*",
            "directconnect:*",
            "networkmanager:*",
            "vpc-lattice:*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics",
            "cloudwatch:GetMetricStatistics",
            "logs:DescribeLogGroups",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
          ]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:GetRole",
            "iam:ListAttachedRolePolicies",
            "iam:ListRolePolicies",
            "iam:ListRoles"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Custom IAM Policies for LZAdminRole
module "lz_admin_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "LZAdminPolicy"
      description = "Policy for Landing Zone Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "organizations:LeaveOrganization",
            "organizations:DeleteOrganization",
            "organizations:RemoveAccountFromOrganization",
            "account:CloseAccount"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Custom IAM Policies for SecurityViewerRole
module "security_viewer_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "SecurityViewerPolicy"
      description = "Policy for Security Viewers"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "config:Get*",
            "config:List*",
            "config:Describe*",
            "config:BatchGet*",
            "config:SelectResourceConfig",
            "cloudtrail:Get*",
            "cloudtrail:Describe*",
            "cloudtrail:LookupEvents",
            "cloudtrail:ListTags",
            "guardduty:Get*",
            "guardduty:List*",
            "securityhub:Get*",
            "securityhub:List*",
            "securityhub:Describe*",
            "inspector:Get*",
            "inspector:List*",
            "inspector:Describe*",
            "inspector2:Get*",
            "inspector2:List*",
            "inspector2:Describe*",
            "macie2:Get*",
            "macie2:List*",
            "macie2:Describe*",
            "access-analyzer:Get*",
            "access-analyzer:List*",
            "access-analyzer:ValidatePolicy",
            "iam:GenerateCredentialReport",
            "iam:GenerateServiceLastAccessedDetails",
            "iam:Get*",
            "iam:List*",
            "iam:SimulatePrincipalPolicy",
            "iam:SimulateCustomPolicy"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Custom IAM Policies for ViewOnlyRole
module "view_only_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "ViewOnlyPolicy"
      description = "Policy for View-Only Access"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "cloudwatch:Describe*",
            "ec2:Describe*",
            "rds:Describe*",
            "dynamodb:List*",
            "dynamodb:Describe*",
            "s3:Get*",
            "s3:List*",
            "lambda:List*",
            "lambda:Get*",
            "sns:List*",
            "sns:Get*",
            "sqs:List*",
            "sqs:Get*",
            "iam:Get*",
            "iam:List*",
            "kms:List*",
            "kms:Describe*",
            "elasticloadbalancing:Describe*",
            "autoscaling:Describe*",
            "cloudfront:List*",
            "cloudfront:Get*",
            "route53:List*",
            "route53:Get*",
            "apigateway:GET",
            "logs:Describe*",
            "logs:Get*",
            "logs:List*",
            "logs:StartQuery",
            "logs:StopQuery",
            "logs:TestMetricFilter",
            "logs:FilterLogEvents",
            "elasticache:Describe*",
            "elasticache:List*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "s3:GetObject"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Custom IAM Policies for DBARole
module "dba_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "DBAPolicy-Part1"
      description = "Policy for Database Administrators - Part 1"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "rds:*",
            "redshift:*",
            "elasticache:*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "cloudwatch:GetMetricData",
            "cloudwatch:ListMetrics",
            "cloudwatch:GetMetricStatistics",
            "logs:DescribeLogGroups",
            "logs:GetLogEvents",
            "logs:FilterLogEvents",
            "sns:ListTopics",
            "sns:ListSubscriptions",
            "sns:Publish"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "DBAPolicy-Part2"
      description = "Policy for Database Administrators - Part 2"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "dynamodb:*",
            "dax:*",
            "docdb:*",
            "neptune:*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "kms:List*",
            "kms:Describe*",
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "rds:DeleteDBInstance",
            "rds:DeleteDBCluster",
            "dynamodb:DeleteTable",
            "redshift:DeleteCluster",
            "docdb:DeleteDBCluster",
            "neptune:DeleteDBCluster"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}

# Permission Boundaries
module "permission_boundaries" {
  source = "../../modules/permission_boundaries"

  permission_boundaries = [
    {
      name        = "CloudAdminRole"
      description = "Permission Boundary for Cloud Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "organizations:*",
            "account:*",
            "iam:CreateUser",
            "iam:DeleteUser",
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "NetworkAdminRole"
      description = "Permission Boundary for Network Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "ec2:*",
            "elasticloadbalancing:*",
            "route53:*",
            "cloudfront:*",
            "apigateway:*",
            "acm:*",
            "globalaccelerator:*",
            "directconnect:*",
            "networkmanager:*",
            "vpc-lattice:*",
            "cloudwatch:*",
            "logs:*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "ec2:DeleteVpc",
            "ec2:DeleteSubnet",
            "organizations:*",
            "iam:*User*",
            "iam:*Group*",
            "iam:*Role*"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "LZAdminRole"
      description = "Permission Boundary for Landing Zone Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "organizations:LeaveOrganization",
            "organizations:DeleteOrganization",
            "organizations:RemoveAccountFromOrganization",
            "account:CloseAccount"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "SecurityViewerRole"
      description = "Permission Boundary for Security Viewers"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "config:*",
            "cloudtrail:*",
            "guardduty:*",
            "securityhub:*",
            "inspector:*",
            "inspector2:*",
            "macie2:*",
            "access-analyzer:*",
            "iam:Get*",
            "iam:List*",
            "iam:Generate*",
            "iam:Simulate*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "config:DeleteConfigRule",
            "config:DeleteConfigurationRecorder",
            "config:DeleteDeliveryChannel",
            "cloudtrail:DeleteTrail",
            "guardduty:DeleteDetector",
            "securityhub:DeleteHub",
            "inspector:DeleteAssessmentRun",
            "inspector:DeleteAssessmentTarget",
            "inspector:DeleteAssessmentTemplate",
            "macie2:DisableMacie"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "ViewOnlyRole"
      description = "Permission Boundary for View-Only Access"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "cloudwatch:Describe*",
            "ec2:Describe*",
            "rds:Describe*",
            "dynamodb:List*",
            "dynamodb:Describe*",
            "s3:Get*",
            "s3:List*",
            "lambda:List*",
            "lambda:Get*",
            "sns:List*",
            "sns:Get*",
            "sqs:List*",
            "sqs:Get*",
            "iam:Get*",
            "iam:List*",
            "kms:List*",
            "kms:Describe*",
            "elasticloadbalancing:Describe*",
            "autoscaling:Describe*",
            "cloudfront:List*",
            "cloudfront:Get*",
            "route53:List*",
            "route53:Get*",
            "apigateway:GET",
            "logs:Describe*",
            "logs:Get*",
            "logs:List*",
            "logs:StartQuery",
            "logs:StopQuery",
            "logs:TestMetricFilter",
            "logs:FilterLogEvents",
            "elasticache:Describe*",
            "elasticache:List*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "s3:GetObject"
          ]
          Resource = "*"
        }
      ]
    },
    {
      name        = "DBARole"
      description = "Permission Boundary for Database Administrators"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "rds:*",
            "dynamodb:*",
            "redshift:*",
            "elasticache:*",
            "dax:*",
            "docdb:*",
            "neptune:*",
            "cloudwatch:*",
            "logs:*",
            "sns:*",
            "kms:List*",
            "kms:Describe*",
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*"
          ]
          Resource = "*"
        },
        {
          Effect   = "Deny"
          Action   = [
            "rds:DeleteDBInstance",
            "rds:DeleteDBCluster",
            "dynamodb:DeleteTable",
            "redshift:DeleteCluster",
            "docdb:DeleteDBCluster",
            "neptune:DeleteDBCluster"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}
