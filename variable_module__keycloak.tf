variable "module_keycloak" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
            replica_count = number
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
        }
        prometheus_enabled = true
    }
}

variable "module_keycloak_database_password" {
    type = string
    description = "The keycloak database password to use."
    sensitive = true
}