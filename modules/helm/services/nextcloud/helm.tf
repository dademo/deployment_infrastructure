// https://github.com/nextcloud/helm/tree/master/charts/nextcloud
resource "helm_release" "nextcloud" {

  depends_on = [
    module.database_deployment,
    kubernetes_secret.auth,
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
    templatefile("${path.module}/templates/nextcloud.tpl.yaml", local.helm_nextcloud_nextcloud_tpl_values)
  ]
}

resource "kubernetes_secret" "auth" {

  metadata {
    name = "nextcloud-auth"
    namespace = var.namespace
  }

  data = {
    "${local.nextcloud_admin_secret_user_key}" = var.service.admin_username
    "${local.nextcloud_admin_secret_password_key}" = var.admin_password
    "${local.nextcloud_smtp_secret_user_key}" = ""
    "${local.nextcloud_smtp_secret_password_key}" = ""
  }

  type = "Opaque"
}

locals {
  helm_nextcloud_nextcloud_tpl_values = {
    namespace = var.namespace
    nextcloud_auth_secret_name = kubernetes_secret.auth.metadata[0].name
    nextcloud_auth_secret_user_key = local.nextcloud_admin_secret_user_key
    nextcloud_auth_secret_password_key = local.nextcloud_admin_secret_password_key
    nextcloud_smtp_secret_user_key = local.nextcloud_smtp_secret_user_key
    nextcloud_smtp_secret_password_key = local.nextcloud_smtp_secret_password_key
    mail_enabled = tostring(var.service.mail.enabled)
    mail_from = var.service.mail.from
    mail_domain = var.service.mail.domain
    smtp_host = var.service.smtp.host
    smtp_secured = tostring(var.service.smtp.secured)
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
    database_password = var.database_password
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
