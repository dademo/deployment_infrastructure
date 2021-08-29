variable "namespace" {
  type = string
  default = "supervision"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "service_name" {
  type = string
  default = "mongodb"
  description = "The service name to use."
  sensitive = false
  validation {
    condition = length(var.service_name) > 0
    error_message = "Service name must not be empty."
  }
}

variable "database" {
  type = object({
    replica_count = number
    username = string
    database = string
    cluster_domain = string
    disable_javascript = bool
    arbiter_enabled = bool
    hidden_enabled = bool
    hidden_replica_count = number
    persistence_size = string
    persistence_storage_class = string
    service = object({
      type = string
      node_port = string
      cluster_ip = string
      load_balancer_ip = string
    })
    external_service = object({
      enabled = bool
      auto_discovery_enabled = bool
      type = string
      node_port = string
      load_balancer_ip = string
      domain = string
    })
  })
  default = {
    replica_count = 1
    username = "mongodb"
    database = "dev"
    cluster_domain = "cluster.local"
    disable_javascript = false
    arbiter_enabled = true
    hidden_enabled = false
    hidden_replica_count = 1
    persistence_size = "8Gi"
    persistence_storage_class = "standard"
    service = {
      type = "ClusterIP"
      node_port = ""
      cluster_ip = ""
      load_balancer_ip = ""
    }
    external_service = {
      enabled = false
      auto_discovery_enabled = false
      type = "LoadBalancer"
      node_port = ""
      load_balancer_ip = ""
      domain = ""
    }
  }
  description = "The MongoDB database configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.database.replica_count > 0,
      var.database.replica_count % 1 == 0,
      var.database.hidden_replica_count > 0,
      var.database.hidden_replica_count % 1 == 0,
      length(var.database.username) > 0,
      length(var.database.database) > 0,
      length(var.database.cluster_domain) > 0,
      length(var.database.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.database.persistence_size)),
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"], var.database.service.type),
      anytrue([
        alltrue([
          !(var.database.service.type == "NodePort"),
          length(var.database.service.node_port) == 0,
        ]),
        length(var.database.service.node_port) > 0,
      ]),
      anytrue([
        !var.database.external_service.enabled,
        alltrue([
          !(var.database.external_service.type == "NodePort"),
          length(var.database.external_service.node_port) == 0,
        ]),
        alltrue([
          length(var.database.external_service.node_port) > 0,
          length(var.database.external_service.domain) == 0,
        ])
      ]),
    ])
    error_message = "Invalid database configuration."
  }
}

variable "mongodb_password" {
  type = string
  description = "The MongoDB user password to use."
  sensitive = true
  validation {
    condition = length(var.mongodb_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "mongodb_root_password" {
  type = string
  description = "The MongoDB root password to use."
  sensitive = true
  validation {
    condition = length(var.mongodb_root_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "mongodb_replicaset_password" {
  type = string
  description = "The MongoDB replica set password to use."
  sensitive = true
  validation {
    condition = can(regex("^[a-zA-Z0-9_-]{5,}$", var.mongodb_replicaset_password))
    error_message = "Password is not valid."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
