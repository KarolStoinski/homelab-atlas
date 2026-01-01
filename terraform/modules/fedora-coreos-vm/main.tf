# Fedora CoreOS K8s Control Plane VM

# Ignition configuration for K8s Control Plane
resource "proxmox_virtual_environment_file" "ignition" {
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
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVw0Nn7/iH2TM83WLGrpSVY6g0z+G+38LI+yeSRExwO karol.stoinski@gmail.com"
            ]
          }
        ]
      },
      storage = {
        files = [
          {
            path = "/etc/modules-load.d/containerd.conf"
            mode = 420
            contents = {
              source = "data:,overlay%0Abr_netfilter"
            }
          },
          {
            path = "/etc/sysctl.d/99-kubernetes-cri.conf"
            mode = 420
            contents = {
              source = "data:,net.bridge.bridge-nf-call-iptables%20%3D%201%0Anet.ipv4.ip_forward%20%3D%201%0Anet.bridge.bridge-nf-call-ip6tables%20%3D%201"
            }
          },
          {
            path = "/usr/local/bin/install-containerd.sh"
            mode = 493
            contents = {
              source = "data:,%23!%2Fbin%2Fbash%0Aset%20-euxo%20pipefail%0A%0A%23%20Install%20containerd%0Aif%20%5B%20!%20-f%20%2Fusr%2Flocal%2Fbin%2Fcontainerd%20%5D%3B%20then%0A%20%20curl%20-L%20https%3A%2F%2Fgithub.com%2Fcontainerd%2Fcontainerd%2Freleases%2Fdownload%2Fv1.7.13%2Fcontainerd-1.7.13-linux-amd64.tar.gz%20%7C%20tar%20-xz%20-C%20%2Fusr%2Flocal%0Afi%0A%0A%23%20Install%20runc%0Aif%20%5B%20!%20-f%20%2Fusr%2Flocal%2Fsbin%2Frunc%20%5D%3B%20then%0A%20%20curl%20-L%20https%3A%2F%2Fgithub.com%2Fopencontainers%2Frunc%2Freleases%2Fdownload%2Fv1.1.12%2Frunc.amd64%20-o%20%2Fusr%2Flocal%2Fsbin%2Frunc%0A%20%20chmod%20%2Bx%20%2Fusr%2Flocal%2Fsbin%2Frunc%0Afi%0A%0A%23%20Install%20CNI%20plugins%0Aif%20%5B%20!%20-d%20%2Fopt%2Fcni%2Fbin%20%5D%3B%20then%0A%20%20mkdir%20-p%20%2Fopt%2Fcni%2Fbin%0A%20%20curl%20-L%20https%3A%2F%2Fgithub.com%2Fcontainernetworking%2Fplugins%2Freleases%2Fdownload%2Fv1.4.0%2Fcni-plugins-linux-amd64-v1.4.0.tgz%20%7C%20tar%20-xz%20-C%20%2Fopt%2Fcni%2Fbin%0Afi%0A%0A%23%20Create%20containerd%20config%20directory%0Amkdir%20-p%20%2Fetc%2Fcontainerd%0A%0A%23%20Generate%20default%20containerd%20config%0Aif%20%5B%20!%20-f%20%2Fetc%2Fcontainerd%2Fconfig.toml%20%5D%3B%20then%0A%20%20%2Fusr%2Flocal%2Fbin%2Fcontainerd%20config%20default%20%3E%20%2Fetc%2Fcontainerd%2Fconfig.toml%0A%20%20%23%20Enable%20SystemdCgroup%0A%20%20sed%20-i%20's%2FSystemdCgroup%20%3D%20false%2FSystemdCgroup%20%3D%20true%2Fg'%20%2Fetc%2Fcontainerd%2Fconfig.toml%0Afi%0A%0A%23%20Load%20kernel%20modules%0Amodprobe%20overlay%0Amodprobe%20br_netfilter%0A%0A%23%20Apply%20sysctl%20settings%0Asysctl%20--system"
            }
          }
        ]
      },
      systemd = {
        units = [
          {
            name = "containerd-install.service"
            enabled = true
            contents = "[Unit]\nDescription=Install containerd and dependencies\nDefaultDependencies=no\nAfter=network-online.target\nWants=network-online.target\n\n[Service]\nType=oneshot\nRemainAfterExit=yes\nExecStart=/usr/local/bin/install-containerd.sh\n\n[Install]\nWantedBy=multi-user.target"
          },
          {
            name = "containerd.service"
            enabled = true
            contents = "[Unit]\nDescription=containerd container runtime\nDocumentation=https://containerd.io\nAfter=network.target local-fs.target containerd-install.service\nRequires=containerd-install.service\n\n[Service]\nExecStartPre=-/sbin/modprobe overlay\nExecStart=/usr/local/bin/containerd\nType=notify\nDelegate=yes\nKillMode=process\nRestart=always\nRestartSec=5\nLimitNPROC=infinity\nLimitCORE=infinity\nLimitNOFILE=infinity\nTasksMax=infinity\nOOMScoreAdjust=-999\n\n[Install]\nWantedBy=multi-user.target"
          }
        ]
      }
    })
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

# Outputs
output "vm_ip" {
  description = "IP address of the VM"
  value       = var.vm_ip
}
