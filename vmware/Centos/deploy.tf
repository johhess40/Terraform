provider "vsphere" {
  user           = var.admin_creds.main.vsphere_user
  password       = var.admin_creds.main.vsphere_password
  vsphere_server = var.admin_creds.main.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "ace" {
  name = var.vm_data.data.data_center
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_data.data.data_store
  datacenter_id = data.vsphere_datacenter.ace.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vm_data.data.compute_cluster
  datacenter_id = data.vsphere_datacenter.ace.id
}

data "vsphere_network" "network" {
  name          = var.vm_data.data.vsphere_network
  datacenter_id = data.vsphere_datacenter.ace.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_data.data.template_name_relay
  datacenter_id = data.vsphere_datacenter.ace.id
}

data "vsphere_virtual_machine" "template2" {
  name          = var.vm_data.data.template_name_client
  datacenter_id = data.vsphere_datacenter.ace.id
}

output "data_center" {
  value = data.vsphere_datacenter.ace.name
}

output "data_center_id" {
  value = data.vsphere_datacenter.ace.id
}

output "compute_cluster" {
  value = data.vsphere_compute_cluster.cluster.name
}

output "network" {
  value = data.vsphere_network.network.name
}

output "vm_template" {
  value = data.vsphere_virtual_machine.template.name
}

resource "vsphere_virtual_machine" "vm_master" {
  name             = var.vm_var_master.vm_alpha.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_var_master.vm_alpha.num_cpus
  memory   = var.vm_var_master.vm_alpha.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_var_master.vm_alpha.host_name
        domain = var.vm_var_master.vm_alpha.domain
      }

      network_interface {
        ipv4_address = var.vm_var_master.vm_alpha.ipv4_address
        ipv4_netmask = var.vm_var_master.vm_alpha.ipv4_netmask
      }

      ipv4_gateway = var.vm_var_master.vm_alpha.ipv4_gateway

      dns_server_list = var.vm_var_master.vm_alpha.dns_server_list
    }
  }
  disk {
    label            = var.vm_var_master.vm_alpha.disk_label
    size             = data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.vm_vars

  name             = each.value["vm_name"]
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = each.value["num_cpus"]
  memory   = each.value["memory"]

  guest_id = data.vsphere_virtual_machine.template2.guest_id

  scsi_type = data.vsphere_virtual_machine.template2.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template2.network_interface_types[0]
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template2.id

    customize {
      linux_options {
        host_name = each.value["host_name"]
        domain = each.value["domain"]
      }

      network_interface {
        ipv4_address = each.value["ipv4_address"]
        ipv4_netmask = each.value["ipv4_netmask"]
      }

      ipv4_gateway = each.value["ipv4_gateway"]

      dns_server_list = each.value["dns_server_list"]
    }
  }
  disk {
    label            = each.value["disk_label"]
    size             = data.vsphere_virtual_machine.template2.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template2.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template2.disks[0].thin_provisioned
  }
}

resource "null_resource" "configurevsphere01" {

  provisioner "local-exec" {
    command = "export ANSIBLE_HOST_KEY_CHECKING=False"
  }
  depends_on = [
    vsphere_virtual_machine.vm[0], vsphere_virtual_machine.vm[1], vsphere_virtual_machine.vm_master
  ]
}

resource "null_resource" "configurevsphere02" {

  provisioner "local-exec" {
    command = "ansible-playbook ./playbooks/test_playbook.yml -i inventory.vmware.yml -vvvv"
  }
  depends_on = [
    null_resource.configurevsphere01
  ]
}