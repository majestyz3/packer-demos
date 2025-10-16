variable "aws_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-east-2"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to launch the instance in"
}

variable "subnet_id" {
  type        = string
  description = "The VPC Subnet ID to launch the instance in"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address with the instance"
  default     = true
}

data "hcp-packer-version" "multicloud-rhel-base-aws" {
  bucket_name  = "multicloud-rhel-base"
  channel_name = "latest"
}

data "hcp-packer-artifact" "multicloud-rhel-base-aws" {
  bucket_name         = data.hcp-packer-version.multicloud-rhel-base-aws.bucket_name
  version_fingerprint = data.hcp-packer-version.multicloud-rhel-base-aws.fingerprint
  platform            = "aws"
  region              = var.aws_region
}




// Very basic source setup. 
// This will generate its own SSH keypair
// This will generate a temporary security group.
// AMI Name is relatively static for demo purposes, but could be make more dynamic with a timestamp or version variable.
source "amazon-ebs" "rhel_10" {
  region                      = var.aws_region
  source_ami                  = data.hcp-packer-artifact.multicloud-rhel-base-aws.external_identifier
  instance_type               = "t2.large"
  ssh_username                = "ec2-user"
  ami_name                    = "multi_rhel_10_podman_${local.time}"
  subnet_id                   = var.subnet_id
  vpc_id                      = var.vpc_id
  associate_public_ip_address = var.associate_public_ip_address
}