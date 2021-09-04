variable "namespace" {
  type = string
  default = "gitea"
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

variable "service" {
  type = object({
    replica_count = number
    persistence_size = string
    persistence_storage_class = string
    ingress_enabled = bool
    ingress_hosts = list(string)
    admin_mail = string
    disable_registration = bool
    openid_registration_only = bool
  })
  default = {
    replica_count = 1
    persistence_size = "2Gi"
    persistence_storage_class = "standard"
    ingress_enabled = true
    ingress_hosts = [
      "gitea.k8s.local"
    ]
    admin_mail = "admin@gitea.k8s.local"
    disable_registration = false
    openid_registration_only = false
  }
  description = "The Gitea service configuration"
  sensitive = false
  validation {
    condition = alltrue([
      var.service.replica_count > 0,
      var.service.replica_count % 1 == 0,
      length(var.service.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
      (!var.service.ingress_enabled) || alltrue([for host in var.service.ingress_hosts : (length(host) > 0)]),
      can(regex("^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-z]+$", var.service.admin_mail)),
    ])
    error_message = "Invalid Gitea service configuration."
  }
}

variable "database_host" {
  type = string
  default = ""
  description = "The database host (only required if deploy_postgresql is false)"
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
    database = "gitea"
    username = "gitea"
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

variable "database_password" {
  type = string
  description = "The database password to use."
  sensitive = true
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
