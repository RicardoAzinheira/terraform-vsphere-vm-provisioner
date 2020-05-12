
// VM on a Cluster and a Datastore Cluster, with Linux and automatic (DHCP) IP addressing.

// Local variables: These determine the underlying topology which against to deploy the VMs, also choose the OS and the IP addressing.
//
locals {
  compute_type                           = "cluster"                    // Acceptable values: "cluster" for compute cluster, or "host" for single ESXi host.
  storage_type                           = "datastore_cluster"          // Acceptable values: "datastore" for single datastore or vSAN volume, or "datastore_cluster".
  os_type                                = "linux"                      // Acceptable values: "Windows or "Linux"
  ip_addressing_type                     = "auto"                       // Acceptable values: "manual" for manually defined network values, or "auto" for DHCP configuration.
}

// Module
//
module "VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto" {
  source                                 = "git::https://github.com/Korenet/terraform-vsphere-provisioner.git?ref=v1.0.1"                        // This should point to the module's location, on git or localy.
  vsphere_server                         = "vSphere-Server"             // This is your vCenter server.
  vsphere_user                           = "vSphere-User"               // You can define this here, but it's strongly recommended to pass these variables via file for security reasons.
  vsphere_password                       = "vSphere-Password"           // You can define this here, but it's strongly recommended to pass these variables via file for security reasons.
  vsphere_datacenter                     = "vSphere-Datacenter"         // This is the Datacenter defined in vCenter where you want to deploy.

//////////////////: You should define either "vsphere_host" or "vsphere_cluster", depending on what you defined in the "compute_type" variable.
//
# vsphere_host                           = "vSphere-Host"               // This is your vSphere single Host, use either this variable or the "vsphere_cluster" variable.
  vsphere_cluster                        = "vSphere-Compute-Cluster"    // This is your vSphere Compute Cluster, use either this variable or the "vsphere_host" variable.

//////////////////: You should define either "vsphere_datastore" or "vsphere_datastore_cluster", depending on what you defined in the "storage_type" variable.
//
# vsphere_datastore                      = "vSphere-DataStore"          // This is your vSphere single DataStore, use either this variable or the "vsphere_datastore_cluster" variable.
  vsphere_datastore_cluster              = "vSphere-DataStore-Cluster"  // This is your vSphere DataStore Cluster, use either this variable or the "vsphere_datastore" variable.
  //
  vsphere_network                        = "vSphere-Network"            // This is the name of the virtual PortGroup where you want the VM to be connected on.
  vsphere_vm_template                    = "vSphere-VM-Template"        // This is the VM Template to be used, keep in mind that in Linux Templates, you should have "VMware tools" installed, since "open-vm-tools" might have undesired results.
# vsphere_vm_instance_count              = 1                            // This is the number of desired VM instances, wich defaults to 1. Important note in regards to manual IP configurations, the IP addresses should be provided in blocks matching the number of desired instances.
# start_serial                           = 1                            // This is where the count begins, by default it starts with one, but if you wish it to start at a different number (IE VM03), just uncomment and edit this variable accordingly.
  vsphere_vm_name                        = "VMNAME"
  vsphere_vm_cpus                        = 2
  vsphere_vm_memory                      = 2048
# vsphere_vm_disk-size                   = 0                            // This variable defaults to 0 which means the VM will have the same disk size as the VM Template, you can use this however to use a different size for the virtual disk, provided it's larger than the one in the VM Template.
//
//////////////////: This variable defines the behaviour of the selection of the resource blocks in the "main.tf", according to the selection on the local variables above.
//
  vm_type                                = "${local.compute_type}_${local.storage_type}_${local.os_type}_${local.ip_addressing_type}"
//
  domain                                 = "domain.local"
//////////////////: You should only define these variables in case you choose "manual" on the "ip_addressing_type" variable, otherwise leave it commented so DHCP can be applied.
//
//////////////////: If you do use "manual" on the "ip_addressing_type" variable, configure this according to your environment.
//
# vsphere_vm_ipv4_address                = "10.20.30.40"
# vsphere_vm_ipv4_netmask                = "24"
# vsphere_vm_ipv4_gateway                = "10.20.30.4"
# vsphere_vm_dns_servers                 = ["10.20.30.41", "10.20.30.42"]
}

// Module outputs
//
output "VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto-IP-Address" {
  value = module.VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto.VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto-IPaddress
}