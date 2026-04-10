# ============================================================
# terraform/main.tf — Phase 3: Infrastructure as Code
# Provisions: Resource Group, ACR, AKS on Azure
# ============================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}

# ── Module: Resource Group ──────────────────────────────────
module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

# ── Module: Azure Container Registry ───────────────────────
module "acr" {
  source              = "./modules/acr"
  name                = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
}

# ── Module: Azure Kubernetes Service ───────────────────────
module "aks" {
  source              = "./modules/aks"
  cluster_name        = var.aks_cluster_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  acr_id              = module.acr.id
}
