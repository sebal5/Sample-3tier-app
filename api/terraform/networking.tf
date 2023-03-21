variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "cloudapis.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudbuild.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "redis.googleapis.com"
  ]
}


resource "google_project_service" "this" {
  for_each           = toset(var.gcp_service_list)
  project            = "toptal-381110"
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_global_address" "this" {
  name          = "google-managed-services-vpn-connector"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "default"
  project       = var.gcp_project
  depends_on    = [google_project_service.this]
}

resource "google_service_networking_connection" "this" {
  network                 = "default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.this.name]
}

resource "google_vpc_access_connector" "this" {
  provider      = google-beta
  project       = "toptal-381110"
  name          = "vpc-connector"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
  region        = var.gcp_region
  depends_on    = [google_compute_global_address.this, google_project_service.this]
}