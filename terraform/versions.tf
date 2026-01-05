terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.90"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.7.6"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.36"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0.1"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2.1.2"
    }
  }
}