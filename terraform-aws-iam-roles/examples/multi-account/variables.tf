variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_ids" {
  description = "Map of workspace names to AWS account IDs"
  type        = map(string)
  default     = {
    account1 = "123456789012"
    account2 = "234567890123"
    account3 = "345678901234"
    account4 = "456789012345"
    account5 = "567890123456"
    # Add more accounts as needed
  }
}

variable "organization_id" {
  description = "AWS Organization ID"
  type        = string
  default     = "o-exampleorgid"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
