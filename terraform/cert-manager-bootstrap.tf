resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [
    module.k8s-kubeconfig
  ]
}

resource "kubernetes_secret_v1" "cert_manager_ovh_credentials" {
  metadata {
    name      = "ovh-credentials"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    applicationKey    = local.ovh_application_key
    applicationSecret = local.ovh_application_secret
    consumerKey       = local.ovh_consumer_key
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace_v1.cert_manager
  ]
}
