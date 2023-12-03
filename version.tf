terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "tu-artifact-bucket"
  #   key            = "state/terraform-tfstate.tfstate"
  #   region         = "us-west-2"
  #   encrypt        = true
  # }
}

provider "aws" {
  # alias = "oregon"
  region = "us-west-2"
}