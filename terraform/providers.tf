provider "proxmox" {
  endpoint = var.proxmox_api_url
  insecure = true // because of self-signed Proxmox TLS certificate
  username = "${var.proxmox_ssh_username}@pam"
  password = var.proxmox_ssh_password

  ssh {
    agent    = true
    username = var.proxmox_ssh_username
    password = var.proxmox_ssh_password
  }
}
