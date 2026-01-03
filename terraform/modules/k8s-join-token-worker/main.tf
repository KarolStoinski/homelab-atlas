terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Retrieve the join token for worker nodes (without certificate key)
data "external" "k8s_join_token_worker" {
  program = ["bash", "-c", <<-EOT
    set -e

    # Get the join command for worker nodes
    TOKEN=$(ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 core@${var.vm_ip} \
      "sudo kubeadm token create --print-join-command 2>/dev/null" | tr -d '\n')

    if [ -z "$TOKEN" ]; then
      echo '{"error":"Failed to retrieve join token"}'
      exit 1
    fi

    echo "{\"join_command\":\"$TOKEN\"}"
  EOT
  ]
}
