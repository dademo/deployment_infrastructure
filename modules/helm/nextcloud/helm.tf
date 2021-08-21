// https://github.com/nextcloud/helm/tree/master/charts/nextcloud
resource "helm_release" "nextcloud" {

    depends_on = [
        module.database_deployment
    ]
    
    name = "nextcloud"
    repository = "https://nextcloud.github.io/helm"
    chart = "nextcloud"
    version = local.helm_nextcloud_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/nextcloud.tpl.yaml", local.helm_nextcloud_nextcloud_tpl_values)}"
    ]
}

locals {
  helm_nextcloud_nextcloud_tpl_values = {
    namespace = var.namespace
    admin_username = var.service.admin_username
    admin_password = var.service_admin_password
    mail_enabled = var.service.mail.enabled
    mail_from = var.service.mail.from
    mail_domain = var.service.mail.domain
    smtp_host = var.service.smtp.host
    smtp_secured = var.service.smtp.secured
    smtp_port = var.service.smtp.port
    smtp_auth_type = var.service.smtp.auth_type
    smtp_username = var.service.smtp.username
    smtp_password = var.smtp_password
    persistence_size = var.service.persistence_size
    persistence_storage_class = var.service.persistence_storage_class
    ingress_enabled = tostring(var.service.ingress_enabled)
    ingress_host = var.service.ingress_host
    database_host = var.deploy_postgresql ? "${local.postgresql_service_name}.${var.namespace}.svc.cluster.local" : var.database_host
    database_name = var.database.database
    database_username = var.database.username
    database_password =  var.database_password
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
