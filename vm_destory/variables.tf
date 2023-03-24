variable "vm_ssh_user" {
    description = "provide ssh user login"
    type = string
}


variable "vm_ssh_pass" {
    description = "provide ssh Admin password."
    type = string
}


variable "bacula_server_ip" {
    description = "provid Bacula Server IP."
    type = string
}

variable "destory_client_hostname" {
    description = "provide Client HostName to Cleanup."
    type = string
}

variable "destory_client_ip" {
    description = "provide Client IP to Cleanup."
    type = string
}


variable "ldap_server_container_name" {
    description = "provide Ldap Server Container Name to Connect."
    type = string
}


variable "ldap_existing_client_domain" {
    description = "provide Ldap Existing Domain Name to Connect."
    type = string
}


variable "ldap_server_ip" {
    description = "provide Ldap Server IP to Connect."
    type = string
}

variable "icinga2_server_ip" {
    description = "provide Icinga2 Server IP to Connect."
    type = string
}

