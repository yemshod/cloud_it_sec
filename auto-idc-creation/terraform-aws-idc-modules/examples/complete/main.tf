provider "aws" {
  region = "us-east-1"
}

module "aws_idc" {
  source = "../../"

  # Create users
  users = [
    {
      username     = "john.doe"
      email        = "john.doe@example.com"
      display_name = "John Doe"
    },
    {
      username     = "jane.smith"
      email        = "jane.smith@example.com"
      display_name = "Jane Smith"
    }
  ]

  # Create groups
  groups = [
    {
      name        = "Developers"
      description = "Development team members"
    },
    {
      name        = "Administrators"
      description = "System administrators with elevated privileges"
    }
  ]

  # Add users to groups
  group_memberships = [
    {
      username  = "john.doe"
      groupname = "Developers"
    },
    {
      username  = "jane.smith"
      groupname = "Administrators"
    }
  ]

  # Create permission sets
  permission_sets = [
    {
      name        = "ReadOnlyAccess"
      description = "Provides read-only access to all resources"
      policy_type = "AWS_MANAGED"
      policy_name = "ReadOnlyAccess"
    },
    {
      name        = "AdminAccess"
      description = "Provides full administrative access"
      policy_type = "AWS_MANAGED"
      policy_name = "AdministratorAccess"
    },
    {
      name        = "CustomDeveloperAccess"
      description = "Custom policy for developers"
      policy_type = "INLINE"
      policy_name = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = ["s3:Get*", "s3:List*"]
            Resource = "*"
          }
        ]
      })
    }
  ]

  # Assign permission sets to accounts
  account_assignments = [
    {
      permission_set_name = "ReadOnlyAccess"
      account_ids         = ["123456789012", "210987654321"]
      principal_type      = "GROUP"
      principal_name      = "Developers"
    },
    {
      permission_set_name = "AdminAccess"
      account_ids         = ["123456789012"]
      principal_type      = "GROUP"
      principal_name      = "Administrators"
    },
    {
      permission_set_name = "CustomDeveloperAccess"
      account_ids         = ["123456789012"]
      principal_type      = "USER"
      principal_name      = "john.doe"
    }
  ]
}
