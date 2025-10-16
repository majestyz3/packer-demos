# Ensure a 'production' channel exists in the rhel-base bucket
resource "hcp_packer_channel" "prod" {
  bucket_name = "rhel-base"
  name        = "production"
}

# Look up the latest iteration (HCP’s implicit “latest” channel)
data "hcp_packer_image" "latest_any" {
  bucket_name = "rhel-base"
  channel     = "latest"
}

# Assign that iteration to the 'production' channel
resource "hcp_packer_channel_assignment" "prod_latest" {
  bucket_name  = hcp_packer_channel.prod.bucket_name
  channel      = hcp_packer_channel.prod.name
  iteration_id = data.hcp_packer_image.latest_any.iteration_id
}
