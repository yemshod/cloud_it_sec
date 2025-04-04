variable "identity_store_id" {
  description = "The ID of the Identity Store"
  type        = string
}

variable "user_id" {
  description = "The ID of the user to add to the group (if known)"
  type        = string
  default     = null
}

variable "user_name" {
  description = "The username of the user to add to the group (used to look up the user_id if not provided)"
  type        = string
  default     = null
}

variable "group_id" {
  description = "The ID of the group to add the user to (if known)"
  type        = string
  default     = null
}

variable "group_name" {
  description = "The name of the group to add the user to (used to look up the group_id if not provided)"
  type        = string
  default     = null
}

# Validation to ensure either user_id or user_name is provided
locals {
  validate_user = (var.user_id != null || var.user_name != null) ? true : file("ERROR: Either user_id or user_name must be provided")
  validate_group = (var.group_id != null || var.group_name != null) ? true : file("ERROR: Either group_id or group_name must be provided")
}
