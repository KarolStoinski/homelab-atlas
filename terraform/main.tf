module "k8s-control-plane-1" {
  source = "./modules/k8s-control-plane"
  name = "k8s-control-plane-1"
  vm_ip  = "10.10.1.11"
}

module "k8s-control-plane-2" {
  source = "./modules/k8s-control-plane"
  name = "k8s-control-plane-2"
  vm_ip  = "10.10.1.12"
}

module "k8s-control-plane-3" {
  source = "./modules/k8s-control-plane"
  name = "k8s-control-plane-3"
  vm_ip  = "10.10.1.13"
}
