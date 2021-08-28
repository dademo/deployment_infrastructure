variable "namespace" {
    type = string
    default = "keycloak"
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
        admin_username = string
        management_username = string
        persistence_size = string
        persistence_storage_class = string
        ingress_enabled = bool
        ingress_host = string
    })
    default = {
        replica_count = 1
        admin_username = "admin"
        management_username = "management"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "keycloak.k8s.local"
    }
    description = "The Keycloak service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            var.service.replica_count > 0,
            var.service.replica_count % 1 == 0,
            length(var.service.admin_username) > 0,
            length(var.service.management_username) > 0,
            length(var.service.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
            (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
        ])
        error_message = "Invalid Keycloak service configuration."
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
        database = "keycloak"
        username = "keycloak"
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
            length(var.database.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.database.persistence_size)),
        ])
        error_message = "Invalid database configuration."
    }
}

variable "admin_password" {
    type = string
    description = "The Keycloak admin password to use."
    sensitive = true
    validation {
        condition = length(var.admin_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "management_password" {
    type = string
    description = "The Keycloak management password to use."
    sensitive = true
    validation {
        condition = length(var.management_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "database_password" {
    type = string
    description = "The Keycloak database password to use."
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
