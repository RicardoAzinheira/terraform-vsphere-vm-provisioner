variable "vsphere_server" {
    description = "vCenter server that manages your vSphere Infra-Structure"
    type = string
}
variable "vsphere_user" {
    description = "User account with permissions on the vCenter and the AD Domain"
    type = string
}
variable "vsphere_password" {
    description = "Password of the user account with permissions on the vCenter and the AD Domain"
}
variable "vsphere_datacenter" {
    description = "vSphere DataCenter"
    type = string
}
variable "vsphere_cluster" {
    description = "vSphere Compute Cluster"
    default = null
}
variable "vsphere_host" {
    description = "vSphere single ESXi Host"
    type = string
    default = null
}
variable "vsphere_datastore" {
    description = "Single DataStore"
    type = string
    default = null
}
variable "vsphere_datastore_cluster" {
    description = "DataStore Cluster"
    type = string
    default = null
}
variable "vsphere_network" {
    description = "Virtual network where do you want the VM to be in"
}
variable "vsphere_vm_template" {
    description = "VM Template required for the deployment"
    type = string
}
variable "vsphere_vm_instance_count" {
    description = "Desired number of resource instances"
    type = number
    default = 1
}
variable "start_serial" {
    description = "Number at which, the instance numbering should start"
    type = number
    default = 1
}
variable "vsphere_vm_name" {
    description = "Desired name for the VM"
    type = string
}
variable "vsphere_vm_cpus" {
    description = "Desired number of CPUs"
    type = number
}
variable "vsphere_vm_memory" {
    description = "Desired amount of RAM"
    type = number
}
variable "vsphere_vm_disk-size" {
    description = "Size of the VM root disk, it defaults to the size of the VM Template root disk"
    type = number
    default = 0
}
variable "vsphere_vm_ipv4_address" {
    description = "IP Addresses"
    type = list(string)
    default = null
}
variable "vsphere_vm_ipv4_netmask" {
    description = "Network submask"
    default = null
}
variable "vsphere_vm_ipv4_gateway" {
    description = "Network gateway"
    default = null
}
variable "vsphere_vm_dns_servers" {
    description = "List of DNS Servers"
    type = list(string)
    default = null
}
variable "compute_type" {                   //This should have "host" or "cluster"
    description = " host or cluster"
    type = string
    default = null
}
variable "storage_type" {                   //This should have "datastore" or "datastore_cluster"
    description = "datastore or datastore_cluster"
    type = string
    default = null
}
variable "os_type" {                        //This should have "windows" or "linox"
    description = "windows or linux"
    type = string
    default = null
}
variable "vm_type" {
    description = "Used to define the appropriate resource block, based on user defined variables"
    type = string
    default = null
}
variable "domain" {
    description = "Active Directory Domain for Windows or domain for Linux"
    type = string
}
variable "ip_addressing_type" {             //This should have "manual" or "auto" (for DHCP)
    description = "Used to define the use of DHCP or user variable defined network configuration"
    default = null
}