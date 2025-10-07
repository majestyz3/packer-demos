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


data "amazon-ami" "rhel_10" {
  region = var.aws_region
  filters = {
    virtualization-type = "hvm"
    name                = "RHEL_HA-10.0.0_HVM-*-x86_64-0-Hourly2-GP3"
    root-device-type    = "ebs"

  }
  owners      = ["309956199498"]
  most_recent = true
}

data "amazon-ami" "rhel_9" {
  region = var.aws_region
  filters = {
    virtualization-type = "hvm"
    name                = "RHEL-9.5.0_HVM-*-x86_64-0-Hourly2-GP3"
    root-device-type    = "ebs"

  }
  owners      = ["309956199498"]
  most_recent = true
}

source "amazon-ebs" "rhel_10" {
  region                      = var.aws_region
  source_ami                  = data.amazon-ami.rhel_10.id
  instance_type               = "t2.large"
  ssh_username                = "ec2-user"
  ami_name                    = "rhel_10_base"
  subnet_id                   = var.subnet_id
  vpc_id                      = var.vpc_id
  associate_public_ip_address = var.associate_public_ip_address

}

# source "amazon-ebs" "rhel_9" {
#   region                      = var.aws_region
#   source_ami                  = data.amazon-ami.rhel_9.id
#   instance_type               = "t2.large"
#   ssh_username                = "ec2-user"
#   ami_name                    = "rhel_9_base"
#   subnet_id                   = var.subnet_id
#   vpc_id                      = var.vpc_id
#   associate_public_ip_address = var.associate_public_ip_address

# }