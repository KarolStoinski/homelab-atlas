variable "name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "datastore_id" {
  type = string
  default = "local-lvm"
}

variable "vm_ip" {
  description = "Static IP address for the VM"
  type        = string
}

variable "gateway" {
  description = "Gateway IP address"
  type        = string
  default     = "10.10.1.1"
}

variable "dns_server" {
  description = "DNS server IP address"
  type        = string
  default     = "1.1.1.1"
}

variable "netmask" {
  description = "Network mask (CIDR notation, e.g., 24 for /24)"
  type        = number
  default     = 24
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size in MB"
  type        = number
  default     = 2048
}

variable "join_command" {
  description = "Kubeadm join command for joining existing cluster (leave empty to init new cluster)"
  type        = string
  default     = ""
}

variable "dns_zone" {
  description = "OVH DNS zone (domain name)"
  type        = string
  default     = "stoinski.pro"
}

variable "dns_subdomain" {
  description = "DNS subdomain prefix"
  type        = string
  default     = "atlas"
}