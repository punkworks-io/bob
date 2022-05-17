/*

This file contains a list of all the variables that will be used by the resources.

The values need to be set in Terraform Cloud Dashboard

*/


# Basic GCP Details

variable "region" {
  default = "asia-south1"
}
variable "gsuite_id" {
  description = "G Suite customer ID"
}
variable "folder_id" {
  description = "The ID of the folder in which projects should be created"
}

variable "billing_account" {
  description = "The ID of the associated billing account"
}

variable "org_id" {
  description = "The ID of the Google Cloud Organization."
}

variable "terraform_service_account" {
  description = "The IDs of the Terraform users or Service Accounts to be applied to VPC Service Controls"
}

# Project Names

variable "project_network" {
  description = "Name of the network project"
}

variable "project_management" {
  description = "Name of the management project"
}

variable "project_production" {
  description = "Name of the production project"
}
variable "project_test" {
  description = "Name of the test project"
}


# Network

variable "main_vpc_name" {
  default     = "main-vpc"
  description = "Name of the VPC network"
}

# Shoparazzi Production

variable "shoparazzi_production_zone_dns_name" {
  default     = "shoparazzi.club"
  description = "DNS name for the managed dns zone - production shoparazzi"
}

variable "shoparazzi_production_storefront_hostname" {
  default     = "*"
  description = "Hostname for shoparazzi frontend on production"
}

variable "shoparazzi_production_identity_hostname" {
  default     = "auth"
  description = "Hostname for shoparazzi identity on production"
}

variable "shoparazzi_production_api_gateway_hostname" {
  default     = "api"
  description = "Hostname for shoparazzi api-gateway on production"
}

# Shoparazzi Test

variable "shoparazzi_test_zone_dns_name" {
  default     = "test-shoparazzi.club"
  description = "DNS name for the managed dns zone - test shoparazzi"
}

variable "shoparazzi_test_storefront_hostname" {
  default     = "*"
  description = "Hostname for shoparazzi frontend on test"
}

variable "shoparazzi_test_identity_hostname" {
  default     = "auth"
  description = "Hostname for shoparazzi identity on test"
}

variable "shoparazzi_test_api_gateway_hostname" {
  default     = "api"
  description = "Hostname for shoparazzi api-gateway on test"
}

# GKE cluster settings

variable "production_gke_security_group_name" {
  description = "[ Production ] Google Group name to be used for GKE RBAC via Google Groups. See https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite"
}

variable "test_gke_security_group_name" {
  description = "[ Test ] Google Group name to be used for GKE RBAC via Google Groups. See https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite"
}

# Postgres settings

variable "postgres_instance_name" {
  default     = "postgres-db-instance"
  description = "Name for the postgres instance to be used"
}

variable "postgres_instance_tier" {
  default     = "db-f1-micro"
  description = "Machine Tier to be used for postgres db"
}

variable "postgres_username" {
  description = "Username for postgres user"
}

variable "postgres_password" {
  description = "Password for postgres user"
}

variable "heimdall_db_name" {
  description = "Database name for heimdall"
}