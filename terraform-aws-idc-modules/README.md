# AWS Identity Center (IDC) Terraform Modules

This repository contains a collection of Terraform modules for managing AWS Identity Center (IDC) resources. These modules provide a robust and flexible way to manage users, groups, permission sets, and account assignments in AWS Identity Center.

## Modules

The repository includes the following modules:

1. **User Module** - Create users in AWS Identity Center
2. **Group Module** - Create groups in AWS Identity Center
3. **User Group Assignment Module** - Add users to groups
4. **Permission Set Module** - Create permission sets with various policy types
5. **Account Assignment Module** - Assign permission sets to AWS accounts for users or groups
6. **Group Account Assignment Module** - Assign groups to AWS accounts with permission sets

## Prerequisites

- Terraform 0.14+
- AWS CLI configured with appropriate permissions
- AWS Identity Center enabled in your AWS Organization

## Usage

### Getting Identity Store ID and Instance ARN

Before using these modules, you need to get your Identity Store ID and SSO Instance ARN:

```hcl
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}
```

### Creating a User

```hcl
module "create_user" {
  source = "./modules/user"

  identity_store_id = local.identity_store_id
  user_name         = "john.doe"
  display_name      = "John Doe"
  given_name        = "John"
  family_name       = "Doe"
  email             = "john.doe@example.com"
}
```

### Creating a Group

```hcl
module "create_group" {
  source = "./modules/group"

  identity_store_id = local.identity_store_id
  group_name        = "pri-developers"
  description       = "Group for developers"
}
```

### Adding a User to a Group

```hcl
module "add_user_to_group" {
  source = "./modules/user_group_assignment"

  identity_store_id = local.identity_store_id
  user_name         = "john.doe"  # Can use user_id instead if known
  group_name        = "pri-developers"  # Can use group_id instead if known
}
```

### Creating a Permission Set

```hcl
module "create_permission_set" {
  source = "./modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "developer-access"
  description         = "Developer access permission set"
  policy_type         = "AWS_MANAGED"
  policy_name         = "PowerUserAccess"
}
```

### Assigning a Permission Set to an Account for a User

```hcl
module "assign_permission_to_account" {
  source = "./modules/account_assignment"

  instance_arn        = local.instance_arn
  permission_set_name = "developer-access"  # Can use permission_set_arn instead if known
  principal_id        = "user-id-here"
  principal_type      = "USER"
  account_ids         = "123456789012, 234567890123"  # Comma-separated list of account IDs
}
```

### Assigning a Group to an Account with a Permission Set

```hcl
module "assign_group_to_account" {
  source = "./modules/group_account_assignment"

  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = "pri-developers"  # Can use group_id instead if known
  permission_set_name = "developer-access"  # Can use permission_set_arn instead if known
  account_ids         = "123456789012, 234567890123"  # Comma-separated list of account IDs
}
```

## Module Inputs and Outputs

Each module has its own set of inputs and outputs. Please refer to the individual module's README for detailed information.

## Examples

Check the `examples` directory for complete examples of how to use these modules together.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
