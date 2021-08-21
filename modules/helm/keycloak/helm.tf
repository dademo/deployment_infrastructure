// https://github.com/bitnami/charts/tree/master/bitnami/keycloak

resource "helm_release" "keycloak" {

    depends_on = [
        module.database_deployment
    ]
    
    name = "keycloak"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "keycloak"
    version = local.helm_keycloak_version

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/keycloak.tpl.yaml", local.helm_keycloak_tpl_values)}"
    ]
}

locals {
    helm_keycloak_tpl_values = {
        namespace = var.namespace
        replica_count = var.service.replica_count
        ingress_enabled = tostring(var.service.ingress_enabled)
        ingress_host = var.service.ingress_host
        database_host = var.deploy_postgresql ? "${local.postgresql_service_name}.${var.namespace}.svc.cluster.local" : var.database_host
        database_name = var.database.database
        database_username = var.database.username
        database_password =  var.database_password
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
