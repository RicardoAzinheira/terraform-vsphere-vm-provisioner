output "vm_ip_addresses" {
  value = formatlist(
    "%s = %s",
    ([for vm in vsphere_virtual_machine.vm : vm.name]),
    ([for vm in vsphere_virtual_machine.vm : vm.guest_ip_addresses[0]]),
  )
}