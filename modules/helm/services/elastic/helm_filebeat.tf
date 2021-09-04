// https://github.com/elastic/helm-charts/tree/master/filebeat
resource "helm_release" "filebeat" {

  count = var.filebeat.enabled ? 1 : 0

  depends_on = [
    helm_release.elasticsearch
  ]

  name = "${var.service_name}-filebeat"
  repository = "https://helm.elastic.co"
  chart = "filebeat"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/filebeat.tpl.yaml", local.helm_filebeat_tpl_values)
  ]
}

locals {
  helm_filebeat_tpl_values = {
    replica_count = var.filebeat.replica_count
    autoscaling_enabled = tostring(var.filebeat.autoscaling.enabled)
    autoscaling_min_replicas = var.filebeat.autoscaling.min_replicas
    autoscaling_max_replicas = var.filebeat.autoscaling.max_replicas
    autoscaling_avg_cpu_utilization = var.filebeat.autoscaling.avg_cpu_utilization
  }
}
