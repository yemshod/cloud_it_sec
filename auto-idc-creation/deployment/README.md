# AWS Identity Center Deployment

This directory contains the Terraform configurations for deploying and managing AWS Identity Center resources. The approach uses a combination of Terraform files and JSON configuration files to provide a scalable and maintainable solution.

## Directory Structure

```
deployment/
├── common.tf              # Common provider and data sources
├── new_resources.tf       # Terraform configuration for creating new resources
├── existing_resources.tf  # Terraform configuration for working with existing resources
├── json/                  # JSON configuration files
│   ├── users.json                      # User definitions
│   ├── groups.json                     # Group definitions
│   ├── permission_sets.json            # Permission set definitions
│   ├── user_group_assignments.json     # User-to-group assignments
│   ├── account_assignments.json        # Group-to-account assignments
│   ├── existing_user_group_assignments.json  # Existing user-to-group assignments
│   ├── existing_account_assignments.json     # Existing group-to-account assignments
│   └── existing_permission_boundaries.json   # Permission boundaries for existing permission sets
├── configs/               # Additional configuration files
│   ├── backend.tf         # For remote backend configuration
│   ├── provider.tf        # AWS provider configuration
│   └── outputs.tf         # Output definitions
├── deploy.sh              # Helper script for deployments
└── README.md              # This file
```

## Usage

### 1. Configure Resources

Edit the JSON files in the `json/` directory to define your resources:

- `users.json`: Define users to create
- `groups.json`: Define groups to create
- `permission_sets.json`: Define permission sets to create
- `user_group_assignments.json`: Define which users should be added to which groups
- `account_assignments.json`: Define which groups should be assigned to which accounts with which permission sets
- `existing_*.json`: Define operations with existing resources

### 2. Deploy Resources

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

## JSON File Formats

### users.json

```json
{
  "unique_key": {
    "user_name": "john.doe",
    "display_name": "John Doe",
    "given_name": "John",
    "family_name": "Doe",
    "email": "john.doe@example.com"
  }
}
```

### groups.json

```json
{
  "unique_key": {
    "group_name": "pri-developers",
    "description": "Developer group"
  }
}
```

### permission_sets.json

```json
{
  "unique_key": {
    "name": "developer-access",
    "description": "Developer access permission set",
    "policy_type": "AWS_MANAGED",
    "policy_name": "PowerUserAccess",
    "permission_boundary_type": "AWS_MANAGED",  # Optional
    "permission_boundary_name": "PowerUserAccess",  # Optional
    "inline_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[...]}"  # Optional for INLINE policy_type
  }
}
```

### user_group_assignments.json

```json
{
  "unique_key": {
    "user_name": "john.doe",
    "group_name": "pri-developers"
  }
}
```

### account_assignments.json

```json
{
  "unique_key": {
    "group_name": "pri-developers",
    "permission_set_name": "developer-access",
    "account_ids": "123456789012,234567890123"
  }
}
```

### existing_user_group_assignments.json

```json
{
  "unique_key": {
    "user_name": "existing.user",
    "group_name": "existing-group"
  }
}
```

### existing_account_assignments.json

```json
{
  "unique_key": {
    "group_name": "existing-group",
    "permission_set_name": "existing-permission-set",
    "account_ids": "123456789012,234567890123"
  }
}
```

### existing_permission_boundaries.json

```json
{
  "unique_key": {
    "permission_set_name": "existing-permission-set",
    "boundary_type": "AWS_MANAGED",
    "boundary_name": "PowerUserAccess",
    "boundary_path": "/"  # Only needed for CUSTOMER_MANAGED
  }
}
```

## Alternative: Direct Configuration in Terraform

If you prefer, you can also define resources directly in the Terraform files instead of using JSON:

```hcl
locals {
  users = merge(local.users_json, {
    user1 = {
      user_name    = "john.doe"
      display_name = "John Doe"
      given_name   = "John"
      family_name  = "Doe"
      email        = "john.doe@example.com"
    }
  })
}
```

## Using the Helper Script

The `deploy.sh` script provides a convenient way to manage deployments:

```bash
# Preview all changes
./deploy.sh --action plan

# Apply only new resources
./deploy.sh --action apply --resource new

# Apply only existing resource operations
./deploy.sh --action apply --resource existing
```

## Best Practices

1. **Version Control**: Keep all JSON and Terraform files in version control
2. **Review Changes**: Always run `terraform plan` before applying changes
3. **Backup State**: Use a remote backend for the Terraform state file
4. **Documentation**: Keep this README updated with any changes to the structure or process
