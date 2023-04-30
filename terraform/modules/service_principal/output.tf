output "cluster_client_id" {
  value = azuread_service_principal.aks_sp.application_id
}

output "cluster_sp_secret" {
  sensitive = true
  value     = random_password.aks_sp_password.result
}

