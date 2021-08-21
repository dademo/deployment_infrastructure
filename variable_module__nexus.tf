variable "module_nexus" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
            persistence_size = string
            persistence_storage_class = string
            ingress_enabled = bool
            ingress_host = string
        })
    })
    sensitive = false
    description = "Nexus module configuration."
    default = {
        enabled = true
        namespace = "nexus"
        service = {
            persistence_size = "5Gi"
            persistence_storage_class = "standard"
            ingress_enabled = true
            ingress_host = "nexus.k8s.local"
        }
    }
}
