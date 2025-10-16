output "ami_id" {
  description = "AMI used for this deployment."
  value       = data.hcp_packer_image.rhel_prod.cloud_image_id
}

output "hcp_iteration_id" {
  description = "HCP Packer iteration backing the production channel."
  value       = data.hcp_packer_image.rhel_prod.iteration_id
}

output "hcp_created_at" {
  description = "Timestamp of the image in HCP."
  value       = data.hcp_packer_image.rhel_prod.created_at
}
