# AWS IAM Policies for Identity Center Terraform Module

This repository contains a set of Terraform modules for managing IAM policies and permission boundaries across multiple AWS accounts. These policies are designed to be used with AWS Identity Center permission sets. The modules follow a consistent naming convention with the prefix 'pri-' for all resources.

## Features

- Centralized management of IAM policies across multiple AWS accounts
- Support for splitting large policies into multiple parts to handle IAM policy size limitations
- Consistent permission boundaries for all roles
- Least privilege policies for common roles like CloudAdmin, NetworkAdmin, etc.
- Multi-account deployment capabilities

## Module Structure

```
terraform-aws-iam-policies/
├── modules/
│   ├── custom_policies/        # Module for creating custom IAM policies
│   └── permission_boundaries/  # Module for creating permission boundary policies
├── accounts/
│   ├── account1/               # Account-specific configuration
│   ├── account2/               # Account-specific configuration
│   └── ...                     # Additional account configurations
└── examples/
    └── multi-account/          # Example for multi-account deployment
```

## Included Policies

The module includes the following predefined policies, each with appropriate permission boundaries:

1. **CloudAdminPolicy** - For cloud administrators with broad permissions
2. **NetworkAdminPolicy** - For network administrators
3. **LZAdminPolicy** - For landing zone administrators
4. **SecurityViewerPolicy** - For security auditing and viewing
5. **ViewOnlyPolicy** - For read-only access across services
6. **DBAPolicy** - For database administrators (split into multiple parts due to size)

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

This will deploy the policies to all accounts defined in the variables.tf file using Terraform workspaces.

## Creating Custom Policies

To create custom policies, modify the policies list in the account's main.tf file:

```hcl
module "custom_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "CustomPolicy"
      description = "Custom policy description"
      policy_statements = [
        {
          Effect   = "Allow"
          Action   = [
            "service:Action1",
            "service:Action2"
          ]
          Resource = "*"
        }
      ]
    }
  ]

  tags = var.tags
}
```

## Handling Large Policies

For large policies that exceed IAM size limits, you can split them into multiple parts:

```hcl
module "large_policies" {
  source = "../../modules/custom_policies"

  policies = [
    {
      name        = "LargePolicy"
      description = "Large policy that needs to be split"
      policy_statements = [
        # Many policy statements here
      ]
      split_policy = true
      chunk_size   = 10  # Number of statements per policy
    }
  ]

  tags = var.tags
}
```

## Integration with AWS Identity Center

To use these policies with AWS Identity Center:

1. Deploy the policies to the target accounts using this module
2. In the AWS Identity Center account, create permission sets that reference these policies by name
3. Assign the permission sets to users/groups and target accounts

Example permission set configuration in AWS Identity Center:

```hcl
resource "aws_ssoadmin_permission_set" "example" {
  name             = "ExamplePermissionSet"
  instance_arn     = aws_ssoadmin_instance.example.arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "example" {
  permission_set_arn    = aws_ssoadmin_permission_set.example.arn
  instance_arn          = aws_ssoadmin_instance.example.arn
  customer_managed_policy_reference {
    name = "pri-CloudAdminPolicy"  # Must match the name of the policy created by this module
    path = "/"
  }
}

resource "aws_ssoadmin_permission_boundary_attachment" "example" {
  permission_set_arn    = aws_ssoadmin_permission_set.example.arn
  instance_arn          = aws_ssoadmin_instance.example.arn
  permission_boundary {
    customer_managed_policy_reference {
      name = "pri-CloudAdminRole-permission-boundary"  # Must match the name of the permission boundary created by this module
      path = "/"
    }
  }
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS CLI configured with appropriate permissions
- Cross-account access role (OrganizationAccountAccessRole) for multi-account deployment

## Notes

- All resources created by these modules will have the prefix 'pri-' in their names
- Policies follow least privilege principles
- The modules use a structured approach to define policies for better readability and maintenance

## License

This project is licensed under the MIT License - see the LICENSE file for details.
