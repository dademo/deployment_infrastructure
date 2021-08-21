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
    })
    default = {
        database = "postgres"
        username = "postgres"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
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
