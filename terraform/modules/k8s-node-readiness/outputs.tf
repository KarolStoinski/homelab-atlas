output "ready_nodes" {
  description = "List of nodes that are ready"
  value       = var.node_names
  depends_on  = [null_resource.check_node_readiness]
}

output "readiness_check_complete" {
  description = "Boolean indicating all nodes are ready"
  value       = true
  depends_on  = [null_resource.check_node_readiness]
}
