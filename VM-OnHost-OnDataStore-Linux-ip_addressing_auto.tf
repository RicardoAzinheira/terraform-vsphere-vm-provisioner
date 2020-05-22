//
//  Creation of VM resource: VM on Host, on DataStore, with Linux OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStore-Linux-ip_addressing_auto" {
  count = (var.vm_type == "host_datastore_linux_auto" ? var.vsphere_vm_instance_count : 0)
  name              = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id  = data.vsphere_host.host[0].resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore[0].id
  firmware          = data.vsphere_virtual_machine.template.firmware
  num_cpus          = var.vsphere_vm_cpus
  memory            = var.vsphere_vm_memory
  guest_id          = data.vsphere_virtual_machine.template.guest_id
  scsi_type         = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id      = data.vsphere_network.network.id
    adapter_type    = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = (var.vsphere_vm_disk-size > 0 ? var.vsphere_vm_disk-size : data.vsphere_virtual_machine.template.disks.0.size)
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        domain    = var.domain
      }
      network_interface {
      }

    }
  }
}