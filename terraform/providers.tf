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

provider "flux" {
  kubernetes = {
    config_path = "${path.root}/kubeconfig"
  }
  git = {
    url = var.flux_git_repo_url
    http = {
      username = var.flux_git_username
      password = var.flux_git_token
    }
  }
}
