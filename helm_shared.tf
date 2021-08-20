// https://github.com/bitnami/charts/tree/master/bitnami/redis
resource "helm_release" "shared_redis" {
    
    count = (var.k8s_shared.redis_force_install
        || local.shared_enabled) ? 1 : 0

    name = "k8s-shared-redis"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "redis"
    version = local.helm_redis_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.shared.metadata[0].name

    values = [
        "${templatefile("helm_templates/redis.tpl.yaml", local.helm_shared_redis_tpl_values)}"
    ]
}

locals {

    helm_shared_redis_tpl_values = {
        replica_count = var.k8s_shared.redis_replica_count
        authentication_enabled = var.k8s_shared.redis_authentication_enabled
        password = var.k8s_shared.redis_password
        persistence_size = var.k8s_shared.redis_persistence_size
        persistence_storage_class = var.k8s_shared.redis_persistence_storage_class
        prometheus_enabled = var.k8s_shared.redis_prometheus_enabled
        volume_permissions_enabled = var.k8s_shared.redis_volume_permissions_enabled
        sysctl_enabled = var.k8s_shared.redis_sysctl_enabled
    }
}
