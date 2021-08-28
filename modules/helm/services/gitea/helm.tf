// https://docs.gitea.io/en-us/install-on-kubernetes/

resource "helm_release" "gitea" {

  depends_on = [
    module.database_deployment
  ]

  name = "gitea"
  repository = "https://dl.gitea.io/charts/"
  chart = "gitea"
  version = local.helm_gitea_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/gitea.tpl.yaml", local.helm_gitea_tpl_values)
  ]
}

locals {
  helm_gitea_tpl_values = {
    namespace = var.namespace
    replica_count = var.service.replica_count
    persistence_size = var.service.persistence_size
    persistence_storage_class = var.service.persistence_storage_class
    ingress_enabled = tostring(var.service.ingress_enabled)
    ingress_hosts = var.service.ingress_hosts
    admin_mail = var.service.admin_mail
    disable_registration = var.service.disable_registration
    openid_registration_only = var.service.openid_registration_only
    database_host = var.deploy_postgresql ? "${local.postgresql_service_name}.${var.namespace}.svc.cluster.local" : var.database_host
    database_name = var.database.database
    database_username = var.database.username
    database_password = var.database_password
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
