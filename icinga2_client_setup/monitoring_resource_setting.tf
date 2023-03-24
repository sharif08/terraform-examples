# Template File
data "template_file" "add_dlt_node" {
  template = "${file("../icinga2_templates/add-dlt-node.tpl")}"
  vars = {
    icinga2_client_hostname     = "${var.icinga2_client_hostname}"
    icinga2_client_ip           = "${var.icinga2_client_ip}"
    icinga2_client_os           = "${var.icinga2_client_os}"
    icinga2_client_os_name      = "${var.icinga2_client_os_name}"
    icinga2_client_os_version   = "${var.icinga2_client_os_version}"
    icinga2_client_service_var  = "${var.icinga2_client_service_var}"
  }
}

data "template_file" "add_host" {
  template = "${file("../icinga2_templates/add-host.tpl")}"
  vars = {
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
    icinga2_client_ip             = "${var.icinga2_client_ip}"
    icinga2_server_host_name      = "${var.icinga2_server_host_name}"
    icinga2_client_snmp_type      = "${var.icinga2_client_snmp_type}"
    icinga2_client_ilom_ip        = "${var.icinga2_client_ilom_ip}"
    icinga2_client_ilom_username  = "${var.icinga2_client_ilom_username}"
    icinga2_client_ilom_password  = "${var.icinga2_client_ilom_password}"
    icinga2_client_os             = "${var.icinga2_client_os}"
    icinga2_client_os_name        = "${var.icinga2_client_os_name}"
    icinga2_client_os_version     = "${var.icinga2_client_os_version}"
    icinga2_client_service_var    = "${var.icinga2_client_service_var}"
  }
}


data "template_file" "constants_conf" {
  template = "${file("../icinga2_templates/constants.conf.tpl")}"
  vars = {
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
  }
}


data "template_file" "dlt_zones" {
  template = "${file("../icinga2_templates/dlt_zones.tpl")}"
  vars = {
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
    icinga2_server_host_name      = "${var.icinga2_server_host_name}"
    icinga2_server_container_name = "${var.icinga2_server_container_name}"
    icinga2_client_ip             = "${var.icinga2_client_ip}"
  }
}


data "template_file" "certificate_handling" {
  template = "${file("../icinga2_templates/certificate-handling.sh.tpl")}"
  vars = {
    ADMIN_USER                    = "${var.vm_ssh_user}"
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    icinga2_server_ip             = "${var.icinga2_server_ip}"
    icinga2_server_container_name = "${var.icinga2_server_container_name}"
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
    icinga2_server_container_port = "${var.icinga2_server_container_port}"
    icinga2_server_zone           = "${var.icinga2_server_zone}"
    icinga2_client_os_version     = "${var.icinga2_client_os_version}"
  }

}

data "template_file" "icinga2_client_installation" {
  template = "${file("../icinga2_templates/icinga2_client_installation.sh.tpl")}"
  vars = {
    ADMIN_USER                    = "${var.vm_ssh_user}"
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
    icinga2_client_os_name        = "${var.icinga2_client_os_name}"
    icinga2_server_ip             = "${var.icinga2_server_ip}"
    icinga2_server_container_name = "${var.icinga2_server_container_name}"
    icinga2_server_container_port = "${var.icinga2_server_container_port}"


  }
}

data "template_file" "icinga2_server_config" {
  template = "${file("../icinga2_templates/icinga2_server_config.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD                = "${var.vm_ssh_pass}"
    icinga2_client_hostname       = "${var.icinga2_client_hostname}"
    icinga2_client_ip             = "${var.icinga2_client_ip}"
    icinga2_server_container_name = "${var.icinga2_server_container_name}"
    icinga2_server_container_port = "${var.icinga2_server_container_port}"
    icinga2_client_os_name        = "${var.icinga2_client_os_name}"

  }
}



# Connect to Monitoring Client
resource "null_resource" "icinga2_client_prepare" {



  # provide some connection info
  connection {
    host        = var.icinga2_client_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "file" {
    content     = "${data.template_file.add_dlt_node.rendered}"
    destination = "/tmp/add_dlt_node"
  }

  provisioner "file" {
    content     = "${data.template_file.add_host.rendered}"
    destination = "/tmp/add_host"
  }

  provisioner "file" {
    content     = "${data.template_file.constants_conf.rendered}"
    destination = "/tmp/constants_conf"
  }

  provisioner "file" {
    content     = "${data.template_file.dlt_zones.rendered}"
    destination = "/tmp/dlt_zones"
  }

  provisioner "file" {
    content     = "${data.template_file.certificate_handling.rendered}"
    destination = "/tmp/certificate_handling.sh"
  }


  provisioner "file" {
    content     = "${data.template_file.icinga2_client_installation.rendered}"
    destination = "/tmp/icinga2_client_installation.sh"
  }

  provisioner "remote-exec" {
    inline = [
         "chmod +x /tmp/icinga2_client_installation.sh /tmp/certificate_handling.sh",
         "bash /tmp/icinga2_client_installation.sh",
         "bash /tmp/certificate_handling.sh",
         #"rm -rf /tmp/icinga2_client_installation.sh /tmp/certificate_handling.sh /tmp/add_host /tmp/add_dlt_node /tmp/constants_conf"
     ]
  }


}


# Connect to Monitoring Server
resource "null_resource" "icinga2_server_prepare" {

  depends_on = [
    null_resource.icinga2_client_prepare,
  ]

  # provide some connection info
  connection {
    host        = var.icinga2_server_ip
    type        = "ssh"
    port        = 22
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }

  provisioner "file" {
    content     = "${data.template_file.icinga2_server_config.rendered}"
    destination = "/tmp/icinga2_server_config.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.add_dlt_node.rendered}"
    destination = "/tmp/add_dlt_node"
  }

  provisioner "file" {
    content     = "${data.template_file.add_host.rendered}"
    destination = "/tmp/add_host"
  }


  provisioner "remote-exec" {
    inline = [
         "chmod +x /tmp/icinga2_server_config.sh",
         "bash /tmp/icinga2_server_config.sh",
         #"rm -rf /tmp/icinga2_server_config.sh /tmp/add_host /tmp/add_dlt_node"

     ]
  }


}
