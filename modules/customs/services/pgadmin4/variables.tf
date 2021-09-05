variable "namespace" {
  type = string
  description = "The Kubernetes namespace where to deploy."
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "service" {
  type = object({
    default_email = string
    login_banner = string
    persistence_size = string
    persistence_storage_class = string
    service = object({
      type = string
      node_port = number
      cluster_ip = string
      load_balancer_ip = string
    })
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  sensitive = false
  default = {
    default_email = "user@domain.com"
    login_banner = ""
    persistence_size = "1G"
    persistence_storage_class = "standard"
    service = {
      type = "ClusterIP"
      node_port = 0
      cluster_ip = ""
      load_balancer_ip = ""
    }
    ingress_enabled = true
    ingress_hosts = [
      "pgadmin.k8s.local"
    ]
  }
}

variable "additional_env_configmap" {
  type = list(string)
  default = []
  description = "List of additional config maps to use."
  sensitive = false
  validation {
    condition = alltrue([for v in var.additional_env_configmap : (length(v) > 0)])
    error_message = "All config maps secrets must be non-empty strings."
  }
}

variable "additional_env_secrets" {
  type = list(string)
  default = []
  description = "List of additional secrets to use."
  sensitive = false
  validation {
    condition = alltrue([for v in var.additional_env_secrets : (length(v) > 0)])
    error_message = "All env secrets must be non-empty strings."
  }
}

variable "database_configurations" {
  /*type = list(object({
    // Required
    Name: string
    Group: string
    HostAddr: string
    Port: number
    MaintenanceDB: string
    Username: string
    SSLMode: string
    // Other
    Host: string
    Role: string
    Comment: string
    DBRestriction: string
    PassFile: string
    SSLCert: string
    SSLKey: string
    SSLRootCert: string
    SSLCrl: string
    SSLCompression: number
    Shared: bool
    BGColor: string
    FGColor: string
    Service: string
    Timeout: number
    UseSSHTunnel: number
    TunnelHost: string
    TunnelPort: number
    TunnelUsername: string
    TunnelAuthentication: number
  }))*/
  type = list(map(any))
  default = []
  description = "List of database configurations to apply."
  sensitive = false
  validation {
    condition = alltrue([for cfg in var.database_configurations : alltrue([
      length(lookup(cfg, "Name", "")) > 0,
      length(lookup(cfg, "Group", "")) > 0,
      length(lookup(cfg, "Host", "")) > 0,
      length(lookup(cfg, "MaintenanceDB", "")) > 0,
      length(lookup(cfg, "Username", "")) > 0,
      length(lookup(cfg, "SSLMode", "")) > 0,
      lookup(cfg, "Port", 0) > 0,
    ])])
    error_message = "At least a configuration is missing required field."
  }
}

variable "container_image" {

  type = string
  default = "dpage/pgadmin4:5.6"
  description = "The image to deploy."
  sensitive = false
  validation {
    condition = can(regex("^[^:]+:[^:]+$", var.container_image))
    error_message = "Invalid container image format."
  }
}

variable "default_password" {

  type = string
  description = "The default admin password."
  sensitive = true
  validation {
    condition = length(var.default_password) > 0
    error_message = "Password must not be empty."
  }
}

variable "debug" {

  type = bool
  description = "Enable service debugging logs."
  sensitive = false
  default = false
}

locals {
  // https://www.pgadmin.org/docs/pgadmin4/latest/import_export_servers.html#importing-servers
  pgadmin_config = {
    Servers = {
    for idx, database_configuration in var.database_configurations :
    tostring(idx) => {for k, v in database_configuration : k => v if v != null}
    }
  }
}