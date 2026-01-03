resource "null_resource" "retrieve_kubeconfig" {
  triggers = {
    control_plane_ip = var.control_plane_ip
  }

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=accept-new core@${var.control_plane_ip} sudo cat /etc/kubernetes/admin.conf"
  }
}

data "external" "kubeconfig" {
  program = [
    "bash",
    "-c",
    "ssh -o StrictHostKeyChecking=accept-new core@${var.control_plane_ip} sudo cat /etc/kubernetes/admin.conf | base64 -w 0 | jq -R '{kubeconfig: .}'"
  ]

  depends_on = [null_resource.retrieve_kubeconfig]
}
