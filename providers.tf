terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.2.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = var.k8s_config_context
  //experiments {
  //  manifest_resource = true
  //}
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = var.k8s_config_context
  }
  repository_cache = "./_helpers/helm_cache/data"
}


