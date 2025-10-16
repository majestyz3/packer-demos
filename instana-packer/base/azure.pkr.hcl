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

source "azure-arm" "rhel_10" {

  image_offer                         = "RHEL"
  image_publisher                     = "redhat"
  image_sku                           = "10-lvm-gen2"

//  Managed images and resource group.
  managed_image_name = "multi-rhel-base-${local.time}"
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