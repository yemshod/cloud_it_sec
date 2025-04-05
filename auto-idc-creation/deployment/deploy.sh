#!/bin/bash

# Script to help with deploying AWS Identity Center resources
# This script provides a convenient way to manage the deployment

set -e

# Default values
ACTION="plan"
RESOURCE_TYPE="all"

# Help function
show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  --action ACTION       Action to perform (plan, apply, destroy)"
  echo "  --resource RESOURCE   Resource type to manage (all, new, existing)"
  echo "  --help                Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --action plan                  # Preview all changes"
  echo "  $0 --action apply --resource new  # Apply only new resources"
  echo "  $0 --action apply --resource existing  # Apply only existing resource operations"
  echo "  $0 --action destroy               # Destroy all resources"
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
    --resource)
      RESOURCE_TYPE="$2"
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

# Validate inputs
if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
  echo "Error: Invalid action '$ACTION'. Must be one of: plan, apply, destroy"
  exit 1
fi

if [[ ! "$RESOURCE_TYPE" =~ ^(all|new|existing)$ ]]; then
  echo "Error: Invalid resource type '$RESOURCE_TYPE'. Must be one of: all, new, existing"
  exit 1
fi

# Function to run Terraform commands
run_terraform() {
  local cmd=$1
  local target_args=$2
  
  if [[ -n "$target_args" ]]; then
    echo "Running: terraform $cmd $target_args"
    terraform $cmd $target_args
  else
    echo "Running: terraform $cmd"
    terraform $cmd
  fi
}

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Perform the requested action
case $ACTION in
  plan)
    case $RESOURCE_TYPE in
      all)
        run_terraform "plan" ""
        ;;
      new)
        run_terraform "plan" "-target=module.users -target=module.groups -target=module.permission_sets -target=module.user_group_assignments -target=module.account_assignments"
        ;;
      existing)
        run_terraform "plan" "-target=module.existing_user_group_assignments -target=module.existing_account_assignments -target=module.existing_permission_boundaries"
        ;;
    esac
    ;;
  apply)
    case $RESOURCE_TYPE in
      all)
        run_terraform "apply" ""
        ;;
      new)
        run_terraform "apply" "-target=module.users -target=module.groups -target=module.permission_sets -target=module.user_group_assignments -target=module.account_assignments"
        ;;
      existing)
        run_terraform "apply" "-target=module.existing_user_group_assignments -target=module.existing_account_assignments -target=module.existing_permission_boundaries"
        ;;
    esac
    ;;
  destroy)
    read -p "Are you sure you want to destroy resources? This cannot be undone. (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      case $RESOURCE_TYPE in
        all)
          run_terraform "destroy" ""
          ;;
        new)
          run_terraform "destroy" "-target=module.account_assignments -target=module.user_group_assignments -target=module.permission_sets -target=module.groups -target=module.users"
          ;;
        existing)
          echo "Warning: Destroying existing resource assignments only removes the assignments, not the resources themselves."
          run_terraform "destroy" "-target=module.existing_permission_boundaries -target=module.existing_account_assignments -target=module.existing_user_group_assignments"
          ;;
      esac
    else
      echo "Destroy cancelled."
    fi
    ;;
esac

echo "Operation completed."
