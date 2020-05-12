# terraform-vsphere-provisioner
This is a Terraform 0.12 module that allows you to deploy VMs against a vSphere environment.

### Purpose of this module:

This module is intended to be used as a VM provisioner to be used against a vSphere environment, 
the resulting object is a VM resource that will create a vanilla VM with a single OS disk with the OS installed in the VM Template.

The logic of this module is based on the combination of user defined _input variables_ and a _counter_ with _ternary logic_ to parse all the 16 VM resource blocks.

This provides a flexible combination of VMs with Windows or Linux, manually defined network configurations, or DHCP, as well as any given combination of Compute Clusters or Hosts sitting on either single DataStores or DataStore Clusters.

The example files provide good baselines, which you can refer to start using this module.

#
### Features to be implemented in the future:

- Multiple disks in the VMs with TF 0.12 dynamic blocks
- Dynamic inline provisioning blocks in the VM resource blocks

### Assumptions

- You have a vSphere Infra-Structure with vCenter Standard and vSphere Enterprise plus on the ESXi hosts.
- You have an Active Directory domain for the target VMs which is also used by vSphere.
- The user you provide for vSphere authentication, has permissions to add and modify computer objects in the AD domain.

#

These are the terraform building blocks of this module:

### **TF Providers**

| Name | Version |
|------|---------|
| vsphere | ~> 1.18 |

### **TF Inputs**

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compute\_type | n/a | `string` | `null` | no |
| domain | n/a | `string` | n/a | yes |
| ip\_addressing\_type | n/a | `any` | `null` | no |
| os\_type | n/a | `string` | `null` | no |
| start\_serial | n/a | `number` | `1` | no |
| storage\_type | n/a | `string` | `null` | no |
| vm\_type | n/a | `string` | `null` | no |
| vsphere\_cluster | n/a | `any` | `null` | no |
| vsphere\_datacenter | n/a | `string` | n/a | yes |
| vsphere\_datastore | n/a | `string` | `null` | no |
| vsphere\_datastore\_cluster | n/a | `string` | `null` | no |
| vsphere\_host | n/a | `string` | `null` | no |
| vsphere\_network | n/a | `any` | n/a | yes |
| vsphere\_password | n/a | `any` | n/a | yes |
| vsphere\_server | n/a | `string` | n/a | yes |
| vsphere\_user | n/a | `string` | n/a | yes |
| vsphere\_vm\_cpus | n/a | `number` | n/a | yes |
| vsphere\_vm\_disk-size | n/a | `number` | `0` | no |
| vsphere\_vm\_dns\_servers | n/a | `list(string)` | `null` | no |
| vsphere\_vm\_instance\_count | n/a | `number` | `1` | no |
| vsphere\_vm\_ipv4\_address | n/a | `list(string)` | `null` | no |
| vsphere\_vm\_ipv4\_gateway | n/a | `any` | `null` | no |
| vsphere\_vm\_ipv4\_netmask | n/a | `any` | `null` | no |
| vsphere\_vm\_memory | n/a | `number` | n/a | yes |
| vsphere\_vm\_name | n/a | `string` | n/a | yes |
| vsphere\_vm\_template | n/a | `string` | n/a | yes |

### **TF Outputs**

| Name | Description |
|------|-------------|
| VM-OnCluster-OnDataStore-Linux-ip\_addressing\_auto-IPaddress | VM IP Output|
| VM-OnCluster-OnDataStore-Windows-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnCluster-OnDataStoreCluster-Linux-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnCluster-OnDataStoreCluster-Windows-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnHost-OnDataStore-Linux-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnHost-OnDataStore-Windows-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnHost-OnDataStoreCluster-Linux-ip\_addressing\_auto-IPaddress | VM IP Output |
| VM-OnHost-OnDataStoreCluster-Windows-ip\_addressing\_auto-IPaddress | VM IP Output |

## Usage licence

This is for the community, thus it has no restrictions, please feel free to share, use, modify and do whatever you want it it.

## Disclaimer

The author of this module takes no responsability of its use by anyone, although this was properly tested agains a proper vSphere Infra-Structure we still recommend propper testing before you use this in your production environment.
