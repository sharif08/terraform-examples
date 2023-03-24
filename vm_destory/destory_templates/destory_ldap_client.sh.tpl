#!/usr/bin/env bash

#--> Versio 0.1
# This Script is used to Destroy VM
#
#
#
#
# Variables used in this script
# if you add any new variables then please consider to add in 'example-env' file and use it in '.evn' via terraform
   # Cleanup Ldap Server Entry

     LDAP_ARPA=$(echo ${LDAP_CLIENT_IP} | awk 'BEGIN{FS="."}{print $3"."$2"."$1".in-addr.arpa."}')
     LDAP_IP_LAST_DIGIT=$(echo ${LDAP_CLIENT_IP} | awk -F. -v OFS=. '{print $4 }')

     # Login to Admin
     docker exec -it ${LDAP_CONTAINER_NAME}  bash -c "echo ${ADMIN_PASSWORD} | kinit admin"

     # Delete DNS Zone Entry
     docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa dnsrecord-del ${LDAP_DOMAIN} ${VM_HOST_CLIENT_NAME} --a-rec ${LDAP_CLIENT_IP}"

     # Delete DNS Revers Entry
     docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa dnsrecord-del "$LDAP_ARPA" "$LDAP_IP_LAST_DIGIT" --ptr-rec ${VM_HOST_CLIENT_NAME}.${LDAP_DOMAIN}."

     # Delete Host Entry
     docker exec -it  ${LDAP_CONTAINER_NAME}  bash -c "ipa host-del ${VM_HOST_CLIENT_NAME}.${LDAP_DOMAIN}"
