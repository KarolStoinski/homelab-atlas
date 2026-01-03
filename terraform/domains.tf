module "dns-capacitor" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "capacitor.atlas"
  ip            = "10.10.1.30"
}