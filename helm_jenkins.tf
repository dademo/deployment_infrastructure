// Using https://www.jenkins.io/doc/book/installing/kubernetes/#prerequisites-2

// resource "kubernetes_cluster_role" "jenkins" {
// 
//     metadata {
//         name = "terraform-example"
//     }
// 
//     rule {
//         api_groups = ["*"]
//         resources = [
//             "statefulsets",
//             "services",
//             "replicationcontrollers",
//             "replicasets",
//             "podtemplates",
//             "podsecuritypolicies",
//             "pods",
//             "pods/log",
//             "pods/exec",
//             "podpreset",
//             "poddisruptionbudget",
//             "persistentvolumes",
//             "persistentvolumeclaims",
//             "jobs",
//             "endpoints",
//             "deployments",
//             "deployments/scale",
//             "daemonsets",
//             "cronjobs",
//             "configmaps",
//             "namespaces",
//             "events",
//             "secrets",
//         ]
//         verbs = [
//             "create",
//             "get",
//             "watch",
//             "delete",
//             "list",
//             "patch",
//             "update",
//         ]
//     }
// 
//     rule {
//         api_groups = [
//             ""
//         ]
//         verbs = [
//             "get",
//             "list",
//             "watch",
//             "update",
//         ]
//     }
// }
// 
// resource "kubernetes_cluster_role_binding" "jenkins" {
// 
//     metadata {
//         
//         name = "jenkins"
//         annotations = {
//             "rbac.authorization.kubernetes.io/autoupdate" = "true",
//         }
//         labels = {
//             "kubernetes.io/bootstrapping" = "rbac-defaults"
//         }
//     }
// 
//     role_ref {
//         api_group = "rbac.authorization.k8s.io"
//         kind      = "ClusterRole"
//         name      = "jenkins"
//     }
// 
//     subject {
//         kind      = "Group"
//         name      = "system:serviceaccounts:jenkins"
//         api_group = "rbac.authorization.k8s.io"
//     }
// }
// 
// resource "kubernetes_service_account" "jenkins" {
// 
//     metadata {
//         name = "jenkins"
//         namespace = var.jenkins.namespace
//     }
// }

resource "helm_release" "jenkins" {
    name       = "jenkins"
    repository = "https://charts.jenkins.io"
    chart      = "jenkins"
    version    = "3.4.0"

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = var.jenkins.namespace

    values = [
        "${templatefile("helm_templates/jenkins.tpl.yaml", local.helm_jenkins_tpl_values)}"
    ]
}

locals {
    helm_jenkins_tpl_values = {
        persistence_size = var.jenkins.persistence_size
        persistence_storage_class = var.jenkins.persistence_storage_class
        ingress_enabled = var.jenkins.ingress_enabled
        ingress_host = var.jenkins.ingress_host
        prometheus_enabled = var.jenkins.prometheus_enabled
    }
}
