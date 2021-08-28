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
  default = "rabbitmq"
  description = "The service name to use."
  sensitive = false
  validation {
    condition = length(var.service_name) > 0
    error_message = "Service name must not be empty."
  }
}

variable "service" {
  type = object({
    replica_count = number
    username = string
    plugins = list(string)
    community_plugins = list(string)
    extra_plugins = list(string)
    clustering = object({
      enabled = bool
      rebalance = bool
    })
    persistence_size = string
    persistence_storage_class = string
    service = object({
      type = string
      node_port = string
      cluster_ip = string
      load_balancer_ip = string
      manager_enabled = bool
      manager_node_port = string
    })
    ingress_enabled = bool
    ingress_host = string
  })
  default = {
    replica_count = 1
    username = "dev"
    plugins = [
      "rabbitmq_management",
      "rabbitmq_peer_discovery_k8s",
    ]
    community_plugins = []
    extra_plugins = []
    clustering = {
      enabled = true
      rebalance = false
    }
    persistence_size = "2Gi"
    persistence_storage_class = "standard"
    service = {
      type = "ClusterIP"
      node_port = ""
      cluster_ip = ""
      load_balancer_ip = ""
      manager_enabled = true
      manager_node_port = ""
    }
    ingress_enabled = true
    ingress_host = "rabbitmq.k8s.local"
  }
  description = "The RabbitMQ service configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.service.replica_count >= 0,
      var.service.replica_count % 1 == 0,
      length(var.service.username) > 0,
      alltrue([for plugin in concat(var.service.plugins, var.service.community_plugins, var.service.extra_plugins) : can(regex("^[a-zA-Z0-9_-]+$", plugin))]),
      length(var.service.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"], var.service.service.type),
      anytrue([
        alltrue([
          !(var.service.service.type == "NodePort"),
          length(var.service.service.node_port) == 0,
          length(var.service.service.manager_node_port) == 0,
        ]),
        alltrue([
          length(var.service.service.node_port) > 0,
          length(var.service.service.manager_node_port) > 0,
        ]),
      ]),
      anytrue([
        !var.service.ingress_enabled,
        length(var.service.ingress_host) > 0,
      ])
    ])
    error_message = "Invalid service configuration."
  }
}

variable "rabbitmq_password" {
  type = string
  description = "The rabbitmq password to use."
  sensitive = true
  validation {
    condition = length(var.rabbitmq_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
