resource "google_service_account" "this" {
  project = var.gcp_project

  account_id   = "sa-${local.service_name}-test"
  display_name = "sa-${local.service_name}-test"
  description  = "Service account for '${local.service_name}' service."
}
resource "google_project_iam_member" "this" {
  for_each = toset(
    [
      "roles/iam.serviceAccountUser",
    ]
  )
  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.this.email}"
}