resource "vsphere_virtual_machine" "vm" {
  for_each = { for idx in range(var.vsphere_vm_instance_count) :
    idx => idx
  }

  name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
  resource_pool_id          = var.use_compute_cluster ? data.vsphere_compute_cluster.cluster[0].resource_pool_id : data.vsphere_host.host[0].resource_pool_id
  datastore_id              = var.use_datastore_cluster ? null : data.vsphere_datastore.datastore[0].id
  datastore_cluster_id      = var.use_datastore_cluster ? data.vsphere_datastore_cluster.datastore_cluster[0].id : null
  folder                    = var.vsphere_folder
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  num_cores_per_socket      = var.vsphere_vm_cores_per_socket > 0 ? var.vsphere_vm_cores_per_socket : var.vsphere_vm_cpus
  cpu_hot_add_enabled       = var.vsphere_cpu_hot_add_enabled
  hv_mode                   = var.vsphere_hv_mode_enabled
  nested_hv_enabled         = var.vsphere_hv_mode_enabled != "hvOff" ? true : false
  memory                    = var.vsphere_vm_memory
  memory_hot_add_enabled    = var.vsphere_memory_hot_add_enabled
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id      = data.vsphere_network.network.id
    adapter_type    = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  cdrom {
    client_device = var.cdrom_enabled
  }

  dynamic "disk" {
    for_each = var.vsphere_vm_disks

    content {
      label       = disk.value.label
      size        = (disk.value.size > 0 ? disk.value.size : data.vsphere_virtual_machine.template.disks.0.size)
      unit_number = disk.value.unit_number
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      dynamic "windows_options" {
        for_each = var.vsphere_vm_os == "windows" ? [1] : []
        content {
          computer_name         = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}"
          join_domain           = var.domain
          domain_admin_user     = var.vsphere_user
          domain_admin_password = var.vsphere_password
        }
      }
      dynamic "linux_options" {
        for_each = var.vsphere_vm_os == "linux" ? [1] : []
        content {
          host_name = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}"
          domain    = var.domain
        }
      }
      network_interface {
        ipv4_address    = var.vsphere_vm_ipv4_address != null ? var.vsphere_vm_ipv4_address[each.value] : null
        ipv4_netmask    = var.vsphere_vm_ipv4_address != null ? var.vsphere_vm_ipv4_netmask : null
      }
      ipv4_gateway    = var.vsphere_vm_ipv4_address != null ? var.vsphere_vm_ipv4_gateway : null
      dns_server_list = var.vsphere_vm_ipv4_address != null ? var.vsphere_vm_dns_servers : null
    }
  }

  lifecycle {
    ignore_changes = [hv_mode, ept_rvi_mode]
  }
}