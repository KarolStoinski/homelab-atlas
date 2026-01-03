# My HomeLab Cluster: Atlas
This repository stores all my homelab configurations. I use it to test various tools,
including Terraform, Ignition, and FluxCD.
Everything is deployed on my home Proxmox cluster.

# Hardware
- 3x HP EliteDesk 800 G2 - Intel Core i5, 16GB RAM, 128GB SSD
- 1x HP EliteDesk 800 G2 - Intel Core i5, 8GB RAM, 1TB HDD
- Netgear ReadyNAS 102 - 2 x 2TB HDD

# Hypervisor Cluster
Three of the machines are running Proxmox VE 8.1 and are connected into a single cluster.
One of the machines is running Proxmox Backup Server 3.1.

# Purpose
I want to learn more about bare-metal clusters and how to deploy them.
I am proficient with Kubernetes and FluxCD, but I want to deepen my knowledge of the
underlying infrastructure—specifically High Availability, Disaster Recovery, Scalability, and Security.

# Development and Deployment Tools
- Terraform
- Butane
- Ignition
- FluxCD

# IDE and Tools
- JetBrains IntelliJ IDEA 2025.3
- Junie
- Claude
- 1Password CLI
- ~~PowerShell on Windows 11~~ (edit: I've switched development to CachyOS entirely. I connect to it through RDP)
- CachyOS

# Thoughts on CachyOS
Hey! Is it for real? A Linux distro that just works... and with working RDP?!
That's a first :O I would seriously consider using it as my daily driver if I were working on a PC full-time.

# Secrets management
All cluster connection secrets are stored in 1Password and loaded via `op run` command. 

# Initial Setup (2025-12-26)
The Proxmox cluster and backup server were deployed manually.
I also installed a CachyOS VM and a MikroTik RouterOS CHR VM.
CachyOS will be used as a development/debug machine within the cluster,
while RouterOS will manage network access to and from the VMs.
The MikroTik VM has internet access and two interfaces:
one for the internal VM network and one for the internet.

# Prerequisites
Upload fedora-coreos-43.20251120.3.0-proxmoxve.x86_64.qcow2
from their website into readynas-smb-diskimage share as 
import/fedora-coreos-43.20251120.3.0-proxmoxve.x86_64.qcow2

# Next Steps
- ~~Connect Terraform to the PVE cluster. (done 2025-12-26)~~
- ~~Deploy a simple Fedora CoreOS VM on the cluster using Terraform.~~
  - ~~This VM will serve as an HTTP server for Ignition configurations.~~
    ~~EDIT 2025-12-26: Won't be needed anymore. I can use Cloud Init to inject Ignition configs.~~
- ~~Create a Terraform module for Fedora CoreOS VMs.~~
- ~~Write a tutorial on how to prepare a Fedora CoreOS VM Template for Terraform. (edit: won't do this. I've replaced template with importing qcow image into smb share)~~
- ~~Add static IPs for the Fedora CoreOS VMs in the Terraform module.~~
- ~~Deploy three Fedora CoreOS VMs on the cluster to serve as Kubernetes control plane nodes.~~
- ~~Create a Terraform module for checking cluster node readiness.~~
- ~~Deploy three Fedora CoreOS VMs on the cluster to serve as Kubernetes worker nodes.~~
- ~~Install FluxCD on the cluster using Terraform.~~
- ~~Deploy metallb on the cluster using FluxCD.~~
- ~~Deploy ingress-nginx on the cluster using FluxCD.~~
- Deploy SealedSecrets with ui on the cluster using FluxCD.
- Deploy FluxCD dashboard.
- Add cert-manager with ovh webhook.
- Install Grafana on the cluster using FluxCD.
- Experiment with cri-o instead of containerd.
- Replace flannel with calico.