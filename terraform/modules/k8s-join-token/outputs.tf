output "join_command" {
  description = "The kubeadm join command with token"
  value       = data.external.k8s_join_token.result.join_command
  sensitive   = true
}
