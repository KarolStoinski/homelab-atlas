variable "ip" {
  type        = string
}

variable "dns_zone" {
  description = "OVH DNS zone (domain name)"
  type        = string
  default     = "stoinski.pro"
}

variable "dns_subdomain" {
  description = "DNS subdomain prefix"
  type        = string
}