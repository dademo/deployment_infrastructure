variable "namespace" {
    type = string
    default = "spark"
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
        controller = object({
            daemon_memory_limit = string
            config_options = list(string)
            extra_env_vars = list(string)
            resources_limits = map(any)
            resources_requests = map(any)
        })
        worker = object({
            java_options = list(string)
            config_options = list(string)
            daemon_memory_limit = string
            memory_limit = string
            core_limit = string
            resources_limits = map(any)
            resources_requests = map(any)
        })
        ingress_enabled = bool
        ingress_host = string
    })
    default = {
        replica_count = 3
        controller = {
            daemon_memory_limit = "1g"
            config_options = []
            extra_env_vars = []
            resources_limits = {
                memory = "1Gi"
            }
            resources_requests = {}
        }
        worker = {
            java_options = []
            config_options = []
            daemon_memory_limit = ""
            memory_limit = "2g"
            core_limit = ""
            resources_limits = {
                memory = "2Gi"
            }
            resources_requests = {}
        }
        ingress_enabled = true
        ingress_host = "spark.k8s.local"
    }
    description = "The Spark service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            var.service.replica_count > 0,
            var.service.replica_count % 1 == 0,
            alltrue([for env_var in var.service.controller.extra_env_vars : can(regex("^[^=]+=[^=]+$"))]),
            (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
        ])
        error_message = "Invalid Spark service configuration."
    }
}

variable "prometheus_enabled" {
    type = bool
    default = true
    description = "Define if prometheus supervision must be enabled."
    sensitive = false
}
