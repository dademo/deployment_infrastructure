// https://docs.gitlab.com/charts/

// https://github.com/bitnami/charts/tree/master/bitnami/redis
resource "helm_release" "gitlab_redis" {
    
    count = var.gitlab.enabled ? 1 : 0

    name       = "gitlab-redis"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "redis"
    version    = "14.6.3"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.gitlab[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/redis.tpl.yaml", local.helm_gitlab_redis_tpl_values)}"
    ]
}


// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "gitlab_postgresql" {
    
    count = var.gitlab.enabled ? 1 : 0
    
    name       = "gitlab-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = "10.4.5"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.gitlab[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_gitlab_postgresql_tpl_values)}"
    ]
}

locals {
    helm_gitlab_redis_tpl_values = {
        replica_count = var.gitlab.redis_replica_count
        authentication_enabled = var.gitlab.redis_authentication_enabled
        password = var.gitlab.redis_password
        persistence_size = var.gitlab.redis_persistence_size
        persistence_storage_class = var.gitlab.redis_persistence_storage_class
        prometheus_enabled = var.gitlab.redis_prometheus_enabled
        volume_permissions_enabled = var.gitlab.redis_volume_permissions_enabled
        sysctl_enabled = var.gitlab.redis_sysctl_enabled
    }
    helm_gitlab_postgresql_tpl_values = {
        database = var.gitlab.postgresql_database
        username = var.gitlab.postgresql_user
        password = var.gitlab.postgresql_password
        persistence_size = var.gitlab.postgresql_persistence_size
        persistence_storage_class = var.gitlab.postgresql_persistence_storage_class
        prometheus_enabled = tostring(var.gitea.postgresql_prometheus_enabled)
    }
}