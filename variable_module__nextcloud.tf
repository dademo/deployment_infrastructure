variable "module_nextcloud" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
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
        deploy_postgresql = bool
        database_host = string
        database = object({
            database = string
            username = string
            persistence_size = string
            persistence_storage_class = string
            service = object({
                service_type = string
                service_node_port = string
                service_cluster_ip = string
                service_load_balancer_ip = string
            })
        })
        prometheus_enabled = bool
    })
    sensitive = false
    description = "Nextcloud module configuration."
    default = {
        enabled = false
        namespace = "nextcloud"
        service = {
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
        deploy_postgresql = true
        database_host = ""
        database = {
            database = "nextcloud"
            username = "nextcloud"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            service = {
                service_type = "ClusterIP"
                service_node_port = ""
                service_cluster_ip = ""
                service_load_balancer_ip = ""
            }
        }
        prometheus_enabled = true
    }
}

variable "module_nextcloud_database_password" {
    type = string
    description = "The Nextcloud database password to use."
    sensitive = true
}

variable "module_nextcloud_smtp_password" {
    type = string
    description = "The Nextcloud SMTP service password to use."
    sensitive = true
}

variable "module_nextcloud_service_admin_password" {
    type = string
    description = "The Nextcloud service administrator password to use."
    sensitive = true
}