variable "policies" {
  description = "List of IAM policies to create"
  type = list(object({
    name           = string
    description    = string
    policy_document = string
    tags           = optional(map(string), {})
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
