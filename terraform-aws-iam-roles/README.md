# AWS IAM Roles and Permission Boundaries Terraform Module

This repository contains a set of Terraform modules for managing IAM roles and permission boundaries across multiple AWS accounts. The modules follow a consistent naming convention with the prefix 'pri-' for all resources.

## Features

- Centralized management of IAM roles across multiple AWS accounts
- Consistent permission boundaries for all roles
- Support for AWS managed policies, customer managed policies, and inline policies
- Standardized role structure for common roles like CloudAdmin, NetworkAdmin, etc.
- Multi-account deployment capabilities

## Module Structure

```
terraform-aws-iam-roles/
├── modules/
│   ├── roles/                # Module for creating IAM roles with permission boundaries
│   ├── policies/             # Module for creating custom IAM policies
│   └── permission_boundaries/ # Module for creating permission boundary policies
├── accounts/
│   ├── account1/             # Account-specific configuration
│   ├── account2/             # Account-specific configuration
│   └── ...                   # Additional account configurations
└── examples/
    └── multi-account/        # Example for multi-account deployment
```

## Included Roles

The module includes the following predefined roles, each with appropriate permission boundaries:

1. **CloudAdminRole** - For cloud administrators with broad permissions
2. **NetworkAdminRole** - For network administrators
3. **LZAdminRole** - For landing zone administrators
4. **SecurityViewerRole** - For security auditing and viewing
5. **ViewOnlyRole** - For read-only access across services
6. **DBARole** - For database administrators

## Usage

### Single Account Deployment

Navigate to the specific account directory and run:

```bash
cd accounts/account1
terraform init
terraform apply
```

### Multi-Account Deployment

Use the provided script in the examples/multi-account directory:

```bash
cd examples/multi-account
./deploy.sh
```

This will deploy the roles to all accounts defined in the variables.tf file using Terraform workspaces.

## Creating Custom Roles

To create custom roles, modify the roles list in the account's main.tf file:

```hcl
module "iam_roles" {
  source = "../../modules/roles"

  roles = [
    {
      name               = "CustomRole"
      description        = "Custom role description"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      permission_boundary_policy = data.aws_iam_policy_document.custom_permission_boundary.json
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/SomeAwsManagedPolicy"
      ]
      inline_policies = {
        "CustomInlinePolicy" = data.aws_iam_policy_document.custom_inline.json
      }
    }
  ]

  enable_permission_boundaries = true
  tags = var.tags
}
```

## Integration with AWS Identity Center

This module is designed to work seamlessly with the AWS Identity Center Terraform module. The roles created by this module can be referenced in permission sets to provide access to users and groups.

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS CLI configured with appropriate permissions
- Cross-account access role (OrganizationAccountAccessRole) for multi-account deployment

## Notes

- All resources created by these modules will have the prefix 'pri-' in their names
- Permission boundaries are applied to all roles by default (can be disabled)
- The modules use data sources to define policies for better readability and maintenance

## License

This project is licensed under the MIT License - see the LICENSE file for details.
