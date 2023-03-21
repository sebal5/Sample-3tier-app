locals {
  service_name = "api-app"
  network      = "default"

  tags = {
    owner       = "toptal"
    managed-by  = "terraform"
    application = local.service_name
  }
}