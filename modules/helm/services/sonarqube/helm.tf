// https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube
resource "helm_release" "sonarqube" {

    depends_on = [
        module.database_deployment
    ]
    
    name = "sonarqube"
    chart = "${local.helm_sonarqube_charts_root}/sonarqube"
    dependency_update = true

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/sonarqube.tpl.yaml", local.helm_sonarqube_tpl_values)}"
    ]
}

locals {

    helm_sonarqube_charts_root = "${path.module}/dependencies/helm-chart-sonarqube/charts"
    helm_sonarqube_tpl_values = {
        namespace = var.namespace
        replica_count = var.service.replica_count
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        ingress_enabled = tostring(var.service.ingress_enabled)
        ingress_hosts = var.service.ingress_hosts
        database_host = var.deploy_postgresql ? "${local.postgresql_service_name}.${var.namespace}.svc.cluster.local" : var.database_host
        database_name = var.database.database
        database_username = var.database.username
        database_password =  var.database_password
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
