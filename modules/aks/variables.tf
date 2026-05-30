variable "aks_clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    
    default_node_pool = object({
      name                = string
      node_count          = number
      vm_size             = string
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
      vnet_subnet_id      = optional(string)
    })

    network_profile = optional(object({
      network_plugin    = optional(string, "azure")
      load_balancer_sku = optional(string, "standard")
      network_policy    = optional(string)
    }))

    extra_node_pools = optional(map(object({
      vm_size             = string
      node_count          = number
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
    })), {})

    tags = optional(map(string), {})
  }))
}
