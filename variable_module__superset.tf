variable "module_superset" {
  type = object({
    enabled = bool
    namespace = string
    service = object({
      replica_count = number
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    deploy_postgresql = bool
    deploy_redis = bool
    database_host = string
    redis_host = string
    redis_authentication_enabled = bool
    database = object({
      database = string
      username = string
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
    })
    redis = object({
      replica_count = number
      authentication_enabled = bool
      persistence_size = string
      persistence_storage_class = string
      volume_permissions_enabled = bool
      sysctl_enabled = bool
    })
    prometheus_enabled = bool
  })
  sensitive = false
  description = "Superset module configuration."
  default = {
    enabled = false
    namespace = "superset"
    service = {
      replica_count = 1
      ingress_enabled = true
      ingress_hosts = [
        "superset.k8s.local"
      ]
    }
    deploy_postgresql = true
    deploy_redis = true
    database_host = ""
    redis_host = ""
    redis_authentication_enabled = true
    database = {
      database = "superset"
      username = "superset"
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
    }
    redis = {
      replica_count = 0
      authentication_enabled = false
      persistence_size = "512Mi"
      persistence_storage_class = "standard"
      volume_permissions_enabled = false
      sysctl_enabled = false
    }
    prometheus_enabled = true
  }
}

variable "module_superset_database_password" {
  type = string
  description = "The Superset database password to use."
  sensitive = true
}

variable "module_superset_redis_password" {
  type = string
  description = "The Superset redis password to use."
  sensitive = true
  default = ""
}