terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.67.0"
    }
  }

  # If you’ll run this in HCP Terraform, fill these in and remove if using local CLI state
  cloud {
    organization = "hashicorp-zarkesh"
    workspaces {
      name = "hcp-packer-ht-demo"
    }
  }
}
