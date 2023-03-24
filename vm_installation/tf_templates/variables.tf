variable "proxmox_api_url" {
    description = "The URL for the Proxmox API."
    type = string
}


variable "proxmox_api_token_id" {
    description = "The ID of the API token used for authentication with the Proxmox API."
    type = string
}


variable "proxmox_api_token_secret" {
    description = "The secret value of the token used for authentication with the Proxmox API."
    type = string
}


variable "proxmox_tls_insecure" {
    description = "If the TLS connection is insecure (self-signed). This is usually the case."
    type = bool
    default = true
}


variable "proxmox_debug" {
    description = "If the debug flag should be set when interacting with the Proxmox API."
    type = bool
    default = true
}


variable "proxmox_vm_node_count" {
    description = " proxmox vm  count, i.e 1 to create vm and 0 to destory vm."
    type = number
}


variable "proxmox_host_node" {
    description = "The name of the proxmox node where VM going to created"
    type = string
}


variable "vm_template_name" {
    description = "The name of VM Template, which is used for creation of VM "
    type = string
}


variable "vm_vm_memory" {
    description = "The amount of memory in MiB to give the proxmox vm."
    type = number
    default = 1024
}


variable "vm_cpu_cores" {
    description = "The proxmox vm  CPU Core 1 or 2 or 3"
    type = number
    default = 1
}



variable "vm_hdd_size" {
    description = "The size of the hard disks. A numeric string with G, M, or K appended ex: 512M or 32G."
    type = string
    default = "10G"
}


variable "vm_disk_storage_type" {
    description = "The Promxox Storage type either NewDisk1 or local-lvm"
    type = string
    default = "NewDrive1"
}


variable "public_ssh_key" {
    description = "provide ssh public key set for the vm to be install."
    type = string
    sensitive = true
}


variable "vm_client_id_name" {
    description = "provide Client Id name."
}
