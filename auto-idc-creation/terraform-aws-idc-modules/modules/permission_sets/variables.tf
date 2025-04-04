variable "permission_sets" {
  description = "List of permission sets to create in AWS Identity Center"
  type = list(object({
    name        = string
    description = optional(string, "")
    policy_type = string
    policy_name = string
    session_duration = optional(string, "PT8H")
    tags = optional(map(string), {})
  }))
  default = []
}
