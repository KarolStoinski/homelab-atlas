resource "proxmox_virtual_environment_vm" "empty_vm" {
  name      = "tf-empty-vm"
  node_name = "pve2"             # Proxmox node

  cpu {
    cores   = 2
    sockets = 1
  }

  memory {
    dedicated = 2048
  }

  scsi_hardware = "virtio-scsi-pci"

  # Root disk
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    iothread     = true
    size         = 20
  }

  # Network
  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  boot_order = ["scsi0"]

  # Optional: cloud-init not used since empty
}
