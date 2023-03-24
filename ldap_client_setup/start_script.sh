#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to run scripts on running VM
#
#
#
#
#
#
# Variables used in this script

    source .values-env
    # Create main file
    mkdir  $LDAP_CLIENT_FQDN
    touch  $LDAP_CLIENT_FQDN/main.tf

echo  '
module "proxmox" {
    source                    =   "../"
    vm_ssh_user               =   "'$ADMIN_USER'"
    vm_ssh_pass               =   "'$ADMIN_PASSWORD'"
    ldap_server_m01_ip        =   "'$LDAP_SERVER_IP01'"
    ldap_server_m01_fqdn      =   "'$LDAP_SERVER_HOST01'"
    ldap_server_m02_ip        =   "'$LDAP_SERVER_IP02'"
    ldap_server_m02_fqdn      =   "'$LDAP_SERVER_HOST02'"
    ldap_server_m01_container =   "'$LDAP_CONTAINER_NAME'"
    ldap_domain               =   "'$LDAP_DOMAIN'"
    ldap_client_fqdn          =   "'$LDAP_CLIENT_FQDN'"
    ldap_client_ip            =   "'$LDAP_CLIENT_IP'"



}
' >> $LDAP_CLIENT_FQDN/main.tf

    cd  $LDAP_CLIENT_FQDN
    # Run Main
    # Run terraform init
    terraform init
    # Run terraform
    terraform apply -auto-approve

    cd ..
    rm -rf $LDAP_CLIENT_FQDN
