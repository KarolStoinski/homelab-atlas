output "kubeconfig_raw" {
  description = "Raw kubeconfig content (base64 encoded)"
  value       = data.external.kubeconfig.result.kubeconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "Decoded kubeconfig content"
  value       = base64decode(data.external.kubeconfig.result.kubeconfig)
  sensitive   = true
}

output "kubeconfig_path" {
  description = "Path to saved kubeconfig file"
  value       = local_sensitive_file.kubeconfig.filename
}
