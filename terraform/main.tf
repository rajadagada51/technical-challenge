resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  subnet_name         = var.subnet_name
  vnet_name           = var.vnet_name
  resource_group_name = azurerm_resource_group.aks.name
  subnet_cidr         = var.subnet_cidr
  location            = var.location
  address_space       = var.address_space
}

module "aks" {
  source                   = "./modules/aks"
  cluster_name             = var.cluster_name
  location                 = var.location
  dns_prefix               = var.dns_prefix
  resource_group_name      = azurerm_resource_group.aks.name
  kubernetes_version       = var.kubernetes_version
  node_count               = var.node_count
  min_count                = var.min_count
  max_count                = var.max_count
  vm_size                  = var.vm_size
  os_disk_size_gb          = var.os_disk_size_gb
  vnet_subnet_id           = module.network.aks_subnet_id
  client_id                = var.cluster_client_id
  client_secret            = var.cluster_client_secret
}  

module "aks_log_analytics" {
  source                           = "./modules/aks_log_analytics"
  log_analytics_workspace_location = var.log_analytics_workspace_location
  log_analytics_workspace_name     = var.log_analytics_workspace_name
  log_analytics_workspace_sku      = var.log_analytics_workspace_sku
  resource_group_name 		   = azurerm_resource_group.aks.name
}    
    
