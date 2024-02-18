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
variable "vsphere_folder" {
    description = "vSphere Folder"
    type = string
    default = null
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
variable "vsphere_vm_cores_per_socket" {
    description = "Desired number of Cores per Socket"
    type = number
    default = 0
}
variable "vsphere_hv_mode_enabled" {
    description = "Hardware Virtualization features pass-trough, should be sett to `hvOff`, `hvOn`, or `hvAuto`"
    type = string
    default = "hvOff"
}
variable "vsphere_cpu_hot_add_enabled" {
    description = "Enables the ability to add CPUs with the VM running"
    type = bool
    default = false
}
variable "vsphere_memory_hot_add_enabled" {
    description = "Enables the ability to add Memory with the VM running"
    type = bool
    default = false
}
variable "vsphere_vm_memory" {
    description = "Desired amount of RAM"
    type = number
}
variable "vsphere_vm_disks" {
    type = list(any)
    default = [
        {
            label = "disk0"
            size  = 0
            unit_number = 0
        }
    ]
}
variable "vsphere_vm_ipv4_address" {
    description = "IP Addresses"
    type = list(any)
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
    type = list(any)
    default = null
}
variable "vsphere_vm_os" {
    description = "Virtual Machine Operative System (OS)"
    type = string
}
variable "use_compute_cluster" {
    description = "defines whether a Compute Cluster is used"
    type = bool
    default = true
}
variable "use_datastore_cluster" {
    description = "defines whether a Datastore Cluster is used"
    type = bool
    default = false
}
variable "domain" {
    description = "Active Directory Domain for Windows or domain for Linux"
    type = string
}