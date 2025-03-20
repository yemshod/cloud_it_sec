variable "memberships" {
  description = "List of user to group assignments"
  type = list(object({
    username  = string
    groupname = string
  }))
  default = []
}
