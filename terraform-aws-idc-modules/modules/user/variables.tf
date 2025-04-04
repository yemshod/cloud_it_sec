variable "identity_store_id" {
  description = "The ID of the Identity Store"
  type        = string
}

variable "user_name" {
  description = "The username for the user"
  type        = string
}

variable "display_name" {
  description = "The display name for the user"
  type        = string
}

variable "given_name" {
  description = "The given name (first name) for the user"
  type        = string
}

variable "family_name" {
  description = "The family name (last name) for the user"
  type        = string
}

variable "email" {
  description = "The email address for the user"
  type        = string
}
