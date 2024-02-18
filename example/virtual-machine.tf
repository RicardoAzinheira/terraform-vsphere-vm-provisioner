## Although not recommended, you can comment the Vault sections, and use local or ENV variables.
# Vault configuration:
provider "vault" {
  address                         = "https://vault.domain.local"
  skip_tls_verify                 = true
}
# Vault secrets data:
data "vault_generic_secret" "vault" {
  path = "path/to/secrets/in/vault"
}
# Module
## You can define these here directly, but it is strongly recommended to pass these
## variables via file, vault, or Bash variables, for security reasons.
module "vsphere_virtual_machine" {
  source                          = "git::https://github.com/Korenet/terraform-vsphere-vm-provisioner.git?ref=v2.0.2"
  vsphere_server                  = data.vault_generic_secret.vsphere.data["vsphere_server"]
  vsphere_user                    = data.vault_generic_secret.vsphere.data["vsphere_user"]
  vsphere_password                = data.vault_generic_secret.vsphere.data["vsphere_password"]
  vsphere_datacenter              = "vsphere-datacenter"
## You should use either "vsphere_host" or "vsphere_cluster". Don't use both simultaneously.
  #vsphere_host                    = "esxi-host"
  use_compute_cluster             = true
  vsphere_cluster                 = "vsphere-cluster"
## You should define either "vsphere_datastore" or "vsphere_datastore_cluster". Don't use both simultaneously.
  vsphere_datastore               = "DataStore"
  use_datastore_cluster           = false
  #vsphere_datastore_cluster       = "DataStoreCluster"
  vsphere_network                 = "vm-port-group"
  vsphere_vm_template             = "vm-template"
  vsphere_vm_instance_count       = 1
## Beginning of Count, by default it starts with one, but if you wish it to start at a different number (IE VM03),
## just uncomment and edit this variable accordingly.
  #start_serial                    = 1
  vsphere_vm_name                 = "vmname"
  vsphere_vm_os                   = "linux"
  vsphere_vm_cpus                 = 1
## If this variable is unset, the Cores-per-Socket will match the number of CPUs, thus always having one Socket.
## This is an ideal configuration for most VMs, change it only if you have VMs with large RAM that need vNUMA.
  #vsphere_vm_cores_per_socket     = 0
  vsphere_cpu_hot_add_enabled     = false
## Hardware Virtualization features pass-trough, should be sett to `hvOff`, `hvOn`, or `hvAuto`.
  vsphere_hv_mode_enabled         = "hvOff"
  vsphere_vm_memory               = 2048
  vsphere_memory_hot_add_enabled  = false
## This should be provided as an array of the values with the different number of disks and, their required capacity.
  vsphere_vm_disks = [
    # disk0 data
    {
      label = "disk0"
      size = 0
      unit_number = 0
    }
    # disk1 data
    #     {
    #       label = "disk1"
    #       size = 64
    #       unit_number = 1
    #     },
    # disk2 data
    #     {
    #       label = "disk2"
    #       size = 64
    #      unit_number = 2
    #     }
  ]
## Virtual Machine network configurations.
  domain                          = "domain.local"
## This section should be commented if you're using Auto IP configuration (DHCP).
## If you want to manually define IP Configuration, uncomment this section, and define the variables.
## The IP addresses should be provided in blocks matching the defined number of instances.
  #vsphere_vm_ipv4_address         = ["1.2.3.4","1.2.3.5"]
  #vsphere_vm_ipv4_netmask         = "24"
  #vsphere_vm_ipv4_gateway         = "1.2.3.10"
  #vsphere_vm_dns_servers          = ["1.2.3.10", "1.2.3.11"]
}