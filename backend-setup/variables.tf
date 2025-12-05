variable "region" {
    type = string
    description = "AWS region for backend"
    default = "us-east-1"
}

variable "bucket_name" {
    type = string
    description = "S3 bucket name for storing Terraform state"
}

variable "dynamodb_table_name" {
    type = string
    description = "DynamoDB table name for Terraform state locking"
    default = "terraform-locks"
}