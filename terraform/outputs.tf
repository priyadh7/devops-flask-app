# ============================================================
# terraform/outputs.tf — Output Values
# ============================================================

output "acr_login_server" {
  description = "ACR login server URL (used in CI/CD to push images)"
  value       = module.acr.login_server
}

output "aks_kube_config" {
  description = "AKS kubeconfig (used by kubectl)"
  value       = module.aks.kube_config
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the provisioned resource group"
  value       = module.resource_group.name
}
