resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.log_analytics_workspace_name}-dev"
  location            = var.log_analytics_workspace_location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name
  location              = azurerm_log_analytics_workspace.log_analytics_workspace.location
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  resource_group_name   = var.resource_group_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
