variable "module_gocd" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
            persistence_size = string
            persistence_storage_class = string
            agent = object({
                replica_count = number
                persistence_enabled = bool
                persistence_size = string
                persistence_storage_class = string
            })
            ingress_enabled = bool
            ingress_hosts = list(string)
        })
    })
    sensitive = false
    description = "GoCD module configuration."
    default = {
        enabled = true
        namespace = "gocd"
        service = {
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            agent = {
                replica_count = 0
                persistence_enabled = false
                persistence_size = "2Gi"
                persistence_storage_class = "standard"
            }
            ingress_enabled = true
            ingress_hosts = ["gocd.k8s.local"]
        }
    }
}
