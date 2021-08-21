variable "k8s_config_context" {
    type = string
    description = "The kubernetes context to use"
    validation {
      condition = length(var.k8s_config_context) > 0
      error_message = "Kubernetes context can't be empty."
    }
}

variable "k8s_dashboard" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        ingress_host = string
    })
    description = "Kubernetes dashboard configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "kubernetes-dashboard"
        service_port_http = 80
        ingress_host = "dashboard.k8s.local"
    }
}

variable "k8s_kibana_logging" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        ingress_host = string
    })
    description = "Kubernetes Kibana logging configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "kibana-logging"
        service_port_http = 5601
        ingress_host = "kibana.k8s.local"
    }
}

variable "k8s_registry" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        service_port_https = number
        ingress_host = string
    })
    description = "Kubernetes registry configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "registry"
        service_port_http = 80
        service_port_https = 443
        ingress_host = "registry.k8s.local"
    }
}
