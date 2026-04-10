# ============================================================
# modules/aks/main.tf
# Creates Azure Kubernetes Service (AKS) cluster
# ============================================================

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  # Default node pool configuration
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2s"   # Cost-effective VM for dev/demo
  }

  # Use system-assigned managed identity (no service principal needed)
  identity {
    type = "SystemAssigned"
  }

  tags = {
    project = "devops-flask-app"
  }
}

# Grant AKS permission to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
