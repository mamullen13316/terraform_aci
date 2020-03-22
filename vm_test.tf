provider "vsphere" {
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_password}"
  vsphere_server       = "${var.vsphere_server}"
  allow_unverified_ssl = true
}
# Fetch the VMware Datacenter
data "vsphere_datacenter" "dc" {
  name = "Xentaurs"
}
# Fetch the Datastore
data "vsphere_datastore" "datastore" {
  name          = "vsanDatastore"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Fetch the cluster
data "vsphere_compute_cluster" "cluster" {
  name          = "LAB"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Fetch the template
data "vsphere_virtual_machine" "template" {
  name          = "centos7-template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Fetch the port group to assign to the VM vnic
data "vsphere_network" "network" {
  name          = "terraform_t1|MyApp|epg1"
#  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Define the VM
resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-centos7"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "Terraform_Test"
  num_cpus = 1
  memory = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = "10.1.1.10"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.1.1.1"
    }
  }
}
