#!/bin/bash

# Script to manage AWS Identity Center users, groups, and permissions using Terraform
# This script helps with common operations by generating Terraform configurations

set -e

# Default values
TF_DIR="./generated"
ACTION=""
USER_NAME=""
DISPLAY_NAME=""
GIVEN_NAME=""
FAMILY_NAME=""
EMAIL=""
GROUP_NAME=""
GROUP_DESC=""
PERMISSION_SET_NAME=""
POLICY_TYPE=""
POLICY_NAME=""
ACCOUNT_IDS=""
PERMISSION_BOUNDARY_TYPE=""
PERMISSION_BOUNDARY_NAME=""
PERMISSION_BOUNDARY_PATH="/"

# Create directory for generated Terraform files if it doesn't exist
mkdir -p $TF_DIR

# Help function
show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --action ACTION                   Action to perform (create_user, create_group, add_user_to_group,"
  echo "                                    create_permission_set, assign_to_account, assign_group_to_account)"
  echo "  --user-name USERNAME              Username for the user"
  echo "  --display-name DISPLAYNAME        Display name for the user"
  echo "  --given-name GIVENNAME            Given name (first name) for the user"
  echo "  --family-name FAMILYNAME          Family name (last name) for the user"
  echo "  --email EMAIL                     Email address for the user"
  echo "  --group-name GROUPNAME            Name of the group"
  echo "  --group-desc DESCRIPTION          Description of the group"
  echo "  --permission-set-name NAME        Name of the permission set"
  echo "  --policy-type TYPE                Policy type (AWS_MANAGED, CUSTOMER_MANAGED, INLINE, NONE)"
  echo "  --policy-name NAME                Name of the policy"
  echo "  --account-ids IDS                 Comma-separated list of AWS account IDs"
  echo "  --permission-boundary-type TYPE   Permission boundary type (AWS_MANAGED, CUSTOMER_MANAGED, NONE)"
  echo "  --permission-boundary-name NAME   Name of the permission boundary policy"
  echo "  --permission-boundary-path PATH   Path of the customer managed permission boundary policy"
  echo "  --help                            Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --action create_user --user-name john.doe --display-name \"John Doe\" --given-name John --family-name Doe --email john.doe@example.com"
  echo "  $0 --action create_group --group-name pri-developers --group-desc \"Group for developers\""
  echo "  $0 --action add_user_to_group --user-name john.doe --group-name pri-developers"
  echo "  $0 --action create_permission_set --permission-set-name developer-access --policy-type AWS_MANAGED --policy-name PowerUserAccess --permission-boundary-type AWS_MANAGED --permission-boundary-name PowerUserAccess"
  echo "  $0 --action assign_to_account --user-name john.doe --permission-set-name developer-access --account-ids \"123456789012,234567890123\""
  echo "  $0 --action assign_group_to_account --group-name pri-developers --permission-set-name developer-access --account-ids \"123456789012,234567890123\""
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
    --display-name)
      DISPLAY_NAME="$2"
      shift
      shift
      ;;
    --given-name)
      GIVEN_NAME="$2"
      shift
      shift
      ;;
    --family-name)
      FAMILY_NAME="$2"
      shift
      shift
      ;;
    --email)
      EMAIL="$2"
      shift
      shift
      ;;
    --group-name)
      GROUP_NAME="$2"
      shift
      shift
      ;;
    --group-desc)
      GROUP_DESC="$2"
      shift
      shift
      ;;
    --permission-set-name)
      PERMISSION_SET_NAME="$2"
      shift
      shift
      ;;
    --policy-type)
      POLICY_TYPE="$2"
      shift
      shift
      ;;
    --policy-name)
      POLICY_NAME="$2"
      shift
      shift
      ;;
    --account-ids)
      ACCOUNT_IDS="$2"
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
    create_user)
      [[ -z "$USER_NAME" ]] && echo "Error: --user-name is required" && valid=false
      [[ -z "$DISPLAY_NAME" ]] && echo "Error: --display-name is required" && valid=false
      [[ -z "$GIVEN_NAME" ]] && echo "Error: --given-name is required" && valid=false
      [[ -z "$FAMILY_NAME" ]] && echo "Error: --family-name is required" && valid=false
      [[ -z "$EMAIL" ]] && echo "Error: --email is required" && valid=false
      ;;
    create_group)
      [[ -z "$GROUP_NAME" ]] && echo "Error: --group-name is required" && valid=false
      ;;
    add_user_to_group)
      [[ -z "$USER_NAME" ]] && echo "Error: --user-name is required" && valid=false
      [[ -z "$GROUP_NAME" ]] && echo "Error: --group-name is required" && valid=false
      ;;
    create_permission_set)
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$POLICY_TYPE" ]] && echo "Error: --policy-type is required" && valid=false
      if [[ "$POLICY_TYPE" != "NONE" ]]; then
        [[ -z "$POLICY_NAME" ]] && echo "Error: --policy-name is required" && valid=false
      fi
      if [[ "$PERMISSION_BOUNDARY_TYPE" != "" && "$PERMISSION_BOUNDARY_TYPE" != "NONE" ]]; then
        [[ -z "$PERMISSION_BOUNDARY_NAME" ]] && echo "Error: --permission-boundary-name is required" && valid=false
      fi
      ;;
    assign_to_account)
      [[ -z "$USER_NAME" ]] && echo "Error: --user-name is required" && valid=false
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$ACCOUNT_IDS" ]] && echo "Error: --account-ids is required" && valid=false
      ;;
    assign_group_to_account)
      [[ -z "$GROUP_NAME" ]] && echo "Error: --group-name is required" && valid=false
      [[ -z "$PERMISSION_SET_NAME" ]] && echo "Error: --permission-set-name is required" && valid=false
      [[ -z "$ACCOUNT_IDS" ]] && echo "Error: --account-ids is required" && valid=false
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
    create_user)
      filename="user_${USER_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
module "user_${USER_NAME}" {
  source = "../modules/user"

  identity_store_id = local.identity_store_id
  user_name         = "${USER_NAME}"
  display_name      = "${DISPLAY_NAME}"
  given_name        = "${GIVEN_NAME}"
  family_name       = "${FAMILY_NAME}"
  email             = "${EMAIL}"
}
EOF
      ;;
    create_group)
      filename="group_${GROUP_NAME}_${timestamp}.tf"
      cat > "$TF_DIR/$filename" << EOF
module "group_${GROUP_NAME}" {
  source = "../modules/group"

  identity_store_id = local.identity_store_id
  group_name        = "${GROUP_NAME}"
  description       = "${GROUP_DESC}"
}
EOF
      ;;
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
    create_permission_set)
      filename="permission_set_${PERMISSION_SET_NAME}_${timestamp}.tf"
      
      # Set default values for permission boundary if not provided
      if [[ -z "$PERMISSION_BOUNDARY_TYPE" ]]; then
        PERMISSION_BOUNDARY_TYPE="NONE"
      fi
      
      cat > "$TF_DIR/$filename" << EOF
module "permission_set_${PERMISSION_SET_NAME}" {
  source = "../modules/permission_set"

  instance_arn        = local.instance_arn
  permission_set_name = "${PERMISSION_SET_NAME}"
  description         = "${PERMISSION_SET_NAME} permission set"
  policy_type         = "${POLICY_TYPE}"
  policy_name         = "${POLICY_NAME}"
  
  # Permission boundary settings
  permission_boundary_type = "${PERMISSION_BOUNDARY_TYPE}"
  permission_boundary_name = "${PERMISSION_BOUNDARY_NAME}"
  permission_boundary_path = "${PERMISSION_BOUNDARY_PATH}"
}
EOF
      ;;
    assign_to_account)
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
echo "Run 'terraform init' and 'terraform apply' in that directory to apply changes"
