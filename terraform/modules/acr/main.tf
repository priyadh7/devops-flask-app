# ============================================================
# modules/acr/main.tf
# Creates Azure Container Registry (ACR)
# ============================================================

resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Basic SKU is sufficient for this project
  sku = "Basic"

  # Allow admin login (used by GitHub Actions to push images)
  admin_enabled = true

  tags = {
    project = "devops-flask-app"
  }
}
