variable "vm_ssh_user" {
    description = "provide ssh user login"
    type = string
    sensitive = true
}


variable "vm_ssh_pass" {
    description = "provide ssh Admin password."
    type = string
    sensitive = true
}


variable "icinga2_client_hostname" {
    description = "provide icinga2 Client HostName."
    type = string
}

variable "icinga2_client_ip" {
    description = "provide icinga2 Client IP."
    type = string
}

variable "icinga2_client_os" {
    description = "provide icinga2 Client OS."
    type = string
    default = "Linux"
}

variable "icinga2_client_os_name" {
    description = "provide icinga2 Client OS name."
    type = string
    default = "ubuntu"
}


variable "icinga2_client_os_version" {
    description = "provide icinga2 Client OS Version."
    type = string
    default = "20.04"
}


variable "icinga2_client_service_var" {
    description = "provide icinga2 Client OS Service Var."
    type = string
    default = "no-swap"
}


variable "icinga2_server_host_name" {
    description = "provide icinga2 Server hostName."
    type = string
    default = "vie01-monitor01.r3c.mgms"
}


variable "icinga2_server_ip" {
    description = "provide icinga2 Server IP."
    type = string
    sensitive = true
}


variable "icinga2_client_snmp_type" {
    description = "provide icinga2 Client SMNP."
    type = string
}


variable "icinga2_client_ilom_ip" {
    description = "provide icinga2 ilom IP."
    type = string
}


variable "icinga2_client_ilom_username" {
    description = "provide icinga2 Client ilom User."
    type = string
}


variable "icinga2_client_ilom_password" {
    description = "provide icinga2 Client ilom Pass."
    type = string
}


variable "icinga2_server_container_name" {
    description = "provide icinga2 Server Container Name."
    type = string
    default = "vie01-icinga2-monitor01"
}


variable "icinga2_server_container_port" {
    description = "provide icinga2 Server Container Port."
    type = string
}

variable "icinga2_server_zone" {
    description = "provide icinga2 Server Zone."
    type = string
    default = "master"
}

