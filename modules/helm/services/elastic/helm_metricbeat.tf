// https://github.com/elastic/helm-charts/tree/master/metricbeat
resource "helm_release" "metricbeat" {

  count = var.metricbeat.enabled ? 1 : 0

  depends_on = [
    helm_release.elasticsearch
  ]

  name = "${var.service_name}-metricbeat"
  repository = "https://helm.elastic.co"
  chart = "metricbeat"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/metricbeat.tpl.yaml", local.helm_metricbeat_tpl_values)
  ]
}

locals {
  helm_metricbeat_tpl_values = {
    replica_count = var.metricbeat.replica_count
    kube_state_metrics_host = var.metricbeat.kube_state_metrics_host
  }
}
