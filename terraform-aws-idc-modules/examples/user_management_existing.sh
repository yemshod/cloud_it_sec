#!/bin/bash

# Script to manage AWS Identity Center focusing on operations with existing resources
# This script helps with common operations by generating Terraform configurations

set -e

# Default values
TF_DIR="./generated"
ACTION=""
USER_NAME=""
GROUP_NAME=""
PERMISSION_SET_NAME=""
ACCOUNT_IDS=""
PRINCIPAL_TYPE=""
PERMISSION_BOUNDARY_TYPE=""
PERMISSION_BOUNDARY_NAME=""
PERMISSION_BOUNDARY_PATH="/"

# Create directory for generated Terraform files if it doesn't exist
mkdir -p $TF_DIR

# Help function
show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Operations with existing resources:"
  echo "  --action add_user_to_group         Add an existing user to an existing group"
  echo "  --action assign_user_to_account    Assign an existing user to accounts with an existing permission set"
  echo "  --action assign_group_to_account   Assign an existing group to accounts with an existing permission set"
  echo "  --action add_boundary_to_permission_set  Add a permission boundary to an existing permission set"
  echo ""
  echo "Options:"
  echo "  --user-name USERNAME              Username of an existing user"
  echo "  --group-name GROUPNAME            Name of an existing group"
  echo "  --permission-set-name NAME        Name of an existing permission set"
  echo "  --account-ids IDS                 Comma-separated list of AWS account IDs"
  echo "  --principal-type TYPE             Principal type (USER or GROUP) for account assignment"
  echo "  --permission-boundary-type TYPE   Permission boundary type (AWS_MANAGED, CUSTOMER_MANAGED)"
  echo "  --permission-boundary-name NAME   Name of the permission boundary policy"
  echo "  --permission-boundary-path PATH   Path of the customer managed permission boundary policy"
  echo "  --help                            Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --action add_user_to_group --user-name john.doe --group-name pri-developers"
  echo "  $0 --action assign_user_to_account --user-name john.doe --permission-set-name developer-access --account-ids \"123456789012,234567890123\""
  echo "  $0 --action assign_group_to_account --group-name pri-developers --permission-set-name developer-access --account-ids \"123456789012,234567890123\""
  echo "  $0 --action add_boundary_to_permission_set --permission-set-name developer-access --permission-boundary-type AWS_MANAGED --permission-boundary-name PowerUserAccess"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --action)
      ACTION="$2"
      shift
      shift
      ;;
    --user-name)
      USER_NAME="$2"
      shift
      shift
      ;;
    --group-name)
      GROUP_NAME="$2"
      shift
      shift
      ;;
    --permission-set-name)
      PERMISSION_SET_NAME="$2"
      shift
      shift
      ;;
    --account-ids)
      ACCOUNT_IDS="$2"
      shift
      shift
      ;;
    --principal-type)
      PRINCIPAL_TYPE="$2"
      shift
      shift
      ;;
    --permission-boundary-type)
      PERMISSION_BOUNDARY_TYPE="$2"
      shift
      shift
      ;;
    --permission-boundary-name)
      PERMISSION_BOUNDARY_NAME="$2"
      shift
      shift
      ;;
    --permission-boundary-path)
      PERMISSION_BOUNDARY_PATH="$2"
      shift
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

# Validate required parameters based on action
validate_params() {
  local valid=true
  
  case $ACTION in
    add_user_to_group)
      [[ -z "$USER_NAME" ]] && echo "Error: --user-name is required" && valid=false
      [[ -z "$GROUP_NAME" ]] && echo "Error: --group-name is required" && valid=false
      ;;
    assign_user_to_account)
      [[ -z "$USER_NAME" ]] && echo "Error: --user-name is required" && valid=false
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$ACCOUNT_IDS" ]] && echo "Error: --account-ids is required" && valid=false
      PRINCIPAL_TYPE="USER"
      ;;
    assign_group_to_account)
      [[ -z "$GROUP_NAME" ]] && echo "Error: --group-name is required" && valid=false
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$ACCOUNT_IDS" ]] && echo "Error: --account-ids is required" && valid=false
      ;;
    add_boundary_to_permission_set)
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$PERMISSION_BOUNDARY_TYPE" ]] && echo "Error: --permission-boundary-type is required" && valid=false
      [[ -z "$PERMISSION_BOUNDARY_NAME" ]] && echo "Error: --permission-boundary-name is required" && valid=false
      ;;
    *)
      echo "Error: Invalid action '$ACTION'"
      show_help
      valid=false
      ;;
  esac
  
  if [[ "$valid" == "false" ]]; then
    exit 1
  fi
}

# Generate provider.tf if it doesn't exist
generate_provider() {
  if [[ ! -f "$TF_DIR/provider.tf" ]]; then
    cat > "$TF_DIR/provider.tf" << EOF
provider "aws" {
  region = "us-east-1"
}

# Get SSO instance ARN and Identity Store ID
data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}
EOF
    echo "Generated provider.tf"
  fi
}

# Generate Terraform configuration based on action
generate_terraform() {
  local timestamp=$(date +%s)
  local filename=""
  
  case $ACTION in
    add_user_to_group)
      filename="user_group_${USER_NAME}_${GROUP_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
module "user_group_${USER_NAME}_${GROUP_NAME}" {
  source = "../modules/user_group_assignment"

  identity_store_id = local.identity_store_id
  user_name         = "${USER_NAME}"
  group_name        = "${GROUP_NAME}"
}
EOF
      ;;
    assign_user_to_account)
      filename="account_assignment_${USER_NAME}_${PERMISSION_SET_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
data "aws_identitystore_user" "this" {
  identity_store_id = local.identity_store_id
  
  filter {
    attribute_path  = "UserName"
    attribute_value = "${USER_NAME}"
  }
}

module "account_assignment_${USER_NAME}_${PERMISSION_SET_NAME}" {
  source = "../modules/account_assignment"

  instance_arn        = local.instance_arn
  permission_set_name = "${PERMISSION_SET_NAME}"
  principal_id        = data.aws_identitystore_user.this.user_id
  principal_type      = "USER"
  account_ids         = "${ACCOUNT_IDS}"
}
EOF
      ;;
    assign_group_to_account)
      filename="group_account_${GROUP_NAME}_${PERMISSION_SET_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
module "group_account_${GROUP_NAME}_${PERMISSION_SET_NAME}" {
  source = "../modules/group_account_assignment"

  instance_arn        = local.instance_arn
  identity_store_id   = local.identity_store_id
  group_name          = "${GROUP_NAME}"
  permission_set_name = "${PERMISSION_SET_NAME}"
  account_ids         = "${ACCOUNT_IDS}"
}
EOF
      ;;
    add_boundary_to_permission_set)
      filename="permission_boundary_${PERMISSION_SET_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
# First, get the existing permission set
data "aws_ssoadmin_permission_set" "existing" {
  instance_arn = local.instance_arn
  name         = "${PERMISSION_SET_NAME}"
}

# Note: You'll need to import the existing permission set into Terraform state before applying
# Run: terraform import module.existing_permission_set_${PERMISSION_SET_NAME}.aws_ssoadmin_permission_set.this \${data.aws_ssoadmin_permission_set.existing.arn}

module "existing_permission_set_${PERMISSION_SET_NAME}" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "${PERMISSION_SET_NAME}"
  description         = "Managed by Terraform"
  
  # Keep existing policy (assuming it's already attached)
  policy_type         = "NONE"
  
  # Add permission boundary
  permission_boundary_type = "${PERMISSION_BOUNDARY_TYPE}"
  permission_boundary_name = "${PERMISSION_BOUNDARY_NAME}"
  permission_boundary_path = "${PERMISSION_BOUNDARY_PATH}"
}

# Output the import command
output "import_command" {
  value = "terraform import module.existing_permission_set_${PERMISSION_SET_NAME}.aws_ssoadmin_permission_set.this \${data.aws_ssoadmin_permission_set.existing.arn}"
}
EOF
      ;;
  esac
  
  echo "Generated $filename"
}

# Main execution
if [[ -z "$ACTION" ]]; then
  echo "Error: --action is required"
  show_help
  exit 1
fi

validate_params
generate_provider
generate_terraform

echo "Terraform configuration generated in $TF_DIR directory"
if [[ "$ACTION" == "add_boundary_to_permission_set" ]]; then
  echo "IMPORTANT: Before applying, you need to import the existing permission set into Terraform state."
  echo "After running 'terraform init', run the import command that will be shown in the terraform output."
fi
echo "Then run 'terraform apply' to apply changes"
