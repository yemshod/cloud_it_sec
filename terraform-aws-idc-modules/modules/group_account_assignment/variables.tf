variable "instance_arn" {
  description = "The ARN of the SSO instance"
  type        = string
}

variable "identity_store_id" {
  description = "The ID of the Identity Store"
  type        = string
}

variable "group_id" {
  description = "The ID of the group to assign (if known)"
  type        = string
  default     = null
}

variable "group_name" {
  description = "The name of the group to assign (used to look up the group_id if not provided)"
  type        = string
  default     = null
}

variable "permission_set_arn" {
  description = "The ARN of the permission set to assign (if known)"
  type        = string
  default     = null
}

variable "permission_set_name" {
  description = "The name of the permission set to assign (used to look up the ARN if not provided)"
  type        = string
  default     = null
}

variable "account_ids" {
  description = "Comma-separated list of AWS account IDs to assign the permission set to"
  type        = string
}

# Validation to ensure either group_id or group_name is provided
locals {
  validate_group = (var.group_id != null || var.group_name != null) ? true : file("ERROR: Either group_id or group_name must be provided")
  validate_permission_set = (var.permission_set_arn != null || var.permission_set_name != null) ? true : file("ERROR: Either permission_set_arn or permission_set_name must be provided")
}
