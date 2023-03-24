#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Destroy VM
# gpg -d --batch --passphrase 1234 -o sharif file.gpg
# gpg -c --batch --passphrase 1234 -o file.gpg all_ssh_key/ssh_global_mgms
#
#
#
#
# Variables used in this script
# if you add any new variables then please consider to add in 'example-env' file and use it in '.evn'
   # ENV file Path vm_installation$/.env
   source .values-env

   BASE_DIR_PATH="../vm_installation/general_vms"
   CLIENT_DIR_PATH="$BASE_DIR_PATH/$PROXMOX_HOST_NAME/$VM_HOST_CLIENT_ID"

    # Step 1
    # CleanUp the existing entrys before destory vms
    # Create main file
    mkdir  $DESTORY_CLIENT_HOSTNAME
    touch  $DESTORY_CLIENT_HOSTNAME/main.tf


echo  '
module "destory" {
    source                         =   "../"
    vm_ssh_user                    =   "'$ADMIN_USER'"
    vm_ssh_pass                    =   "'$ADMIN_PASSWORD'"
    bacula_server_ip               =   "'$BACKUP_SERVER_IP'"
    destory_client_hostname        =   "'$DESTORY_CLIENT_HOSTNAME'"
    destory_client_ip              =   "'$DESTORY_CLIENT_IP'"
    ldap_server_container_name     =   "'$LDAP_SERVER_CONTAINER_NAME'"
    ldap_existing_client_domain    =   "'$LDAP_EXSTING_CLIENT_DOMAIN'"
    ldap_server_ip                 =   "'$LDAP_SERVER_IP'"
    icinga2_server_ip              =   "'$ICINGA2_SERVER_IP'"

}
' >> $DESTORY_CLIENT_HOSTNAME/main.tf

    cd  $DESTORY_CLIENT_HOSTNAME
    # Run Main
    # Run terraform init
    terraform init
    # Run terraform
    terraform apply -auto-approve

    cd ..
    rm -rf $DESTORY_CLIENT_HOSTNAME

   # Step 2
   # Destory VM from Promox
   # Run Main
     if [[ -f "$CLIENT_DIR_PATH/main.tf.gpg" ]]; then

        # Decrypt GPG files
        gpg -d --batch --passphrase $ADMIN_PASSWORD  -o $CLIENT_DIR_PATH/main.tf $CLIENT_DIR_PATH/main.tf.gpg
        gpg -d --batch --passphrase $ADMIN_PASSWORD  -o $CLIENT_DIR_PATH/terraform.tfstate $CLIENT_DIR_PATH/terraform.tfstate.gpg

        sed -i -e 's/    proxmox_vm_node_count     =   1/    proxmox_vm_node_count     =   0/' $CLIENT_DIR_PATH/main.tf

        cd $CLIENT_DIR_PATH
           # Run terraform init
           terraform init
           # Run terraform
           terraform apply -auto-approve
        cd ../../../
     else
        echo "noting apply"
     fi

     # Cleanup the file for security point before push to githu
     if [[ -f "$CLIENT_DIR_PATH/main.tf" ]]; then
       rm -rf $CLIENT_DIR_PATH/main.tf
       rm -rf $CLIENT_DIR_PATH
       echo "Completey Removed"
     fi
