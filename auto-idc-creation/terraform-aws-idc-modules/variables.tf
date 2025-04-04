variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "users" {
  description = "List of users to create in AWS Identity Center"
  type = list(object({
    username     = string
    email        = string
    display_name = string
  }))
  default = []
}

variable "groups" {
  description = "List of groups to create in AWS Identity Center"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

variable "group_memberships" {
  description = "List of user to group assignments"
  type = list(object({
    username  = string
    groupname = string
  }))
  default = []
}

variable "permission_sets" {
  description = "List of permission sets to create in AWS Identity Center"
  type = list(object({
    name        = string
    description = optional(string, "")
    policy_type = string # "AWS_MANAGED", "CUSTOMER_MANAGED", "INLINE"
    policy_name = string # AWS managed policy name, customer managed policy name, or inline policy JSON
    session_duration = optional(string, "PT8H")
    tags = optional(map(string), {})
  }))
  default = []
}

variable "account_assignments" {
  description = "List of permission set assignments to AWS accounts"
  type = list(object({
    permission_set_name = string
    account_ids         = list(string)
    principal_type      = optional(string, "GROUP") # GROUP or USER
    principal_name      = string # Group name or username
  }))
  default = []
}
