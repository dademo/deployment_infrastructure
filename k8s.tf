resource "kubernetes_namespace" "gitea" {
    metadata {
        name = var.gitea.namespace
    }
}

resource "kubernetes_namespace" "jenkins" {
    metadata {
        name = var.jenkins.namespace
    }
}

resource "kubernetes_namespace" "nexus" {
    metadata {
        name = var.nexus.namespace
    }
}

resource "kubernetes_namespace" "sonarqube" {
    metadata {
        name = var.sonarqube.namespace
    }
}

resource "kubernetes_namespace" "keycloak" {
    metadata {
        name = var.keycloak.namespace
    }
}
