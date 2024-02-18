# The Provider block sets up the vSphere provider to connect to vCenter.
# Use variables to avoid hardcoding credentials here

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
 
# if you have a self-signed cert
  allow_unverified_ssl = true
}