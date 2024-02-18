output "vm_host_datastore_dhcp" {
   value = var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == false && var.use_compute_cluster == false ? vsphere_virtual_machine.vm_host_datastore_dhcp.8.guest_ip_addresses.0 : null
}
output "vm_host_datastorecluster_dhcp" {
  value = var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == true && var.use_compute_cluster == false ? vsphere_virtual_machine.vm_host_datastorecluster_dhcp.0.guest_ip_addresses.0 : null
}
output "vm_cluster_datastorecluster_dhcp" {
  value = var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == true && var.use_compute_cluster == true ? vsphere_virtual_machine.vm_cluster_datastorecluster_dhcp.0.guest_ip_addresses.0 : null
}
output "vm_cluster_datastore_dhcp" {
  value = var.vsphere_vm_ipv4_address == null && var.use_datastore_cluster == false && var.use_compute_cluster == true ? vsphere_virtual_machine.vm_cluster_datastore_dhcp.0.guest_ip_addresses.0 : null
}
