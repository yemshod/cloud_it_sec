variable "instance_arn" {
  description = "The ARN of the SSO instance"
  type        = string
}

variable "permission_set_arn" {
  description = "The ARN of the permission set to attach the boundary to (if known)"
  type        = string
  default     = null
}

variable "permission_set_name" {
  description = "The name of the permission set to attach the boundary to (used to look up the ARN if not provided)"
  type        = string
  default     = null
}

variable "boundary_type" {
  description = "Type of permission boundary to attach: AWS_MANAGED or CUSTOMER_MANAGED"
  type        = string
  
  validation {
    condition     = contains(["AWS_MANAGED", "CUSTOMER_MANAGED"], var.boundary_type)
    error_message = "Permission boundary type must be one of: AWS_MANAGED or CUSTOMER_MANAGED."
  }
}

variable "boundary_name" {
  description = "The name of the permission boundary policy to attach"
  type        = string
}

variable "boundary_path" {
  description = "The path of the customer managed permission boundary policy (required for CUSTOMER_MANAGED boundary type)"
  type        = string
  default     = "/"
}

# Validation to ensure either permission_set_arn or permission_set_name is provided
locals {
  validate_permission_set = (var.permission_set_arn != null || var.permission_set_name != null) ? true : file("ERROR: Either permission_set_arn or permission_set_name must be provided")
}
