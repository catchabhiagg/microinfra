output "aks_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.id }
}

output "aks_kube_configs" {
  value     = { for k, v in azurerm_kubernetes_cluster.this : k => v.kube_config_raw }
  sensitive = true
}

output "aks_fqdns" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.fqdn }
}
