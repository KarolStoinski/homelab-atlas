# OVH DNS Record
resource "ovh_domain_zone_record" "dns_record" {
  zone      = var.dns_zone
  subdomain = var.dns_subdomain
  fieldtype = "A"
  ttl       = 60
  target    = var.ip
}

output "fqdn" {
  description = "Fully qualified domain name"
  value       = "${var.dns_subdomain}.${var.dns_zone}"

  depends_on = [
    ovh_domain_zone_record.dns_record
  ]
}