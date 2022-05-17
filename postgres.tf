

resource "google_compute_global_address" "postgres_private_ip_address" {
  provider      = "google-beta"
  name          = local.postgres_private_ip_address_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main-vpc.self_link
  project       = google_project.network.project_id
}

resource "google_service_networking_connection" "postgres_private_vpc_connection" {
  provider                = "google-beta"
  network                 = google_compute_network.main-vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.postgres_private_ip_address.name]
}

resource "google_sql_database_instance" "postgres_instance" {
  provider         = "google"
  database_version = "POSTGRES_13"
  project          = google_project.production.project_id
  depends_on       = [google_service_networking_connection.postgres_private_vpc_connection]
  name             = var.postgres_instance_name
  region           = var.region

  lifecycle {
    prevent_destroy = true
  }

  settings {
    tier = var.postgres_instance_tier

    ip_configuration {
      # Instance is not publicly accessible:
      ipv4_enabled    = false
      private_network = google_compute_network.main-vpc.id
    }

  }

}

resource "google_sql_database" "heimdall_postgres_db" {
  name     = var.heimdall_db_name
  project  = google_project.production.project_id
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "postgres_heimdall_user" {
  instance = google_sql_database_instance.postgres_instance.name
  project  = google_project.production.project_id
  name     = var.postgres_username
  password = var.postgres_password
}

output "postgres_host" {
  value = google_sql_database_instance.postgres_instance.first_ip_address
}
