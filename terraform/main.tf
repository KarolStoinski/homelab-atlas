# Fedora CoreOS HTTP Server VM

# Ignition configuration for HTTP server
resource "proxmox_virtual_environment_file" "fcos_ignition" {
  node_name    = "pve1"
  content_type = "snippets"
  datastore_id = "readynas-smb-diskimage"

  source_raw {
    data = jsonencode({
      ignition = {
        version = "3.4.0"
      },
      passwd = {
        users = [
          {
            name = "core",
            sshAuthorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvBuMhx7sbVFpdYEsSDEcOeNenlsboGAHU41I0jdtes karol.stoinski@gmail.com"
            ]
          }
        ]
      },
      storage = {
        directories = [
          {
            path = "/var/www",
            mode = 493
          }
        ]
      },
      systemd = {
        units = [
          {
            name    = "httpd.service",
            enabled = true,
            contents = <<-EOT
              [Unit]
              Description=HTTP Server (podman)
              After=network-online.target
              Wants=network-online.target

              [Service]
              ExecStartPre=-/usr/bin/podman kill httpd
              ExecStartPre=-/usr/bin/podman rm httpd
              ExecStartPre=/bin/sleep 5
              ExecStart=/usr/bin/podman run --name httpd -p 80:80 -v /var/www:/usr/local/apache2/htdocs docker.io/httpd:latest
              ExecStop=/usr/bin/podman stop httpd

              [Install]
              WantedBy=multi-user.target
            EOT
          }
        ]
      }
    })
    file_name = "fcos-http-server.ign"
  }
}

resource "proxmox_virtual_environment_vm" "fcos_vm" {
  name      = "fcos-http-01"
  node_name = "pve1"

  clone {
    vm_id = 900
  }

  # CPU
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # Memory
  memory {
    dedicated = 2048
  }

  initialization {
    datastore_id = proxmox_virtual_environment_file.fcos_ignition.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.fcos_ignition.id
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

