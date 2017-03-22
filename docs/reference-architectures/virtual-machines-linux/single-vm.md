---
title: Run a Linux VM on Azure
description: >-
  How to run a Linux VM on Azure, paying attention to scalability, resiliency,
  manageability, and security.
services: ''
documentationcenter: na
author: MikeWasson
manager: roshar
editor: ''
tags: ''
pnp.series.title: Linux VM workloads
pnp.series.next: multi-vm
ms.assetid: 9a77b10a-c364-46d7-b28a-1852cd2016f0
ms.service: guidance
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: na
ms.date: 11/22/2016
ms.author: mwasson
pnp.series.prev: ./index
cardTitle: Single VM
---
# Run a Linux VM on Azure

This reference architecture shows a set of proven practices for running a Linux virtual machine (VM) on Azure. It includes recommendations for provisioning the VM along with networking and storage components. This architecture can be used to run a single instance, and is the basis for more complex architectures such as N-tier applications. [**Deploy this solution**.](#deploy-the-solution)

![[0]][0]

## Architecture


Provisioning a VM in Azure involves more moving parts than just the VM itself. There are compute, networking, and storage elements that you need to consider.

* **Resource group.** A [*resource group*][resource-manager-overview] is a container that holds related resources. Create a resource group to hold the resources for this VM.
* **VM**. Azure supports running various popular Linux distributions, including CentOS, Debian, Red Hat Enterprise, Ubuntu, and FreeBSD. For more information, see [Azure and Linux][azure-linux]. You can provision a VM from a list of published images or from a virtual hard disk (VHD) file that you upload to Azure Blob storage. 
* **OS disk.** The OS disk is a VHD stored in [Azure Storage][azure-storage]. That means it persists even if the host machine goes down. The OS disk is `/dev/sda1`.
* **Temporary disk.** The VM is created with a temporary disk. This disk is stored on a physical drive on the host machine. It is *not* saved in Azure Storage, and might be deleted during reboots and other VM lifecycle events. Use this disk only for temporary data, such as page or swap files. The temporary disk is `/dev/sdb1` and is mounted at `/mnt/resource` or `/mnt`.
* **Data disks.** A [data disk][data-disk] is a persistent VHD used for application data. Data disks are stored in Azure Storage, like the OS disk.
* **Virtual network (VNet) and subnet.** Every VM in Azure is deployed into a VNet that is further divided into subnets.
* **Public IP address.** A public IP address is needed to communicate with the VM&mdash;for example over SSH.
* **Network interface (NIC)**. The NIC enables the VM to communicate with the virtual network.
* **Network security group (NSG)**. The [NSG][nsg] is used to allow/deny network traffic to the subnet. You can associate an NSG with an individual NIC or with a subnet. If you associate it with a subnet, the NSG rules apply to all VMs in that subnet.
* **Diagnostics.** Diagnostic logging is crucial for managing and troubleshooting the VM.



> [!NOTE]
> Azure has two different deployment models: [Resource Manager][resource-manager-overview] and classic. This article uses Resource Manager, which Microsoft recommends for new deployments.
> 
> 

## Recommendations

This architecture shows the baseline recommendations for running a Linux VM in Azure. However, we don't recommend using a single VM for mission critical workloads, because it creates a single point of failure. For higher availability, deploy multiple VMs in an [availability set][availability-set]. For more information, see [Running multiple VMs on Azure][multi-vm]. 

### VM recommendations

Azure offers many different virtual machine sizes, but we recommend the DS- and GS-series because these machine sizes support [Premium Storage][premium-storage]. Select one of these machine sizes unless you have a specialized workload such as high-performance computing. For details, see [virtual machine sizes][virtual-machine-sizes].

If you are moving an existing workload to Azure, start with the VM size that's the closest match to your on-premises servers. Then measure the performance of your actual workload with respect to CPU, memory, and disk input/output operations per second (IOPS), and adjust the size if needed. If you require multiple NICs for your VM, be aware that the maximum number of NICs is a function of the [VM size][vm-size-tables].

When you provision the VM and other resources, you must specify a region. Generally, choose a region closest to your internal users or customers. However, not all VM sizes may be available in all region. For details, see [Services by region][services-by-region]. To list the VM sizes available in a given region, run the following Azure command-line interface (CLI) command:

```
azure vm sizes --location <location>
```

For information about choosing a published VM image, see [Select Linux VM images with the Azure CLI][select-vm-image].

### Disk and storage recommendations

For best disk I/O performance, we recommend [Premium Storage][premium-storage], which stores data on solid-state drives (SSDs). Cost is based on the size of the provisioned disk. IOPS and throughput (that is, data transfer rate) also depend on disk size, so when you provision a disk, consider all three factors (capacity, IOPS, and throughput). 

Create separate Azure storage accounts for each VM to hold the virtual hard disks (VHDs) in order to avoid hitting the IOPS limits for storage accounts. 

Add one or more data disks. When you create a VHD, it is unformatted. Log in to the VM to format the disk. In the Linux shell, data disks are displayed as `/dev/sdc`, `/dev/sdd`, and so on. You can run `lsblk` to list the block devices, including the disks. To use a data disk, create a partition and file system, and mount the disk. For example:

```bat
# Create a partition.
sudo fdisk /dev/sdc     # Enter 'n' to partition, 'w' to write the change.     

# Create a file system.
sudo mkfs -t ext3 /dev/sdc1

# Mount the drive.
sudo mkdir /data1
sudo mount /dev/sdc1 /data1
```

If you have a large number of data disks, be aware of the total I/O limits of the storage account. For more information, see [virtual machine disk limits][vm-disk-limits].

When you add a data disk, a logical unit number (LUN) ID is assigned to the disk. Optionally, you can specify the LUN ID &mdash; for example, if you're replacing a disk and want to retain the same LUN ID, or you have an application that looks for a specific LUN ID. However, remember that LUN IDs must be unique for each disk.

You may want to change the I/O scheduler to optimize for performance on SSDs, because the disks for VMs with premium storage accounts are SSDs. A common recommendation is to use the NOOP scheduler for SSDs, but you should use a tool such as [iostat] to monitor disk I/O performance for your particular workload.

For best performance, create a separate storage account to hold diagnostic logs. A standard locally redundant storage (LRS) account is sufficient for diagnostic logs.

### Network recommendations

The public IP address can be dynamic or static. The default is dynamic.

* Reserve a [static IP address][static-ip] if you need a fixed IP address that won't change &mdash; for example, if you need to create an A record in DNS, or need the IP address to be added to a safe list.
* You can also create a fully qualified domain name (FQDN) for the IP address. You can then register a [CNAME record][cname-record] in DNS that points to the FQDN. For more information, see [create a fully qualified domain name in the Azure portal][fqdn].

All NSGs contain a set of [default rules][nsg-default-rules], including a rule that blocks all inbound Internet traffic. The default rules cannot be deleted, but other rules can override them. To enable Internet traffic, create rules that allow inbound traffic to specific ports &mdash; for example, port 80 for HTTP.  

To enable SSH, add a rule to the NSG that allows inbound traffic to TCP port 22.

## Scalability considerations

To scale up or down, [change the VM size][vm-resize]. 

To scale out horizontally, put two or more VMs into an availability set behind a load balancer. For details, see [running multiple VMs on Azure][multi-vm].

## Availability considerations

For higher availabiility, deploy multiple VMs in an availability set. This also provides a higher [service level agreement][vm-sla]  (SLA). 

Your VM may be affected by [planned maintenance][planned-maintenance] or [unplanned maintenance][manage-vm-availability]. You can use [VM reboot logs][reboot-logs] to determine whether a VM reboot was caused by planned maintenance.

VHDs are stored in [Azure storage][azure-storage], and Azure storage is replicated for durability and availability.

To protect against accidental data loss during normal operations (for example, because of user error), you should also implement point-in-time backups, using [blob snapshots][blob-snapshot] or another tool.

## Manageability considerations

**Resource groups.** Put tightly coupled resources that share the same life cycle into the same [resource group][resource-manager-overview]. Resource groups allow you to deploy and monitor resources as a group, and roll up billing costs by resource group. You can also delete resources as a set, which is very useful for test deployments. Give resources meaningful names. That makes it easier to locate a specific resource and understand its role. See [Recommended Naming Conventions for Azure Resources][naming conventions].

**SSH**. Before you create a Linux VM, generate a 2048-bit RSA public-private key pair. Use the public key file when you create the VM. For more information, see [How to Use SSH with Linux and Mac on Azure][ssh-linux].

**VM diagnostics.** Enable monitoring and diagnostics, including basic health metrics, diagnostics infrastructure logs, and [boot diagnostics][boot-diagnostics]. Boot diagnostics can help you diagnose boot failure if your VM gets into a nonbootable state. For more information, see [Enable monitoring and diagnostics][enable-monitoring].  

The following CLI command enables diagnostics:

```
azure vm enable-diag <resource-group> <vm-name>
```

**Stopping a VM.** Azure makes a distinction between "stopped" and "deallocated" states. You are charged when the VM status is stopped, but not when the VM is deallocated.

Use the following CLI command to deallocate a VM:

```
azure vm deallocate <resource-group> <vm-name>
```

In the Azure portal, the **Stop** button deallocates the VM. However, if you shut down through the OS while logged in, the VM is stopped but *not* deallocated, so you will still be charged.

**Deleting a VM.** If you delete a VM, the VHDs are not deleted. That means you can safely delete the VM without losing data. However, you will still be charged for storage. To delete the VHD, delete the file from [Blob storage][blob-storage].

To prevent accidental deletion, use a [resource lock][resource-lock] to lock the entire resource group or lock individual resources, such as the VM. 

## Security considerations

Automate OS updates by using the [OSPatching] VM extension. Install this extension when you provision the VM. You can specify how often to install patches and whether to reboot after patching.

Use [role-based access control][rbac] (RBAC) to control access to the Azure resources that you deploy. RBAC lets you assign authorization roles to members of your DevOps team. For example, the Reader role can view Azure resources but not create, manage, or delete them. Some roles are specific to particular Azure resource types. For example, the Virtual Machine Contributor role can restart or deallocate a VM, reset the administrator password, create a VM, and so forth. Other [built-in RBAC roles][rbac-roles] that might be useful for this architecture include [DevTest Labs User][rbac-devtest] and [Network Contributor][rbac-network]. 

A user can be assigned to multiple roles, and you can create custom roles for even more fine-grained permissions.

> [!NOTE]
> RBAC does not limit the actions that a user logged into a VM can perform. Those permissions are determined by the account type on the guest OS.   
> 
> 

Use [audit logs][audit-logs] to see provisioning actions and other VM events.

Consider [Azure Disk Encryption][disk-encryption] if you need to encrypt the OS and data disks. 

## Deploy the solution

A deployment for this architecture is available on [GitHub][github-folder]. It includes a VNet, NSG, and a single VM. To deploy the architecture, follow these steps: 

1. Click the button below:
<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fguidance-compute-single-vm%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Once the link has opened in the Azure portal, you must enter values for some of the settings: 
   * The **Resource group** name is already defined in the parameter file, so select **Create New** and enter `ra-single-vm-rg` in the text box.
   * Select the region from the **Location** drop down box.
   * Do not edit the **Template Root Uri** or the **Parameter Root Uri** text boxes.
   * Select **linux** in the **Os Type** drop down box.
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click on the **Purchase** button.
3. Wait for the deployment to complete.
4. The parameter files include a hard-coded administrator user name and password, and it is strongly recommended that you immediately change both. Click on the VM named `ra-single-vm0 `in the Azure portal. Then, click on **Reset password** in the **Support + troubleshooting** section. Select **Reset password** in the **Mode** dropdown box, then select a new **User name** and **Password**. Click the **Update** button to persist the new user name and password.


<!-- links -->
[multi-vm]: ../virtual-machines-linux/multi-vm.md
[naming conventions]: ../../best-practices/naming-conventions.md
[audit-logs]: https://azure.microsoft.com/blog/analyze-azure-audit-logs-in-powerbi-more/
[availability-set]: /azure/virtual-machines/virtual-machines-linux-manage-availability
[azure-cli]: /azure/virtual-machines-command-line-tools
[azure-linux]: /azure/virtual-machines/virtual-machines-linux-azure-overview
[azure-storage]: /azure/storage/storage-introduction
[blob-snapshot]: /azure/storage/storage-blob-snapshots
[blob-storage]: /azure/storage/storage-introduction
[boot-diagnostics]: https://azure.microsoft.com/blog/boot-diagnostics-for-virtual-machines-v2/
[cname-record]: https://en.wikipedia.org/wiki/CNAME_record
[data-disk]: /azure/virtual-machines/virtual-machines-linux-about-disks-vhds
[disk-encryption]: /azure/security/azure-security-disk-encryption
[enable-monitoring]: /azure/monitoring-and-diagnostics/insights-how-to-use-diagnostics
[fqdn]: /azure/virtual-machines/virtual-machines-linux-portal-create-fqdn
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/guidance-compute-single-vm/
[iostat]: https://en.wikipedia.org/wiki/Iostat
[manage-vm-availability]: /azure/virtual-machines/virtual-machines-linux-manage-availability
[nsg]: /azure/virtual-network/virtual-networks-nsg
[nsg-default-rules]: /azure/virtual-network/virtual-networks-nsg#default-rules
[OSPatching]: https://github.com/Azure/azure-linux-extensions/tree/master/OSPatching
[planned-maintenance]: /azure/virtual-machines/virtual-machines-linux-planned-maintenance
[premium-storage]: /azure/storage/storage-premium-storage
[rbac]: /azure/active-directory/role-based-access-control-what-is
[rbac-roles]: /azure/active-directory/role-based-access-built-in-roles
[rbac-devtest]: /azure/active-directory/role-based-access-built-in-roles#devtest-labs-user
[rbac-network]: /azure/active-directory/role-based-access-built-in-roles#network-contributor
[reboot-logs]: https://azure.microsoft.com/blog/viewing-vm-reboot-logs/
[Resize-VHD]: https://technet.microsoft.com/library/hh848535.aspx
[Resize virtual machines]: https://azure.microsoft.com/blog/resize-virtual-machines/
[resource-lock]: /azure/resource-group-lock-resources
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[select-vm-image]: /azure/virtual-machines/virtual-machines-linux-cli-ps-findimage
[services-by-region]: https://azure.microsoft.com/regions/#services
[ssh-linux]: /azure/virtual-machines/virtual-machines-linux-mac-create-ssh-keys
[static-ip]: /azure/virtual-network/virtual-networks-reserved-public-ip
[storage-account-limits]: /azure/azure-subscription-service-limits#storage-limits
[storage-price]: https://azure.microsoft.com/pricing/details/storage/
[virtual-machine-sizes]: /azure/virtual-machines/virtual-machines-linux-sizes
[visio-download]: http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx
[vm-disk-limits]: /azure/azure-subscription-service-limits#virtual-machine-disk-limits
[vm-resize]: /azure/virtual-machines/virtual-machines-linux-change-vm-size
[vm-size-tables]: /azure/virtual-machines/virtual-machines-linux-sizes
[vm-sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_0/
[readme]: https://github.com/mspnp/reference-architectures/blob/master/guidance-compute-single-vm
[blocks]: https://github.com/mspnp/template-building-blocks
[0]: ./images/single-vm-diagram.png "Single Linux VM architecture in Azure"

