resource "helm_release" "gitea" {
    name       = "gitea"
    repository = "https://dl.gitea.io/charts/"
    chart      = "gitea"
    version    = "3.0.0"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = var.gitea.namespace

    values = [
        "${templatefile("helm_templates/gitea.tpl.yaml", local.helm_gitea_tpl_values)}"
    ]
}

resource "helm_release" "gitea_postgresql" {

    name       = "gitea-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = "10.4.5"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = var.gitea.namespace

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_gitea_postgresql_tpl_values)}"
    ]
}

locals {
    gitea_ingress_hosts = join(",", formatlist("\"%s\"", var.gitea.ingress_hosts))
    helm_gitea_tpl_values = {
        namespace = var.gitea.namespace
        persistence_size = var.gitea.persistence_size
        persistence_storage_class = var.gitea.persistence_storage_class
        ingress_enabled = var.gitea.ingress_enabled
        ingress_hosts = format("[%s]", local.gitea_ingress_hosts)
        admin_mail = var.gitea.admin_mail
        database_svc_name = helm_release.gitea_postgresql.name
        database_name = var.gitea.postgresql_database
        database_user = var.gitea.postgresql_user
        database_password =  var.gitea.postgresql_database
    }
    helm_gitea_postgresql_tpl_values = {
        username = var.gitea.postgresql_user
        password = var.gitea.postgresql_password
        database = var.gitea.postgresql_database
        persistence_size = var.gitea.postgresql_persistence_size
        persistence_storage_class = var.gitea.postgresql_persistence_storage_class
    }
}
