provider "onepassword" {
  account = var.onepassword_account
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  insecure = true // because of self-signed Proxmox TLS certificate
  username = "${local.proxmox_ssh_username}@pam"
  password = local.proxmox_ssh_password

  ssh {
    agent    = true
    username = local.proxmox_ssh_username
    password = local.proxmox_ssh_password
  }
}

provider "flux" {
  kubernetes = {
    config_path = "${path.root}/kubeconfig"
  }
  git = {
    url = var.flux_git_repo_url
    http = {
      username = local.flux_git_username
      password = local.flux_git_token
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
