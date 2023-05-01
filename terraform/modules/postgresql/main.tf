resource "random_password" "pg_passwd" {
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
  name                = "${var.product_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.pg_sku_name
  version             = var.pg_version
  administrator_login = "${var.product_name}${var.environment}${var.location}"
  administrator_login_password = random_password.pg_passwd.result
}
