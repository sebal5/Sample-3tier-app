resource "google_secret_manager_secret" "this" {
  project = var.gcp_project
  replication {
    automatic = true
  }
  secret_id = "dbhost"
}

resource "google_secret_manager_secret_version" "this" {
  enabled     = true
  secret      = "projects/toptal-381110/secrets/dbhost"
  secret_data = google_sql_database_instance.this.private_ip_address
}