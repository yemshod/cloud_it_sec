# AWS Identity Center Terraform Modules - Examples

This directory contains examples of how to use the AWS Identity Center Terraform modules.

## Basic Example

The `main.tf` file demonstrates basic usage of all the modules:

- Creating a user
- Creating a group
- Adding a user to a group
- Creating a permission set
- Assigning a permission set to an account for a user
- Assigning a group to an account with a permission set

## Bulk Operations Example

The `bulk_operations.tf` file demonstrates how to perform bulk operations using the modules:

- Creating multiple users
- Creating multiple groups
- Adding multiple users to groups
- Creating multiple permission sets
- Assigning multiple groups to accounts

## User Management Script

The `user_management.sh` script provides a command-line interface for common operations:

```bash
# Make the script executable
chmod +x user_management.sh

# Create a user
./user_management.sh --action create_user \
  --user-name john.doe \
  --display-name "John Doe" \
  --given-name John \
  --family-name Doe \
  --email john.doe@example.com

# Create a group
./user_management.sh --action create_group \
  --group-name pri-developers \
  --group-desc "Group for developers"

# Add a user to a group
./user_management.sh --action add_user_to_group \
  --user-name john.doe \
  --group-name pri-developers

# Create a permission set
./user_management.sh --action create_permission_set \
  --permission-set-name developer-access \
  --policy-type AWS_MANAGED \
  --policy-name PowerUserAccess

# Assign a permission set to an account for a user
./user_management.sh --action assign_to_account \
  --user-name john.doe \
  --permission-set-name developer-access \
  --account-ids "123456789012,234567890123"

# Assign a group to an account with a permission set
./user_management.sh --action assign_group_to_account \
  --group-name pri-developers \
  --permission-set-name developer-access \
  --account-ids "123456789012,234567890123"
```

The script generates Terraform configuration files in a `generated` subdirectory, which you can then apply using Terraform.

## Usage

To use these examples:

1. Copy the example file you want to use to your working directory
2. Modify the values to match your environment
3. Run `terraform init` to initialize the Terraform environment
4. Run `terraform plan` to see what changes will be made
5. Run `terraform apply` to apply the changes

## Notes

- These examples assume you have AWS Identity Center enabled in your AWS Organization
- You need appropriate permissions to manage AWS Identity Center resources
- Replace the account IDs with your actual AWS account IDs
