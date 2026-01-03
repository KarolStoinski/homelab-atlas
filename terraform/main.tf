module "k8s-control-plane-1" {
  source        = "./modules/coreos-k8s-vm"
  name          = "k8s-control-plane-1"
  vm_ip         = "10.10.1.11"
  node_name     = "pve1"
}

module "k8s-join-token-1" {
  source = "./modules/k8s-join-token"
  vm_ip  = module.k8s-control-plane-1.vm_ip
  vm_id  = module.k8s-control-plane-1.vm_id
}

output "k8s_join_command" {
  description = "Kubernetes join command for worker nodes"
  value       = module.k8s-join-token-1.join_command
  sensitive   = true
}

module "k8s-control-plane-2" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-control-plane-2"
  vm_ip        = "10.10.1.12"
  node_name    = "pve2"
  join_command = module.k8s-join-token-1.join_command
}

module "k8s-control-plane-3" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-control-plane-3"
  vm_ip        = "10.10.1.13"
  node_name    = "pve3"
  join_command = module.k8s-join-token-1.join_command
}

module "k8s-control-plane-readiness" {
  source             = "./modules/k8s-node-readiness"
  node_names         = [
    "k8s-control-plane-2.atlas.stoinski.pro",
    "k8s-control-plane-3.atlas.stoinski.pro"
  ]
  control_plane_ip   = module.k8s-control-plane-1.vm_ip
  timeout_seconds    = 600
  check_interval     = 10

  depends_on = [
    module.k8s-control-plane-2,
    module.k8s-control-plane-3
  ]
}