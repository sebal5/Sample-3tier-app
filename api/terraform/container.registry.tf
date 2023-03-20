data "google_container_registry_image" "this" {
    name = "sample-web-app/${local.service_name}"
    project = var.gcp_project
    region = var.gcp_region
}