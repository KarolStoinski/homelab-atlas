variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "proxmox_ssh_username" {
  type = string
  sensitive = true
}

variable "proxmox_ssh_password" {
  type = string
  sensitive = true
}

variable "coreos_password_hash" {
  type = string
  sensitive = true
}