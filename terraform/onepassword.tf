data "onepassword_item" "proxmox_terraform_root" {
  vault = "HomeLab"
  title = "Proxmox-Terraform-Root"
}

data "onepassword_item" "coreos_password_hash" {
  vault = "HomeLab"
  title = "CoreOS-Password-Hash"
}

data "onepassword_item" "github_token" {
  vault = "HomeLab"
  title = "GitHub-Token"
}

data "onepassword_item" "ovh_api" {
  vault = "HomeLab"
  title = "OVH-API"
}

locals {
  # Get OVH API fields
  ovh_application_key_value = [
    for section in data.onepassword_item.ovh_api.section : [
      for field in section.field : field.value
      if field.label == "application_key"
    ]
  ]
  ovh_application_secret_value = [
    for section in data.onepassword_item.ovh_api.section : [
      for field in section.field : field.value
      if field.label == "application_secret"
    ]
  ]
  ovh_consumer_key_value = [
    for section in data.onepassword_item.ovh_api.section : [
      for field in section.field : field.value
      if field.label == "consumer_key"
    ]
  ]

  # Assign to variables used by Terraform
  proxmox_ssh_username     = data.onepassword_item.proxmox_terraform_root.username
  proxmox_ssh_password     = data.onepassword_item.proxmox_terraform_root.password
  coreos_password_hash     = data.onepassword_item.coreos_password_hash.password
  flux_git_username        = data.onepassword_item.github_token.username
  flux_git_token           = data.onepassword_item.github_token.password
  ovh_application_key      = flatten(local.ovh_application_key_value)[0]
  ovh_application_secret   = flatten(local.ovh_application_secret_value)[0]
  ovh_consumer_key         = flatten(local.ovh_consumer_key_value)[0]
}
