# terraform-vsphere-vm-provisioner
This is a Terraform v1 module that allows you to deploy VMs against a vSphere environment.

## Purpose of this module:

This module is intended to be used as a VM provisioner to be used against a vSphere environment, 
the resulting object is a VM resource that will create a vanilla VM with the disks defined in the variables, and with the OS installed in the VM Template, and it is designed to be flexible, but with code as lean and D.R.Y. as possible. With a combination of _count_ and _for_each_ 
in conjunction with _dynamic_blocks_ this can be used against a variety of vSphere environments, and has a good set of VM features.

As the previous version, it still allows to deploy VMs with Windows or Linux, manually defined network configurations, 
or DHCP, as well as any given combination of Compute Clusters, or Hosts, sitting on either single DataStores, or DataStore Clusters.

The example file _[virtual-machine.tf](https://github.com/RicardoAzinheira/terraform-vsphere-vm-provisioner/blob/master/example/virtual-machine.tf)_ provides a good baseline, which you can refer to, in order to start using this module.

## Assumptions:

- You have a vSphere Infra-Structure with vCenter Standard and vSphere Enterprise plus on the ESXi hosts.
- You have an Active Directory domain for the target VMs which is also used by vSphere.
- The user you provide for vSphere authentication, has permissions to add and modify computer objects in the AD domain.

## [v2.0.1](https://github.com/RicardoAzinheira/terraform-vsphere-vm-provisioner/tree/v2.0.1)

- Improvememtns in the README and change of minor version in the _[virtual-machine.tf](https://github.com/RicardoAzinheira/terraform-vsphere-vm-provisioner/blob/master/example/virtual-machine.tf)_ file.

## [v2.0.0 (current major version)](https://github.com/RicardoAzinheira/terraform-vsphere-vm-provisioner/tree/v2.0.0)

- Refactored to current version of Terraform v1.
- Drastically improves the code via the use of _dynamic blocks_ and _conditional variables_, which reduces both the client and module files.
- Terraform Providers updated, and tested against the latest version 7 and 8 of vCenter Server.
- Inclusion of HashiCorp Vault configuration.
- Addition of Outputs for DHCP VMs.
- Includes new features:
  - Multiple Disks (via list type variable)
  - Ability to enable Hardware Virtualization
  - Hot CPU and Memory Addition enablement
  - Socket vs Core allocation configuration
#### Features to be implemented in the future:
- Possibly reduce the main.tf even further, by improving the _dynamic block_ logic.
- Possibility of inclusion of _userdata_, in order to customize _cloud images_.
- If there is enough interest, multiple NICs.



## [v1.0.3](https://github.com/RicardoAzinheira/terraform-vsphere-vm-provisioner/releases/tag/v1.0.3)
#### Features to be implemented in the future:

- Multiple disks in the VMs with TF 0.12 dynamic blocks
- Dynamic inline provisioning blocks in the VM resource blocks


#

These are the terraform building blocks of this module:

### **TF Providers**

| Name                         | Version |
|------------------------------|---------|
| vsphere                      | ~> 1.18 |

### **TF Inputs**

| Name                         | Description                                                                    | Type           | Default | Required |
|------------------------------|--------------------------------------------------------------------------------|----------------|---------|:--------:|
| compute_type                 | host or cluster                                                                | `string`       | `null`  | no       |
| domain                       | Active Directory Domain for Windows or domain for Linux                        | `string`       |   n/a   | yes      |
| ip_addressing_type           | Used to define the use of DHCP or user variable defined network configuration  | `any`          | `null`  | no       |
| os_type                      | windows or linux                                                               | `string`       | `null`  | no       |
| start_serial                 | Number at which, the instance numbering should start                           | `number`       |    `1`  | no       |
| storage_type                 | datastore or datastore\_cluster                                                | `string`       | `null`  | no       |
| vm_type                      | Used to define the appropriate resource block, based on user defined variables | `string`       | `null`  | no       |
| vsphere_cluster              | vSphere Compute Cluster                                                        | `any`          | `null`  | no       |
| vsphere_datacenter           | vSphere DataCenter                                                             | `string`       |    n/a  | yes      |
| vsphere_datastore            | Single DataStore                                                               | `string`       | `null`  | no       |
| vsphere_datastore_cluster    | DataStore Cluster                                                              | `string`       | `null`  | no       |
| vsphere_host                 | vSphere single ESXi Host                                                       | `string`       | `null`  | no       |
| vsphere_network              | Virtual network where do you want the VM to be in                              | `any`          |     n/a | yes      |
| vsphere_password             | Password of the user account with permissions on the vCenter and the AD Domain | `any`          |     n/a | yes      |
| vsphere_server               | vCenter server that manages your vSphere Infra-Structure                       | `string`       | n/a     | yes      |
| vsphere_user                 | User account with permissions on the vCenter and the AD Domain                 | `string`       | n/a     | yes      |
| vsphere_vm_cpus              | Desired number of CPUs                                                         | `number`       | n/a     | yes      |
| vsphere_vm_disk-size         | Size of the VM root disk, it defaults to the size of the VM Template root disk | `number`       | `0`     | no       |
| vsphere_vm_dns_servers       | List of DNS Servers                                                            | `list(string)` | `null`  | no       |
| vsphere_vm_instance_count    | Desired number of resource instances                                           | `number`       | `1`     | no       |
| vsphere_vm_ipv4_address      | IP Addresses                                                                   | `list(string)` | `null`  | no       |
| vsphere_vm_ipv4_gateway      | Network gateway                                                                | `any`          | `null`  | no       |
| vsphere_vm_ipv4_netmask      | Network submask                                                                | `any`          | `null`  | no       |
| vsphere_vm_memory            | Desired amount of RAM                                                          | `number`       | n/a     | yes      |
| vsphere_vm_name              | Desired name for the VM                                                        | `string`       | n/a     | yes      |
| vsphere_vm_template          | VM Template required for the deployment                                        | `string`       | n/a     | yes      |

### **TF Outputs**

| Name                         | Description |
|------------------------------|-------------|
| DHCP VM resource blocks      | VM IP Output|

## Usage licence

This is for the community, thus it has no restrictions, please feel free to share, use, modify and do whatever you want it it.

## Disclaimer

The author of this module takes no responsibility of its use by anyone, although this was properly tested against a supported vSphere Infra-Structure, it is still recommended testing this module before you use it in your production environment.
