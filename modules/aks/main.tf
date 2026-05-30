resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.aks_clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  tags                = each.value.tags

  default_node_pool {
    name                = each.value.default_node_pool.name
    node_count          = each.value.default_node_pool.node_count
    vm_size             = each.value.default_node_pool.vm_size
    enable_auto_scaling = each.value.default_node_pool.enable_auto_scaling
    min_count           = each.value.default_node_pool.min_count
    max_count           = each.value.default_node_pool.max_count
    vnet_subnet_id      = each.value.default_node_pool.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      load_balancer_sku = network_profile.value.load_balancer_sku
      network_policy    = network_profile.value.network_policy
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  for_each = merge([
    for cluster_key, cluster_val in var.aks_clusters : {
      for pool_key, pool_val in cluster_val.extra_node_pools :
      "${cluster_key}_${pool_key}" => merge(pool_val, {
        kubernetes_cluster_id = azurerm_kubernetes_cluster.this[cluster_key].id
        name                  = pool_key
      })
    }
  ]...)

  name                  = each.value.name
  kubernetes_cluster_id = each.value.kubernetes_cluster_id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
}
