#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Install VM on Proxmox
#
#
#
#
#
#
# Variables used in this script,
# if you add any new variables then please consider to add in 'example-env' file and use it in '.evn'
   # ENV file Path vm_installation$/.env
   source .values-env

   # Directory Path
   CLIENT_DIR_PATH="$BASE_DIR_PATH/$PROXMOX_HOST_NAME/$VM_HOST_ID_NAME"


   # Decrypt Public Key with vm client IP
   decrypt_ssh_global_mgms_public=$(gpg -d --batch --passphrase $ADMIN_PASSWORD  ../encrypted_ssh_keys/ssh_id_rsa.pub.gpg)


   # Create Dir Structure
   mkdir -p $CLIENT_DIR_PATH

   # Delete main file
   rm -rf $CLIENT_DIR_PATH/main.tf

   # Create main file
   touch $CLIENT_DIR_PATH/main.tf
   touch $CLIENT_DIR_PATH/outputs.tf
echo  '
module "proxmox" {
    source                    =   "../../../tf_templates"
    proxmox_api_url           =   "'$PROXMOX_URL'"
    proxmox_api_token_id      =   "terraform@ACCESS_TERRAFORM_API"
    proxmox_api_token_secret  =   "'$PROXMOX_API_SECRETS'"
    proxmox_debug             =   false
    proxmox_vm_node_count     =   '$VM_CREATE'
    proxmox_host_node         =   "'$PROXMOX_HOST_NAME'"
    vm_template_name          =   "'$VM_OS_TEMPLATE'"
    vm_cpu_cores              =   1
    vm_vm_memory              =   "'$VM_HOST_CLIENT_MEMORY'"
    vm_hdd_size               =   "'$VM_HOST_CLIENT_SIZE'"
    vm_disk_storage_type      =   "'$VM_HOST_CLIENT_STORAGE_TYPE'"
    public_ssh_key            =   "'$decrypt_ssh_global_mgms_public'  '$ADMIN_USER'@'$VM_HOST_CLIENT_IP'"
    vm_client_id_name         =   "'$VM_HOST_ID_NAME'"
}
' >> $CLIENT_DIR_PATH/main.tf
   ls -l
   # Run Main
   if [[ ! -f "$CLIENT_DIR_PATH/main.tf.gpg" ]]; then
     cd $CLIENT_DIR_PATH
        # Run terraform init
        terraform init
        # Run terraform
        terraform apply -auto-approve
     cd ../../../
     # Encrypt main.tf file
     gpg -c --batch --passphrase $ADMIN_PASSWORD  -o $CLIENT_DIR_PATH/main.tf.gpg $CLIENT_DIR_PATH/main.tf
     gpg -c --batch --passphrase $ADMIN_PASSWORD  -o $CLIENT_DIR_PATH/terraform.tfstate.gpg $CLIENT_DIR_PATH/terraform.tfstate
   else
     echo "the main.tf file exists, Can not Create Existing VM Again. Destory VM before Create"
  fi

  # Cleanup the file for security point before push to github
  if [[ -f "$CLIENT_DIR_PATH/main.tf" ]]; then
     rm -rf $CLIENT_DIR_PATH/main.tf
     rm -rf $CLIENT_DIR_PATH/.terraform
     rm -rf $CLIENT_DIR_PATH/.terraform.lock.hcl
     rm -rf $CLIENT_DIR_PATH/terraform.tfstate
  fi
