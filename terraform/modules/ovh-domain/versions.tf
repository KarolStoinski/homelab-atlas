terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.90"
    }
    ct = {
      source = "poseidon/ct"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.36"
    }
  }
}