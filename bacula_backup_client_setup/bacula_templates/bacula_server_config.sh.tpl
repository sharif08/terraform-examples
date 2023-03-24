#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Install Bacula Backup Server Config for a Backup Client
#
#
#
#
#
#
# Variables used in this script are from Terraform

    # Create required directories for bacula client if it does not exist
    if [ ! -d "/mnt/data/backups/backup-server-files" ]; then

       mkdir -p /mnt/data/backups/backup-server-files
       mkdir -p /mnt/data/restore
       chown bacula:bacula /mnt/data/restore
       chown bacula:bacula /mnt/data/backups/backup-server-files
    fi

    check_host_entry=$(cat /etc/hosts | grep -e "${bacula_backup_client_hostname}")

    if [ "$check_host_entry" == "" ]; then

       # Add Bacula Client Host Entry to /etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo " " >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${bacula_backup_client_ip} ${bacula_backup_client_hostname}" >> /etc/hosts'

       # Create Bacula client configuration file
       echo ${ADMIN_PASSWORD} | sudo -S cp /tmp/client_host.conf /etc/bacula/conf.d/${bacula_backup_client_hostname}.conf
       echo ${ADMIN_PASSWORD} | sudo -S chmod 0666   /etc/bacula/conf.d/${bacula_backup_client_hostname}.conf
       echo ${ADMIN_PASSWORD} | sudo -S chown root:bacula /etc/bacula/conf.d/${bacula_backup_client_hostname}.conf

       # Restart Bacula Service
       # restart service on the server --> delegate_to doesn't work for handler
       echo ${ADMIN_PASSWORD} | sudo -S systemctl restart bacula-director
    fi
