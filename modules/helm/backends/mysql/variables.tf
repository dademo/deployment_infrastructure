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
    default = "MySQL"
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
    description = "The MySQL image tag to deploy"
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
        replica_count = number
        database = string
        username = string
        persistence_size = string
        persistence_storage_class = string
        primary_service = object({
            type = string
            node_port = string
            cluster_ip = string
            load_balancer_ip = string
        })
        secondary_service = object({
            type = string
            node_port = string
            cluster_ip = string
            load_balancer_ip = string
        })
    })
    default = {
        replica_count = 0
        database = "mysql"
        username = "mysql"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        primary_service = {
            type = "ClusterIP"
            node_port = ""
            cluster_ip = ""
            load_balancer_ip = ""
        }
        secondary_service = {
            type = "ClusterIP"
            node_port = ""
            cluster_ip = ""
            load_balancer_ip = ""
        }
    }
    description = "The MySQL database configuration."
    sensitive = false
    validation {
        condition = alltrue([
            var.database.replica_count >= 0,
            var.database.replica_count % 1 == 0,
            length(var.database.database) > 0,
            length(var.database.username) > 0,
            length(var.database.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.database.persistence_size)),
        ])
        error_message = "Invalid database configuration."
    }
}

variable "database_root_password" {
    type = string
    description = "The database root user password to use."
    sensitive = true
    validation {
        condition = length(var.database_root_password) > 0
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

variable "database_replication_password" {
    type = string
    description = "The database replication password to use."
    sensitive = true
    validation {
        condition = length(var.database_replication_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "prometheus_enabled" {
    type = bool
    default = true
    description = "Define if prometheus supervision must be enabled."
    sensitive = false
}
