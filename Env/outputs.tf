output "resource_group_ids" {
  value = module.resource_groups.resource_group_ids
}

output "acr_login_servers" {
  value = module.acrs.acr_login_servers
}

output "aks_ids" {
  value = module.aks.aks_ids
}

output "aks_kube_configs" {
  value     = module.aks.aks_kube_configs
  sensitive = true
}
