/*

  This file contains resources for GCP Projects.
  Enables necessary GCP APIs on project.


  These are the projects available
  1. network: to manage VPC & subnets
  2. managememt: to manage servcie accounts & policies
  3. production: to manage containers & clusters in production env
  4. test: to manage containers & clusters in test env
  5. DNS: to manage dns zones & dns entries 

*/


## Create Projects

# project to manage VPC and subnets
resource "google_project" "network" {
  name                = var.project_network
  project_id          = var.project_network
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# project to manage service accounts & policies
resource "google_project" "management" {
  name                = var.project_management
  project_id          = var.project_management
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# Project to manage clusters & containers in production
resource "google_project" "production" {
  name                = var.project_production
  project_id          = var.project_production
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# Project to manage clusters & containers in test
resource "google_project" "test" {
  name                = var.project_test
  project_id          = var.project_test
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}



## Enable GKE API on nework, test & prod projects

# Enable GKE on network project
resource "google_project_service" "container_api_network" {
  project                    = google_project.network.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Enable GKE on test project
resource "google_project_service" "container_api_test" {
  project                    = google_project.test.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Enable GKE on production project
resource "google_project_service" "container_api_production" {
  project                    = google_project.production.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}



## Enable Tracing & Monitoring

# Cloudtrace on test
resource "google_project_service" "cloudtrace_api_test" {
  project                    = google_project.test.project_id
  service                    = "cloudtrace.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Monitoring on test
resource "google_project_service" "monitoring_api_test" {
  project                    = google_project.test.project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Cloudtrace on production
resource "google_project_service" "cloudtrace_api_production" {
  project                    = google_project.production.project_id
  service                    = "cloudtrace.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Monitoring on production
resource "google_project_service" "monitoring_api_production" {
  project                    = google_project.production.project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}


# Enable DNS on network 
resource "google_project_service" "dns_api_network" {
  project                    = google_project.network.project_id
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Enable ServiceNetworking on network - used for VPC peering databases
resource "google_project_service" "servicenetworking_api_network" {
  project                    = google_project.network.project_id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}

# Enable ServiceNetworking on network - used for VPC peering databases
resource "google_project_service" "servicenetworking_api_production" {
  project                    = google_project.production.project_id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = true
}