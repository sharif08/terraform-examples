#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Install Bacula Backup Client Config
#
#
#
#
#
#
# Variables used in this script are from Terraform

    check_host_entry=$(cat /etc/hosts | grep -e "${backup_server_hostname}")

    if [ "$check_host_entry" == "" ]; then

       # Add the user  with a specific uid and a primary group of 'bacula'
       useradd bacula

       # Add Bacula Client Host Entry to /etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo " " >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "# BackUp-Server" >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${backup_server_ip} ${backup_server_hostname}" >> /etc/hosts'

       # Create Bacula client configuration file
       echo ${ADMIN_PASSWORD} | sudo -S cp /tmp/bacula-fd.conf /etc/bacula/bacula-fd.conf

       # Restart Bacula Service
       echo ${ADMIN_PASSWORD} | sudo -S systemctl restart bacula-fd
    fi
