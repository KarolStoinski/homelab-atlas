module "k8s-control-plane-1" {
  source        = "./modules/coreos-k8s-vm"
  name          = "k8s-control-plane-1"
  vm_ip         = "10.10.1.11"
  node_name     = "pve1"
  datastore_id  = "local-lvm"
}

module "k8s-join-token-1" {
  source = "./modules/k8s-join-token-control-plane"
  vm_ip  = module.k8s-control-plane-1.vm_ip
  vm_id  = module.k8s-control-plane-1.vm_id
}

module "k8s-control-plane-2" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-control-plane-2"
  vm_ip        = "10.10.1.12"
  node_name    = "pve2"
  datastore_id = "local-lvm"
  join_command = module.k8s-join-token-1.join_command
}

module "k8s-control-plane-3" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-control-plane-3"
  vm_ip        = "10.10.1.13"
  node_name    = "pve3"
  datastore_id = "local-lvm"
  join_command = module.k8s-join-token-1.join_command
}

module "k8s-control-plane-readiness" {
  source             = "./modules/k8s-node-readiness"
  node_names         = [
    module.k8s-control-plane-2.fqdn,
    module.k8s-control-plane-3.fqdn
  ]
  control_plane_ip   = module.k8s-control-plane-1.vm_ip
  timeout_seconds    = 900
  check_interval     = 10

  depends_on = [
    module.k8s-control-plane-2,
    module.k8s-control-plane-3
  ]
}

module "k8s-join-token-worker" {
  source = "./modules/k8s-join-token-worker"
  vm_ip  = module.k8s-control-plane-1.vm_ip

  depends_on = [
    module.k8s-control-plane-readiness
  ]
}

module "k8s-worker-1" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-worker-1"
  vm_ip        = "10.10.1.21"
  node_name    = "pve1"
  datastore_id = "local-lvm"
  memory       = 5 * 1024
  join_command = module.k8s-join-token-worker.join_command
}

module "k8s-worker-2" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-worker-2"
  vm_ip        = "10.10.1.22"
  node_name    = "pve2"
  datastore_id = "local-lvm"
  memory       = 12 * 1024
  join_command = module.k8s-join-token-worker.join_command
}

module "k8s-worker-3" {
  source       = "./modules/coreos-k8s-vm"
  name         = "k8s-worker-3"
  vm_ip        = "10.10.1.23"
  node_name    = "pve3"
  datastore_id = "local-lvm"
  memory       = 12 * 1024
  join_command = module.k8s-join-token-worker.join_command
}

module "k8s-worker-readiness" {
  source             = "./modules/k8s-node-readiness"
  node_names         = [
    module.k8s-worker-1.fqdn,
    module.k8s-worker-2.fqdn,
    module.k8s-worker-3.fqdn
  ]
  control_plane_ip   = module.k8s-control-plane-1.vm_ip
  timeout_seconds    = 1800
  check_interval     = 10

  depends_on = [
    module.k8s-worker-1,
    module.k8s-worker-2,
    module.k8s-worker-3,
    module.k8s-control-plane-readiness
  ]
}

module "k8s-kubeconfig" {
  source           = "./modules/k8s-kubeconfig"
  control_plane_ip = module.k8s-control-plane-1.vm_ip

  depends_on = [
    module.k8s-control-plane-readiness
  ]
}

module "flux-bootstrap" {
  source      = "./modules/flux-bootstrap"
  target_path = "flux"

  depends_on = [
    module.k8s-worker-readiness,
    module.k8s-kubeconfig,
    kubernetes_secret_v1.cert_manager_ovh_credentials
  ]
}