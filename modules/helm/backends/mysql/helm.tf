// https://github.com/bitnami/charts/tree/master/bitnami/mysql
resource "helm_release" "mysql" {

    depends_on = [
        kubernetes_secret.auth
    ]

    name = var.service_name
    repository = "https://charts.bitnami.com/bitnami"
    chart = "mysql"
    version = local.helm_mysql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/mysql.tpl.yaml", local.helm_mysql_tpl_values)}"
    ]
}

resource "kubernetes_secret" "auth" {

    metadata {
        name = "mysql-auth"
        namespace = var.namespace
    }

    data = {
        "mysql-root-password" = var.database_root_password
        "mysql-password" = var.database_password
        "mysql-replication-password" = var.database_replication_password
    }
    
    type = "Opaque"
}

locals {
    helm_mysql_tpl_values = {
        replica_count = var.database.replica_count
        database = var.database.database
        username = var.database.username
        password = var.database_password
        database_secret = kubernetes_secret.auth.metadata[0].name
        persistence_size = var.database.persistence_size
        persistence_storage_class = var.database.persistence_storage_class
        primary_service_type = var.database.primary_service.type
        primary_service_node_port = var.database.primary_service.node_port
        primary_service_cluster_ip = var.database.primary_service.cluster_ip
        primary_service_load_balancer_ip = var.database.primary_service.load_balancer_ip
        secondary_service_type = var.database.secondary_service.type
        secondary_service_node_port = var.database.secondary_service.node_port
        secondary_service_cluster_ip = var.database.secondary_service.cluster_ip
        secondary_service_load_balancer_ip = var.database.secondary_service.load_balancer_ip
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
