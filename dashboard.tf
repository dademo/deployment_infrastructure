resource "kubernetes_ingress" "dashboard" {
    metadata {
        name = "dashboard"
        namespace = "kubernetes-dashboard"
    }

    spec {
        backend {
            service_name = "kubernetes-dashboard"
            service_port = 8080
        }

        rule {

            host = "${var.dashboard_ingress_hostname}"

            http {
                path {
                    backend {
                        service_name = "kubernetes-dashboard"
                        service_port = 80
                    }

                    path = "/"
                }
            }
        }
    }
}
