terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "vpc-module-rs"
    key            = "jenkins-server-tfstate"
    region         = "us-east-1"
    dynamodb_table = "vpc-module-locking"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
