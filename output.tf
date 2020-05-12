output "VM-OnHost-OnDataStore-Windows-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnHost-OnDataStore-Windows-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnCluster-OnDataStore-Windows-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnCluster-OnDataStore-Windows-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnHost-OnDataStoreCluster-Windows-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnHost-OnDataStoreCluster-Windows-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnCluster-OnDataStoreCluster-Windows-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnCluster-OnDataStoreCluster-Windows-ip_addressing_auto.*.guest_ip_addresses
}
output "VM-OnHost-OnDataStore-Linux-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnHost-OnDataStore-Linux-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnCluster-OnDataStore-Linux-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnCluster-OnDataStore-Linux-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnHost-OnDataStoreCluster-Linux-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnHost-OnDataStoreCluster-Linux-ip_addressing_auto.*.guest_ip_addresses
}

output "VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto-IPaddress" {
  value = vsphere_virtual_machine.VM-OnCluster-OnDataStoreCluster-Linux-ip_addressing_auto.*.guest_ip_addresses
}