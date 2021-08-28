variable "module_istio" {
  type = object({
    enabled = bool
    namespace = string
    enable_analysis = bool
    system_ingress_enabled = bool
    system_egress_enabled = bool
  })
  sensitive = false
  description = "Istio module configuration."
  default = {
    enabled = true
    namespace = "istio"
    enable_analysis = false
    system_ingress_enabled = false
    system_egress_enabled = false
  }
}