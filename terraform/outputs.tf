output "kubeconfig" {
  description = "Kubernetes admin kubeconfig"
  value       = module.k8s-kubeconfig.kubeconfig
  sensitive   = true
}
