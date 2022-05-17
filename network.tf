/*
    This file maintains VPC, subnets & network iam policies for all the projects.

		# VPC & subnets:

			The VPC and subnets are created in the network project
			
			Read the below links to understand primary and secondary ip address ranges
			https://cloud.google.com/vpc/docs/alias-ip#container-architecture

		
		# Service accounts

			For more Info: https://cloud.google.com/iam/docs/service-accounts#google-managed

			* Your project is likely to contain a service account named the Google APIs Service Agent,
				with an email address that uses the following format:
				project-number@cloudservices.gserviceaccount.com
			
		
			* The name of your Google Kubernetes Engine service account is as follows,
				service-PROJECT_NUMBER@container-engine-robot.iam.gserviceaccount.com


		# IAM Policies

			* google_compute_subnetwork_iam_policy:
				Sets the IAM policy for the subnetwork and replaces any existing policy already attached.

			



*/


## VPC

# The main VPC created in network project 
resource "google_compute_network" "main-vpc" {
  name                    = var.main_vpc_name
  project                 = google_project.network.project_id
  auto_create_subnetworks = false
}

# Enabling shared vpc on production and test projects
# https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#enabling_shared_vpc_and_granting_roles
resource "google_compute_shared_vpc_host_project" "network" {
  provider = google-beta
  project  = google_project.network.project_id
}
resource "google_compute_shared_vpc_service_project" "production" {
  provider        = google-beta
  host_project    = google_compute_shared_vpc_host_project.network.project
  service_project = google_project.production.project_id
}
resource "google_compute_shared_vpc_service_project" "test" {
  provider        = google-beta
  host_project    = google_compute_shared_vpc_host_project.network.project
  service_project = google_project.test.project_id
}



## Subnets

# This is a subnet for production.
# Part of main-vpc
resource "google_compute_subnetwork" "production" {
  name    = local.production_subnet_name
  project = google_project.network.project_id
  region  = var.region
  network = google_compute_network.main-vpc.self_link

  # This needs to be set becasue we disabled External IPs for VMs in org-policies
  private_ip_google_access = true

  # This is the list of IPs available for on-premise BGP routers
  ip_cidr_range = local.production_subnet_cidr

  # IP ranges to be used by k8s pods in the production cluster.
  # This is referenced by GKE config by name
  secondary_ip_range {
    range_name    = local.production_pod_ip_range_name
    ip_cidr_range = local.production_pod_ip_cidr_range
  }

  # IP ranges to be used by k8s services in the production cluster.
  # This is referenced by GKE config by name
  secondary_ip_range {
    range_name    = local.production_services_ip_range_name
    ip_cidr_range = local.production_services_ip_cidr_range
  }

}


# This is a subnet for test.
# Part of main-vpc
resource "google_compute_subnetwork" "test" {
  name    = local.test_subnet_name
  project = google_project.network.project_id
  region  = var.region
  network = google_compute_network.main-vpc.self_link

  # This needs to be set becasue we disabled External IPs for VMs in org-policies
  private_ip_google_access = true

  # This is the list of IPs available for on-premise BGP routers
  ip_cidr_range = local.test_subnet_cidr


  # IP ranges to be used by k8s pods in the test cluster.
  # This is referenced by GKE config by name
  secondary_ip_range {
    range_name    = local.test_pod_ip_range_name
    ip_cidr_range = local.test_pod_ip_cidr_range
  }

  # IP ranges to be used by k8s services in the test cluster.
  # This is referenced by GKE config by name
  secondary_ip_range {
    range_name    = local.test_services_ip_range_name
    ip_cidr_range = local.test_services_ip_cidr_range
  }

}



## IAM Policies on Service Accounts=

# Production

# Production IAM Policy definition
data "google_iam_policy" "production-policy" {
  binding {
    role = "roles/compute.networkUser"
    members = [
      "serviceAccount:${google_project.production.number}@cloudservices.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/compute.networkUser"
    members = [
      "serviceAccount:service-${google_project.production.number}@container-engine-robot.iam.gserviceaccount.com",
    ]
  }
}

# Production IAM policy binding 
resource "google_compute_subnetwork_iam_policy" "production" {
  project     = google_project.network.project_id
  region      = var.region
  subnetwork  = google_compute_subnetwork.production.name
  policy_data = data.google_iam_policy.production-policy.policy_data
}


# Test 

# Test IAM Policy definition
data "google_iam_policy" "test-policy" {
  binding {
    role = "roles/compute.networkUser"
    members = [
      "serviceAccount:${google_project.test.number}@cloudservices.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/compute.networkUser"
    members = [
      "serviceAccount:service-${google_project.test.number}@container-engine-robot.iam.gserviceaccount.com",
    ]
  }
}

# Test IAM policy binding
resource "google_compute_subnetwork_iam_policy" "test" {
  project     = google_project.network.project_id
  region      = var.region
  subnetwork  = google_compute_subnetwork.test.name
  policy_data = data.google_iam_policy.test-policy.policy_data
}