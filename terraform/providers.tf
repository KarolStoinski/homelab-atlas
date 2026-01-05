provider "onepassword" {
  account = var.onepassword_account
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  insecure = true // because of self-signed Proxmox TLS certificate
  username = "${coalesce(var.proxmox_ssh_username, local.proxmox_ssh_username)}@pam"
  password = coalesce(var.proxmox_ssh_password, local.proxmox_ssh_password)

  ssh {
    agent    = true
    username = coalesce(var.proxmox_ssh_username, local.proxmox_ssh_username)
    password = coalesce(var.proxmox_ssh_password, local.proxmox_ssh_password)
  }
}

provider "flux" {
  kubernetes = {
    config_path = "${path.root}/kubeconfig"
  }
  git = {
    url = var.flux_git_repo_url
    http = {
      username = coalesce(var.flux_git_username, local.flux_git_username)
      password = coalesce(var.flux_git_token, local.flux_git_token)
    }
  }
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = local.ovh_application_key
  application_secret = local.ovh_application_secret
  consumer_key       = local.ovh_consumer_key
}

provider "kubernetes" {
  config_path = "${path.root}/kubeconfig"
}
