variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "subnet_id" {
  description = "Optional subnet ID. If not provided, the default subnet for the selected region will be used."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "Optional security group ID. If not provided, the default VPC's default security group will be used."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}
