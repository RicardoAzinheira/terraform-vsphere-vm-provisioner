//
//  Data block
//
data "vsphere_datacenter" "dc" {
  name              = var.vsphere_datacenter
}

data "vsphere_host" "host" {
  count             = (var.vsphere_host != null ? 1 : 0 )
  name              = var.vsphere_host
  datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  count             = (var.vsphere_cluster != null ? 1 : 0)
  name              = var.vsphere_cluster
  datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  count             = (var.vsphere_datastore != null ? 1 : 0)
  name              = var.vsphere_datastore
  datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count             = (var.vsphere_datastore_cluster  != null ? 1 : 0)
  name              = var.vsphere_datastore_cluster
  datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name              = var.vsphere_network
  datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name              = var.vsphere_vm_template
  datacenter_id     = data.vsphere_datacenter.dc.id
}
//
//  Creation of VM resource block 1 (VM on Host, on DataStore, with Windows OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStore-Windows-ip_addressing_auto" {
  count = (var.vm_type == "host_datastore_windows_auto" ? var.vsphere_vm_instance_count : 0)
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
    template_uuid    = data.vsphere_virtual_machine.template.id
     
    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }
 
      network_interface {

      }


    }
  }
}
//
//  Creation of VM resource block 2 (VM on Host, on DataStore Cluster, with Windows OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStoreCluster-Windows-ip_addressing_auto" {
  count = (var.vm_type == "host_datastore_cluster_windows_auto" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {

      }


    }
  }
}
//
//  Creation of VM resource block 3 (VM on Cluster, on DataStore, with Windows OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStore-Windows-ip_addressing_auto" {
  count = (var.vm_type == "cluster_datastore_windows_auto" ? var.vsphere_vm_instance_count : 0)
  name              = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id  = data.vsphere_compute_cluster.cluster[0].resource_pool_id
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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {

      }


    }
  }
}
//
//  Creation of VM resource block 4 (VM on Cluster, on DataStore Cluster, with Windows OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStoreCluster-Windows-ip_addressing_auto" {
  count = (var.vm_type == "cluster_datastore_cluster_windows_auto" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {

      }


    }
  }
}
//
//  Creation of VM resource block 5 (VM on Host, on DataStore, with Windows OS ans IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStore-Windows-ip_addressing_manual" {
  count = (var.vm_type == "host_datastore_windows_manual" ? var.vsphere_vm_instance_count : 0)
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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers


    }
  }
}
//
//  Creation of VM resource block 6 (VM on Host, on DataStore Cluster, with Windows OS ans IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStoreCluster-Windows-ip_addressing_manual" {
  count = (var.vm_type == "host_datastore_cluster_windows_manual" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers


    }
  }
}
//
//  Creation of VM resource block 7 (VM on Cluster, on DataStore, with Windows OS ans IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStore-Windows-ip_addressing_manual" {
  count = (var.vm_type == "cluster_datastore_windows_manual" ? var.vsphere_vm_instance_count : 0)
  name              = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id  = data.vsphere_compute_cluster.cluster[0].resource_pool_id
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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers


    }
  }
}
//
//  Creation of VM resource block 8 (VM on Cluster, on DataStore Cluster, with Windows OS ans IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStoreCluster-Windows-ip_addressing_manual" {
  count = (var.vm_type == "cluster_datastore_cluster_windows_manual" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
    template_uuid    = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name           = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
        join_domain             = var.domain
        domain_admin_user       = var.vsphere_user
        domain_admin_password   = var.vsphere_password
      }

      network_interface {
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers


    }
  }
}
//
//  Creation of VM resource block 9 (VM on Host, on DataStore, with Linux OS and IP addressing auto (DHCP)
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
//
//  Creation of VM resource block 10 (VM on Host, on DataStore Cluster, with Linux OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStoreCluster-Linux-ip_addressing_auto" {
  count = (var.vm_type == "host_datastore_cluster_linux_auto" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
//
//  Creation of VM resource block 11 (VM on Cluster, on DataStore, with Linux OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStore-Linux-ip_addressing_auto" {
  count = (var.vm_type == "cluster_datastore_linux_auto" ? var.vsphere_vm_instance_count : 0)
  name              = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id  = data.vsphere_compute_cluster.cluster[0].resource_pool_id
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
        host_name = var.vsphere_vm_name
        domain    = var.domain
      }
      network_interface {
      }

    }
  }
}
//
//  Creation of VM resource block 12 (VM on Cluster, on DataStore Cluster, with Linux OS and IP addressing auto (DHCP)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto" {
  count = (var.vm_type == "cluster_datastore_cluster_linux_auto" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
        host_name = "${var.vsphere_vm_name}-${var.vsphere_vm_instance_count}.${var.domain}"
        domain    = var.domain
      }
      network_interface {
      }

    }
  }
}
//
//  Creation of VM resource block 13 (VM on Host, on DataStore, with Linux OS and IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStore-Linux-ip_addressing_manual" {
  count = (var.vm_type == "host_datastore_linux_manual" ? var.vsphere_vm_instance_count : 0)
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
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers

    }
  }
}
//
//  Creation of VM resource block 14 (VM on Host, on DataStore Cluster, with Linux OS and IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnHost-OnDataStoreCluster-Linux-ip_addressing_manual" {
  count = (var.vm_type == "host_datastore_cluster_linux_manual" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_host.host[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers

    }
  }
}
//
//  Creation of VM resource block 15 (VM on Cluster, on DataStore, with Linux OS and IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStore-Linux-ip_addressing_manual" {
  count = (var.vm_type == "cluster_datastore_linux_manual" ? var.vsphere_vm_instance_count : 0)
  name              = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id  = data.vsphere_compute_cluster.cluster[0].resource_pool_id
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
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers

    }
  }
}
//
//  Creation of VM resource block 16 (VM on Cluster, on DataStore Cluster, with Linux OS and IP addressing manual (Variable defined values)
//
resource "vsphere_virtual_machine" "VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_manual" {
  count = (var.vm_type == "cluster_datastore_cluster_linux_manual" ? var.vsphere_vm_instance_count : 0)
  name                      = "${var.vsphere_vm_name}${format("%02d", count.index + var.start_serial)}"
  resource_pool_id          = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  datastore_cluster_id      = data.vsphere_datastore_cluster.datastore_cluster[0].id
  firmware                  = data.vsphere_virtual_machine.template.firmware
  num_cpus                  = var.vsphere_vm_cpus
  memory                    = var.vsphere_vm_memory
  guest_id                  = data.vsphere_virtual_machine.template.guest_id
  scsi_type                 = data.vsphere_virtual_machine.template.scsi_type

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
        ipv4_address = var.vsphere_vm_ipv4_address[count.index]
        ipv4_netmask = var.vsphere_vm_ipv4_netmask
      }
      ipv4_gateway = var.vsphere_vm_ipv4_gateway
      dns_server_list = var.vsphere_vm_dns_servers

    }
  }
}