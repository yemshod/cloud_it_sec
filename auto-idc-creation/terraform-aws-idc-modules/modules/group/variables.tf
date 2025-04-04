variable "identity_store_id" {
  description = "The ID of the Identity Store"
  type        = string
}

variable "group_name" {
  description = "The name of the group"
  type        = string
}

variable "description" {
  description = "The description of the group"
  type        = string
  default     = ""
}
