variable "infrastructure" {
  description = "Nested map of objects defining the infrastructure"
  type = map(object({
    location = string
    tags     = optional(map(string), {})
    acrs = optional(map(object({
      sku           = optional(string, "Standard")
      admin_enabled = optional(bool, false)
    })), {})
    aks_clusters = optional(map(object({
      dns_prefix = string
      default_node_pool = object({
        name       = string
        node_count = number
        vm_size    = string
      })
      extra_node_pools = optional(map(object({
        vm_size    = string
        node_count = number
      })), {})
    })), {})
  }))
}
