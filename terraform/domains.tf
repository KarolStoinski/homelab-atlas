module "dns-readynas" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "readynas"
  ip            = "192.168.1.200"
}

module "dns-pve1" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "pve1.atlas"
  ip            = "192.168.1.201"
}

module "dns-pve2" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "pve2.atlas"
  ip            = "192.168.1.202"
}

module "dns-pve3" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "pve3.atlas"
  ip            = "192.168.1.203"
}

module "dns-pbs1" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "pbs1.atlas"
  ip            = "192.168.1.204"
}

module "dns-capacitor" {
  source        = "./modules/ovh-domain"
  dns_subdomain = "capacitor.atlas"
  ip            = "10.10.1.30"
}