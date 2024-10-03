terraform {
  required_version = ">= 1.9.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.69.0"
    }
  }
}

provider "aws" {
  region = local.region

  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    sns = "http://localhost:4566"
  }

  # default_tags {
  #   created_by = "Terraform"
  # }
}
