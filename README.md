# terraform-azurerm-aks-private

## provider.tf

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

## main.tf

module "aks-private" {
  source  = "singhsynergy/aks-private/azurerm"
  version = "1.0.20"

  location = "Central India"
  hub_resource_group_name = "RG-Dev-HUB-NETWORK-new"
  kube_resource_group_name = "RG-Dev-kube-PROD-new"
  hub_vnet_name = "vnet-hub1-firewalvnet"
  kube_vnet_name = "vnet-spoke1-kubevnet"
  kube_version_prefix = "1.35"
  nodepool_nodes_count = 1
  nodepool_vm_size = "Standard_D2_v2"
  network_docker_bridge_cidr = "172.17.0.1/16"
  network_dns_service_ip = "10.2.0.10"
  network_service_cidr = "10.2.0.0/24"

}

## output.tf
output "jumpbox_vm_ip" {
  value = module.aks-private.jumpbox_vm_ip
}

output "jumpbox_vm_username" {
  value = module.aks-private.jumpbox_vm_username
}

output "jumpbox_vm_user_password" {
  value     = module.aks-private.jumpbox_vm_user_password
  sensitive = true
}
