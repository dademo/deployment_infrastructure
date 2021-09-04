variable "module_dokuwiki" {
  type = object({
    enabled = bool
    namespace = string
    auth = object({
      username = string
      email = string
      full_name = string
    })
    service = object({
      wiki_name = string
      persistence_size = string
      persistence_storage_class = string
      ingress_enabled = bool
      ingress_host = string
    })
    prometheus_enabled = bool
  })
  sensitive = false
  description = "Dokuwiki module configuration."
  default = {
    enabled = false
    namespace = "dokuwiki"
    auth = {
      username = "admin"
      email = "admin@k8s.local"
      full_name = "The Administrator"
    }
    service = {
      wiki_name = "WIKI"
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
      ingress_enabled = true
      ingress_host = "dokuwiki.k8s.local"
    }
    prometheus_enabled = true
  }
}

variable "dokuwiki_auth_password" {
  type = string
  description = "The Dokuwiki adminstrator password."
  sensitive = true
}
