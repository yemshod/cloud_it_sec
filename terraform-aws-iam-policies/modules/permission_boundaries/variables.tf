variable "permission_boundaries" {
  description = "List of permission boundaries to create"
  type = list(object({
    name            = string
    description     = string
    policy_statements = list(any)
    tags            = optional(map(string), {})
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
