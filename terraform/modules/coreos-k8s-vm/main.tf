# Fedora CoreOS K8s Control Plane VM

data "template_file" "butane" {
  template = file("${path.module}/fcos.bu.tfpl")

  vars = {
    hostname = var.name
  }
}

# Butane configuration for K8s Control Plane
data "ct_config" "ignition" {
  content = data.template_file.butane.rendered
  strict  = true
}

# Upload Ignition configuration to Proxmox
resource "proxmox_virtual_environment_file" "ignition" {
  node_name    = "pve1"
  content_type = "snippets"
  datastore_id = "readynas-smb-diskimage"

  source_raw {
    data      = data.ct_config.ignition.rendered
    file_name = "${var.name}.ign"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = "pve1"

  clone {
    vm_id = 900
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