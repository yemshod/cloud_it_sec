variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = "456789012345"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
