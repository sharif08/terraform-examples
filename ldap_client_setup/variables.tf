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


variable "ldap_server_m01_ip" {
    description = "provide Ldap Server Master01 IP."
}


variable "ldap_server_m01_fqdn" {
    description = "provide Ldap Server Master01 HostName."
}


variable "ldap_server_m02_ip" {
    description = "provide Ldap Server Master02 IP."
}


variable "ldap_server_m02_fqdn" {
    description = "provide Ldap Server Master02 HostName."
}


variable "ldap_server_m01_container" {
    description = "provide Ldap Server Master01 Contianer Name."
    type = string
}


variable "ldap_domain" {
    description = "provide Ldap Server Domain."
    type = string
}



variable "ldap_client_fqdn" {
    description = "provide Ldap Client HostName."
    type = string
}


variable "ldap_client_ip" {
    description = "provide Ldap Client IP."
    sensitive = true
}
