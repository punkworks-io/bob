/*

    This file contains a list of all the local values that will be used by the resources.

*/


locals {

  # VPC service controls

  regular_service_perimeter_restricted_services = [
    "cloudtrace.googleapis.com",
  "monitoring.googleapis.com", ]

  # production  subnet details

  production_subnet_name = "production"
  production_subnet_cidr = "10.0.4.0/22" # 10.0.4.0 - 10.0.7.255 ; 1024 IPs


  production_pod_ip_range_name = "production-pod-cidr"
  production_pod_ip_cidr_range = "10.4.0.0/14" # 10.4.0.0 - 10.7.255.255 ; 262,144 IPs


  production_services_ip_range_name = "production-services-cidr"
  production_services_ip_cidr_range = "10.0.32.0/20" # 10.0.32.0 - 10.0.47.255 ; 4096 IPs



  # test subnet details  

  test_subnet_name = "test"
  test_subnet_cidr = "172.16.4.0/22" # 172.16.4.0 - 172.16.7.255 ; 1024 IPs


  test_pod_ip_range_name = "test-pod-cidr"
  test_pod_ip_cidr_range = "172.20.0.0/14" # 172.20.0.0 - 172.23.255.255 ; 262,144 IPs

  test_services_ip_range_name = "test-services-cidr"
  test_services_ip_cidr_range = "172.16.16.0/20" # 172.16.16.0 - 172.16.31.255 ; 4096 IPs


  # DNS settings

  shoparazzi_production_storefront_external_address_name = "shoparazzi-frontend-production-ext-ip"
  shoparazzi_test_storefront_external_address_name       = "shoparazzi-frontend-test-ext-ip"

  shoparazzi_production_identity_external_address_name = "shoparazzi-production-identity-ext-ip"
  shoparazzi_test_identity_external_address_name       = "shoparazzi-test-identity-ext-ip"

  shoparazzi_production_api_gateway_external_address_name = "shoparazzi-api-gateway-production-ext-ip"
  shoparazzi_test_api_gateway_external_address_name       = "shoparazzi-api-gateway-test-ext-ip"


  # GKE cluster settings

  production_cluster_name                 = "production"
  production_node_pool_initial_node_count = 1
  production_cluster_release_channel      = "REGULAR"
  production_master_ipv4_cidr_block       = "10.10.11.0/28" # 10.10.11.0 - 10.10.11.15 ; 16 IPs

  production_master_authorized_networks_config_1_display_name = "all"
  production_master_authorized_networks_config_1_cidr_block   = "0.0.0.0/0"

  production_node_pool_autoscaling_min_node_count = 1
  production_node_pool_autoscaling_max_node_count = 1
  production_node_pool_auto_repair                = true
  production_node_pool_auto_upgrade               = true

  production_node_pool_max_surge       = 1
  production_node_pool_max_unavailable = 0
  production_node_pool_machine_type    = "e2-standard-2"

  production_node_pool_oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]


  # Test

  test_cluster_name                 = "test"
  test_node_pool_initial_node_count = 1
  test_cluster_release_channel      = "REGULAR"
  test_master_ipv4_cidr_block       = "10.10.12.0/28" # 10.10.11.0 - 10.10.11.15 ; 16 IPs

  test_master_authorized_networks_config_1_display_name = "all"
  test_master_authorized_networks_config_1_cidr_block   = "0.0.0.0/0"

  test_node_pool_autoscaling_min_node_count = 1
  test_node_pool_autoscaling_max_node_count = 1
  test_node_pool_auto_repair                = true
  test_node_pool_auto_upgrade               = true

  test_node_pool_max_surge       = 1
  test_node_pool_max_unavailable = 0
  test_node_pool_machine_type    = "e2-standard-2"

  test_node_pool_oauth_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/cloud-platform",
  ]


  # Postgres DB

  postgres_private_ip_address_name = "production-postgres-ip"

}

