resource "google_cloud_run_service" "this" {
  name                       = "${local.service_name}-cloud-run-test"
  location                   = var.gcp_region
  autogenerate_revision_name = true

  metadata {
    labels = local.tags
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
      "run.googleapis.com/ingress"     = "all"
    }
  }

  template {
    spec {
      containers {
        image = "europe-west4-docker.pkg.dev/toptal-381110/sample-web-app/${local.service_name}:latest"
        resources {
          limits = {
            cpu    = "1000m"
            memory = "256Mi"
          }
        }
        ports {
          container_port = 8080
        }
      }
      service_account_name = google_service_account.this.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["client.knative.dev/user-image"],
      metadata.0.annotations["run.googleapis.com/client-name"],
      metadata.0.annotations["run.googleapis.com/client-version"],
      template.0.metadata.0.annotations["client.knative.dev/user-image"],
      template.0.metadata.0.annotations["run.googleapis.com/client-name"],
      template.0.metadata.0.annotations["run.googleapis.com/client-version"],
    ]
  }
}

data "google_iam_policy" "this" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "this" {
  project  = google_cloud_run_service.this.project
  location = google_cloud_run_service.this.location
  service  = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.this.policy_data
}