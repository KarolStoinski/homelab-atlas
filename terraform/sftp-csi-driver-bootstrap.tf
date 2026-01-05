resource "kubernetes_namespace_v1" "sftp_csi_driver" {
  metadata {
    name = "sftp-csi-driver"
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [
    module.k8s-kubeconfig
  ]
}

resource "kubernetes_secret_v1" "sftp_csi_driver_credentials" {
  metadata {
    name      = "sftp-creds"
    namespace = kubernetes_namespace_v1.sftp_csi_driver.metadata[0].name
    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "sftp-user" = local.smb_csi_driver_username
    "sftp-pass" = base64encode(local.smb_csi_driver_password)
  }

  type = "Opaque"

  depends_on = [
    kubernetes_namespace_v1.cert_manager
  ]
}
