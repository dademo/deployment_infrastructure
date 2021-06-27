// Using https://www.jenkins.io/doc/book/installing/kubernetes/#prerequisites-2

resource "helm_release" "jenkins" {
    name       = "jenkins"
    repository = "https://charts.jenkins.io"
    chart      = "jenkins"
    version    = "3.4.0"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.jenkins.metadata[0].name

    values = [
        "${templatefile("helm_templates/jenkins.tpl.yaml", local.helm_jenkins_tpl_values)}"
    ]
}

locals {
    helm_jenkins_tpl_values = {
        persistence_size = var.jenkins.persistence_size
        persistence_storage_class = var.jenkins.persistence_storage_class
        ingress_enabled = var.jenkins.ingress_enabled
        ingress_host = var.jenkins.ingress_host
        prometheus_enabled = var.jenkins.prometheus_enabled
    }
}
