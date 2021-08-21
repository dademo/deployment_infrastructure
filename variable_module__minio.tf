variable "module_minio" {
    type = object({
        enabled = bool
        namespace = string
        operator = object({
            operator_replica_count = number
            console_replica_count = number
            ingress_enabled = bool
            ingress_host = string
        })
        tenant_creds_access_key = string
        prometheus_enabled = bool
    })
    sensitive = false
    description = "Istio module configuration."
    default = {
        enabled = true
        namespace = "minio"
        operator = {
            operator_replica_count = 3
            console_replica_count = 3
            ingress_enabled = true
            ingress_host = "minio.k8s.local"
        }
        tenant_creds_access_key = "minio"
        prometheus_enabled = true
    }
}

variable "module_minio_tenant_creds_secret_key" {
    type = string
    description = "Key in secret for tenants"
    sensitive = true
}