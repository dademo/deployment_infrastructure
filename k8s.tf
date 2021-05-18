resource "kubernetes_namespace" "k8s_gitea_namespace" {
    metadata {
        name = var.gitea.namespace
    }
}
