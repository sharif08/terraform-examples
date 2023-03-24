variable "vm_node_name" {
    description = "Name of the new vm name"
    type = string
}


variable "vm_ssh_user" {
    description = "provide ssh user login"
    type = string
}


variable "vm_ssh_pass" {
    description = "provide ssh password to login."
    type = string
}


variable "vm_client_ip" {
    description = "provide Client IP."
    type = string
}


variable "vm_client_gateway" {
    description = "provide Client gateway."
    type = string
}

variable "config_vlan" {
    description = "provide Client Vlan Tag."
}
