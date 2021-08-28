// Using https://www.jenkins.io/doc/book/installing/kubernetes/#prerequisites-2

resource "helm_release" "jenkins" {

    name = "jenkins"
    repository = "https://charts.jenkins.io"
    chart = "jenkins"
    version = local.helm_jenkins_version

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/jenkins.tpl.yaml", local.helm_jenkins_tpl_values)}"
    ]
}

locals {
    helm_jenkins_tpl_values = {
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        ingress_enabled = tostring(var.service.ingress_enabled)
        ingress_host = var.service.ingress_host
        additional_plugins = [ for plugin_def in var.additional_plugins: format("%s:%s", plugin_def.plugin, plugin_def.version) ]
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
