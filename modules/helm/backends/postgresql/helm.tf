// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "postgresql" {

    depends_on = [
        kubernetes_secret.auth
    ]

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

resource "kubernetes_secret" "auth" {

    metadata {
        name = "postgresql-auth"
        namespace = var.namespace
    }

    data = {
        "postgresql-postgres-password" = var.database_postgres_password
        "postgresql-password": var.database_password
    }
    
    type = "Opaque"
}

locals {
    helm_postgresql_tpl_values = {
        image_tag = var.image_tag
        database = var.database.database
        username = var.database.username
        database_secret = kubernetes_secret.auth.metadata[0].name
        persistence_size = var.database.persistence_size
        persistence_storage_class = var.database.persistence_storage_class
        service_type = var.database.service.service_type
        service_node_port = var.database.service.service_node_port
        service_cluster_ip = var.database.service.service_cluster_ip
        service_load_balancer_ip = var.database.service.service_load_balancer_ip
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
