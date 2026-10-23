terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "technova-tfstate-924308937786-6325192"
    key            = "aula-10/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "technova-terraform-locks-6325192"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
