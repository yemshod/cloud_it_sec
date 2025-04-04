variable "users" {
  description = "List of users to create in AWS Identity Center"
  type = list(object({
    username     = string
    email        = string
    display_name = string
  }))
  default = []
}
