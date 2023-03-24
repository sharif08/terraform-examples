#!/bin/bash


cat > ~/00-installer-config.yaml  << EOF

# This is the network config written by 'subiquity'
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      match:
        name: ens18
  vlans:
    vlan.${VM_HOST_CLIENT_VLAN_TAG}:
      id: ${VM_HOST_CLIENT_VLAN_TAG}
      link: ens18
      dhcp4: no
      addresses: [${VM_HOST_CLIENT_IP}/24]
      gateway4: ${VM_HOST_CLIENT_GW}
      nameservers:
        addresses: [8.8.8.8]

# Old Auto Generated Config
# This is the network config written by 'subiquity'
#network:
#  ethernets:
#    ens18:
#      addresses:
#      - ${VM_HOST_CLIENT_IP}/24
#      gateway4: ${VM_HOST_CLIENT_GW}
#      nameservers:
#        addresses:
#        - 8.8.8.8
#  version: 2
EOF

echo '${ADMIN_PASSWORD}' | sudo -S mv ~/00-installer-config.yaml /etc/netplan/00-installer-config.yaml

sudo hostnamectl set-hostname ${VM_HOST_CLIENT_NAME}

sudo netplan apply

# Disable Root Access
sudo sed -i 's/PermitRootLogin yes/ /' /etc/ssh/sshd_config
sudo systemctl restart ssh
