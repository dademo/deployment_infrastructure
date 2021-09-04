// https://superset.apache.org/docs/installation/running-on-kubernetes

resource "helm_release" "superset" {

  depends_on = [
    module.database_deployment,
    module.redis_deployment,
  ]

  name = "superset"
  repository = "https://apache.github.io/superset/"
  chart = "superset"
  version = local.helm_superset_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/superset.tpl.yaml", local.helm_superset_tpl_values)
  ]
}

resource "kubernetes_secret" "auth" {

  metadata {
    name = "superset-auth"
    namespace = var.namespace
  }

  data = {
    "${local.superset_secret_database_key}" = var.database_password
    "${local.superset_secret_redis_key}" = local.generate_redis_password ? random_password.redis_password[0].result : var.redis_password
  }

  type = "Opaque"
}

resource "random_password" "redis_password" {

  count = local.generate_redis_password ? 1 : 0

  length = 512
  lower = true
  upper = true
  number = true
  special = false
}

locals {

  generate_redis_password = var.redis_authentication_enabled && var.redis_password == ""

  helm_superset_tpl_values = {
    namespace = var.namespace
    replica_count = var.service.replica_count
    ingress_enabled = tostring(var.service.ingress_enabled)
    ingress_hosts = var.service.ingress_hosts
    database_host = var.deploy_postgresql ? "${local.postgresql_service_name}.${var.namespace}.svc.cluster.local" : var.database_host
    database_name = var.database.database
    database_username = var.database.username
    database_name = var.database.database
    database_secret = kubernetes_secret.auth.metadata[0].name
    database_secret_key = local.superset_secret_database_key
    redis_host = var.deploy_redis ? "${local.redis_service_name}.${var.namespace}.svc.cluster.local" : var.redis_host
    redis_auth_enabled = tostring(var.redis_authentication_enabled)
    redis_secret = kubernetes_secret.auth.metadata[0].name
    redis_secret_key = local.superset_secret_redis_key
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
