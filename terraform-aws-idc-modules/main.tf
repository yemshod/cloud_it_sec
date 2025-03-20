/**
 * # AWS Identity Center (IDC) Terraform Module
 *
 * This module provides a comprehensive solution for managing AWS Identity Center resources:
 * - Users
 * - Groups
 * - Group memberships
 * - Permission sets
 * - Account assignments
 */

provider "aws" {
  region = var.region
}

module "users" {
  source = "./modules/users"
  
  users = var.users
}

module "groups" {
  source = "./modules/groups"
  
  groups = var.groups
}

module "group_memberships" {
  source = "./modules/group_memberships"
  
  memberships = var.group_memberships
  depends_on  = [module.users, module.groups]
}

module "permission_sets" {
  source = "./modules/permission_sets"
  
  permission_sets = var.permission_sets
}

module "account_assignments" {
  source = "./modules/account_assignments"
  
  account_assignments = var.account_assignments
  depends_on          = [module.permission_sets]
}
