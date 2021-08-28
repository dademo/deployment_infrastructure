variable "namespace" {
    type = string
    default = "nexus"
    description = "The Kubernetes namespace where to deploy"
    sensitive = false
    validation {
        condition = length(var.namespace) > 0
        error_message = "The namespace value must not be null or empty."
    }
}

variable "service" {
    type = object({
        persistence_size = string
        persistence_storage_class = string
        ingress_enabled = bool
        ingress_host = string
    })
    default = {
        persistence_size = "5Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "nexus.k8s.local"
    }
    description = "The Nexus service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            length(var.service.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
            (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
        ])
        error_message = "Invalid Nexus service configuration."
    }
}
