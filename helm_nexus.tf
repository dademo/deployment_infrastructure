// https://github.com/sonatype/helm3-charts/tree/master/charts/nexus-repository-manager

resource "helm_release" "nexus" {
    name       = "nexus"
    repository = "https://sonatype.github.io/helm3-charts/"
    chart      = "nexus-repository-manager"
    version    = "29.2.0"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.nexus.metadata[0].name

    values = [
        "${templatefile("helm_templates/nexus.tpl.yaml", local.helm_nexus_tpl_values)}"
    ]
}

locals {
    helm_nexus_tpl_values = {
        persistence_size = var.nexus.persistence_size
        persistence_storage_class = var.nexus.persistence_storage_class
        ingress_enabled = var.nexus.ingress_enabled
        ingress_host = var.nexus.ingress_host
    }
}