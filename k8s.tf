
resource "kubernetes_namespace" "shared" {
    count = (var.k8s_shared.redis_force_install
        || local.shared_enabled) ? 1 : 0
    metadata {
        name = "shared"
    }
}

resource "kubernetes_namespace" "supervision" {
    count = var.supervision.enabled ? 1 : 0
    metadata {
        name = var.supervision.namespace
    }
}

resource "kubernetes_namespace" "istio" {
    count = var.istio.enabled ? 1 : 0
    metadata {
        name = var.istio.namespace
    }
}

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

resource "kubernetes_namespace" "gitlab" {
    count = var.gitlab.enabled ? 1 : 0
    metadata {
        name = var.gitlab.namespace
    }
}

resource "kubernetes_namespace" "dokuwiki" {
    count = var.dokuwiki.enabled ? 1 : 0
    metadata {
        name = var.dokuwiki.namespace
    }
}

resource "kubernetes_namespace" "nextcloud" {
    count = var.nextcloud.enabled ? 1 : 0
    metadata {
        name = var.nextcloud.namespace
    }
}

resource "kubernetes_namespace" "kafka" {
    count = var.kafka.enabled ? 1 : 0
    metadata {
        name = var.kafka.namespace
    }
}

resource "kubernetes_namespace" "spark" {
    count = var.spark.enabled ? 1 : 0
    metadata {
        name = var.spark.namespace
    }
}

resource "kubernetes_namespace" "minio" {
    count = var.minio.enabled ? 1 : 0
    metadata {
        name = var.minio.namespace
    }
}

locals {
    shared_enabled = (var.gitlab.enabled)
}
