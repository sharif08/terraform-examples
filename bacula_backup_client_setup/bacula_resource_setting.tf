# Template File
data "template_file" "bacula_fd_config" {
  template = "${file("../bacula_templates/bacula-fd.conf.tpl")}"
  vars = {
    backup_server_hostname        = "${var.backup_server_hostname}"
    bacula_backup_pass            = "${var.bacula_backup_pass}"
    bacula_backup_client_hostname = "${var.bacula_backup_client_hostname}"
    bacula_backup_client_ip       = "${var.bacula_backup_client_ip}"
  }
}

data "template_file" "client_host_conf" {
  template = "${file("../bacula_templates/client_host.conf.tpl")}"
  vars = {
    bacula_backup_client_hostname = "${var.bacula_backup_client_hostname}"
    bacula_backup_client_ip       = "${var.bacula_backup_client_ip}"
    bacula_backup_pass            = "${var.bacula_backup_pass}"
    bacula_backup_restore_dir     = "${var.bacula_backup_restore_dir}"
  }
}

data "template_file" "bacula_client_install" {
  template = "${file("../bacula_templates/bacula_client_install.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    backup_server_hostname        = "${var.backup_server_hostname}"
    backup_server_ip              = "${var.backup_server_ip}"
  }
}

data "template_file" "bacula_server_config" {
  template = "${file("../bacula_templates/bacula_server_config.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    bacula_backup_client_hostname = "${var.bacula_backup_client_hostname}"
    bacula_backup_client_ip       = "${var.bacula_backup_client_ip}"

  }
}

data "template_file" "bacula_server_initial" {
  template = "${file("../bacula_templates/bacula_server_initial.sh.tpl")}"
  vars = {
    VM_USED_FOR                   = "${var.vm_used_for}"
    ADMIN_USER                    = "${var.vm_ssh_user}"
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    backup_server_ip              = "${var.backup_server_ip}"

  }
}




resource "null_resource" "backup_client_prepare" {

  # provide some connection info
  connection {
    host        = var.bacula_backup_client_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }


  provisioner "file" {
    content         = "${data.template_file.bacula_fd_config.rendered}"
    destination     = "/tmp/bacula-fd.conf"
  }

  provisioner "file" {
    content         = "${data.template_file.client_host_conf.rendered}"
    destination     = "/tmp/client_host.conf"
  }

  provisioner "file" {
    content         = "${data.template_file.bacula_client_install.rendered}"
    destination     = "/tmp/bacula_client_install.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.bacula_server_config.rendered}"
    destination = "/tmp/bacula_server_config.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.bacula_server_initial.rendered}"
    destination = "/tmp/bacula_server_initial.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bacula_client_install.sh /tmp/bacula_server_config.sh /tmp/bacula_server_initial.sh", 
        "bash /tmp/bacula_server_initial.sh",
        "bash /tmp/bacula_client_install.sh",
        #"echo ${var.vm_ssh_pass} | sudo -S reboot"
    ]
  }

}


# Connect to BackUp Server
resource "null_resource" "backup_server_prepare" {

  depends_on = [
    null_resource.backup_client_prepare,
  ]

  # provide some connection info
  connection {
    host        = var.backup_server_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/bacula_server_config.sh",
         "bash /tmp/bacula_server_config.sh",
         #"echo ${var.vm_ssh_pass} | sudo -S rm -rf /tmp/bacula_server_config.sh /tmp/client_host.conf /tmp/terraform*"
     ]
  }


}
