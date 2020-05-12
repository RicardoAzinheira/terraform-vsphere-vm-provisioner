variable "vsphere_server" {
    type = string
}
variable "vsphere_user" {
    type = string
}
variable "vsphere_password" {}
variable "vsphere_datacenter" {
    type = string
}
variable "vsphere_cluster" {
    default = null
}
variable "vsphere_host" {
    type = string
    default = null
}
variable "vsphere_datastore" {
    type = string
    default = null
}
variable "vsphere_datastore_cluster" {
    type = string
    default = null
}
variable "vsphere_network" {}
variable "vsphere_vm_template" {
    type = string
}
variable "vsphere_vm_instance_count" {
    type = number
    default = 1
}
variable "start_serial" {
    type = number
    default = 1
}
variable "vsphere_vm_name" {
    type = string
}
variable "vsphere_vm_cpus" {
    type = number
}
variable "vsphere_vm_memory" {
    type = number
}
variable "vsphere_vm_disk-size" {
    type = number
    default = 0
}
variable "vsphere_vm_ipv4_address" {
    type = list(string)
    default = null
}
variable "vsphere_vm_ipv4_netmask" {
    default = null
}
variable "vsphere_vm_ipv4_gateway" {
    default = null
}
variable "vsphere_vm_dns_servers" {
    type = list(string)
    default = null
}
variable "compute_type" {                   //This should have "host" or "cluster"
    type = string
    default = null
}
variable "storage_type" {                   //This should have "datastore" or "datastore_cluster"
    type = string
    default = null
}
variable "os_type" {                        //This should have "windows" or "linox"
    type = string
    default = null
}
variable "vm_type" {
    type = string
    default = null
}
variable "domain" {
    type = string
}
variable "ip_addressing_type" {             //This should have "manual" or "auto" (for DHCP)
    default = null
}