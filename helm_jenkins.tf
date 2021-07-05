// Using https://www.jenkins.io/doc/book/installing/kubernetes/#prerequisites-2

resource "helm_release" "jenkins" {
    
    count = var.jenkins.enabled ? 1 : 0

    name       = "jenkins"
    repository = "https://charts.jenkins.io"
    chart      = "jenkins"
    version    = local.helm_jenkins_version

    timeout = 600
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.jenkins[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/jenkins.tpl.yaml", local.helm_jenkins_tpl_values)}"
    ]
}

locals {
    helm_jenkins_tpl_values = {
        persistence_size = var.jenkins.persistence_size
        persistence_storage_class = var.jenkins.persistence_storage_class
        ingress_enabled = tostring(var.jenkins.ingress_enabled)
        ingress_host = var.jenkins.ingress_host
        prometheus_enabled = tostring(var.jenkins.prometheus_enabled)
        additional_plugins = [ for plugin_def in var.jenkins.additional_plugins: format("%s:%s", plugin_def.plugin, plugin_def.version) ]
    }
}
