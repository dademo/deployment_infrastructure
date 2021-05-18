terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.2.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.1.2"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.k8s_config_context
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = var.k8s_config_context
  }
}


