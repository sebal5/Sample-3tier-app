locals {
    service_name = "web-app"

    tags = {
        owner = "toptal"
        managed-by = "terraform"
        application = local.service_name
    }
}