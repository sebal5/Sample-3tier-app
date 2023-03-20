locals {
    service_name = "api-app"

    tags = {
        owner = "toptal"
        managed-by = "terraform"
        application = local.service_name
    }
}