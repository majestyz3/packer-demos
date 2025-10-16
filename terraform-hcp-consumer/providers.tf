provider "aws" {
  region = var.aws_region

  # helpful FinOps hygiene
  default_tags {
    tags = {
      Project     = "hcp-packer-ht-demo"
      Environment = "production"
    }
  }
}

# HCP API for channels, image lookups, etc.
provider "hcp" {}
