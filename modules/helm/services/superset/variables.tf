variable "namespace" {
  type = string
  default = "superset"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "deploy_postgresql" {
  type = bool
  default = true
  description = "If we have to deploy a PostgreSQL service."
  sensitive = false
}

variable "deploy_redis" {
  type = bool
  default = true
  description = "If we have to deploy a Redis service."
  sensitive = false
}

variable "service" {
  type = object({
    replica_count = number
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  default = {
    replica_count = 1
    ingress_enabled = true
    ingress_hosts = [
      "superset.k8s.local"
    ]
  }
  description = "The Superset service configuration"
  sensitive = false
  validation {
    condition = alltrue([
      var.service.replica_count > 0,
      var.service.replica_count % 1 == 0,
      (!var.service.ingress_enabled) || alltrue([for host in var.service.ingress_hosts : (length(host) > 0)]),
    ])
    error_message = "Invalid Superset service configuration."
  }
}

variable "database_host" {
  type = string
  default = ""
  description = "The database host (only required if deploy_postgresql is false)"
  sensitive = false
}

variable "redis_host" {
  type = string
  default = ""
  description = "The redis host (only required if deploy_redis is false)"
  sensitive = false
}

variable "database" {
  type = object({
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
  default = {
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
  description = "The PostgreSQL database configuration."
  sensitive = false
}

variable "redis" {
  type = object({
    replica_count = number
    authentication_enabled = bool
    persistence_size = string
    persistence_storage_class = string
    volume_permissions_enabled = bool
    sysctl_enabled = bool
  })
  default = {
    replica_count = 0
    authentication_enabled = false
    persistence_size = "512Mi"
    persistence_storage_class = "standard"
    volume_permissions_enabled = false
    sysctl_enabled = false
  }
  description = "The Redis service configuration."
  sensitive = false
}

variable "database_password" {
  type = string
  description = "The database password to use."
  sensitive = true
}

variable "redis_authentication_enabled" {
  type = bool
  description = "If the redis authentication is enabled."
  sensitive = false
  default = false
}

variable "redis_password" {
  type = string
  description = "The Redis service password to use."
  sensitive = true
  default = ""
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
