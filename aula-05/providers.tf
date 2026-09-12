terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "technova-tfstate-508379315632-6325192"
    key            = "aula-05/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "technova-tf-locks-6325192"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project = "TechNova"
    Aula    = "05"
    Owner   = "6325192"
  }
}
