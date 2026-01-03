output "join_command" {
  description = "The kubeadm join command for worker nodes"
  value       = data.external.k8s_join_token_worker.result.join_command
  sensitive   = true
}
