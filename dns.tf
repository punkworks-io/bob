/*
  This file maintains the DNS zones & dns record sets

  # google_compute_global_address
  google_compute_global_address.name is referenced by Ingress using `kubernetes.io/ingress.global-static-ip-name:` in annotations to assign static-ip to the service 

  The kubernetes.io/ingress.global-static-ip-name annotation specifies the name of the global IP address resource to be associated with the HTTP(S) Load Balancer.

*/



# Shoparazzi DNS settings
# 
# Shoparazzi Frontend needs to be configured for both prod & test separately
# because we provide the frontend url in the following format
# USERNAME.shoparazzi.club & USERNAME.test-shoparazzi.club
# 
# We override auth.shoparazzi.club to point to identity service
#  


#### Shoparazzi Production

# Add an entry for GCP managed zone for shoparazzi production
resource "google_dns_managed_zone" "shoparazzi-production-dns-zone" {
  project    = google_project.network.project_id
  name       = "shoparazzi-production-dns-zone"
  dns_name   = "${var.shoparazzi_production_zone_dns_name}."
  depends_on = [google_project_service.dns_api_network]
}

# Output Name servers for shoparazzi production DNS management
output "shoparazzi_production_nameservers" {
  value = google_dns_managed_zone.shoparazzi-production-dns-zone.name_servers
}


## Production Storefront

# Allocate IP address for shoparazzi production storefront DNS
resource "google_compute_global_address" "shoparazzi-production-storefront-ext-ip" {
  name         = local.shoparazzi_production_storefront_external_address_name
  project      = google_project.production.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi production storefront."
  address_type = "EXTERNAL"
}

# Add a DNS record for shoparazzi production storefront with IP address allocated above
resource "google_dns_record_set" "shoparazzi-production-storefront" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_production_storefront_hostname}.${google_dns_managed_zone.shoparazzi-production-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-production-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-production-storefront-ext-ip.address]
}

# Output the shoparazzi production storefront IP after allocation
output "shoparazzi-production-storefront-ext-ip" {
  value = google_compute_global_address.shoparazzi-production-storefront-ext-ip.address
}


## Production Identity

# Allocate IP address for shoparazzi production identity 
resource "google_compute_global_address" "shoparazzi-production-identity-ext-ip" {
  name         = local.shoparazzi_production_identity_external_address_name
  project      = google_project.production.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi production identity."
  address_type = "EXTERNAL"
}

# Add a DNS record for shoparazzi production identity with IP address allocated above
resource "google_dns_record_set" "shoparazzi-production-identity" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_production_identity_hostname}.${google_dns_managed_zone.shoparazzi-production-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-production-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-production-identity-ext-ip.address]
}

# Output the shoparazzi production identity IP after allocation
output "shoparazzi-production-identity-ext-ip" {
  value = google_compute_global_address.shoparazzi-production-identity-ext-ip.address
}


## Production API Gateway

# Allocate IP address for shoparazzi production api-gateway
resource "google_compute_global_address" "shoparazzi-production-api-gateway-ext-ip" {
  name         = local.shoparazzi_production_api_gateway_external_address_name
  project      = google_project.production.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi production api-gateway."
  address_type = "EXTERNAL"
}

# Add a DNS record for shoparazzi production api-gateway with IP address allocated above
resource "google_dns_record_set" "shoparazzi-production-api-gateway" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_production_api_gateway_hostname}.${google_dns_managed_zone.shoparazzi-production-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-production-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-production-api-gateway-ext-ip.address]
}

# Output the shoparazzi production api-gateway IP after allocation
output "shoparazzi-production-api-gateway-ext-ip" {
  value = google_compute_global_address.shoparazzi-production-api-gateway-ext-ip.address
}


## Test

# Add an entry for GCP managed zone for shoparazzi test
resource "google_dns_managed_zone" "shoparazzi-test-dns-zone" {
  project    = google_project.network.project_id
  name       = "shoparazzi-test-dns-zone"
  dns_name   = "${var.shoparazzi_test_zone_dns_name}."
  depends_on = [google_project_service.dns_api_network]
}

# Output DNS Zone Used for shoparazzi test
output "shoparazzi_test_zone_dns_name" {
  value = var.shoparazzi_test_zone_dns_name
}

# Output Name servers for shoparazzi-test DNS management
output "shoparazzi_test_name_servers" {
  value = google_dns_managed_zone.shoparazzi-test-dns-zone.name_servers
}


## Test Storefront

# Allocate IP address for shoparazzi test storefront
resource "google_compute_global_address" "shoparazzi-test-storefront-ext-ip" {
  name         = local.shoparazzi_test_storefront_external_address_name
  project      = google_project.test.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi test storefront."
  address_type = "EXTERNAL"
}

# Output the shoparazzi test storefront IP after allocation
output "shoparazzi-test-storefront-ext-ip" {
  value = google_compute_global_address.shoparazzi-test-storefront-ext-ip.address
}

# Add a DNS record for shoparazzi test storefront with IP address allocated above
resource "google_dns_record_set" "shoparazzi-test-storefront" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_test_storefront_hostname}.${google_dns_managed_zone.shoparazzi-test-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-test-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-test-storefront-ext-ip.address]
}


## Test Identity

# Allocate IP address for shoparazzi test identity
resource "google_compute_global_address" "shoparazzi-test-identity-ext-ip" {
  name         = local.shoparazzi_test_identity_external_address_name
  project      = google_project.test.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi test identity."
  address_type = "EXTERNAL"
}

# Output the shoparazzi test identity IP after allocation
output "shoparazzi-test-identity-ext-ip" {
  value = google_compute_global_address.shoparazzi-test-identity-ext-ip.address
}

# Add a DNS record for shoparazzi test identity with IP address allocated above
resource "google_dns_record_set" "shoparazzi-test-identity" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_test_identity_hostname}.${google_dns_managed_zone.shoparazzi-test-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-test-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-test-identity-ext-ip.address]
}



## Test api-gateway

# Allocate IP address for shoparazzi test api-gateway
resource "google_compute_global_address" "shoparazzi-test-api-gateway-ext-ip" {
  name         = local.shoparazzi_test_api_gateway_external_address_name
  project      = google_project.test.project_id
  description  = "A named external IP address to match an Ingress rule for the shoparazzi test api-gateway."
  address_type = "EXTERNAL"
}

# Output the shoparazzi test api-gateway IP after allocation
output "shoparazzi-test-api-gateway-ext-ip" {
  value = google_compute_global_address.shoparazzi-test-api-gateway-ext-ip.address
}

# Add a DNS record for shoparazzi test api-gateway with IP address allocated above
resource "google_dns_record_set" "shoparazzi-test-api-gateway" {
  project      = google_project.network.project_id
  name         = "${var.shoparazzi_test_api_gateway_hostname}.${google_dns_managed_zone.shoparazzi-test-dns-zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.shoparazzi-test-dns-zone.name
  rrdatas      = [google_compute_global_address.shoparazzi-test-api-gateway-ext-ip.address]
}


