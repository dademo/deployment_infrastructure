// https://github.com/bitnami/bitnami-docker-keycloak

resource "helm_release" "keycloak" {
    
    count = var.keycloak.enabled ? 1 : 0
    
    name       = "keycloak"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "keycloak"
    version    = local.helm_keycloak_version

    timeout = 600
    cleanup_on_fail = true
    wait = false
    wait_for_jobs = false

    namespace  = kubernetes_namespace.keycloak[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/keycloak.tpl.yaml", local.helm_keycloak_tpl_values)}"
    ]
}

// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "keycloak_postgresql" {
    
    count = var.keycloak.enabled ? 1 : 0
    
    name       = "keycloak-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = local.helm_postgresql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.keycloak[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_keycloak_postgresql_tpl_values)}"
    ]
}

locals {
    helm_keycloak_tpl_values = {
        namespace = var.keycloak.namespace
        replica_count = var.keycloak.replica_count
        ingress_enabled = tostring(var.keycloak.ingress_enabled)
        ingress_host = var.keycloak.ingress_host
        database_svc_name = var.keycloak.enabled ? helm_release.keycloak_postgresql[0].name : ""
        database_name = var.keycloak.postgresql_database
        database_user = var.keycloak.postgresql_user
        database_password =  var.keycloak.postgresql_database
        prometheus_enabled = tostring(var.keycloak.prometheus_enabled)
    }
    helm_keycloak_postgresql_tpl_values = {
        database = var.keycloak.postgresql_database
        username = var.keycloak.postgresql_user
        password = var.keycloak.postgresql_password
        persistence_size = var.keycloak.postgresql_persistence_size
        persistence_storage_class = var.keycloak.postgresql_persistence_storage_class
        prometheus_enabled = tostring(var.gitea.postgresql_prometheus_enabled)
    }
}
