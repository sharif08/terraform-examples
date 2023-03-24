#!/bin/bash

#--> Versio 0.1
# This Script is used to Install Bacula Backup Server Config for a Backup Client
#
#
#
#
#
#
# Variables used in this script are from Terraform

    # Add additional directories for backup based on the VM Used for

    if [ "${VM_USED_FOR}" == "kubernetes" ]; then
       # Add additional directories for backup - for k8s-etcd cluster
       sed -i '/Include/a \    File = \/var\/lib\/kubelet' /tmp/client_host.conf

    elif [ "${VM_USED_FOR}" == "etcd" ]; then
       #Add additional directories for backup - for k8s-etcd cluster
       sed -i '/Include/a \    File = \/var\/lib\/etcd' /tmp/client_host.conf

    elif [ "${VM_USED_FOR}" == "jenkins" ]; then
       # Add additional directories for backup - for server jenkins
       sed -i '/Include/a \    File = \/var\/lib\/jenkins' /tmp/client_host.conf

    elif [ "${VM_USED_FOR}" == "proxmox" ]; then
       # Add additional directories for backup, if server is in group proxmox
       sed -i '/Include/a \    File = \/var\/lib\/pve' /tmp/client_host.conf
       sed -i '/Include/a \    File = \/var\/lib\/pve-cluster' /tmp/client_host.conf
       sed -i '/Include/a \    File = \/var\/lib\/pve-firewall' /tmp/client_host.conf
       sed -i '/Include/a \    File = \/var\/lib\/pve-manager' /tmp/client_host.conf

   elif [ "${VM_USED_FOR}" == "artifactory" ]; then
      # Add additional directories for backup - for server artifactory
      sed -i '/Include/a \    File = \/opt\/jfrog' /tmp/client_host.conf
      sed -i '/Include/a \    File = \/var\/opt\/jfrog' /tmp/client_host.conf

   elif [ "${VM_USED_FOR}" == "sonarqube" ]; then
      # Add additional directories for backup - for server sonarqube
      sed -i '/Include/a \    File = \/opt' /tmp/client_host.conf
   fi


    # Generate SSH key Pair for New Vms
    if [ ! -d "/home/${ADMIN_USER}/.ssh" ]; then

         # Install SSH PASS on Local VM
         echo ${ADMIN_PASSWORD} | sudo -S apt-get update
         echo ${ADMIN_PASSWORD} | sudo -S sudo -S apt-get install sshpass -y

         # generate key and then copy t ldap server
         ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
         sshpass -p  ${ADMIN_PASSWORD} ssh-copy-id  -o StrictHostKeyChecking=no ${ADMIN_USER}@${backup_server_ip}
    fi

    # Copy client_host.conf to Backup Server
    sshpass -p  ${ADMIN_PASSWORD} scp  -r /tmp/client_host.conf ${ADMIN_USER}@${backup_server_ip}:/tmp/
    sshpass -p  ${ADMIN_PASSWORD} scp  -r /tmp/bacula_server_config.sh ${ADMIN_USER}@${backup_server_ip}:/tmp/
