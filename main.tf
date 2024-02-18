 # 1 Creation of VM resource: VM on Compute Cluster, on DataStore, and automatic IP addressing (DHCP).
resource "vsphere_virtual_machine" "vm_cluster_datastore_dhcp" {
  for_each = { for idx in range(var.vsphere_vm_instance_count) :
    idx => idx
  if (var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == false && var.use_compute_cluster == true)}

  name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
  resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  folder                    = var.vsphere_folder
  datastore_id              = data.vsphere_datastore.datastore[0].id
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
      }
    }
  }
  lifecycle {
    ignore_changes = [hv_mode, ept_rvi_mode]
  }
}

 # 2 Creation of VM resource: VM on Compute Cluster, on DataStore, and manually defined IP addressing.
 resource "vsphere_virtual_machine" "vm_cluster_datastore_manual" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address != null && var.use_datastore_cluster == false && var.use_compute_cluster == true)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
   datastore_id              = data.vsphere_datastore.datastore[0].id
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
         ipv4_address    = var.vsphere_vm_ipv4_address[each.value]
         ipv4_netmask    = var.vsphere_vm_ipv4_netmask
       }
       ipv4_gateway    = var.vsphere_vm_ipv4_gateway
       dns_server_list = var.vsphere_vm_dns_servers
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 3 Creation of VM resource: VM on Host, on DataStore, and automatic IP addressing (DHCP).
 resource "vsphere_virtual_machine" "vm_host_datastore_dhcp" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == false && var.use_compute_cluster == false)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
   datastore_id              = data.vsphere_datastore.datastore[0].id
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
       }
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 4 Creation of VM resource: VM on Host, on DataStore, and manually defined IP addressing.
 resource "vsphere_virtual_machine" "vm_host_datastore_manual" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address != null && var.use_datastore_cluster == false && var.use_compute_cluster == false)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
   datastore_id              = data.vsphere_datastore.datastore[0].id
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
         ipv4_address    = var.vsphere_vm_ipv4_address[each.value]
         ipv4_netmask    = var.vsphere_vm_ipv4_netmask
       }
       ipv4_gateway    = var.vsphere_vm_ipv4_gateway
       dns_server_list = var.vsphere_vm_dns_servers
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 5 Creation of VM resource: VM on Compute Cluster, on DataStoreCluster, and automatic IP addressing (DHCP).
 resource "vsphere_virtual_machine" "vm_cluster_datastorecluster_dhcp" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == true && var.use_compute_cluster == true)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
   datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
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
       }
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 6 Creation of VM resource: VM on Compute Cluster, on DataStore Cluster, and manually defined IP addressing.
 resource "vsphere_virtual_machine" "vm_cluster_datastorecluster_manual" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address != null && var.use_datastore_cluster == true && var.use_compute_cluster == true)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
   datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
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
         ipv4_address    = var.vsphere_vm_ipv4_address[each.value]
         ipv4_netmask    = var.vsphere_vm_ipv4_netmask
       }
       ipv4_gateway    = var.vsphere_vm_ipv4_gateway
       dns_server_list = var.vsphere_vm_dns_servers
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 7 Creation of VM resource: VM on Host, on DataStore Cluster, and automatic IP addressing (DHCP).
 resource "vsphere_virtual_machine" "vm_host_datastorecluster_dhcp" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == true && var.use_compute_cluster == false)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
   datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
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
       }
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}

 # 8 Creation of VM resource: VM on Host, on DataStore Cluster, and manually defined IP addressing.
 resource "vsphere_virtual_machine" "vm_host_datastorecluster_manual" {
   for_each = { for idx in range(var.vsphere_vm_instance_count) :
     idx => idx
     if (var.vsphere_vm_ipv4_address != null && var.use_datastore_cluster == true && var.use_compute_cluster == false)}

   name                      = "${var.vsphere_vm_name}${format("%02d", each.value + var.start_serial)}.${var.domain}"
   resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
   datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
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
         ipv4_address    = var.vsphere_vm_ipv4_address[each.value]
         ipv4_netmask    = var.vsphere_vm_ipv4_netmask
       }
       ipv4_gateway    = var.vsphere_vm_ipv4_gateway
       dns_server_list = var.vsphere_vm_dns_servers
     }
   }
   lifecycle {
     ignore_changes = [hv_mode, ept_rvi_mode]
   }
}





