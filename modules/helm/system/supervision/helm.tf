// https://github.com/prometheus-community/helm-charts

resource "helm_release" "prometheus" {

  count = var.prometheus.enabled ? 1 : 0

  name = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus"
  version = local.helm_prometheus_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/prometheus.tpl.yaml", local.helm_prometheus_tpl_values)
  ]
}

// https://github.com/grafana/helm-charts

resource "helm_release" "grafana" {

  count = var.grafana.enabled ? 1 : 0

  depends_on = [
    kubernetes_secret.grafana_auth
  ]

  name = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
  version = local.helm_grafana_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/grafana.tpl.yaml", local.helm_grafana_tpl_values)
  ]
}

resource "kubernetes_secret" "grafana_auth" {

  count = var.grafana.enabled ? 1 : 0

  metadata {
    name = "grafana-auth"
    namespace = var.namespace
  }

  data = {
    "${local.grafana_admin_secret_user_key}" = var.grafana.admin_username
    "${local.grafana_admin_secret_password_key}" = var.grafana_admin_password
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "grafana_istio_dashboards_config" {

  count = var.istio_enabled ? 1 : 0

  metadata {
    name = "istio-grafana-dashboards"
    namespace = var.namespace
  }

  data = {
  for filename in fileset("${path.module}/resources/grafana_dashboards/istio-grafana-dashboards", "*.json"): basename(filename) => file("${path.module}/resources/grafana_dashboards/istio-grafana-dashboards/${filename}")
  }
}

resource "kubernetes_config_map" "grafana_istio_services_dashboards_config" {

  count = var.istio_enabled ? 1 : 0

  metadata {
    name = "istio-services-grafana-dashboards"
    namespace = var.namespace
  }

  data = {
  for filename in fileset("${path.module}/resources/grafana_dashboards/istio-services-grafana-dashboards", "*.json"): filename => file("${path.module}/resources/grafana_dashboards/istio-services-grafana-dashboards/${filename}")
  }
}


locals {
  helm_prometheus_tpl_values = {
    prometheus_scrape_interval = var.prometheus.prometheus.scrape_interval
    prometheus_scrape_timeout = var.prometheus.prometheus.scrape_timeout
    prometheus_evaluation_interval = var.prometheus.prometheus.evaluation_interval
    prometheus_persistence_storage_class = var.prometheus.prometheus.persistence_storage_class
    prometheus_persistence_size = var.prometheus.prometheus.persistence_size
    prometheus_replica_count = var.prometheus.prometheus.replica_count
    kube_state_metrics_enabled = tostring(var.prometheus.kube_state_metrics_enabled)
    node_exporter_enabled = tostring(var.prometheus.node_exporter_enabled)
    alert_manager_enabled = tostring(var.prometheus.alert_manager.enabled)
    alert_manager_persistence_storage_class = var.prometheus.alert_manager.persistence_storage_class
    alert_manager_persistence_size = var.prometheus.alert_manager.persistence_size
    alert_manager_replica_count = var.prometheus.alert_manager.replica_count
    push_gateway_enabled = tostring(var.prometheus.push_gateway.enabled)
    push_gateway_replica_count = var.prometheus.push_gateway.replica_count
  }
  helm_grafana_tpl_values = {
    namespace = var.namespace
    replica_count = var.grafana.replica_count
    admin_auth_secret = var.grafana.enabled ? kubernetes_secret.grafana_auth[0].metadata[0].name : ""
    admin_auth_secret_user_key = local.grafana_admin_secret_user_key
    admin_auth_secret_password_key = local.grafana_admin_secret_password_key
    ingress_enabled = tostring(var.grafana.ingress_enabled)
    ingress_hosts = var.grafana.ingress_hosts
    persistence_storage_class = var.grafana.persistence_storage_class
    persistence_size = var.grafana.persistence_size
    plugins = var.grafana.plugins
    dashboard_config_maps = merge(
    var.istio_enabled ? {
      istio = kubernetes_config_map.grafana_istio_dashboards_config[0].metadata[0].name,
      istio-services = kubernetes_config_map.grafana_istio_services_dashboards_config[0].metadata[0].name,
    } : {},
    )
  }
}
