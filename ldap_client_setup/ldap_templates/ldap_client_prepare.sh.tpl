#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to add the entry to Ldap Server
#
#
#
#
# Variables used in this script from provision_script.sh file

    # Generate SSH key Pair for New Vms
    if [ ! -d "/home/${ADMIN_USER}/.ssh" ]; then

         echo ${ADMIN_PASSWORD} | sudo -S hostnamectl set-hostname ${LDAP_CLIENT_FQDN}

         # Install SSH PASS on Local VM
         echo ${ADMIN_PASSWORD} | sudo -S apt-get update
         echo ${ADMIN_PASSWORD} | sudo -S sudo -S apt-get install sshpass -y

         # generate key and then copy t ldap server
         ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
         sshpass -p  ${ADMIN_PASSWORD} ssh-copy-id  -o StrictHostKeyChecking=no ${ADMIN_USER}@${LDAP_SERVER_IP01}
    fi


    # Login to kinit admin
    sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${LDAP_SERVER_IP01} \
               'docker exec -it ${LDAP_CONTAINER_NAME}  bash -c "echo ${ADMIN_PASSWORD} | kinit admin"'

    # check the record exit are not
    dnsrecord_find=`sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${LDAP_SERVER_IP01} \
                      'docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa dnsrecord-find ${LDAP_DOMAIN} --name=${LDAP_CLIENT_FQDN}" | grep -e "Record name:"'`

    # if the Condition pass then only add the entry to Ldap Server
    if [ "$dnsrecord_find" = "" ] ; then

         LDAP_ARPA=$(echo ${LDAP_CLIENT_IP} | awk 'BEGIN{FS="."}{print $3"."$2"."$1".in-addr.arpa."}')
         LDAP_IP_LAST_DIGIT=$(echo ${LDAP_CLIENT_IP} | awk -F. -v OFS=. '{print $4 }')

         #Add DNS Entry Record
         sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${LDAP_SERVER_IP01} \
                'docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa dnsrecord-add ${LDAP_DOMAIN} ${LDAP_CLIENT_FQDN} --a-rec ${LDAP_CLIENT_IP}"'

         #Add Revers DNS Entry
         sshpass -p ${ADMIN_PASSWORD} ssh  -o LogLevel=QUIET -t ${ADMIN_USER}@${LDAP_SERVER_IP01} \
                'docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa dnsrecord-add "'$LDAP_ARPA'" "'$LDAP_IP_LAST_DIGIT'" --ptr-rec ${LDAP_CLIENT_FQDN}.${LDAP_DOMAIN}."
        #ipa service-add-host --hosts=${LDAP_CLIENT_FQDN}.${LDAP_DOMAIN}  HTTP/${LDAP_CLIENT_FQDN}.${LDAP_DOMAIN}"'

    fi

