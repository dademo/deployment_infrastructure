// https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html

resource "kubernetes_service" "service" {

  metadata {
    name = "pgadmin4"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "pgadmin4"
    }

    type = var.service.service.type
    session_affinity = "ClientIP"
    cluster_ip = var.service.service.type == "ClusterIP" && length(var.service.service.cluster_ip) > 0 ? var.service.service.cluster_ip : null
    load_balancer_ip = var.service.service.type == "LoadBalancer" ? var.service.service.load_balancer_ip : null

    port {
      port = var.service.service.type != "NodePort" ? local.pgadmin_port : null
      node_port = var.service.service.type == "NodePort" ? var.service.service.node_port : null
      name = "http"
      protocol = "TCP"
      target_port = local.pgadmin_port
    }
  }
}

resource "kubernetes_stateful_set" "service" {

  metadata {
    name = "pgadmin4"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    service_name = kubernetes_service.service.metadata[0].name


    selector {
      match_labels = {
        app = "pgadmin4"
      }

    }

    template {
      metadata {
        name = "pgadmin4"
        labels = {
          app = "pgadmin4"
        }
      }
      spec {

        // https://github.com/postgres/pgadmin4/blob/master/Dockerfile
        //security_context {
        //  run_as_non_root = true
        //  // pgadmin == 5050
        //  run_as_user = 5050
        //  run_as_group = 5050
        //  fs_group = 5050
        //}

        volume {
          name = "pgadmin4-servers-config"
          secret {
            optional = false
            secret_name = kubernetes_secret.service_sensible_param.metadata[0].name
          }
        }

        volume {
          name = "pgadmin4-cache"
          empty_dir {
            medium = "Memory"
          }
        }

        init_container {
          name = "pgadmin4-warmer"
          image = "busybox:1.34.0"

          volume_mount {
            name = "pgadmin4-data"
            mount_path = local.pgadmin_data_dir
            read_only = false
          }

          command = [
            "sh",
            "-c",
            "chown -v 5050:5050 '${local.pgadmin_data_dir}'",
          ]
        }


        container {
          name = "pgadmin4"
          image = var.container_image

          port {
            container_port = local.pgadmin_port
            name = "http"
            protocol = "TCP"
          }

          volume_mount {
            name = "pgadmin4-data"
            mount_path = local.pgadmin_data_dir
            read_only = false
          }

          volume_mount {
            name = "pgadmin4-servers-config"
            mount_path = format("%s/server_config", local.pgadmin_config_dir)
            read_only = true
          }

          volume_mount {
            name = "pgadmin4-cache"
            mount_path = local.pgadmin_cache_dir
            read_only = false
          }

          env {
            name = "PGADMIN_ENABLE_TLS"
            value = ""
          }

          env {
            name = "PGADMIN_LISTEN_ADDRESS"
            value = "0.0.0.0"
          }

          env {
            name = "PGADMIN_LISTEN_PORT"
            value = tostring(local.pgadmin_port)
          }

          env {
            name = "GUNICORN_ACCESS_LOGFILE"
            value = "-"
          }

          env {
            name = "PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION"
            value = "True"
          }

          env {
            name = "PGADMIN_CONFIG_UPGRADE_CHECK_ENABLED"
            value = "False"
          }

          env {
            name = "PGADMIN_CONFIG_LOGIN_BANNER"
            value = "'${var.service.login_banner}'"
          }

          env {
            name = "PGADMIN_CONFIG_LOG_FILE"
            value = "'${local.pgadmin_data_dir}/pgadmin4.log'"
          }

          env {
            name = "PGADMIN_CONFIG_SESSION_DB_PATH"
            value = "'${local.pgadmin_cache_dir}/sessions'"
          }

          env {
            name = "PGADMIN_CONFIG_STORAGE_DIR"
            value = "'${local.pgadmin_data_dir}/storage'"
          }

          env {
            name = "PGADMIN_SERVER_JSON_FILE"
            value = "${local.pgadmin_config_dir}/server_config/servers.json"
          }

          env {
            name = "SQLITE_PATH"
            value = "${local.pgadmin_data_dir}/pgadmin4.db"
          }

          env {
            // Application log level - one of:
            //   CRITICAL 50
            //   ERROR    40
            //   WARNING  30
            //   SQL      25
            //   INFO     20
            //   DEBUG    10
            //   NOTSET    0
            name = "PGADMIN_CONFIG_CONSOLE_LOG_LEVEL"
            value = var.debug ? 10 : 30
          }


          env_from {
            secret_ref {
              name = kubernetes_secret.auth.metadata[0].name
              optional = false
            }
          }

          dynamic "env_from" {
            for_each = var.additional_env_configmap
            content {
              config_map_ref {
                name = env_from.value
                optional = false
              }
            }
          }

          dynamic "env_from" {
            for_each = var.additional_env_secrets
            content {
              secret_ref {
                name = env_from.value
                optional = false
              }
            }
          }

          startup_probe {
            failure_threshold = 5
            initial_delay_seconds = 30
            period_seconds = 15
            success_threshold = 1
            timeout_seconds = 5
            http_get {
              path = "/misc/ping"
              port = "http"
              scheme = "HTTP"
            }
          }
          liveness_probe {
            failure_threshold = 5
            initial_delay_seconds = 30
            period_seconds = 15
            success_threshold = 1
            timeout_seconds = 5
            http_get {
              path = "/misc/ping"
              port = "http"
              scheme = "HTTP"
            }
          }
          readiness_probe {
            failure_threshold = 5
            initial_delay_seconds = 30
            period_seconds = 15
            success_threshold = 1
            timeout_seconds = 5
            http_get {
              path = "/misc/ping"
              port = "http"
              scheme = "HTTP"
            }
          }
        }
      }
    }

    volume_claim_template {

      metadata {
        name = "pgadmin4-data"
        namespace = var.namespace
        labels = {
          app = "pgadmin4"
        }
      }
      spec {
        access_modes = [
          "ReadWriteOnce"
        ]
        storage_class_name = var.service.persistence_storage_class
        resources {
          requests = {
            storage = var.service.persistence_size
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "dashboard" {

  count = var.service.ingress_enabled ? 1 : 0

  wait_for_load_balancer = true

  metadata {
    name = "pgadmin4"
    namespace = var.namespace
  }

  spec {
    dynamic "rule" {
      for_each = var.service.ingress_hosts
      content {
        host = rule.value
        http {
          path {
            backend {
              service_name = kubernetes_service.service.metadata[0].name
              service_port = kubernetes_service.service.spec[0].port[0].port
            }
            path = "/"
          }
        }
      }
    }
  }
}

resource "kubernetes_secret" "service_sensible_param" {

  metadata {
    name = "pgadmin-sensible-param"
    namespace = var.namespace
  }

  data = {
    "servers.json" = jsonencode(local.pgadmin_config)
  }

  type = "Opaque"
}

resource "kubernetes_secret" "auth" {

  metadata {
    name = "pgadmin-auth"
    namespace = var.namespace
  }

  data = {
    PGADMIN_DEFAULT_EMAIL = var.service.default_email
    PGADMIN_DEFAULT_PASSWORD = var.default_password
  }

  type = "Opaque"
}
