// https://github.com/elastic/helm-charts/tree/master/apm-server
resource "helm_release" "apm" {

  count = var.apm.enabled ? 1 : 0

  depends_on = [
    helm_release.elasticsearch
  ]

  name = "${var.service_name}-apm"
  repository = "https://helm.elastic.co"
  chart = "elasticsearch"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/apm.tpl.yaml", local.helm_apm_tpl_values)
  ]
}

locals {
  helm_apm_tpl_values = {
    replica_count = var.apm.replica_count
    autoscaling_enabled = tostring(var.apm.autoscaling.enabled)
    autoscaling_min_replicas = var.apm.autoscaling.min_replicas
    autoscaling_max_replicas = var.apm.autoscaling.max_replicas
    autoscaling_avg_cpu_utilization = var.apm.autoscaling.avg_cpu_utilization
    service_type = var.apm.service.type
    service_node_port = var.apm.service.node_port
    service_load_balancer_ip = var.apm.service.load_balancer_ip
    ingress_enabled = tostring(var.apm.ingress_enabled)
    ingress_hosts = var.apm.ingress_hosts
  }
}
