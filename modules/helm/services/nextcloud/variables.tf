variable "namespace" {
    type = string
    default = "nextcloud"
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
        admin_username = string
        mail = object({
            enabled = bool
            from = string
            domain = string
        })
        smtp = object({
            host = string
            secured = bool
            port = number
            auth_type = string
            username = string
        })
        persistence_size = string
        persistence_storage_class = string
        ingress_enabled = bool
        ingress_host = string
    })
    default = {
        admin_username = "admin"
        mail = {
            enabled = false
            from = "admin"
            domain = "k8s.local"
        }
        smtp = {
            host = "mail.k8s.local"
            secured = false
            port = 25
            auth_type = "LOGIN"
            username = "admin"
        }
        persistence_size = "20Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "nextcloud.k8s.local"
    }
    description = "The Nextcloud service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            length(var.service.admin_username) > 0,
            (!var.service.mail.enabled) || alltrue([
                length(var.service.mail.from) > 0,
                length(var.service.mail.domain) > 0,
                length(var.service.smtp.host) > 0,
                var.service.smtp.port > 0,
                length(var.service.smtp.auth_type) > 0,
                length(var.service.smtp.username) > 0,
            ]),
            length(var.service.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
            (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
        ])
        error_message = "Invalid Nextcloud service configuration."
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
        database = "nextcloud"
        username = "nextcloud"
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

variable "database_password" {
    type = string
    description = "The database password to use."
    sensitive = true
    validation {
        condition = length(var.database_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "smtp_password" {
    type = string
    description = "The SMTP service password to use."
    sensitive = true
    validation {
        condition = length(var.smtp_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "admin_password" {
    type = string
    description = "The Nextcloud service administrator password to use."
    sensitive = true
    validation {
        condition = length(var.admin_password) > 0
        error_message = "Password must not be empty."
    }
}

variable "prometheus_enabled" {
    type = bool
    default = true
    description = "Define if prometheus supervision must be enabled."
    sensitive = false
}
