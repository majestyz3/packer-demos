# Always fetch the latest PRODUCTION image from the rhel-base bucket
data "hcp_packer_image" "rhel_prod" {
  bucket_name = "rhel-base"
  channel     = "production"
}

# Tag the AMI itself in AWS so it’s clearly marked as production
resource "aws_ec2_tag" "ami_prod_tag" {
  resource_id = data.hcp_packer_image.rhel_prod.cloud_image_id
  key         = "Environment"
  value       = "production"
}
