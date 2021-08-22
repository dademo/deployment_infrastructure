variable "module_keycloak" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
            replica_count = number
            admin_username = string
            management_username = string
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
    description = "Keycloak module configuration."
    default = {
        enabled = true
        namespace = "keycloak"
        service = {
            replica_count = 1
            admin_username = "admin"
            management_username = "management"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            ingress_enabled = true
            ingress_host = "keycloak.k8s.local"
        }
        deploy_postgresql = true
        database_host = ""
        database = {
            database = "keycloak"
            username = "keycloak"
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

variable "module_keycloak_admin_password" {
    type = string
    description = "The Keycloak admin password to use."
    sensitive = true
}

variable "module_keycloak_management_password" {
    type = string
    description = "The Keycloak management password to use."
    sensitive = true
}

variable "module_keycloak_database_password" {
    type = string
    description = "The Keycloak database password to use."
    sensitive = true
}