/*
    This file contains iam policy for k8s service agent

*/

# Grant the Host Service Agent User role to the GKE service accounts on the host project
resource "google_project_iam_binding" "host-service-agent-for-gke-service-accounts" {
  project = google_project.network.project_id
  role    = "roles/container.hostServiceAgentUser"
  members = [
    "serviceAccount:service-${google_project.production.number}@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:service-${google_project.test.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

# Create a role firewall admin
resource "google_project_iam_custom_role" "firewall_admin" {
  depends_on = [google_project.network]
  project    = google_project.network.project_id
  role_id    = "firewall_admin"
  title      = "Firewall Admin"

  permissions = [
    "compute.firewalls.create",
    "compute.firewalls.get",
    "compute.firewalls.delete",
    "compute.firewalls.list",
    "compute.firewalls.update",
    "compute.networks.updatePolicy",
    "servicenetworking.services.addPeering"
  ]
}

# Add the production Kubernetes Engine Service Agent to the above custom role
resource "google_project_iam_member" "add_firewall_admin_to_production_gke_service_account" {
  project = google_project.network.project_id
  role    = "projects/${google_project.network.project_id}/roles/firewall_admin"
  member  = "serviceAccount:service-${google_project.production.number}@container-engine-robot.iam.gserviceaccount.com"
}

# Add the test Kubernetes Engine Service Agent to the above custom role
resource "google_project_iam_member" "add_firewall_admin_to_test_gke_service_account" {
  project = google_project.network.project_id
  role    = "projects/${google_project.network.project_id}/roles/firewall_admin"
  member  = "serviceAccount:service-${google_project.test.number}@container-engine-robot.iam.gserviceaccount.com"
}
