provider "aws" {
    region = "us-east-1"
    
    assume_role {
        role_arn = "arn:aws:iam::407894219710:role/TerraformExecutionRole"
    }
}