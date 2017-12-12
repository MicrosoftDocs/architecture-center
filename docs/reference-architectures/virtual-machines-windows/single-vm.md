---
title: Run a Windows VM on Azure
description: >-
  How to run a Windows VM on Azure, paying attention to scalability, resiliency,
  manageability, and security.

author: telmosampaio

ms.date: 11/16/2017

pnp.series.title: Windows VM workloads
pnp.series.next: multi-vm
pnp.series.prev: ./index
---

# Run a Windows VM on Azure

This reference architecture shows a set of proven practices for running a Windows virtual machine (VM) on Azure. It includes recommendations for provisioning the VM along with networking and storage components. This architecture can be used to run a single VM instance, and is the basis for more complex architectures such as N-tier applications. [**Deploy this solution.**](#deploy-the-solution)

![[0]][0]

*Download a [Visio file][visio-download] that contains this architecture diagram.*

## Architecture

Provisioning an Azure VM requires additional components, such as compute, networking, and storage resources.

* **Resource group.** A [resource group][resource-manager-overview] is a container that holds related resources. In general, you should group resources in a solution based on their lifetime and who will manage the resources. For a single VM workload, you may want to create a single resource group for all resources.
* **VM**. You can provision a VM from a list of published images, or from a custom managed image or virtual hard disk (VHD) file uploaded to Azure Blob storage.
* **OS disk.** The OS disk is a VHD stored in [Azure Storage][azure-storage], so it persists even when the host machine is down.
* **Temporary disk.** The VM is created with a temporary disk (the `D:` drive on Windows). This disk is stored on a physical drive on the host machine. It is **not** saved in Azure Storage and may be deleted during reboots and other VM lifecycle events. Use this disk only for temporary data, such as page or swap files.
* **Data disks.** A [data disk][data-disk] is a persistent VHD used for application data. Data disks are stored in Azure Storage, like the OS disk.
* **Virtual network (VNet) and subnet.** Every Azure VM is deployed into a VNet that can be segmented into multiple subnets.
* **Public IP address.** A public IP address is needed to communicate with the VM &mdash; for example, via remote desktop (RDP).  
* **Azure DNS**. [Azure DNS][azure-dns] is a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.  
* **Network interface (NIC)**. An assigned NIC enables the VM to communicate with the virtual network.  
* **Network security group (NSG)**. [Network security groups][nsg] are used to allow or deny network traffic to a network resource. You can associate an NSG with an individual NIC or with a subnet. If you associate it with a subnet, the NSG rules apply to all VMs in that subnet.
* **Diagnostics.** Diagnostic logging is crucial for managing and troubleshooting the VM.

## Recommendations

This architecture shows the baseline recommendations for running a Windows VM in Azure. However, we don't recommend using a single VM for mission critical workloads because it creates a single point of failure. For higher availability, deploy multiple VMs in an [availability set][availability-set]. For more information, see [Running multiple VMs on Azure][multi-vm]. 

### VM recommendations

Azure offers many different virtual machine sizes. [Premium Storage][premium-storage] is recommended due to its high performance and low latency, and is [supported by specific VM sizes][premium-storage-supported]. Select one of these sizes unless you have a specialized workload such as high-performance computing. For more information, see [virtual machine sizes][virtual-machine-sizes].

If you are moving an existing workload to Azure, start with the VM size that's the closest match to your on-premises servers. Then measure the performance of your actual workload with respect to CPU, memory, and disk input/output operations per second (IOPS), and adjust the size as needed. If you require multiple NICs for your VM, be aware that a maximum number of NICs is defined for each [VM size][vm-size-tables].

When you provision Azure resources, you must specify a region. Generally, choose a region closest to your internal users or customers. However, not all VM sizes are available in all regions. For more information, see [Services by region][services-by-region]. For a list of the VM sizes available in a specific region, run the following command from the Azure command-line interface (CLI):

```
az vm list-sizes --location <location>
```

For information about choosing a published VM image, see [Find Windows VM images][select-vm-image].

Enable monitoring and diagnostics, including basic health metrics, diagnostics infrastructure logs, and [boot diagnostics][boot-diagnostics]. Boot diagnostics can help you diagnose boot failure if your VM gets into a non-bootable state. For more information, see [Enable monitoring and diagnostics][enable-monitoring].  

### Disk and storage recommendations

For best disk I/O performance, we recommend [Premium Storage][premium-storage], which stores data on solid-state drives (SSDs). Cost is based on the capacity of the provisioned disk. IOPS and throughput (that is, data transfer rate) also depend on disk size, so when you provision a disk, consider all three factors (capacity, IOPS, and throughput). 

We also recommend the use of [managed disks](/azure/storage/storage-managed-disks-overview). Managed disks do not require a storage account. You simply specify the size and type of disk and it is deployed as a highly available resource.

If you are using unmanaged disks, create separate Azure storage accounts for each VM to hold the virtual hard disks (VHDs), in order to avoid hitting the [(IOPS) limits][vm-disk-limits] for storage accounts.

Add one or more data disks. When you create a VHD, it is unformatted. Log into the VM to format the disk. If you are not using managed disks and have a large number of data disks, be aware of the total I/O limits of the storage account. For more information, see [virtual machine disk limits][vm-disk-limits].

When possible, install applications on a data disk, not the OS disk. Some legacy applications might need to install components on the C: drive; in that case, you can [resize the OS disk][resize-os-disk] using PowerShell.

To maximize performance, create a separate storage account to hold diagnostic logs. A standard locally redundant storage (LRS) account is sufficient for diagnostic logs.

### Network recommendations

The public IP address can be dynamic or static. The default is dynamic.

* Reserve a [static IP address][static-ip] if you need a fixed IP address that won't change &mdash; for example, if you need to create a DNS 'A' record or add the IP address to a safe list.
* You can also create a fully qualified domain name (FQDN) for the IP address. You can then register a [CNAME record][cname-record] in DNS that points to the FQDN. For more information, see [Create a fully qualified domain name in the Azure portal][fqdn].

All NSGs contain a set of [default rules][nsg-default-rules], including a rule that blocks all inbound Internet traffic. The default rules cannot be deleted, but other rules can override them. To enable Internet traffic, create rules that allow inbound traffic to specific ports &mdash; for example, port 80 for HTTP.

To enable RDP, add an NSG rule that allows inbound traffic to TCP port 3389.

## Scalability considerations

You can scale a VM up or down by [changing the VM size][vm-resize]. To scale out horizontally, put two or more VMs behind a load balancer. For more information, see [Running multiple VMs on Azure for scalability and availability][multi-vm].

## Availability considerations

For higher availability, deploy multiple VMs in an availability set. This also provides a higher [service level agreement (SLA)][vm-sla].

Your VM may be affected by [planned maintenance][planned-maintenance] or [unplanned maintenance][manage-vm-availability]. You can use [VM reboot logs][reboot-logs] to determine whether a VM reboot was caused by planned maintenance.

VHDs are stored in [Azure storage][azure-storage]. Azure storage is replicated for durability and availability.

To protect against accidental data loss during normal operations (for example, because of user error), you should also implement point-in-time backups, using [blob snapshots][blob-snapshot] or another tool.

## Manageability considerations

**Resource groups.** Put closely associated resources that share the same lifecycle into the same [resource group][resource-manager-overview]. Resource groups allow you to deploy and monitor resources as a group and track billing costs by resource group. You can also delete resources as a set, which is very useful for test deployments. Assign meaningful resource names to simplify locating a specific resource and understanding its role. For more information, see [Recommended Naming Conventions for Azure Resources][naming-conventions].

**Stopping a VM.** Azure makes a distinction between "stopped" and "deallocated" states. You are charged when the VM status is stopped, but not when the VM is deallocated.

In the Azure portal, the **Stop** button deallocates the VM. If you shut down through the OS while logged in, the VM is stopped but **not** deallocated, so you will still be charged.

**Deleting a VM.** If you delete a VM, the VHDs are not deleted. That means you can safely delete the VM without losing data. However, you will still be charged for storage. To delete the VHD, delete the file from [Blob storage][blob-storage].

To prevent accidental deletion, use a [resource lock][resource-lock] to lock the entire resource group or lock individual resources, such as a VM.

## Security considerations

Use [Azure Security Center][security-center] to get a central view of the security state of your Azure resources. Security Center monitors potential security issues and provides a comprehensive picture of the security health of your deployment. Security Center is configured per Azure subscription. Enable security data collection as described in the [Azure Security Center quick start guide][security-center-get-started]. When data collection is enabled, Security Center automatically scans any VMs created under that subscription.

**Patch management.** If enabled, Security Center checks whether any security and critical updates are missing. Use [Group Policy settings][group-policy] on the VM to enable automatic system updates.

**Antimalware.** If enabled, Security Center checks whether antimalware software is installed. You can also use Security Center to install antimalware software from inside the Azure portal.

**Operations.** Use [role-based access control (RBAC)][rbac] to control access to the Azure resources that you deploy. RBAC lets you assign authorization roles to members of your DevOps team. For example, the Reader role can view Azure resources but not create, manage, or delete them. Some roles are specific to particular Azure resource types. For example, the Virtual Machine Contributor role can restart or deallocate a VM, reset the administrator password, create a new VM, and so on. Other [built-in RBAC roles][rbac-roles] that may be useful for this architecture include [DevTest Labs User][rbac-devtest] and [Network Contributor][rbac-network]. A user can be assigned to multiple roles, and you can create custom roles for even more fine-grained permissions.

> [!NOTE]
> RBAC does not limit the actions that a user logged into a VM can perform. Those permissions are determined by the account type on the guest OS.   

Use [audit logs][audit-logs] to see provisioning actions and other VM events.

**Data encryption.** Consider [Azure Disk Encryption][disk-encryption] if you need to encrypt the OS and data disks. 

## Deploy the solution

A deployment for this architecture is available on [GitHub][github-folder]. It deploys the following:

  * A virtual network with a single subnet named **web** used to host the VM.
  * An NSG with two incoming rules to allow RDP and HTTP traffic to the VM.
  * A VM running the latest version of Windows Server 2016 Datacenter Edition.
  * A sample custom script extension that formats the two data disks, and a PowerShell DSC script that deploys IIS.

### Prerequisites

Before you can deploy the reference architecture to your own subscription, you must perform the following steps.

1. Clone, fork, or download the zip file for the [AzureCAT reference architectures][ref-arch-repo] GitHub repository.

2. Make sure you have the Azure CLI 2.0 installed on your computer. For CLI installation instructions, see [Install Azure CLI 2.0][azure-cli-2].

3. Install the [Azure building blocks][azbb] npm package.

4. From a command prompt, bash prompt, or PowerShell prompt, login to your Azure account by using one of the commands below, and follow the prompts.

  ```bash
  az login
  ```

### Deploy the solution using azbb

To deploy the sample single VM workload, follow these steps:

1. Navigate to the `virtual-machines\single-vm\parameters\windows` folder for the repository you downloaded in the prerequisites step above.

2. Open the `single-vm-v2.json` file and enter a username and SSH key between the quotes, as shown below, then save the file.

  ```bash
  "adminUsername": "",
  "adminPassword": "",
  ```

3. Run `azbb` to deploy the sample VM as shown below.

  ```bash
  azbb -s <subscription_id> -g <resource_group_name> -l <location> -p single-vm-v2.json --deploy
  ```

For more information on deploying this sample reference architecture, visit our [GitHub repository][git].

## Next steps

- Learn about our [Azure building Blocks][azbbv2].
- Deploy [multiple VMs][multi-vm] in Azure.

<!-- links -->
[audit-logs]: https://azure.microsoft.com/blog/analyze-azure-audit-logs-in-powerbi-more/
[availability-set]: /azure/virtual-machines/virtual-machines-windows-create-availability-set
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks
[azbbv2]: https://github.com/mspnp/template-building-blocks
[azure-cli-2]: /cli/azure/install-azure-cli?view=azure-cli-latest
[azure-dns]: /azure/dns/dns-overview
[azure-storage]: /azure/storage/storage-introduction
[blob-snapshot]: /azure/storage/storage-blob-snapshots
[blob-storage]: /azure/storage/storage-introduction
[boot-diagnostics]: https://azure.microsoft.com/blog/boot-diagnostics-for-virtual-machines-v2/
[cname-record]: https://en.wikipedia.org/wiki/CNAME_record
[data-disk]: /azure/virtual-machines/virtual-machines-windows-about-disks-vhds
[disk-encryption]: /azure/security/azure-security-disk-encryption
[enable-monitoring]: /azure/monitoring-and-diagnostics/insights-how-to-use-diagnostics
[fqdn]: /azure/virtual-machines/virtual-machines-windows-portal-create-fqdn
[git]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/single-vm
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/single-vm
[group-policy]: https://technet.microsoft.com/en-us/library/dn595129.aspx
[log-collector]: https://azure.microsoft.com/blog/simplifying-virtual-machine-troubleshooting-using-azure-log-collector/
[manage-vm-availability]: /azure/virtual-machines/virtual-machines-windows-manage-availability
[multi-vm]: multi-vm.md
[naming-conventions]: /azure/architecture/best-practices/naming-conventions.md
[nsg]: /azure/virtual-network/virtual-networks-nsg
[nsg-default-rules]: /azure/virtual-network/virtual-networks-nsg#default-rules
[planned-maintenance]: /azure/virtual-machines/virtual-machines-windows-planned-maintenance
[premium-storage]: /azure/virtual-machines/windows/premium-storage
[premium-storage-supported]: /azure/virtual-machines/windows/premium-storage#supported-vms
[rbac]: /azure/active-directory/role-based-access-control-what-is
[rbac-roles]: /azure/active-directory/role-based-access-built-in-roles
[rbac-devtest]: /azure/active-directory/role-based-access-built-in-roles#devtest-labs-user
[rbac-network]: /azure/active-directory/role-based-access-built-in-roles#network-contributor
[reboot-logs]: https://azure.microsoft.com/blog/viewing-vm-reboot-logs/
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
[resize-os-disk]: /azure/virtual-machines/virtual-machines-windows-expand-os-disk
[resource-lock]: /azure/resource-group-lock-resources
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[security-center]: /azure/security-center/security-center-intro
[security-center-get-started]: /azure/security-center/security-center-get-started
[select-vm-image]: /azure/virtual-machines/virtual-machines-windows-cli-ps-findimage
[services-by-region]: https://azure.microsoft.com/regions/#services
[static-ip]: /azure/virtual-network/virtual-networks-reserved-public-ip
[virtual-machine-sizes]: /azure/virtual-machines/virtual-machines-windows-sizes
[visio-download]: https://archcenter.azureedge.net/cdn/vm-reference-architectures.vsdx
[vm-disk-limits]: /azure/azure-subscription-service-limits#virtual-machine-disk-limits
[vm-resize]: /azure/virtual-machines/virtual-machines-linux-change-vm-size
[vm-size-tables]: /azure/virtual-machines/virtual-machines-windows-sizes
[vm-sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[0]: ./images/single-vm-diagram.png "Single Windows VM architecture in Azure"
