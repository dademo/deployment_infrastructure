variable "namespace" {
  type = string
  default = "istio"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "enable_analysis" {
  type = bool
  default = false
  description = "Enable Istiod analysis."
  sensitive = false
}

variable "system_ingress_enabled" {
  type = bool
  default = false
  description = "Define if Istio system ingress is enabled."
  sensitive = false
}

variable "system_egress_enabled" {
  type = bool
  default = false
  description = "Define if Istio system egress is enabled."
  sensitive = false
}
