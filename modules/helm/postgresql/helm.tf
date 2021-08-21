// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "postgresql" {

    name = var.service_name
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
    version = local.helm_postgresql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/postgresql.tpl.yaml", local.helm_postgresql_tpl_values)}"
    ]
}

locals {
    helm_postgresql_tpl_values = {
        image_tag = var.image_tag
        database = var.database.database
        username = var.database.username
        password = var.database_password
        persistence_size = var.database.persistence_size
        persistence_storage_class = var.database.persistence_storage_class
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
