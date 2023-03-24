#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Install Ldap Client
#
#
#
#
#
#
# Variables used in this script
       # Add Entry inside /etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo " " >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "# Ldap Server" >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${icinga2_client_ip}  ${icinga2_client_hostname}.r3c.mgms ${icinga2_client_hostname}" >> /etc/hosts'

       # Copy server hosts file to a container volume"
       echo ${ADMIN_PASSWORD} | sudo -S  cp /etc/hosts /home/mgms-admin/.icinga2/data/icinga/etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S  chown mgms-admin:mgms-admin /home/mgms-admin/.icinga2/data/icinga/etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S  chmod 0644 /home/mgms-admin/.icinga2/data/icinga/etc/hosts

       # Copy hosts file to /etc/hosts
       docker exec -it ${icinga2_server_container_name} cp /etc/icinga2/hosts /etc/hosts

       # Copy client configuration file to server
       if [ "${icinga2_client_os_name}" == "ubuntu" ]; then
          echo ${ADMIN_PASSWORD} | sudo -S cp  /tmp/add_host  /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf
          echo ${ADMIN_PASSWORD} | sudo -S chown mgms-admin:mgms-admin /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf
          echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf

          #Create host configuration file - non DLT nodes

       elif [ "${icinga2_client_os_name}" == "debian" ]; then
          # Create host configuration file - DLT nodes only
          # os_name == "debian"
          echo ${ADMIN_PASSWORD} | sudo -S cp  /tmp/add_dlt_node  /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf
          echo ${ADMIN_PASSWORD} | sudo -S chown mgms-admin:mgms-admin /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf
          echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${icinga2_client_hostname}.conf

       fi

       # Set permissions
       docker exec -it ${icinga2_server_container_name} bash -c 'chown -R nagios:nagios /etc/icinga2/'

       # Reload Icinga master configuration"
       docker exec -it ${icinga2_server_container_name} bash -c 'service icinga2 reload'
