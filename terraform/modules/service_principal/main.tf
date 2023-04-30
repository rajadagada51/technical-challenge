resource "azuread_application" "aks" {
  display_name = var.cluster_name
}

resource "azuread_service_principal" "aks_sp" {
  application_id = azuread_application.aks.application_id
}


resource "random_password" "aks_sp_password" {
  length = 32
  special = true
  override_special = "_%@"
}

resource "azuread_service_principal_password" "aks_sp_password" {
  service_principal_id = azuread_service_principal.aks_sp.id
  value                = random_password.aks_sp_password.result
}
