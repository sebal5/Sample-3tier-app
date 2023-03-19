provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  credentials = file("terraform-sa.json")
}

