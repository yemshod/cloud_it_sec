variable "instance_arn" {
  description = "The ARN of the SSO instance"
  type        = string
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

variable "principal_id" {
  description = "The ID of the principal (user or group) to assign the permission set to"
  type        = string
}

variable "principal_type" {
  description = "The type of principal (USER or GROUP)"
  type        = string
  
  validation {
    condition     = contains(["USER", "GROUP"], var.principal_type)
    error_message = "Principal type must be either USER or GROUP."
  }
}

variable "account_ids" {
  description = "Comma-separated list of AWS account IDs to assign the permission set to"
  type        = string
}

# Validation to ensure either permission_set_arn or permission_set_name is provided
locals {
  validate_permission_set = (var.permission_set_arn != null || var.permission_set_name != null) ? true : file("ERROR: Either permission_set_arn or permission_set_name must be provided")
}
