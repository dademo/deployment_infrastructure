variable "namespace" {
  type = string
  default = "supervision"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "service_name" {
  type = string
  default = "elasticsearch"
  description = "The service name to use."
  sensitive = false
  validation {
    condition = length(var.service_name) > 0
    error_message = "Service name must not be empty."
  }
}

variable "elasticsearch" {
  type = object({
    replica_count = number
    cluster_name = string
    node_group = string
    java_opts = list(string)
    cpu_limits_millis = number
    memory_limits_mega = number
    persistence_size = string
    persistence_storage_class = string
    service = object({
      type = string
      node_port = string
      load_balancer_ip = string
    })
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  default = {
    replica_count = 3
    persistence_size = "8Gi"
    persistence_storage_class = "standard"
    cluster_name = "elasticsearch"
    node_group = "master"
    java_opts = []
    cpu_limits_millis = 1000
    memory_limits_mega = 2048
    persistence_size = "20Gi"
    persistence_storage_class = "standard"
    service = {
      type = "ClusterIP"
      node_port = ""
      cluster_ip = ""
      load_balancer_ip = ""
    }
    ingress_enabled = true
    ingress_hosts = [
      "elasticsearch.elastic.k8s.local",
    ]
  }
  description = "The Elasticsearch service configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.elasticsearch.replica_count > 0,
      var.elasticsearch.replica_count % 1 == 0,
      length(var.elasticsearch.cluster_name) > 0,
      length(var.elasticsearch.node_group) > 0,
      alltrue([for java_opt in var.elasticsearch.java_opts : (length(java_opt) > 0)]),
      var.elasticsearch.cpu_limits_millis > 0,
      var.elasticsearch.cpu_limits_millis % 1 == 0,
      var.elasticsearch.memory_limits_mega > 0,
      var.elasticsearch.memory_limits_mega % 1 == 0,
      length(var.elasticsearch.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.elasticsearch.persistence_size)),
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"
      ], var.elasticsearch.service.type),
      anytrue([
        alltrue([
          !(var.elasticsearch.service.type == "NodePort"),
          length(var.elasticsearch.service.node_port) == 0,
        ]),
        length(var.elasticsearch.service.node_port) > 0,
      ]),
      anytrue([
        !var.elasticsearch.ingress_enabled,
        alltrue([for ingress_host in var.elasticsearch.ingress_hosts : (length(ingress_host) > 0)]),
      ]),
    ])
    error_message = "Invalid Elasticsearch configuration."
  }
}

variable "kibana" {
  type = object({
    enabled = bool
    replica_count = number
    service = object({
      type = string
      node_port = string
      load_balancer_ip = string
    })
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  default = {
    enabled = true
    replica_count = 1
    service = {
      type = "ClusterIP"
      node_port = ""
      cluster_ip = ""
      load_balancer_ip = ""
    }
    ingress_enabled = true
    ingress_hosts = [
      "kibana.elastic.k8s.local",
    ]
  }
  description = "The Kibana configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.kibana.replica_count > 0,
      var.kibana.replica_count % 1 == 0,
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"
      ], var.kibana.service.type),
      anytrue([
        alltrue([
          !(var.kibana.service.type == "NodePort"),
          length(var.kibana.service.node_port) == 0,
        ]),
        length(var.kibana.service.node_port) > 0,
      ]),
      anytrue([
        !var.kibana.ingress_enabled,
        alltrue([for ingress_host in var.kibana.ingress_hosts : (length(ingress_host) > 0)]),
      ]),
    ])
    error_message = "Invalid Kibana configuration."
  }
}

variable "apm" {
  type = object({
    enabled = bool
    replica_count = number
    autoscaling = object({
      enabled = bool
      min_replicas = number
      max_replicas = number
      avg_cpu_utilization = number
    })
    service = object({
      type = string
      node_port = string
      load_balancer_ip = string
    })
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  default = {
    enabled = false
    replica_count = 1
    autoscaling = {
      enabled = true
      min_replicas = 1
      max_replicas = 3
      avg_cpu_utilization = 50
    }
    service = {
      type = "ClusterIP"
      node_port = ""
      cluster_ip = ""
      load_balancer_ip = ""
    }
    ingress_enabled = true
    ingress_hosts = [
      "apm.elastic.k8s.local",
    ]
  }
  description = "The APM configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.apm.replica_count > 0,
      var.apm.replica_count % 1 == 0,
      contains([
        "ClusterIP",
        "NodePort",
        "LoadBalancer",
        "ExternalName"
      ], var.apm.service.type),
      anytrue([
        alltrue([
          !(var.apm.service.type == "NodePort"),
          length(var.apm.service.node_port) == 0,
        ]),
        length(var.apm.service.node_port) > 0,
      ]),
      anytrue([
        !var.apm.autoscaling.enabled,
        alltrue([
          var.apm.autoscaling.min_replicas > 0,
          var.apm.autoscaling.min_replicas >= var.apm.replica_count,
          var.apm.autoscaling.max_replicas > var.apm.autoscaling.min_replicas,
        ])
      ]),
      anytrue([
        !var.apm.ingress_enabled,
        alltrue([for ingress_host in var.apm.ingress_hosts : (length(ingress_host) > 0)]),
      ]),
    ])
    error_message = "Invalid APM configuration."
  }
}

variable "filebeat" {
  type = object({
    enabled = bool
    replica_count = number
    autoscaling = object({
      enabled = bool
      min_replicas = number
      max_replicas = number
      avg_cpu_utilization = number
    })
  })
  default = {
    enabled = false
    replica_count = 1
    autoscaling = {
      enabled = true
      min_replicas = 1
      max_replicas = 3
      avg_cpu_utilization = 50
    }
  }
  description = "The Filebeat configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.filebeat.replica_count > 0,
      var.filebeat.replica_count % 1 == 0,
      anytrue([
        !var.filebeat.autoscaling.enabled,
        alltrue([
          var.filebeat.autoscaling.min_replicas > 0,
          var.filebeat.autoscaling.min_replicas >= var.filebeat.replica_count,
          var.filebeat.autoscaling.max_replicas > var.filebeat.autoscaling.min_replicas,
        ])
      ]),
    ])
    error_message = "Invalid Filebeat configuration."
  }
}

variable "logstash" {
  type = object({
    enabled = bool
    replica_count = number
    java_opts = list(string)
    cpu_limits_millis = number
    memory_limits_mega = number
    persistence_size = string
    persistence_storage_class = string
    ingress_enabled = bool
    ingress_hosts = list(string)
  })
  default = {
    enabled = false
    replica_count = 1
    java_opts = []
    cpu_limits_millis = 100
    memory_limits_mega = 1536
    persistence_size = "1Gi"
    persistence_storage_class = "standard"
    ingress_enabled = true
    ingress_hosts = [
      "logstash.elastic.k8s.local",
    ]
  }
  description = "The Logstash configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.logstash.replica_count > 0,
      var.logstash.replica_count % 1 == 0,
      alltrue([for java_opt in var.logstash.java_opts : (length(java_opt) > 0)]),
      var.logstash.cpu_limits_millis > 0,
      var.logstash.cpu_limits_millis % 1 == 0,
      var.logstash.memory_limits_mega > 0,
      var.logstash.memory_limits_mega % 1 == 0,
      length(var.logstash.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.logstash.persistence_size)),
      anytrue([
        !var.logstash.ingress_enabled,
        alltrue([for ingress_host in var.logstash.ingress_hosts : (length(ingress_host) > 0)]),
      ]),
    ])
    error_message = "Invalid Logstash configuration."
  }
}

variable "metricbeat" {
  type = object({
    enabled = bool
    replica_count = number
    kube_state_metrics_host = string
  })
  default = {
    enabled = false
    replica_count = 1
    kube_state_metrics_host = "prometheus-kube-state-metrics.supervision.svc.cluster.local:8080"
  }
  description = "The Metricbeat configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.metricbeat.replica_count > 0,
      var.metricbeat.replica_count % 1 == 0,
      length(var.metricbeat.kube_state_metrics_host) > 0,
    ])
    error_message = "Invalid Metricbeat configuration."
  }
}
