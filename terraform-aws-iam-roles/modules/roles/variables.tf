variable "roles" {
  description = "List of IAM roles to create"
  type = list(object({
    name                    = string
    description             = string
    assume_role_policy      = string
    permission_boundary_policy = string
    managed_policy_arns     = list(string)
    inline_policies         = map(string)
    tags                    = optional(map(string), {})
  }))
}

variable "enable_permission_boundaries" {
  description = "Whether to enable permission boundaries for roles"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
