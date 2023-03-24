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
    rm -rf $VM_HOST_CLIENT_NAME
    mkdir  $VM_HOST_CLIENT_NAME
    touch  $VM_HOST_CLIENT_NAME/main.tf

echo  '
module "post_installation" {
    source                    =   "../"
    vm_ssh_user               =   "'$ADMIN_USER'"
    vm_ssh_pass               =   "'$ADMIN_PASSWORD'"
    vm_client_ip              =   "'$VM_HOST_CLIENT_IP'"
    vm_client_gateway         =   "'$VM_HOST_CLIENT_GW'"
    config_vlan               =   "'$VM_HOST_CLIENT_VLAN_TAG'"
    vm_node_name              =   "'$VM_HOST_CLIENT_NAME'"

}
' >> $VM_HOST_CLIENT_NAME/main.tf

    cd  $VM_HOST_CLIENT_NAME
    # Run Main
    # Run terraform init
    terraform init
    # Run terraform
    tf_log=debug terraform apply  -auto-approve

    cd ..

    # Remove working Dir
    rm -rf $VM_HOST_CLIENT_NAME
