// https://istio.io/latest/docs/setup/install/helm/

resource "helm_release" "istio_base" {
    
    count = var.istio.enabled ? 1 : 0
    
    name = "istio-base"
    chart = "${local.helm_istio_charts_root}/base"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.istio[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/istio_generic.tpl.yaml", local.helm_istio_generic_tpl_values)}"
    ]
}

resource "helm_release" "istio_discovery" {

    count = var.istio.enabled ? 1 : 0
    depends_on = [
        helm_release.istio_base
    ]
    
    name = "istio-discovery"
    chart = "${local.helm_istio_charts_root}/istio-control/istio-discovery"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.istio[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/istio_generic.tpl.yaml", local.helm_istio_generic_tpl_values)}"
    ]
}

resource "helm_release" "istio_ingress" {

    count = var.istio.enabled && var.istio.system_ingress_enabled ? 1 : 0
    depends_on = [
        helm_release.istio_base,
        helm_release.istio_discovery,
    ]
    
    name = "istio-ingress"
    chart = "${local.helm_istio_charts_root}/gateways/istio-ingress"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.istio[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/istio_generic.tpl.yaml", local.helm_istio_generic_tpl_values)}"
    ]
}

resource "helm_release" "istio_egress" {

    count = var.istio.enabled && var.istio.system_egress_enabled ? 1 : 0
    depends_on = [
        helm_release.istio_base,
        helm_release.istio_discovery,
    ]
    
    name = "istio-egress"
    chart = "${local.helm_istio_charts_root}/gateways/istio-egress"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.istio[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/istio_generic.tpl.yaml", local.helm_istio_generic_tpl_values)}"
    ]
}

locals {
    helm_istio_charts_root = "${path.module}/dependencies/istio/manifests/charts"
    helm_istio_generic_tpl_values = {
        namespace = var.istio.namespace
        enable_analysis = var.istio.enable_analysis
    }
}

