resource "kubernetes_namespace" "gitea" {
    count = var.gitea.enabled ? 1 : 0
    metadata {
        name = var.gitea.namespace
    }
}

resource "kubernetes_namespace" "jenkins" {
    count = var.jenkins.enabled ? 1 : 0
    metadata {
        name = var.jenkins.namespace
    }
}

resource "kubernetes_namespace" "nexus" {
    count = var.nexus.enabled ? 1 : 0
    metadata {
        name = var.nexus.namespace
    }
}

resource "kubernetes_namespace" "sonarqube" {
    count = var.sonarqube.enabled ? 1 : 0
    metadata {
        name = var.sonarqube.namespace
    }
}

resource "kubernetes_namespace" "keycloak" {
    count = var.keycloak.enabled ? 1 : 0
    metadata {
        name = var.keycloak.namespace
    }
}
