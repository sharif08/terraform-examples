variable "vm_ssh_user" {
    description = "provide ssh user login"
    type = string
}


variable "vm_ssh_pass" {
    description = "provide ssh Admin password."
    type = string
}


variable "backup_server_hostname" {
    description = "provide Bacula Server Hostname"
    type       = string
    default    = "vie01-bkp01"
    sensitive  = true
}


variable "backup_server_ip" {
    description = "provide Bacula Server IP"
    type        = string
}


variable "bacula_backup_pass" {
    description = "provide Bacula Server Backup Pass"
    type      = string
    default   = "backuppassword"
    sensitive = true
}


variable "bacula_backup_restore_dir" {
    description = "provide Bacula Backup Restore Dir Path"
    type        = string
    default     = "/mnt/data/restore"
}


variable "bacula_backup_client_hostname" {
    description = "provide Bacula Client Backup HostName"
    type = string
}


variable "bacula_backup_client_ip" {
    description = "provide Bacula Client Backup IP"
    type = string
}


variable "vm_used_for" {
    description = "provide Bacula Client Used for either Kubernetes,etcd, jenkins ..."
    type = string
}

