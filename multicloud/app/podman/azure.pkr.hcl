variable "azure_subscription_id" {
  type        = string
  description = "The Subscription ID which contains the resources."
}

variable "azure_client_id" {
  type        = string
  description = "The Client ID which has access to the Subscription."
}

variable "azure_client_secret" {
  type        = string
  description = "The Client Secret which has access to the Subscription."
}

variable "azure_tenant_id" {
  type        = string
  description = "The Tenant ID which has access to the Subscription."
}

variable "azure_location" {
  type        = string
  description = "The Azure location to create resources in"
  default     = "East US"
}

locals {
  time = formatdate("YYYYMMDDHHMM", timestamp())
}

data "hcp-packer-version" "multicloud-rhel-base-azure" {
  bucket_name  = "multicloud-rhel-base"
  channel_name = "latest"
}

data "hcp-packer-artifact" "multicloud-rhel-base" {
  bucket_name   = "multicloud-rhel-base"
  channel_name  = "latest"
  platform      = "azure"
  region        = var.azure_location
}

source "azure-arm" "rhel_10" {

  custom_managed_image_name = regex(".*/images/(.*)", data.hcp-packer-artifact.multicloud-rhel-base.external_identifier)[0]
  custom_managed_image_resource_group_name = "packer-rg"

//  Managed images and resource group.
  managed_image_name = "multi-rhel-podman-${local.time}"
  managed_image_resource_group_name = "packer-rg"
  
  vm_size = "Standard_B1s"
  temp_resource_group_name = "packer-rg-temp-${local.time}"
  location = var.azure_location
  os_type = "linux"

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}