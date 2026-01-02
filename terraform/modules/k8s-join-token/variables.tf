variable "vm_ip" {
  description = "IP address of the Kubernetes control plane VM"
  type        = string
}

variable "vm_id" {
  description = "ID of the VM to track for changes"
  type        = string
}
