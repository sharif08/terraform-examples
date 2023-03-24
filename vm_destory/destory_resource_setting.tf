# Template File
data "template_file" "destory_ldap_client" {
  template = "${file("../destory_templates/destory_ldap_client.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD       = "${var.vm_ssh_pass}"
    LDAP_CLIENT_IP       = "${var.destory_client_ip}"
    LDAP_CONTAINER_NAME  = "${var.ldap_server_container_name}"
    LDAP_DOMAIN          = "${var.ldap_existing_client_domain}"
    VM_HOST_CLIENT_NAME  = "${var.destory_client_hostname}"
  }
}


resource "null_resource" "delete_monitoring_entry" {

  # provide some connection info
  connection {
    host        = var.icinga2_server_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "remote-exec" {
    inline = [
          "echo ${var.vm_ssh_pass} | sudo -S  sed -i '/${var.destory_client_hostname}/d' /etc/hosts",
          "echo ${var.vm_ssh_pass} | sudo -S rm /home/mgms-admin/.icinga2/data/icinga/etc/icinga2/zones.d/master/${var.destory_client_hostname}.conf",
          "docker exec -it vie01-icinga2-monitor01 bash -c 'service icinga2 reload'"
    ]
  }

}

resource "null_resource" "delete_backup_entry" {

  depends_on = [
    null_resource.delete_monitoring_entry,
  ]


  # provide some connection info
  connection {
    host        = var.bacula_server_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "remote-exec" {
    inline = [
          "echo ${var.vm_ssh_pass} | sudo -S  sed -i '/${var.destory_client_hostname}/d' /etc/hosts",
          "echo ${var.vm_ssh_pass} | sudo -S rm /etc/bacula/conf.d/${var.destory_client_hostname}.conf",
          "echo ${var.vm_ssh_pass} | sudo -S systemctl restart bacula-director"
    ]
  }

}


resource "null_resource" "delete_ldap_entry" {

  depends_on = [
    null_resource.delete_backup_entry,
  ]

  # provide some connection info
  connection {
    host        = var.ldap_server_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "file" {
    content     = "${data.template_file.destory_ldap_client.rendered}"
    destination = "/tmp/destory_ldap_client.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/destory_ldap_client.sh",
        "sh /tmp/destory_ldap_client.sh",
        "rm -rf /tmp/destory_ldap_client.sh"
    ]
  }

}
