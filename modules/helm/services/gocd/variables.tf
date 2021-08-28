variable "namespace" {
    type = string
    default = "gocd"
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
        agent = object({
            replica_count = number
            persistence_enabled = bool
            persistence_storage_class = string
            persistence_size = string
        })
        ingress_enabled = bool
        ingress_hosts = list(string)
    })
    default = {
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        agent = {
            replica_count = 0
            persistence_enabled = false
            persistence_storage_class = "standard"
            persistence_size = "1Gi"
        }
        ingress_enabled = true
        ingress_hosts = ["gocd.k8s.local"]
    }
    description = "The GoCD service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            length(var.service.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
            var.service.agent.replica_count >= 0,
            var.service.agent.replica_count % 1 == 0,
            length(var.service.agent.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.agent.persistence_size)),
            (!var.service.ingress_enabled) || alltrue([for host in var.service.ingress_hosts : length(host) > 0]),
        ])
        error_message = "Invalid GoCD service configuration."
    }
}
