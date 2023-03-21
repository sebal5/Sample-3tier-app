resource "google_sql_database" "this" {
  name     = "web-db"
  instance = google_sql_database_instance.this.name
}
resource "google_sql_database_instance" "this" {
  name             = "web-db"
  database_version = "POSTGRES_13"
  depends_on       = [google_service_networking_connection.this]
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 10 # 10 GB is the smallest disk size
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/toptal-381110/global/networks/default"
    }
  }
}
resource "google_sql_user" "this" {
  name     = "db_user"
  instance = google_sql_database_instance.this.name
  password = "postgres"
}