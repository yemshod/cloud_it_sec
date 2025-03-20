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
