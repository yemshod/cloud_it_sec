variable "instance_arn" {
  description = "The ARN of the SSO instance"
  type        = string
}

variable "permission_set_name" {
  description = "The name of the permission set"
  type        = string
}

variable "description" {
  description = "The description of the permission set"
  type        = string
  default     = ""
}

variable "session_duration" {
  description = "The length of time that the application user sessions are valid for"
  type        = string
  default     = "PT8H"  # 8 hours
}

variable "relay_state" {
  description = "The relay state URL used to redirect users within the application"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Key-value map of tags for the permission set"
  type        = map(string)
  default     = {}
}

variable "policy_type" {
  description = "Type of policy to attach: AWS_MANAGED, CUSTOMER_MANAGED, or INLINE"
  type        = string
  default     = "AWS_MANAGED"
  
  validation {
    condition     = contains(["AWS_MANAGED", "CUSTOMER_MANAGED", "INLINE", "NONE"], var.policy_type)
    error_message = "Policy type must be one of: AWS_MANAGED, CUSTOMER_MANAGED, INLINE, or NONE."
  }
}

variable "policy_name" {
  description = "The name of the policy to attach"
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "The path of the customer managed policy (required for CUSTOMER_MANAGED policy type)"
  type        = string
  default     = "/"
}

variable "inline_policy" {
  description = "The inline policy document in JSON format (required for INLINE policy type)"
  type        = string
  default     = null
}

variable "permission_boundary_type" {
  description = "Type of permission boundary to attach: AWS_MANAGED, CUSTOMER_MANAGED, or NONE"
  type        = string
  default     = "NONE"
  
  validation {
    condition     = contains(["AWS_MANAGED", "CUSTOMER_MANAGED", "NONE"], var.permission_boundary_type)
    error_message = "Permission boundary type must be one of: AWS_MANAGED, CUSTOMER_MANAGED, or NONE."
  }
}

variable "permission_boundary_name" {
  description = "The name of the permission boundary policy to attach"
  type        = string
  default     = ""
}

variable "permission_boundary_path" {
  description = "The path of the customer managed permission boundary policy (required for CUSTOMER_MANAGED boundary type)"
  type        = string
  default     = "/"
}
