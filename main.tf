# module "aks-private" {
#   source  = "singhsynergy/aks-private/azurerm"
#   version = "1.0.1"
# }


#Resource groups
resource "azurerm_resource_group" "vnet" {
  name     = var.hub_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "kube" {
  name     = var.kube_resource_group_name
  location = var.location
}

#Networking (VNETs, Subnets)

module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.vnet.name #hub_resource_group_name
  location            = var.location
  vnet_name           = var.hub_vnet_name
  address_space       = ["10.0.0.0/22"]
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["10.0.0.0/24"]
    },
    {
      name : "jumpbox-subnet"
      address_prefixes : ["10.0.1.0/24"]
    }
  ]
    depends_on = [
    azurerm_resource_group.vnet,
    azurerm_resource_group.kube
  ]
}

module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  vnet_name           = var.kube_vnet_name
  address_space       = ["10.0.4.0/22"]
  subnets = [
    {
      name : "aks-subnet"
      address_prefixes : ["10.0.5.0/24"]
    }
  ]
  depends_on = [
    azurerm_resource_group.vnet,
    azurerm_resource_group.kube,
  ]
}

module "vnet_peering" {
  source              = "./modules/vnet_peering"
  vnet_1_name         = var.hub_vnet_name
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = azurerm_resource_group.vnet.name
  vnet_2_name         = var.kube_vnet_name
  vnet_2_id           = module.kube_network.vnet_id
  vnet_2_rg           = azurerm_resource_group.kube.name
  peering_name_1_to_2 = "HubToSpoke1"
  peering_name_2_to_1 = "Spoke1ToHub"
  depends_on = [
    azurerm_resource_group.vnet,
    azurerm_resource_group.kube,
    module.hub_network,
    module.kube_network
  ]
}

resource "azurerm_kubernetes_cluster" "privateaks" {
  name                    = "private-aks"
  location                = var.location
  kubernetes_version      = "1.34.0"
  resource_group_name     = azurerm_resource_group.kube.name
  dns_prefix              = "private-aks"
  private_cluster_enabled = true
  oidc_issuer_enabled     = true

  default_node_pool {
    name           = "default"
    vm_size        = var.nodepool_vm_size
    vnet_subnet_id = module.kube_network.subnet_ids["aks-subnet"]
  #Manual Scal  
    # node_count     = var.nodepool_nodes_count
  #Autoscaling    
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = 5
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    outbound_type  = "loadBalancer"   # ✅ changed
    dns_service_ip = var.network_dns_service_ip
    service_cidr   = var.network_service_cidr
  }
  depends_on = [
    azurerm_resource_group.vnet,
    azurerm_resource_group.kube,
    module.hub_network,
    module.kube_network,
    module.vnet_peering,

  ]
}

resource "azurerm_role_assignment" "netcontributor" {
  role_definition_name = "Network Contributor"
  scope                = module.kube_network.subnet_ids["aks-subnet"]
  principal_id         = azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
}

 module "jumpbox" {
   source                  = "./modules/jumpbox"
   location                = var.location
   resource_group          = azurerm_resource_group.vnet.name
   vnet_id                 = module.hub_network.vnet_id
   subnet_id               = module.hub_network.subnet_ids["jumpbox-subnet"]
   dns_zone_name           = join(".", slice(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn))))
   dns_zone_resource_group = azurerm_kubernetes_cluster.privateaks.node_resource_group
 }

