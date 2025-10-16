# Discover the default VPC if subnet_id or security_group_id aren't passed
data "aws_vpc" "default" {
  default = true
}

# Pick the first default subnet if none provided
data "aws_subnet" "default" {
  count = var.subnet_id == null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Pick the default security group if none provided
data "aws_security_group" "default" {
  count = var.security_group_id == null ? 1 : 0
  filter {
    name   = "group-name"
    values = ["default"]
  }
  vpc_id = data.aws_vpc.default.id
}

locals {
  chosen_subnet_id         = var.subnet_id != null ? var.subnet_id : data.aws_subnet.default[0].id
  chosen_security_group_id = var.security_group_id != null ? var.security_group_id : data.aws_security_group.default[0].id
}

resource "aws_instance" "web" {
  ami                         = data.hcp_packer_image.rhel_prod.cloud_image_id
  instance_type               = var.instance_type
  subnet_id                   = local.chosen_subnet_id
  vpc_security_group_ids      = [local.chosen_security_group_id]
  associate_public_ip_address = true

  tags = {
    Name        = "demo-web"
    ImageBucket = "rhel-base"
    Channel     = "production"
  }
}
