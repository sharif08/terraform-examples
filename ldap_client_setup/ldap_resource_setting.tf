# Template File
data "template_file" "ldap_client_prepare" {
  template = "${file("../ldap_templates/ldap_client_prepare.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD      = "${var.vm_ssh_pass}"
    ADMIN_USER          = "${var.vm_ssh_user}"
    LDAP_CONTAINER_NAME = "${var.ldap_server_m01_container}"
    LDAP_CLIENT_FQDN    = "${var.ldap_client_fqdn}"
    LDAP_CLIENT_IP      = "${var.ldap_client_ip}"
    LDAP_DOMAIN        = "${var.ldap_domain}"
    LDAP_SERVER_IP01   = "${var.ldap_server_m01_ip}"
  }
}

data "template_file" "ldap_client_install" {
  template = "${file("../ldap_templates/ldap_client_install.sh.tpl")}"
  vars = {
    LDAP_DOMAIN        = "${var.ldap_domain}"
    LDAP_SERVER_IP01   = "${var.ldap_server_m01_ip}"
    LDAP_SERVER_HOST01 = "${var.ldap_server_m01_fqdn}"
    LDAP_SERVER_IP02   = "${var.ldap_server_m02_ip}"
    LDAP_SERVER_HOST02 = "${var.ldap_server_m02_fqdn}"
    LDAP_CLIENT_FQDN   = "${var.ldap_client_fqdn}" 
    ADMIN_PASSWORD     = "${var.vm_ssh_pass}"
  }
}



resource "null_resource" "prepare" {

  # provide some connection info
  connection {
    host        = var.ldap_client_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }


  provisioner "file" {
    content     = "${data.template_file.ldap_client_prepare.rendered}"
    destination = "/tmp/ldap_client_prepare.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.ldap_client_install.rendered}"
    destination = "/tmp/ldap_client_install.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/ldap_client_prepare.sh", "chmod +x /tmp/ldap_client_install.sh", "bash /tmp/ldap_client_prepare.sh", "bash /tmp/ldap_client_install.sh"]
  }

}
