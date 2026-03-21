terraform {
  backend "s3" {
    bucket = "inf-aws-module-inventory-state"
    key = "dev/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}