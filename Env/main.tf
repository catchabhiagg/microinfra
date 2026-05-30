terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_groups" {
  source = "../modules/resource_group"

  resource_groups = {
    for rg_name, config in var.infrastructure : rg_name => {
      location = config.location
      tags     = config.tags
    }
  }
}

module "acrs" {
  source = "../modules/acr"

  acrs = merge([
    for rg_name, config in var.infrastructure : {
      for acr_name, acr_config in config.acrs : acr_name => {
        resource_group_name = rg_name
        location            = config.location
        sku                 = acr_config.sku
        admin_enabled       = acr_config.admin_enabled
        tags                = config.tags
      }
    }
  ]...)

  depends_on = [module.resource_groups]
}

module "aks" {
  source = "../modules/aks"

  aks_clusters = merge([
    for rg_name, config in var.infrastructure : {
      for aks_name, aks_config in config.aks_clusters : aks_name => {
        resource_group_name = rg_name
        location            = config.location
        dns_prefix          = aks_config.dns_prefix
        default_node_pool   = aks_config.default_node_pool
        extra_node_pools    = aks_config.extra_node_pools
        tags                = config.tags
      }
    }
  ]...)

  depends_on = [module.resource_groups]
}
