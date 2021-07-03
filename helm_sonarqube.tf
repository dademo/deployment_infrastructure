// https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube

resource "helm_release" "sonarqube" {
    name       = "sonarqube"
    chart      = "./dependencies/helm-chart-sonarqube/charts/sonarqube"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.sonarqube.metadata[0].name

    values = [
        "${templatefile("helm_templates/sonarqube.tpl.yaml", local.helm_sonarqube_tpl_values)}"
    ]
}

resource "helm_release" "sonarqube_postgresql" {

    name       = "sonarqube-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = "10.4.5"

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.sonarqube.metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_sonarqube_postgresql_tpl_values)}"
    ]
}

locals {
    helm_sonarqube_tpl_values = {
        namespace = var.sonarqube.namespace
        replicaCount = var.sonarqube.replicaCount
        persistence_size = var.sonarqube.persistence_size
        persistence_storage_class = var.sonarqube.persistence_storage_class
        ingress_enabled = var.sonarqube.ingress_enabled
        ingress_hosts = var.sonarqube.ingress_hosts
        database_svc_name = helm_release.sonarqube_postgresql.name
        database_name = var.sonarqube.postgresql_database
        database_user = var.sonarqube.postgresql_user
        database_password =  var.sonarqube.postgresql_database
        prometheus_enabled = var.sonarqube.prometheus_enabled
    }
    helm_sonarqube_postgresql_tpl_values = {
        database = var.sonarqube.postgresql_database
        username = var.sonarqube.postgresql_user
        password = var.sonarqube.postgresql_password
        persistence_size = var.sonarqube.postgresql_persistence_size
        persistence_storage_class = var.sonarqube.postgresql_persistence_storage_class
    }
}
