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

     # Run on Master
     #generate ticket on the icinga2 master and save it as a variable - Run on Icinga2 server
     #ticket_id=$(docker exec -it ${icinga2_server_container_name} /usr/sbin/icinga2 pki ticket --cn ${icinga2_client_hostname})



    # Run on Client
    if [ ! -d "/etc/icinga2/pki" ]; then
       useradd nagios
       echo ${ADMIN_PASSWORD} | sudo -S mkdir -p  /etc/icinga2/pki
       echo ${ADMIN_PASSWORD} | sudo -S chown nagios:nagios /etc/icinga2/pki

         ticket_id=$(sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${icinga2_server_ip} \
                     'docker exec -it ${icinga2_server_container_name} /usr/sbin/icinga2 pki ticket --cn ${icinga2_client_hostname}')

       # Create local cert
       echo ${ADMIN_PASSWORD} | sudo -S icinga2 pki new-cert --cn ${icinga2_client_hostname} --key /etc/icinga2/pki/${icinga2_client_hostname}.key  --cert /etc/icinga2/pki/${icinga2_client_hostname}.crt

       #  Save the masters cert as trustedcert
       echo ${ADMIN_PASSWORD} | sudo -S icinga2 pki save-cert --key /etc/icinga2/pki/${icinga2_client_hostname}.key \
          --cert /etc/icinga2/pki/${icinga2_client_hostname}.crt --trustedcert /etc/icinga2/pki/trusted-master.crt --host ${icinga2_server_ip}

       # Request the certificate from the icinga2 server
       # --ticket "$ticket_id"
       echo ${ADMIN_PASSWORD} | sudo -S icinga2 pki request --host ${icinga2_server_ip} --port ${icinga2_server_container_port} \
                                  --ticket ticket-replace --key /etc/icinga2/pki/${icinga2_client_hostname}.key --cert /etc/icinga2/pki/${icinga2_client_hostname}.crt \
                                       --trustedcert /etc/icinga2/pki/trusted-master.crt --ca /etc/icinga2/pki/ca.key


       # Recursively change ownership of /etc/icinga2 - the first time
       #echo ${ADMIN_PASSWORD} | sudo -S chown nagios:nagios /etc/icinga2


       # icinga2 node setup ubuntu 20.04"
       # when: os_version == "20.04"
       # --ticket "$ticket_id"
       if [ "${icinga2_client_os_version}" == "20.04" ]; then
          echo ${ADMIN_PASSWORD} | sudo -S icinga2 node setup --ticket ticket-replace --endpoint ${icinga2_server_container_name} \
                                  --zone ${icinga2_client_hostname} --parent_host ${icinga2_server_container_name} --trustedcert /etc/icinga2/pki/trusted-master.crt \
                                      --parent_zone ${icinga2_server_zone} --accept-config --accept-commands --disable-confd --cn ${icinga2_client_hostname}
       # os_version == "18.04" or os_name == "debian"
       # --ticket "$ticket_id"
       elif [ "${icinga2_client_os_version}" == "18.04" ]; then
          echo ${ADMIN_PASSWORD} | sudo -S icinga2 node setup --ticket ticket-replace --endpoint ${icinga2_server_container_name} \
                                 --zone ${icinga2_client_hostname} --master_host ${icinga2_server_container_name} --trustedcert /etc/icinga2/pki/trusted-master.crt \
                                      --accept-config --accept-commands --cn ${icinga2_client_hostname}

      elif [ "${icinga2_client_os_version}" == "debian" ]; then
          echo ${ADMIN_PASSWORD} | sudo -S icinga2 node setup  --ticket ticket-replace --endpoint ${icinga2_server_container_name} \
                                 --zone ${icinga2_client_hostname} --master_host ${icinga2_server_container_name} --trustedcert /etc/icinga2/pki/trusted-master.crt \
                                      --accept-config --accept-commands --cn ${icinga2_client_hostname}
      fi
      # Override zones configuration file
      if [ "${icinga2_client_os_version}" == "debian" ]; then
         echo ${ADMIN_PASSWORD} | sudo -S cp /tmp/dlt_zones /etc/icinga2/zones.conf
         echo ${ADMIN_PASSWORD} | sudo -S chown -R:nagios /etc/icinga2/zones.conf
         echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /etc/icinga2/zones.conf
      fi
      # Recursively change ownership of /etc/icinga2 - the second time"
      #echo ${ADMIN_PASSWORD} | sudo -S chown -R:nagios /etc/icinga2
   fi
   echo ${ADMIN_PASSWORD} | sudo -S systemctl restart icinga2
