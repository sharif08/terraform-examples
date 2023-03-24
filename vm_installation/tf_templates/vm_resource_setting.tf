# Resouce Module
resource "proxmox_vm_qemu" "vie01-proxmox" {
  count       =  var.proxmox_vm_node_count
  name        =  var.vm_client_id_name
  target_node =  var.proxmox_host_node
  clone       =  var.vm_template_name
  agent       =  1
  os_type     =  "ubuntu"
  cores       =  var.vm_cpu_cores
  sockets     =  1
  cpu         =  "host"
  memory      =  var.vm_vm_memory
  scsihw      =  "virtio-scsi-pci"
  bootdisk    =  "scsi0"
  disk {
    slot      =  0
    size      =  var.vm_hdd_size
    type      =  "scsi"
    storage   =  var.vm_disk_storage_type
    iothread  =  1
  }
  network {
    model     =  "virtio"
    bridge    =  "vmbr0"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  sshkeys     = <<EOF
  ${var.public_ssh_key}
  EOF
}
