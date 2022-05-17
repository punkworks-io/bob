/*
    This file contains resources needed to create GCP router & nat
    to expose our nodes to internet via loadbalancers.


    # Router
    Cloud Router enables you to dynamically exchange routes between your 
    Virtual Private Cloud (VPC) and on-premises networks by using 
    Border Gateway Protocol (BGP). 
    More info: https://cloud.google.com/network-connectivity/docs/router

    
    !! A Cloud Router also serves as the control plane for Cloud NAT.
    More on this: https://cloud.google.com/network-connectivity/docs/router/concepts/overview

    Instead of a physical device or appliance, each Cloud Router is
    implemented by software tasks that act as BGP speakers and responders

    # Nat
    Cloud NAT (network address translation) lets certain resources without external IP addresses create outbound connections to the internet.
    https://cloud.google.com/nat/docs/overview

    None of the containers / pods have any IP addresses.
    So, we use NAT to assign IPs on the fly to outbound requests

*/



# GCP router connected to main-vpc
resource "google_compute_router" "router" {
  name    = "main-router"
  project = google_project.network.project_id
  region  = var.region
  network = google_compute_network.main-vpc.self_link
}


# Outbound NAT for private clusters
resource "google_compute_router_nat" "nat" {
  name                               = "main-nat"
  project                            = google_project.network.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.production.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.test.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }
}

