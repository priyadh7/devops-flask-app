# ============================================================
# modules/resource_group/main.tf
# Creates an Azure Resource Group
# ============================================================

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location

  tags = {
    project     = "devops-flask-app"
    environment = "production"
  }
}
