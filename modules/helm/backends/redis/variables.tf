variable "namespace" {
  type = string
  default = "redis"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "service_name" {
  type = string
  default = "spark"
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
  description = "The Redis service configuration"
  sensitive = false
  validation {
    condition = alltrue([
      var.service.replica_count >= 0,
      var.service.replica_count % 1 == 0,
      length(var.service.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
    ])
    error_message = "Invalid Redis service configuration."
  }
}

variable "redis_password" {
  type = string
  description = "The Redis password to use."
  sensitive = true
  validation {
    condition = length(var.redis_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
