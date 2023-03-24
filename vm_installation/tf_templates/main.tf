# Here is the provider details, which is Proxmox!
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = ">=2.9.3"
    }
  }
}

provider "proxmox" {
    # Proxmox api url (hostname or Ip of proxmox) with suffix :8006/api2/json
    pm_api_url = var.proxmox_api_url

    # Proxmox api token id which is in the form of <username>@pam!<tokenId>                    
    pm_api_token_id = var.proxmox_api_token_id

    # Proxmox api token secret which is genrated while creating api
    pm_api_token_secret = var.proxmox_api_token_secret

    # Plroxmox tls insecure, its about proxmox ssl certificate    
    pm_tls_insecure = var.proxmox_tls_insecure   

    # logging 
    pm_debug = var.proxmox_debug

}
