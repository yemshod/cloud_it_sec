# AWS Identity Center (IDC) Terraform Modules

This repository contains a set of Terraform modules for managing AWS Identity Center (IDC) resources. The modules follow a consistent naming convention with the prefix 'pri-' for all resources.

## Features

- Create and manage users in AWS Identity Center
- Create and manage groups in AWS Identity Center
- Add users to groups
- Create permission sets with different policy types (AWS managed, customer managed, inline)
- Assign permission sets to AWS accounts for users or groups

## Module Structure

```
terraform-aws-idc-modules/
├── modules/
│   ├── users/                # Module for creating users
│   ├── groups/               # Module for creating groups
│   ├── group_memberships/    # Module for adding users to groups
│   ├── permission_sets/      # Module for creating permission sets
│   └── account_assignments/  # Module for assigning permission sets to accounts
└── examples/
    └── complete/            # Complete example using all modules
```

## Usage

### Creating Users

```hcl
module "aws_idc" {
  source = "path/to/terraform-aws-idc-modules"
  
  users = [
    {
      username     = "john.doe"
      email        = "john.doe@example.com"
      display_name = "John Doe"
    }
  ]
}
```

### Creating Groups

```hcl
module "aws_idc" {
  source = "path/to/terraform-aws-idc-modules"
  
  groups = [
    {
      name        = "Developers"
      description = "Development team members"
    }
  ]
}
```

### Adding Users to Groups

```hcl
module "aws_idc" {
  source = "path/to/terraform-aws-idc-modules"
  
  group_memberships = [
    {
      username  = "john.doe"
      groupname = "Developers"
    }
  ]
}
```

### Creating Permission Sets

```hcl
module "aws_idc" {
  source = "path/to/terraform-aws-idc-modules"
  
  permission_sets = [
    {
      name        = "ReadOnlyAccess"
      description = "Provides read-only access to all resources"
      policy_type = "AWS_MANAGED"
      policy_name = "ReadOnlyAccess"
    },
    {
      name        = "CustomAccess"
      description = "Custom inline policy"
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
}
```

### Assigning Permission Sets to Accounts

```hcl
module "aws_idc" {
  source = "path/to/terraform-aws-idc-modules"
  
  account_assignments = [
    {
      permission_set_name = "ReadOnlyAccess"
      account_ids         = ["123456789012", "210987654321"]
      principal_type      = "GROUP"
      principal_name      = "Developers"
    }
  ]
}
```

## Complete Example

See the [complete example](./examples/complete/main.tf) for a comprehensive demonstration of all module features.

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS CLI configured with appropriate permissions

## Notes

- All resources created by these modules will have the prefix 'pri-' in their names
- The modules use data sources to look up existing resources when needed
- Dependencies between modules are managed automatically

## License

This project is licensed under the MIT License - see the LICENSE file for details.
