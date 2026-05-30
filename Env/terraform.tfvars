infrastructure = {
  "rg-dev-backend" = {
    location = "East US"
    tags     = { Environment = "Dev", Department = "IT" }
    acrs = {
      "acrdevbackend" = {
        sku           = "Basic"
        admin_enabled = true
      }
    }
    aks_clusters = {
      "aks-dev-cluster" = {
        dns_prefix = "aksdev"
        default_node_pool = {
          name       = "default"
          node_count = 1
          vm_size    = "Standard_DS2_v2"
        }
        extra_node_pools = {
          "userpool" = {
            vm_size    = "Standard_DS2_v2"
            node_count = 2
          }
        }
      }
    }
  }
  "rg-prod-frontend" = {
    location = "West US"
    acrs = {
      "acrprodfrontend" = {
        sku = "Premium"
      }
    }
  }
}
