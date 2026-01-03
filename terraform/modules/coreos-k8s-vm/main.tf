# Fedora CoreOS K8s Control Plane VM

data "template_file" "butane" {
  template = file("${path.module}/fcos.bu.tfpl")

  vars = {
    hostname     = "${var.name}.atlas.stoinski.pro"
    join_command = var.join_command
  }
}

# Butane configuration for K8s Control Plane
data "ct_config" "ignition" {
  content = data.template_file.butane.rendered
  strict  = true
}

# Upload Ignition configuration to Proxmox
resource "proxmox_virtual_environment_file" "ignition" {
  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = "readynas-smb-diskimage"

  source_raw {
    data      = data.ct_config.ignition.rendered
    file_name = "${var.name}.ign"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.node_name

  disk {
    interface    = "scsi0"
    datastore_id = "readynas-smb-diskimage"
    import_from  = "readynas-smb-diskimage:import/fedora-coreos-43.20251120.3.0-proxmoxve.x86_64.qcow2"
    size         = 10
  }

  # CPU
  cpu {
    cores   = var.cpu_cores
    sockets = 1
    type    = "host"
  }

  # Memory
  memory {
    dedicated = var.memory
  }

  initialization {
    datastore_id = proxmox_virtual_environment_file.ignition.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.ignition.id

    ip_config {
      ipv4 {
        address = "${var.vm_ip}/${var.netmask}"
        gateway = var.gateway
      }
    }

    dns {
      servers = [var.dns_server]
    }
  }

  # Network
  network_device {
    model  = "virtio"
    bridge = "vmbr0"
    vlan_id = 100
  }

  template = false
  started  = true
}

output "vm_id" {
  description = "VM ID"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_ip" {
  description = "VM IP address"
  value       = var.vm_ip
}