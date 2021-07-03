// https://github.com/bitnami/bitnami-docker-keycloak

resource "helm_release" "keycloak" {
    name       = "keycloak"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "keycloak"
    version    = "3.1.1"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.keycloak.metadata[0].name

    values = [
        "${templatefile("helm_templates/keycloak.tpl.yaml", local.helm_keycloak_tpl_values)}"
    ]
}

resource "helm_release" "keycloak_postgresql" {

    name       = "keycloak-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = "10.4.5"

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.keycloak.metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_keycloak_postgresql_tpl_values)}"
    ]
}

locals {
    helm_keycloak_tpl_values = {
        namespace = var.keycloak.namespace
        replica_count = var.keycloak.replica_count
        ingress_enabled = var.keycloak.ingress_enabled
        ingress_host = var.keycloak.ingress_host
        database_svc_name = helm_release.keycloak_postgresql.name
        database_name = var.keycloak.postgresql_database
        database_user = var.keycloak.postgresql_user
        database_password =  var.keycloak.postgresql_database
        prometheus_enabled = var.keycloak.prometheus_enabled
    }
    helm_keycloak_postgresql_tpl_values = {
        database = var.keycloak.postgresql_database
        username = var.keycloak.postgresql_user
        password = var.keycloak.postgresql_password
        persistence_size = var.keycloak.postgresql_persistence_size
        persistence_storage_class = var.keycloak.postgresql_persistence_storage_class
    }
}
