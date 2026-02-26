variable "location" {
  description = "The resource group location"
  default     = "Central India"
}

variable "hub_resource_group_name" {
  description = "The resource group name to be created"
  default     = "RG-HUB-NETWORK-POC"
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "RG-kube-PROD-POC"
}


variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "hub1-firewalvnet-poc"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "spoke1-kubevnet-poc"
}

variable "kube_version_prefix" {
  description = "AKS Kubernetes version prefix. Formatted '[Major].[Minor]' like '1.18'. Patch version part (as in '[Major].[Minor].[Patch]') will be set to latest automatically."
  default     = "1.18"
}



variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 1
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_D2_v2"
}

variable "network_docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.17.0.1/16"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.2.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "10.2.0.0/24"
}