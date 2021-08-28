// https://github.com/bitnami/charts/tree/master/bitnami/redis
resource "helm_release" "redis" {

  depends_on = [
    kubernetes_secret.auth
  ]

  name = var.service_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "redis"
  version = local.helm_redis_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/redis.tpl.yaml", local.helm_shared_redis_tpl_values)
  ]
}

resource "kubernetes_secret" "auth" {

  count = var.service.authentication_enabled ? 1 : 0

  metadata {
    name = "redis-auth"
    namespace = var.namespace
  }

  data = {
    "${local.secret_password_key}" = var.redis_password
  }

  type = "Opaque"
}

locals {

  helm_shared_redis_tpl_values = {
    replica_count = var.service.replica_count
    authentication_enabled = var.service.authentication_enabled
    mysql_auth_secret = var.service.authentication_enabled ? kubernetes_secret.auth[0].metadata[0].name : ""
    mysql_auth_secret_password_key = var.service.authentication_enabled ? local.secret_password_key : ""
    persistence_size = var.service.persistence_size
    persistence_storage_class = var.service.persistence_storage_class
    volume_permissions_enabled = var.service.volume_permissions_enabled
    sysctl_enabled = var.service.sysctl_enabled
    prometheus_enabled = var.prometheus_enabled
  }
}
