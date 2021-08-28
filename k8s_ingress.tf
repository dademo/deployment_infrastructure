resource "kubernetes_ingress" "dashboard" {

  count = var.k8s_dashboard.enabled ? 1 : 0

  wait_for_load_balancer = true

  metadata {
    name = "dashboard"
    namespace = "${var.k8s_dashboard.namespace}"
  }

  spec {
    rule {
      host = "${var.k8s_dashboard.ingress_host}"
      http {
        path {
          backend {
            service_name = "${var.k8s_dashboard.service_name}"
            service_port = var.k8s_dashboard.service_port_http
          }
          path = "/"
        }
      }
    }
  }
}

resource "kubernetes_ingress" "kibana_logging" {

  count = var.k8s_kibana_logging.enabled ? 1 : 0

  wait_for_load_balancer = true

  metadata {
    name = "kibana-logging"
    namespace = "${var.k8s_kibana_logging.namespace}"
  }

  spec {
    rule {
      host = "${var.k8s_kibana_logging.ingress_host}"
      http {
        path {
          backend {
            service_name = "${var.k8s_kibana_logging.service_name}"
            service_port = var.k8s_kibana_logging.service_port_http
          }
          path = "/"
        }
      }
    }
  }
}

resource "kubernetes_ingress" "registry" {

  count = var.k8s_registry.enabled ? 1 : 0

  wait_for_load_balancer = true

  metadata {
    name = "dashboard"
    namespace = "${var.k8s_registry.namespace}"
  }

  spec {
    rule {
      host = "${var.k8s_registry.ingress_host}"
      http {
        path {
          backend {
            service_name = "${var.k8s_registry.service_name}"
            service_port = var.k8s_registry.service_port_http
          }
          path = "/"
        }
      }
    }
  }
}
