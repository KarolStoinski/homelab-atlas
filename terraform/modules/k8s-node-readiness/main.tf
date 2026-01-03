terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "check_node_readiness" {
  for_each = toset(var.node_names)

  triggers = {
    node_name        = each.value
    control_plane_ip = var.control_plane_ip
  }

  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      set -e

      NODE_NAME="${each.value}"
      CONTROL_PLANE_IP="${var.control_plane_ip}"
      TIMEOUT=${var.timeout_seconds}
      INTERVAL=${var.check_interval}
      ELAPSED=0

      echo "Checking readiness for node: $NODE_NAME"

      while [ $ELAPSED -lt $TIMEOUT ]; do
        # Check if the node exists and is Ready
        if ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 core@$CONTROL_PLANE_IP \
          "sudo kubectl get node $NODE_NAME 2>/dev/null | grep -q ' Ready'" 2>/dev/null; then
          echo "Node $NODE_NAME is ready!"
          exit 0
        fi

        echo "Node $NODE_NAME not ready yet, waiting... ($ELAPSED/$TIMEOUT seconds)"
        sleep $INTERVAL
        ELAPSED=$((ELAPSED + INTERVAL))
      done

      echo "ERROR: Node $NODE_NAME not ready after $TIMEOUT seconds"
      exit 1
    EOT

    interpreter = ["/bin/bash", "-c"]
  }
}
