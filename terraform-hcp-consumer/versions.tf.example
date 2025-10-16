# Example versions.tf
# Copy this file to versions.tf and fill in your HCP organization and optional project.

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

  cloud {
    organization = "<YOUR_HCP_ORG>"      # e.g., "majid-zarkesh"
    # Optional: uncomment the next 3 lines to specify a project (e.g., "Packer_D")
    # workspaces {
    #   project = "Packer_D"
    #   name    = "hcp-packer-ht-demo"
    # }

    # If you leave it out, Terraform will create it in your default project.
    workspaces { name = "hcp-packer-ht-demo" }
  }
}
