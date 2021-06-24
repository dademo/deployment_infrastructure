resource "kubernetes_namespace" "k8s_gitea_namespace" {
    metadata {
        name = var.gitea.namespace
    }
}

resource "kubernetes_namespace" "k8s_jenkins_namespace" {
    metadata {
        name = var.jenkins.namespace
    }
}