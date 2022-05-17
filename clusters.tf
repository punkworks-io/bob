/*
    This file contains all the resources to maintain GKE clusters & it's nodes
    
    GKE Shielded nodes:
    https://cloud.google.com/kubernetes-engine/docs/how-to/shielded-gke-nodes

*/


######## Production

# Create a GKE clusteer for production
resource "google_container_cluster" "production" {
  provider                 = google-beta
  name                     = local.production_cluster_name
  location                 = var.region
  project                  = google_project.production.project_id
  network                  = google_compute_network.main-vpc.self_link
  subnetwork               = google_compute_subnetwork.production.self_link
  remove_default_node_pool = true
  initial_node_count       = local.production_node_pool_initial_node_count
  enable_shielded_nodes    = true

  # GKE release channels:
  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  release_channel {
    channel = local.production_cluster_release_channel
  }

  # allows Kubernetes service accounts to act as a user-managed Google IAM Service Account.      
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#workload_identity_config
  workload_identity_config {
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#identity_namespace
    identity_namespace = "${google_project.production.project_id}.svc.id.goog"
  }


  # Define sources for ip-addresses for pods & services 
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#ip_allocation_policy
  ip_allocation_policy {
    cluster_secondary_range_name  = local.production_pod_ip_range_name
    services_secondary_range_name = local.production_services_ip_range_name
  }

  # GKE private cluster
  # In a private cluster, nodes only have internal IP addresses, 
  # which means that nodes and Pods are isolated from the internet by default.
  # https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false

    # specifies an internal IP address range for the control plan.
    # This setting is permanent for this cluster.
    master_ipv4_cidr_block = local.production_master_ipv4_cidr_block
  }

  # https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
  # specifies that access to the public endpoint is restricted to IP address ranges that you authorize.  
  #   
  # nodes and containers are already shielded from internet.So, all ips can be allowed access
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.production_master_authorized_networks_config_1_cidr_block
      display_name = local.production_master_authorized_networks_config_1_display_name
    }
  }

  #  Configuration for the Google Groups for GKE feature. Structure is documented below.
  #  https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite
  authenticator_groups_config {
    security_group = var.production_gke_security_group_name
  }
}


resource "google_container_node_pool" "production_node_pool" {
  provider           = google-beta
  name               = "${local.production_cluster_name}-node-pool"
  location           = var.region
  initial_node_count = local.production_node_pool_initial_node_count
  cluster            = google_container_cluster.production.name
  project            = google_project.production.project_id

  autoscaling {

    min_node_count = local.production_node_pool_autoscaling_min_node_count
    max_node_count = local.production_node_pool_autoscaling_max_node_count

  }

  management {

    auto_repair  = local.production_node_pool_auto_repair
    auto_upgrade = local.production_node_pool_auto_upgrade

  }

  upgrade_settings {

    max_surge       = local.production_node_pool_max_surge
    max_unavailable = local.production_node_pool_max_unavailable

  }

  node_config {

    #  https://cloud.google.com/compute/docs/machine-types#recommendations_for_machine_types
    machine_type = local.production_node_pool_machine_type

    image_type = "COS_CONTAINERD"

    #  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#oauth_scopes
    oauth_scopes = local.production_node_pool_oauth_scopes

    shielded_instance_config {
      enable_secure_boot = true
    }


    # With Workload Identity, you can configure a Kubernetes service account to act as a Google service account.
    # 
    # Pods running as the Kubernetes service account will automatically authenticate as the Google service account
    # when accessing Google Cloud APIs.
    # 
    # This enables you to assign distinct, fine-grained identities and authorization for each application in your cluster.
    # 
    # Service account is refered in the clusters workload_identity_config
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

  }

}

######## Test

# Create a GKE clusteer for test
resource "google_container_cluster" "test" {
  provider                 = google-beta
  name                     = local.test_cluster_name
  location                 = var.region
  project                  = google_project.test.project_id
  network                  = google_compute_network.main-vpc.self_link
  subnetwork               = google_compute_subnetwork.test.self_link
  remove_default_node_pool = true
  initial_node_count       = local.test_node_pool_initial_node_count
  enable_shielded_nodes    = true

  # GKE release channels:
  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  release_channel {
    channel = local.test_cluster_release_channel
  }

  # allows Kubernetes service accounts to act as a user-managed Google IAM Service Account.      
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#workload_identity_config
  workload_identity_config {
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#identity_namespace
    identity_namespace = "${google_project.test.project_id}.svc.id.goog"
  }


  # Define sources for ip-addresses for pods & services 
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#ip_allocation_policy
  ip_allocation_policy {
    cluster_secondary_range_name  = local.test_pod_ip_range_name
    services_secondary_range_name = local.test_services_ip_range_name
  }

  # GKE private cluster
  # In a private cluster, nodes only have internal IP addresses, 
  # which means that nodes and Pods are isolated from the internet by default.
  # https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false

    # specifies an internal IP address range for the control plan.
    # This setting is permanent for this cluster.
    master_ipv4_cidr_block = local.test_master_ipv4_cidr_block
  }

  # https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
  # specifies that access to the public endpoint is restricted to IP address ranges that you authorize.  
  #   
  # nodes and containers are already shielded from internet.So, all ips can be allowed access
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.test_master_authorized_networks_config_1_cidr_block
      display_name = local.test_master_authorized_networks_config_1_display_name
    }
  }

  #  Configuration for the Google Groups for GKE feature. Structure is documented below.
  #  https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite
  authenticator_groups_config {
    security_group = var.test_gke_security_group_name
  }
}


resource "google_container_node_pool" "test_node_pool" {
  provider           = google-beta
  name               = "${local.test_cluster_name}-node-pool"
  location           = var.region
  initial_node_count = local.test_node_pool_initial_node_count
  cluster            = google_container_cluster.test.name
  project            = google_project.test.project_id

  autoscaling {

    min_node_count = local.test_node_pool_autoscaling_min_node_count
    max_node_count = local.test_node_pool_autoscaling_max_node_count

  }

  management {

    auto_repair  = local.test_node_pool_auto_repair
    auto_upgrade = local.test_node_pool_auto_upgrade

  }

  upgrade_settings {

    max_surge       = local.test_node_pool_max_surge
    max_unavailable = local.test_node_pool_max_unavailable

  }

  node_config {

    #  https://cloud.google.com/compute/docs/machine-types#recommendations_for_machine_types
    machine_type = local.test_node_pool_machine_type

    image_type = "COS_CONTAINERD"

    #  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#oauth_scopes
    oauth_scopes = local.test_node_pool_oauth_scopes

    shielded_instance_config {
      enable_secure_boot = true
    }


    # With Workload Identity, you can configure a Kubernetes service account to act as a Google service account.
    # 
    # Pods running as the Kubernetes service account will automatically authenticate as the Google service account
    # when accessing Google Cloud APIs.
    # 
    # This enables you to assign distinct, fine-grained identities and authorization for each application in your cluster.
    # 
    # Service account is refered in the clusters workload_identity_config
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

  }

}


