// https://github.com/nextcloud/helm/tree/master/charts/nextcloud
resource "helm_release" "nextcloud" {
    
    count = var.nextcloud.enabled ? 1 : 0
    
    name = "nextcloud"
    repository = "https://nextcloud.github.io/helm"
    chart = "nextcloud"
    version = local.helm_nextcloud_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.nextcloud[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/nextcloud.tpl.yaml", local.helm_nextcloud_nextcloud_tpl_values)}"
    ]
}

// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "nextcloud_postgresql" {
    
    count = var.nextcloud.enabled ? 1 : 0
    
    name = "nextcloud-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
    version = local.helm_postgresql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.nextcloud[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_nextcloud_postgresql_tpl_values)}"
    ]
}

locals {
  helm_nextcloud_nextcloud_tpl_values = {
    namespace = var.nextcloud.namespace
    admin_username = var.nextcloud.admin_username
    admin_password = var.nextcloud.admin_password
    mail_enabled = var.nextcloud.mail_enabled
    mail_from = var.nextcloud.mail_from
    mail_domain = var.nextcloud.mail_domain
    smtp_host = var.nextcloud.smtp_host
    smtp_secured = var.nextcloud.smtp_secured
    smtp_port = var.nextcloud.smtp_port
    smtp_auth_type = var.nextcloud.smtp_auth_type
    smtp_username = var.nextcloud.smtp_username
    smtp_password = var.nextcloud.smtp_password
    persistence_size = var.nextcloud.persistence_size
    persistence_storage_class = var.nextcloud.persistence_storage_class
    ingress_enabled = tostring(var.nextcloud.ingress_enabled)
    ingress_host = var.nextcloud.ingress_host
    database_svc_name = var.nextcloud.enabled ? helm_release.nextcloud_postgresql[0].name : ""
    database_name = var.nextcloud.postgresql_database
    database_user = var.nextcloud.postgresql_user
    database_password =  var.nextcloud.postgresql_database
    prometheus_enabled = tostring(var.nextcloud.prometheus_enabled)
  }
  helm_nextcloud_postgresql_tpl_values = {
        image_tag = var.nextcloud.postgresql_image_tag
        database = var.nextcloud.postgresql_database
        username = var.nextcloud.postgresql_user
        password = var.nextcloud.postgresql_password
        persistence_size = var.nextcloud.postgresql_persistence_size
        persistence_storage_class = var.nextcloud.postgresql_persistence_storage_class
        prometheus_enabled = tostring(var.gitea.postgresql_prometheus_enabled)
  }
}
