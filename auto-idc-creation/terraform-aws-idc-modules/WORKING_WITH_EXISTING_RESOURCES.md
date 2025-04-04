# Working with Existing AWS Identity Center Resources

This guide explains how to use these Terraform modules with resources that already exist in your AWS Identity Center (IDC) environment.

## Overview

The modules are designed to work seamlessly with both new and existing resources. This is particularly useful when you want to:

1. Add existing users to existing groups
2. Assign existing users to AWS accounts with existing permission sets
3. Assign existing groups to AWS accounts with existing permission sets

## How It Works

The modules use AWS data sources to look up existing resources by name:

- `aws_identitystore_user` - Looks up users by username
- `aws_identitystore_group` - Looks up groups by name
- `aws_ssoadmin_permission_set` - Looks up permission sets by name

## Examples

### Adding an Existing User to an Existing Group

```hcl
module "add_existing_user_to_group" {
  source = "./modules/user_group_assignment"

  identity_store_id = local.identity_store_id
  user_name         = "existing.user"     # Name of existing user
  group_name        = "existing-group"    # Name of existing group
}
```

### Assigning an Existing User to Accounts with an Existing Permission Set

```hcl
# Look up the existing user
data "aws_identitystore_user" "existing_user" {
  identity_store_id = local.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = "existing.user"
  }
}

module "assign_existing_user_to_accounts" {
  source = "./modules/account_assignment"

  instance_arn        = local.instance_arn
  permission_set_name = "existing-permission-set"  # Name of existing permission set
  principal_id        = data.aws_identitystore_user.existing_user.user_id
  principal_type      = "USER"
  account_ids         = "123456789012, 234567890123"
}
```

### Assigning an Existing Group to Accounts with an Existing Permission Set

```hcl
module "assign_existing_group_to_accounts" {
  source = "./modules/group_account_assignment"

  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = "existing-group"           # Name of existing group
  permission_set_name = "existing-permission-set"  # Name of existing permission set
  account_ids         = "123456789012, 234567890123"
}
```

## Bulk Operations with Existing Resources

You can also perform bulk operations with existing resources:

```hcl
locals {
  users_to_add = [
    "existing.user1",
    "existing.user2",
    "existing.user3"
  ]
}

module "add_multiple_users_to_group" {
  source = "../modules/user_group_assignment"
  for_each = toset(local.users_to_add)
  
  identity_store_id = local.identity_store_id
  user_name         = each.value
  group_name        = "existing-group"
}
```

## Using the Command-Line Script

The `examples/user_management_existing.sh` script is specifically designed for working with existing resources:

```bash
# Add an existing user to an existing group
./user_management_existing.sh --action add_user_to_group \
  --user-name existing.user \
  --group-name existing-group

# Assign an existing user to accounts with an existing permission set
./user_management_existing.sh --action assign_user_to_account \
  --user-name existing.user \
  --permission-set-name existing-permission-set \
  --account-ids "123456789012,234567890123"

# Assign an existing group to accounts with an existing permission set
./user_management_existing.sh --action assign_group_to_account \
  --group-name existing-group \
  --permission-set-name existing-permission-set \
  --account-ids "123456789012,234567890123"
```

## Important Notes

1. **Case Sensitivity**: Make sure to use the exact names of your existing resources, as lookups are case-sensitive.

2. **Error Handling**: If a resource cannot be found, Terraform will return an error during the plan or apply phase.

3. **State Management**: When working with existing resources, Terraform will only manage the relationships you define (e.g., group membership, account assignment), not the underlying resources themselves.

4. **Idempotency**: These operations are idempotent - running them multiple times with the same parameters will not create duplicate assignments.

## Troubleshooting

If you encounter errors like "User not found" or "Group not found":

1. Verify that the resource exists in AWS Identity Center
2. Check that you're using the correct name (exact spelling and case)
3. Ensure your AWS credentials have sufficient permissions to read the resources
4. Check the AWS region you're using matches where your Identity Center instance is located
