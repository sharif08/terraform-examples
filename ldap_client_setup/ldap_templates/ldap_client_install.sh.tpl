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
    check_host_entry=$(cat /etc/hosts | grep -e "${LDAP_SERVER_HOST01}")

    if [ "$check_host_entry" == "" ]; then

       # Add Entry inside /etc/hosts
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo " " >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "# Ldap Server" >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${LDAP_SERVER_IP01}  ${LDAP_SERVER_HOST01}.r3c.mgms ${LDAP_SERVER_HOST01}" >> /etc/hosts'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "${LDAP_SERVER_IP02}  ${LDAP_SERVER_HOST02}.r3c.mgms ${LDAP_SERVER_HOST02}" >> /etc/hosts'


       # Modify the time zone to vienna - CET
       echo ${ADMIN_PASSWORD} | sudo -S rm -rf /etc/localtime
       echo ${ADMIN_PASSWORD} | sudo -S ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime


       # Add Entry to resolce Config
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "nameserver: ${LDAP_SERVER_IP01}" >> /etc/resolvconf/resolv.conf.d/tail'
       echo ${ADMIN_PASSWORD} | sudo -S -- sh -c 'echo "nameserver: ${LDAP_SERVER_IP02}" >> /etc/resolvconf/resolv.conf.d/tail'
       #echo "session     required      pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session

    fi
    # Install Ldap Client
    echo ${ADMIN_PASSWORD} | sudo -S ipa-client-install --unattended -N \
         --domain=${LDAP_DOMAIN} \
         --server=${LDAP_SERVER_HOST01}.r3c.mgms \
         --realm=R3C.MGMS \
         --principal=admin \
         --password=${ADMIN_PASSWORD} \
         --mkhomedir \
         --hostname=${LDAP_CLIENT_FQDN}.${LDAP_DOMAIN}

    # Set Client Host Name
    echo ${ADMIN_PASSWORD} | sudo -S hostnamectl set-hostname ${LDAP_CLIENT_FQDN}
