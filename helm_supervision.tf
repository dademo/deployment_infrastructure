// https://github.com/prometheus-community/helm-charts

resource "helm_release" "prometheus" {
    
    count = var.supervision.enabled ? 1 : 0
    
    name       = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart      = "prometheus"
    version    = local.helm_prometheus_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.supervision[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/prometheus.tpl.yaml", local.helm_prometheus_tpl_values)}"
    ]
}

// https://github.com/grafana/helm-charts

resource "helm_release" "grafana" {
    
    count = var.supervision.enabled ? 1 : 0
    
    name       = "grafana"
    repository = "https://grafana.github.io/helm-charts"
    chart      = "grafana"
    version    = local.helm_grafana_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.supervision[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/grafana.tpl.yaml", local.helm_grafana_tpl_values)}"
    ]
}


locals {
  helm_prometheus_tpl_values = {
        alert_manager_enabled = var.supervision.alert_manager_enabled
        alert_manager_external_url = var.supervision.alert_manager_external_url
        alert_manager_ingress_enabled = var.supervision.alert_manager_ingress_enabled
        alert_manager_persistence_storage_class = var.supervision.alert_manager_persistence_storage_class
        alert_manager_persistence_size = var.supervision.alert_manager_persistence_size
        alert_manager_replica_count = var.supervision.alert_manager_replica_count
        kube_state_metrics_enabled = var.supervision.kube_state_metrics_enabled
        node_exporter_enabled = var.supervision.node_exporter_enabled
        prometheus_enabled = var.supervision.prometheus_enabled
        prometheus_scrape_interval = var.supervision.prometheus_scrape_interval
        prometheus_scrape_timeout = var.supervision.prometheus_scrape_timeout
        prometheus_evaluation_interval = var.supervision.prometheus_evaluation_interval
        prometheus_persistence_storage_class = var.supervision.prometheus_persistence_storage_class
        prometheus_persistence_size = var.supervision.prometheus_persistence_size
        prometheus_replica_count = var.supervision.prometheus_replica_count
        push_gateway_enabled = var.supervision.push_gateway_enabled
        push_gateway_replica_count = var.supervision.push_gateway_replica_count
  }
  helm_grafana_tpl_values = {
      namespace = var.supervision.namespace
      replica_count = var.supervision.grafana_replication_count
      ingress_enabled = var.supervision.grafana_ingress_enabled
      ingress_hosts = var.supervision.granafa_ingress_hosts
      persistence_storage_class = var.supervision.granafa_persistence_storage_class
      persistence_size = var.supervision.granafa_persistence_size
      plugins = var.supervision.granafa_plugins
  }
}