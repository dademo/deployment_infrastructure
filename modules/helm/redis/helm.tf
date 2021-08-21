// https://github.com/bitnami/charts/tree/master/bitnami/redis
resource "helm_release" "redis" {

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
        "${templatefile("${path.module}/templates/redis.tpl.yaml", local.helm_shared_redis_tpl_values)}"
    ]
}

locals {

    helm_shared_redis_tpl_values = {
        replica_count = var.service.replica_count
        authentication_enabled = var.service.authentication_enabled
        password = var.redis_password
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        volume_permissions_enabled = var.service.volume_permissions_enabled
        sysctl_enabled = var.service.sysctl_enabled
        prometheus_enabled = var.prometheus_enabled
    }
}
