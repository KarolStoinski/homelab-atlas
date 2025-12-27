# My HomeLab Cluster: Atlas
This repository stores all my homelab configurations. I use it to test various tools,
including Terraform, Ignition, and FluxCD.
Everything is deployed on my home Proxmox cluster.

# Hardware
- 2x HP EliteDesk 800 G2 - Intel Core i5, 16GB RAM, 128GB SSD
- 1x HP EliteDesk 800 G2 - Intel Core i5, 8GB RAM, 128GB SSD
- 1x HP EliteDesk 800 G2 - Intel Core i5, 16GB RAM, 1TB HDD
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
- Ignition
- FluxCD

# IDE and Tools
- JetBrains IntelliJ IDEA 2025.3
- Junie
- Claude
- 1Password

# Secrets management
All cluster connection secrets are stored in 1Password and loaded via `op run` command. 

# Initial Setup (2025-12-26)
The Proxmox cluster and backup server were deployed manually.
I also installed a Debian VM and a MikroTik RouterOS CHR VM.
Debian will be used as a development/debug machine within the cluster,
while RouterOS will manage network access to and from the VMs.
The MikroTik VM has internet access and two interfaces:
one for the internal VM network and one for the internet.

# Next Steps
- ~~Connect Terraform to the PVE cluster. (done 2025-12-26)~~
- ~~Deploy a simple Fedora CoreOS VM on the cluster using Terraform. (done 2025-12-26)~~
  - ~~This VM will serve as an HTTP server for Ignition configurations.~~
    ~~EDIT 2025-12-26: Won't be needed anymore. I can use Cloud Init to inject Ignition configs.~~
- Create a Terraform module for Fedora CoreOS VMs.
- Deploy three Fedora CoreOS VMs on the cluster to serve as Kubernetes control plane nodes.
- Deploy three Fedora CoreOS VMs on the cluster to serve as Kubernetes worker nodes.
- Write a tutorial on how to prepare a Fedora CoreOS VM Template for Terraform.