variable "groups" {
  description = "List of groups to create in AWS Identity Center"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}
