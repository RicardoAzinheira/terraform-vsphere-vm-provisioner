# terraform-vsphere-provisioner
This is a Terraform 0.12 module that allows you to deploy VMs against a vSphere environment.

### Purpose of this module:

This module is intended to be used as a VM provisioner to be used against a vSphere environment, 
the resulting object is a VM resource that will create a vanilla VM with a single OS disk with the OS installed in the VM Template.

The logic of this module is based on the combination of user defined _input variables_ and a _counter_ with _ternary logic_ to parse all the 16 VM resource blocks.

This provides a flexible combination of VMs with Windows or Linux, manually defined network configurations, or DHCP, as well as any given combination of Compute Clusters or Hosts sitting on either single DataStores or DataStore Clusters.

The example files provide good baselines, which you can refer to, to start using this module.

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

The author of this module takes no responsability of its use by anyone, although this was properly tested against a supported vSphere Infra-Structure we still recommend proper testing before you use this in your production environment.
