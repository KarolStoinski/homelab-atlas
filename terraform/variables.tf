variable "onepassword_account" {
  type = string
}

variable "proxmox_api_url" {
  type = string
}

variable "flux_git_repo_url" {
  type = string
  description = "Git repository URL for Flux"
}

variable "ovh_endpoint" {
  type        = string
  description = "OVH API endpoint (e.g., ovh-eu)"
  default     = "ovh-eu"
}