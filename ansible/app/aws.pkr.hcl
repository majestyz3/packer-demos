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

data "hcp-packer-version" "rhel-base" {
  bucket_name  = "rhel-base"
  channel_name = "latest"
}

data "hcp-packer-artifact" "rhel-base" {
  bucket_name         = data.hcp-packer-version.rhel-base.bucket_name
  version_fingerprint = data.hcp-packer-version.rhel-base.fingerprint
  platform            = "aws"
  region              = var.aws_region
}


source "amazon-ebs" "rhel_10_podman" {
  region                      = var.aws_region
  source_ami                  = data.hcp-packer-artifact.rhel-base.ami_id
  instance_type               = "t2.large"
  ssh_username                = "ec2-user"
  ami_name                    = "rhel_10_base"
  subnet_id                   = var.subnet_id
  vpc_id                      = var.vpc_id
  associate_public_ip_address = var.associate_public_ip_address
}