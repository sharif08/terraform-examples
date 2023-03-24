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

    #Install latest version of icinga agent

     if [ "${icinga2_client_os_name}" == "ubuntu" ]; then
        echo ${ADMIN_PASSWORD} | sudo -S wget -O - https://packages.icinga.com/icinga.key | apt-key add -
        echo ${ADMIN_PASSWORD} | sudo -S echo "deb http://packages.icinga.com/debian icinga-$(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/icinga2.list
        echo ${ADMIN_PASSWORD} | sudo -S echo "deb-src http://packages.icinga.com/debian icinga-$(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/icinga2.list

        echo ${ADMIN_PASSWORD} | sudo -S apt-get update
        echo ${ADMIN_PASSWORD} | sudo -S apt-get install -y icinga2
        echo ${ADMIN_PASSWORD} | sudo -S apt-get install -y monitoring-plugins


        echo ${ADMIN_PASSWORD} | sudo -S systemctl start icinga2

        #Create host configuration file - non DLT nodes
        # when: os_name == "ubuntu"
        echo ${ADMIN_PASSWORD} | sudo -S cp  /tmp/add_host  /etc/icinga2/conf.d/${icinga2_client_hostname}.conf
        echo ${ADMIN_PASSWORD} | sudo -S chown nagios:nagios /etc/icinga2/conf.d/${icinga2_client_hostname}.conf
        echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /etc/icinga2/conf.d/${icinga2_client_hostname}.conf
    fi

     if [ "${icinga2_client_os_name}" == "debian" ]; then
        echo ${ADMIN_PASSWORD} | sudo -S wget -O - https://packages.icinga.com/icinga.key | apt-key add -
        echo ${ADMIN_PASSWORD} | sudo -S echo "deb http://packages.icinga.com/debian icinga-$(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/icinga2.list
        echo ${ADMIN_PASSWORD} | sudo -S echo "deb-src http://packages.icinga.com/debian icinga-$(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/icinga2.list

        echo ${ADMIN_PASSWORD} | sudo -S apt-get update
        echo ${ADMIN_PASSWORD} | sudo -S apt-get install -y icinga2
        echo ${ADMIN_PASSWORD} | sudo -S apt-get install -y monitoring-plugins


        echo ${ADMIN_PASSWORD} | sudo -S systemctl start icinga2


        # Create host configuration file - DLT nodes only
        # os_name == "debian"
        echo ${ADMIN_PASSWORD} | sudo -S cp /tmp/add-dlt-node /etc/icinga2/conf.d/${icinga2_client_hostname}.conf
        echo ${ADMIN_PASSWORD} | sudo -S chown nagios:nagios /etc/icinga2/conf.d/${icinga2_client_hostname}.conf
        echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /etc/icinga2/conf.d/${icinga2_client_hostname}.conf


       # delete old hosts.conf file on DLT nodes
       # os_name == "debian"
       echo ${ADMIN_PASSWORD} | sudo -S rm -rf /etc/icinga2/conf.d/hosts.conf

       # delete old constants.conf file on DLT nodes
       # os_name == "debian"
       echo ${ADMIN_PASSWORD} | sudo -S rm -rf /etc/icinga2/constants.conf


       # Create new constants configuration file - DLT nodes only
       # os_name == "debian"
       echo ${ADMIN_PASSWORD} | sudo -S cp /tmp/constants.conf /etc/icinga2/constants.conf
       echo ${ADMIN_PASSWORD} | sudo -S chown nagios:nagios /etc/icinga2/constants.conf
       echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /etc/icinga2/constants.conf

    fi
    #Add master to client /etc/hosts
    # Add Entry inside /etc/hosts
    echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo " " >> /etc/hosts'
    echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "# Ldap Server" >> /etc/hosts'
    echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${icinga2_server_ip}  ${icinga2_server_container_name}.r3c.mgms ${icinga2_server_container_name}" >> /etc/hosts'

    # Delete local zones.conf file
    echo ${ADMIN_PASSWORD} | sudo -S rm -rf /etc/icinga2/zones.conf

    # Set Permission to files
    echo ${ADMIN_PASSWORD} | sudo -S chown -R :nagios /etc/icinga2/conf.d/
    echo ${ADMIN_PASSWORD} | sudo -S chmod 0644 /etc/icinga2/conf.d/
    echo ${ADMIN_PASSWORD} | sudo find . -name "/etc/icinga2/conf.d/*.conf" -exec chmod 644 {} \;

    echo ${ADMIN_PASSWORD} | sudo -S chown -R :nagios /etc/icinga2/features-available
    echo ${ADMIN_PASSWORD} | sudo -S chmod 0775 /etc/icinga2/features-available
    echo ${ADMIN_PASSWORD} | sudo find . -name "/etc/icinga2/features-available/*.conf" -exec chmod 644 {} \;

    echo ${ADMIN_PASSWORD} | sudo -S systemctl restart icinga2


    if [ ! -d "/home/${ADMIN_USER}/.ssh" ]; then

         # Install SSH PASS on Local VM
         echo ${ADMIN_PASSWORD} | sudo -S apt-get update
         echo ${ADMIN_PASSWORD} | sudo -S sudo -S apt-get install sshpass -y

         # generate key and then copy t ldap server
         ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
    fi

    sshpass -p  ${ADMIN_PASSWORD} ssh-copy-id  -o StrictHostKeyChecking=no ${ADMIN_USER}@${icinga2_server_ip}
    ticket_id=$(sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${icinga2_server_ip} \
                'docker exec -it ${icinga2_server_container_name} /usr/sbin/icinga2 pki ticket --cn ${icinga2_client_hostname}')


    sed -i "s/ticket-replace/$ticket_id/g" /tmp/certificate_handling.sh
    sed -i -e "s/\r//g" /tmp/certificate_handling.sh

