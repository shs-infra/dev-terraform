terraform {
    backend "s3" {
        bucket = "terraform-remote-backend-shared-services-state"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}