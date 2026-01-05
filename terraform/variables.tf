variable "onepassword_account" {
  type = string
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_ssh_username" {
  type      = string
  sensitive = true
  default   = null
}

variable "proxmox_ssh_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "flux_git_repo_url" {
  type = string
  description = "Git repository URL for Flux"
}

variable "flux_git_username" {
  type        = string
  description = "Git username for Flux"
  sensitive   = true
  default     = null
}

variable "flux_git_token" {
  type        = string
  description = "Git token/password for Flux"
  sensitive   = true
  default     = null
}

variable "ovh_endpoint" {
  type        = string
  description = "OVH API endpoint (e.g., ovh-eu)"
  default     = "ovh-eu"
}

variable "ovh_application_key" {
  type        = string
  description = "OVH API application key"
  sensitive   = true
  default     = null
}

variable "ovh_application_secret" {
  type        = string
  description = "OVH API application secret"
  sensitive   = true
  default     = null
}

variable "ovh_consumer_key" {
  type        = string
  description = "OVH API consumer key"
  sensitive   = true
  default     = null
}