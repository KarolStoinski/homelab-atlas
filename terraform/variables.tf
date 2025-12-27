variable "proxmox_api_url" {
  type = string
}

variable "proxmox_ssh_username" {
  type = string
  sensitive = true
}

variable "proxmox_ssh_password" {
  type = string
  sensitive = true
}