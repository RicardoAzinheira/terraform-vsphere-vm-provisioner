# The Provider block sets up the vSphere provider - How to connect to vCenter. Note the use of
# variables to avoid hardcoding credentials here

provider "vsphere" {
  version        = "~> 1.18"
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
 
# if you have a self-signed cert
  allow_unverified_ssl = true
}