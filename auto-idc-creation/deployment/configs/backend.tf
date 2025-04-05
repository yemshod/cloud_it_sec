# Uncomment and configure this file to use a remote backend for state management

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "idc/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt        = true
#   }
# }
