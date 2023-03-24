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
    mkdir  $ICINGA2_CLIENT_HOSTNAME
    touch  $ICINGA2_CLIENT_HOSTNAME/main.tf

echo  '
module "icinga2" {
    source                        =   "../"
    vm_ssh_user                   =   "'$ADMIN_USER'"
    vm_ssh_pass                   =   "'$ADMIN_PASSWORD'"
    icinga2_client_hostname       =   "'$ICINGA2_CLIENT_HOSTNAME'"
    icinga2_client_ip             =   "'$ICINGA2_CLIENT_IP'"
    icinga2_client_os             =   "'$ICINGA2_CLIENT_OS'"
    icinga2_client_os_name        =   "'$ICINGA2_CLIENT_OS_NAME'"
    icinga2_client_os_version     =   "'$ICINGA2_CLIENT_OS_VERSION'"
    icinga2_client_service_var    =   "'$ICINGA2_CLIENT_SERVICE_VR'"
    icinga2_client_snmp_type      =   "'$ICINGA2_CLIENT_SNMP_TYPE'"
    icinga2_client_ilom_ip        =   "'$ICINGA2_CLIENT_ILOM_IP'"
    icinga2_client_ilom_username  =   "'$ICINGA2_CLIENT_ILOM_USERNAME'"
    icinga2_client_ilom_password  =   "'$ICINGA2_CLIENT_ILOM_PASSWORD'"
    icinga2_server_container_name =   "'$ICINGA2_SERVER_CONTAINER_NAME'"
    icinga2_server_container_port =   "'$ICINGA2_SERVER_CONTAINER_PORT'"
    icinga2_server_host_name      =   "'$ICINGA2_SERVER_HOSTNAME'"
    icinga2_server_ip             =   "'$ICINGA2_SERVER_IP'"


}
' >> $ICINGA2_CLIENT_HOSTNAME/main.tf

    cd  $ICINGA2_CLIENT_HOSTNAME
    # Run Main
    # Run terraform init
    terraform init
    # Run terraform
    terraform apply -auto-approve

    cd ..
    rm -rf $ICINGA2_CLIENT_HOSTNAME
