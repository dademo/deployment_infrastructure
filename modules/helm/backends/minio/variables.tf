variable "namespace" {
  type = string
  default = "MinIO"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "operator" {
  type = object({
    operator_replica_count = number
    console_replica_count = number
    ingress_enabled = bool
    ingress_host = string
  })
  default = {
    operator_replica_count = 3
    console_replica_count = 3
    ingress_enabled = true
    ingress_host = "minio.k8s.local"
  }
  description = "The MinIO operator configuration"
  sensitive = false
  validation {
    condition = alltrue([
      var.operator.operator_replica_count > 0,
      var.operator.console_replica_count % 1 == 0,
      (!var.operator.ingress_enabled) || length(var.operator.ingress_host) > 0,
    ])
    error_message = "Invalid MinIO operator configuration."
  }
}

variable "tenant_creds_access_key" {
  type = string
  default = "minio"
  description = "Key in secret for tenants"
  sensitive = false
  validation {
    condition = length(var.tenant_creds_access_key) > 0
    error_message = "Secret access key for tenants must be defined and non-empty."
  }
}

variable "tenant_creds_secret_key" {
  type = string
  description = "Key in secret for tenants"
  sensitive = true
  validation {
    condition = length(var.tenant_creds_secret_key) > 0
    error_message = "Secret key for tenants must be defined and non-empty."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
