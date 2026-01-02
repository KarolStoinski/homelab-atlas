terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "wait_for_k8s_ready" {
  triggers = {
    vm_ip    = var.vm_ip
    vm_id    = var.vm_id
  }

  # Wait for SSH to be available and k8s node to be ready
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e

      VM_IP="${var.vm_ip}"
      TIMEOUT=300  # 5 minutes
      ELAPSED=0
      INTERVAL=10

      echo "Waiting for SSH to be available on $VM_IP..."

      # Wait for SSH to be available
      while [ $ELAPSED -lt $TIMEOUT ]; do
        if ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 -o BatchMode=yes core@$VM_IP "exit" 2>/dev/null; then
          echo "SSH connection established!"
          break
        fi
        echo "SSH not ready yet, waiting... ($ELAPSED/$TIMEOUT seconds)"
        sleep $INTERVAL
        ELAPSED=$((ELAPSED + INTERVAL))
      done

      if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "ERROR: SSH connection timeout after $TIMEOUT seconds"
        exit 1
      fi

      # Wait for k8s node to be ready
      echo "Waiting for Kubernetes node to be ready..."
      ELAPSED=0
      TIMEOUT=600  # 10 minutes for k8s to be ready

      while [ $ELAPSED -lt $TIMEOUT ]; do
        if ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 core@$VM_IP "sudo kubectl get nodes 2>/dev/null | grep -q ' Ready'" 2>/dev/null; then
          echo "Kubernetes node is ready!"
          break
        fi
        echo "Kubernetes node not ready yet, waiting... ($ELAPSED/$TIMEOUT seconds)"
        sleep $INTERVAL
        ELAPSED=$((ELAPSED + INTERVAL))
      done

      if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "ERROR: Kubernetes node not ready after $TIMEOUT seconds"
        exit 1
      fi
    EOT

    interpreter = ["/bin/bash", "-c"]
  }
}

# Retrieve the join token
data "external" "k8s_join_token" {
  depends_on = [null_resource.wait_for_k8s_ready]

  program = ["bash", "-c", <<-EOT
    set -e
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
