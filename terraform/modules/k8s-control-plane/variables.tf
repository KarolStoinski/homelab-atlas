variable "name" {
  type = string
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