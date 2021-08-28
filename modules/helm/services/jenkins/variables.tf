variable "namespace" {
  type = string
  default = "jenkins"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "service" {
  type = object({
    persistence_size = string
    persistence_storage_class = string
    ingress_enabled = bool
    ingress_host = string
  })
  default = {
    persistence_size = "2Gi"
    persistence_storage_class = "standard"
    ingress_enabled = true
    ingress_host = "jenkins.k8s.local"
  }
  description = "The Jenkins service configuration"
  sensitive = false
  validation {
    condition = alltrue([
      length(var.service.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
      (!var.service.ingress_enabled) || length(var.service.ingress_host) > 0,
    ])
    error_message = "Invalid Jenkins service configuration."
  }
}

variable "additional_plugins" {
  type = list(object({
    plugin = string
    version = string
  }))
  default = [
    // System
    {
      plugin = "saml",
      version = "2.0.7"
    },
    {
      plugin = "credentials",
      version = "2.5"
    },
    {
      plugin = "mailer",
      version = "1.34"
    },
    // Interface
    {
      plugin = "cloudbees-folder",
      version = "6.15"
    },
    {
      plugin = "dashboard-view",
      version = "2.17"
    },
    // Pipeline
    {
      plugin = "pipeline-model-definition",
      version = "1.8.5"
    },
    {
      plugin = "pipeline-stage-step",
      version = "2.5"
    },
    {
      plugin = "pipeline-build-step",
      version = "2.13"
    },
    {
      plugin = "workflow-scm-step",
      version = "2.13"
    },
    {
      plugin = "pipeline-github",
      version = "2.7"
    },
    // Development tools
    {
      plugin = "gitlab-plugin",
      version = "1.5.20"
    },
    {
      plugin = "git-client",
      version = "3.7.2"
    },
    {
      plugin = "xunit",
      version = "3.0.2"
    },
    {
      plugin = "junit",
      version = "1.51"
    },
    {
      plugin = "jacoco",
      version = "3.3.0"
    },
    // ... and more
    {
      plugin = "blueocean",
      version = "1.24.7"
    },
  ]
  description = "Additional Jenkins plugins to install."
  sensitive = false
  validation {
    condition = alltrue([for plugin in var.additional_plugins : alltrue([
      length(plugin.plugin) > 0,
      anytrue([
        can(regex("^[0-9]+$", plugin.version)),
        can(regex("^[0-9]+\\.[0-9]+$", plugin.version)),
        can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", plugin.version)),
      ])
    ])])
    error_message = "Invalid Jenkins plugins configuration."
  }
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}
