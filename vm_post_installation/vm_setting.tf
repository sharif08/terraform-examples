# Template File
data "template_file" "consul_config" {
  template = "${file("${path.module}/vm_ip_setting.sh.tpl")}"
  vars = {
    ADMIN_PASSWORD = "${var.vm_ssh_pass}"
    VM_HOST_CLIENT_VLAN_TAG = "${var.config_vlan}"
    VM_HOST_CLIENT_IP = "${var.vm_client_ip}"
    VM_HOST_CLIENT_GW = "${var.vm_client_gateway}"
    VM_HOST_CLIENT_NAME = "${var.vm_node_name}"
  }
}

resource "null_resource" "hdd_config" {

  # provide some connection info
  connection {
    host        = "0.0.0.0"
    type        = "ssh"
    user        = "root"
    password    = var.vm_ssh_pass
  }


  provisioner "remote-exec" {
    inline = [
      "sgdisk --move-second-header /dev/sda",
      "parted -s /dev/sda 'resizepart 3 100%'",
      "pvresize /dev/sda3",
      "lvresize --extents +100%FREE --resizefs /dev/mapper/ubuntu--vg-ubuntu--lv"]
  }

}



resource "null_resource" "configure_host" {

  depends_on = [
    null_resource.hdd_config,
  ]

  # provide some connection info
  connection {
    host        = "0.0.0.0"
    type        = "ssh"
    user        = var.vm_ssh_user
    password    = var.vm_ssh_pass
  }


  provisioner "file" {
    content     = "${data.template_file.consul_config.rendered}"
    destination = "/tmp/vm_ip_setting.sh"
  }


  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/vm_ip_setting.sh", "bash /tmp/vm_ip_setting.sh", "echo 'All Config Changes Added - Done'"]
  }

}
