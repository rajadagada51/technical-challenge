resource "random_password" "root_auth" {
  length      = 20
  min_lower   = 5
  min_upper   = 5
  min_numeric = 5
  special     = false
  lifecycle {
    ignore_changes = [min_lower, min_upper, min_numeric]
  }
}

resource "azurerm_postgresql_server" "postgres_server" {
  name                = var.server_name
  location            = azurerm_resource_group.postgres_rg.location
  resource_group_name = azurerm_resource_group.postgres_rg.name
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  version             = var.postgres_version
  administrator_login = var.username
  administrator_login_password = random_password.root_auth.result
}

