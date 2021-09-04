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
  default = "postgresql"
  description = "The service name to use."
  sensitive = false
  validation {
    condition = length(var.service_name) > 0
    error_message = "Service name must not be empty."
  }
}

variable "image_tag" {
  type = string
  default = "latest"
  description = "The PostgreSQL image tag to deploy"
  sensitive = false
  validation {
    condition = alltrue([
      length(var.image_tag) > 0,
      anytrue([
        var.image_tag == "latest",
        can(regex("^[0-9]+$", var.image_tag)),
        can(regex("^[0-9]+\\.[0-9]+$", var.image_tag)),
        can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.image_tag)),
      ])
    ])
    error_message = "The image tag value must not be null or empty."
  }
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
    database = "dev"
    username = "dev"
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
  validation {
    condition = alltrue([
      length(var.database.database) > 0,
      length(var.database.username) > 0,
      var.database.database != "postgres",
      var.database.username != "postgres",
      length(var.database.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.database.persistence_size)),
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"
      ], var.database.service.type),
      anytrue([
        alltrue([
          !(var.database.service.type == "NodePort"),
          length(var.database.service.node_port) == 0,
        ]),
        length(var.database.service.node_port) > 0
      ])
    ])
    error_message = "Invalid database configuration."
  }
}

variable "database_postgres_password" {
  type = string
  description = "The database postgres user password to use."
  sensitive = true
  validation {
    condition = length(var.database_postgres_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "database_password" {
  type = string
  description = "The database password to use."
  sensitive = true
  validation {
    condition = length(var.database_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
