provider "aws" {
    profile = "shared"
    region = "us-east-1"

    default_tags {
        tags = var.tags
    }
}