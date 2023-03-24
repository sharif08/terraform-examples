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
    mkdir  $BACKUP_CLIENT_HOSTNAME
    touch  $BACKUP_CLIENT_HOSTNAME/main.tf

echo  '
module "bacula_backup" {
    source                        =   "../"
    vm_ssh_user                   =   "'$ADMIN_USER'"
    vm_ssh_pass                   =   "'$ADMIN_PASSWORD'"
    backup_server_hostname        =   "'$BACKUP_SERVER_HOSTNAME'"
    backup_server_ip              =   "'$BACKUP_SERVER_IP'"
    bacula_backup_client_hostname =   "'$BACKUP_CLIENT_HOSTNAME'"
    bacula_backup_client_ip       =   "'$BACKUP_CLIENT_IP'"
    vm_used_for                   =   "'$BACKUP_CLIENT_USED_FOR'"


}
' >> $BACKUP_CLIENT_HOSTNAME/main.tf

    cd  $BACKUP_CLIENT_HOSTNAME
    # Run Main
    # Run terraform init
    terraform init
    # Run terraform
    terraform apply -auto-approve

    cd ..
    rm -rf $BACKUP_CLIENT_HOSTNAME
