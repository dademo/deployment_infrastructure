variable "module_jenkins" {
    type = object({
        enabled = bool
        namespace = string
        service = object({
            persistence_size = string
            persistence_storage_class = string
            ingress_enabled = bool
            ingress_host = string
        })
        additional_plugins = list(object({
            plugin = string
            version = string
        }))
        prometheus_enabled = bool
    })
    sensitive = false
    description = "Jenkins module configuration."
    default = {
        enabled = true
        namespace = "jenkins"
        service = {
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            ingress_enabled = true
            ingress_host = "jenkins.k8s.local"
        }
        additional_plugins = [
            // System
            { plugin = "saml",                      version = "2.0.7" },
            { plugin = "credentials",               version = "2.5" },
            { plugin = "mailer",                    version = "1.34" },
            // Interface
            { plugin = "cloudbees-folder",          version = "6.15" },
            { plugin = "dashboard-view",            version = "2.17" },
            // Pipeline
            { plugin = "pipeline-model-definition", version = "1.8.5" },
            { plugin = "pipeline-stage-step",       version = "2.5" },
            { plugin = "pipeline-build-step",       version = "2.13" },
            { plugin = "workflow-scm-step",         version = "2.13" },
            { plugin = "pipeline-github",           version = "2.7" },
            // Development tools
            { plugin = "gitlab-plugin",             version = "1.5.20" },
            { plugin = "git-client",                version = "3.7.2" },
            { plugin = "xunit",                     version = "3.0.2" },
            { plugin = "junit",                     version = "1.51" },
            { plugin = "jacoco",                    version = "3.3.0" },
            // ... and more
            { plugin = "blueocean",                 version = "1.24.7" },
        ]
        prometheus_enabled = true
    }
}
