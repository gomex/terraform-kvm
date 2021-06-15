terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu+ssh://${var.kvm_user}@${var.kvm_host}/system"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "ubuntu-qcow2" {
  name   = var.domain_name
  pool   = "default"
  source = "http://dnsfilter-kvm-volume.s3-website-us-east-1.amazonaws.com/ubuntu-20.04-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

resource "libvirt_volume" "extra-storage-qcow2" {
  name   = "${var.domain_name}-extra_storage"
  pool   = "default"
  format = "qcow2"
  size = var.extra_storage_size
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    domain_name = var.domain_name
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
  vars = {
    ip_address = var.ip_address
    gateway4 = var.gateway4
    primary_nameserver = var.primary_nameserver
    secondary_nameserver = var.secondary_nameserver
  }
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${var.domain_name}.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = "default"
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  name   = var.domain_name
  memory = var.memory
  vcpu   = var.cpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge = "br0"
  }

  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  disk {
    volume_id = var.extra_storage ? libvirt_volume.extra-storage-qcow2.id : null
  }
  

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}