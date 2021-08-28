variable "namespace" {
  type = string
  default = "dokuwiki"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "auth" {
  type = object({
    username = string
    email = string
    full_name = string
  })
  default = {
    username = "admin"
    email = "admin@k8s.local"
    full_name = "The Administrator"
  }
  description = "The Dokuwiki service authentication configuration"
  sensitive = false
  validation {
    condition = alltrue([
      length(var.auth.username) > 0,
      can(regex("^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-z]+$", var.auth.email)),
      length(var.auth.full_name) > 0,
    ])
    error_message = "Invalid Gitea service configuration."
  }
}

variable "auth_password" {
  type = string
  description = "The adminstrator password."
  sensitive = true
  validation {
    condition = length(var.auth_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "service" {
  type = object({
    wiki_name = string
    persistence_size = string
    persistence_storage_class = string
    ingress_enabled = bool
    ingress_host = string
  })
  default = {
    wiki_name = "WIKI"
    persistence_size = "2Gi"
    persistence_storage_class = "standard"
    ingress_enabled = true
    ingress_host = "dokuwiki.k8s.local"
  }
  description = "The Dokuwiki service configuration"
  sensitive = false
  validation {
    condition = alltrue([
      length(var.service.wiki_name) > 0,
      length(var.service.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
      (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
    ])
    error_message = "Invalid Gitea service configuration."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
