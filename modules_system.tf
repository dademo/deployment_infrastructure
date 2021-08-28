module "supervision" {
  source = "./modules/helm/system/supervision"
  count = var.module_supervision.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["supervision"]
  ]

  // Variables
  namespace = var.module_supervision.namespace
  istio_enabled = var.module_supervision.istio_enabled
  grafana = var.module_supervision.grafana
  grafana_admin_password = var.module_supervision_grafana_admin_password
  prometheus = var.module_supervision.prometheus
}

module "istio" {
  source = "./modules/helm/system/istio"
  count = var.module_istio.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["istio"]
  ]

  // Variables
  namespace = var.module_istio.namespace
  enable_analysis = var.module_istio.enable_analysis
  system_ingress_enabled = var.module_istio.system_ingress_enabled
  system_egress_enabled = var.module_istio.system_egress_enabled
}
