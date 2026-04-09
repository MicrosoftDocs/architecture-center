Provisioning a virtual machine (VM) in Azure requires additional components besides the VM itself, including networking and storage resources. This article shows best practices for running a secure Linux VM on Azure.

## Architecture

:::image type="content" border="false" source="./images/single-vm-diagram.svg" alt-text="Diagram that shows a Linux VM in Azure." lightbox="./images/single-vm-diagram.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/linux-vm-single-vm-diagram.vsdx) of this architecture.*

### Workflow
This is a very simple implementation with a single virtual machine to show an example of a basic deployment with the required components for a functional virtual machine that can run workloads, be managed, and communicate with the public internet without making it directly reachable by potential bad actors

- Any workloads running on the virtual machine aren't exposed externally, and are only accessible from within the same, or a peered, virtual network, such as in a hub and spoke configuration
- Management access to the virtual machine is shown using Azure Bastion via SSH, and is not directly permitted from the public internet
- Outbound external internet access is provided through the use of the NAT Gateway and its associated Public IP address


### Components

#### Resource group

A [resource group][resource-manager-overview] is a logical container that holds related Azure resources. In general, group resources based on their lifetime and who will manage them.

Deploy closely associated resources that share the same lifecycle into the same [resource group][resource-manager-overview]. Resource groups allow you to deploy and monitor resources as a group and track billing costs by resource group. You can also delete resources as a set, which is useful for test deployments. Assign meaningful resource names to simplify locating a specific resource and understanding its role. For more information, see [Recommended Naming Conventions for Azure Resources](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging).

#### Virtual machine

You can provision a VM from a list of published images, or from a custom managed image or virtual hard disk (VHD) file uploaded to Azure Blob storage. Azure supports running various popular Linux distributions, including Debian, Red Hat Enterprise Linux (RHEL), and Ubuntu. For more information, see [Azure and Linux](/azure/virtual-machines/linux/endorsed-distros).

Azure provides many different [virtual machine sizes](/azure/virtual-machines/sizes). If you move an existing workload to Azure, start with the VM size that's the closest match to your on-premises servers. Then measure the performance of your actual workload in terms of CPU, memory, and disk input/output operations per second (IOPS), and adjust the size as needed.

Generally, choose an Azure region that is closest to your internal users or customers. Not all VM sizes are available in all regions. For more information, see [Services by region](https://azure.microsoft.com/regions/#services). For a list of the VM sizes available in a specific region, run the following command from the Azure CLI:

```azurecli
az vm list-sizes --location <location>
```

For information about choosing a published VM image, see [Find Linux VM images](/azure/virtual-machines/linux/cli-ps-findimage).

#### Disks

For best disk I/O performance, we recommend [Premium SSDs](/azure/virtual-machines/linux/premium-storage), which stores data on solid-state drives (SSDs). Cost is based on the capacity of the provisioned disk. IOPS and throughput (that is, data transfer rate) also depend on disk size, so when you provision a disk, consider all three factors (capacity, IOPS, and throughput). Premium SSDs feature free bursting which, combined with an understanding of workload patterns, offers an effective SKU selection and cost optimization strategy for IaaS infrastructure. This enables high performance without excessive over-provisioning and minimizing the cost of unused capacity.

> [!NOTE]
> Currently, Premium SSD v2 and Ultra disks can only be used for data disks. They are not supported for OS disks.

[Managed Disks](/azure/storage/storage-managed-disks-overview) simplify disk management by handling the storage for you. Managed disks don't require a storage account. You specify the size and type of disk and it's deployed as a highly available resource. Managed disks also offer cost optimization by providing desired performance without the need for over-provisioning, accounting for fluctuating workload patterns, and minimizing unused provisioned capacity.

By default, the OS disk is a managed disk stored in [Azure Disk Storage](/azure/virtual-machines/managed-disks-overview), so it persists even when the host machine is down. In the case of stateless workloads, where fast provisioning and no OS persistence is desired, [ephemeral OS disks](/azure/virtual-machines/ephemeral-os-disks) are recommended. These place the OS image on the VM host's local storage instead of remote Azure Storage, lowering read latency, speeding up reimaging, and eliminating the managed disk cost. However, all data on an ephemeral OS disk is lost on stop-deallocate, reimage, or host maintenance healing events, and ephemeral OS disks don't support snapshots or Azure Backup. Use ephemeral OS disks only when VMs are fully redeployable from automation.

Many Linux images don't configure swap space by default. If your workload requires swap, create it on the temp disk by using [cloud-init](/azure/virtual-machines/linux/cloudinit-configure-swapfile) rather than on the OS disk or a data disk.

We recommend creating one or more [data disks](/azure/virtual-machines/disks-types) for application data. Data disks are persistent managed disks backed by Azure Storage.

When you create a disk, it's unformatted. Log in to the VM to format the disk. In the Linux shell, data disks are displayed as `/dev/sdc`, `/dev/sdd`, and later letters in the series. You can run `lsblk` to list the block devices, including the disks. To use a data disk, create a partition and file system, and mount the disk. For example:

```bash
# Create a partition.

sudo fdisk /dev/sdc     # Enter 'n' to partition, 'w' to write the change.

# Create a file system.

sudo mkfs -t ext3 /dev/sdc1

# Mount the drive.

sudo mkdir /data1
sudo mount /dev/sdc1 /data1
```

When you add a data disk, a logical unit number (LUN) ID is assigned to the disk. Optionally, you can specify the LUN ID &mdash; for example, if you're replacing a disk and want to retain the same LUN ID, or you have an application that looks for a specific LUN ID. However, remember that LUN IDs must be unique for each disk.

You might want to change the I/O scheduler to optimize for performance on SSDs because the disks for VMs with premium storage accounts are SSDs. A common recommendation is to use the NOOP scheduler for SSDs, but you should use a tool such as [iostat](https://en.wikipedia.org/wiki/Iostat) to monitor disk I/O performance for your workload.

Many VMs are created with a temporary disk, which is stored on a physical drive on the host machine. It's *not* saved in Azure Storage and might be deleted during reboots and other VM lifecycle events. Use this disk only for temporary data, such as page or swap files. For Linux VMs, the temporary disk is `/dev/disk/azure/resource-part1` and is mounted at `/mnt/resource` or `/mnt`.

#### Network

The networking components include the following resources:

- **Virtual network**. Every VM is deployed into a virtual network that gets segmented into subnets.

- **Network interface (NIC)**. The NIC enables the VM to communicate with the virtual network. If you need multiple NICs for your VM, a maximum number of NICs is defined for each [VM size](/azure/virtual-machines/sizes).

- **Public IP address**. A public IP address *may* be used to communicate with the VM from outside Azure &mdash; for example, via Secure Sockets Host (SSH)). However, this is discouraged as it's a potential security risk.

  > [!WARNING]
  > Attaching a public IP address directly represents a potential security risk. It should **only** be done in extreme circumstances and only in conjunction with other security methods such as filtering traffic using Network Security Groups (see below). 
  
  For management access to a virtual machine, we recommend you use Azure Bastion (see below) or internally when connected through a VPN or Azure ExpressRoute.

  - The public IP address can be dynamic or static. The default is dynamic. Reserve a [static IP address](/azure/virtual-network/virtual-networks-reserved-public-ip) if you need a fixed IP address that doesn't change &mdash; for example, if you need to create a DNS 'A' record or add the IP address to a safe list.
  - You can also create a fully qualified domain name (FQDN) for the IP address. You can then register a [CNAME record](https://en.wikipedia.org/wiki/CNAME_record) in DNS that points to the FQDN. For more information, see [Create a fully qualified domain name in the Azure portal](/azure/virtual-machines/create-fqdn).
    
- **Network security group (NSG)**. [Network security groups](/azure/virtual-network/virtual-networks-nsg) are used to allow or deny network traffic to VMs and/or subnets. They can be associated with the subnets or with individual NICs attached to VMs.

  - All NSGs contain a set of [default rules](/azure/virtual-network/security-overview#default-security-rules), including a rule that blocks all inbound Internet traffic. The default rules cannot be deleted, but other rules can override them. For example, to enable Internet traffic, create rules that allow inbound traffic to specific ports &mdash; such as port 443 for HTTPS.

- **Azure NAT Gateway.** [Network Address Translation (NAT) gateways](/azure/nat-gateway) allow all instances in a private subnet to connect outbound to the internet while remaining fully private. Only packets that arrive as response packets to an outbound connection can pass through a NAT gateway. Unsolicited inbound connections from the internet aren't permitted. 

> [!NOTE]
> To improve default security, implicit outbound internet access is being deprecated for all new virtual networks. Outbound internet connectivity will need to be explicitly configured through the use of other resources such as NAT Gateways, Azure Standard Load Balancers, or firewalls. See [Default outbound access in Azure](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access?tabs=portal) for details

- **Azure Bastion.** [Azure Bastion](/azure/bastion/) is a fully managed platform as a service solution that provides secure access to VMs via private IP addresses. With this configuration, VMs don't need a public IP address that exposes them to the internet, which increases their security posture. Azure Bastion provides secure RDP or SSH connectivity to your VMs directly over Transport Layer Security (TLS) through various methods, including the Azure portal or native SSH or RDP clients.

### Operations

**SSH**. Before you create a Linux VM, generate a 2048-bit RSA public-private key pair. Use the public key file when you create the VM. For more information, see [How to Use SSH with Linux and Mac on Azure](/azure/virtual-machines/linux/mac-create-ssh-keys).

**Diagnostics**. Enable monitoring and diagnostics, including basic health metrics, diagnostics infrastructure logs, and [boot diagnostics](https://azure.microsoft.com/blog/boot-diagnostics-for-virtual-machines-v2/). Boot diagnostics can help you diagnose boot failure if your VM gets into a non-bootable state. Create an Azure Storage account to store the logs. A standard locally redundant storage (LRS) account is sufficient for diagnostic logs. For more information, see [Enable monitoring and diagnostics](/azure/monitoring-and-diagnostics/insights-how-to-use-diagnostics).

**Availability**. Your VM might be affected by [planned maintenance](/azure/virtual-machines/maintenance-and-updates) or [unplanned downtime](/azure/virtual-machines/linux/manage-availability). You can use [VM reboot logs](https://azure.microsoft.com/blog/viewing-vm-reboot-logs) to determine whether a VM reboot was caused by planned maintenance. For higher availability, deploy multiple VMs across [availability zones](/azure/virtual-machines/availability#availability-zones) within a region. This provides a higher [service-level agreement (SLA)](https://aka.ms/csla). Where availability zones are not supported, [availability sets](/azure/virtual-machines/availability#availability-sets) can help provide protection against host failures or host updates. However availability zones are the recommended option where possible.

**Backups** To protect against accidental data loss, use the [Azure Backup](/azure/backup/) service to back up your VMs to storage. Depending on the region, you can use geo-redundant or zone-redundant storage for backups. Azure Backup provides application-consistent backups. For performance-sensitive workloads or specialized Linux distributions that don't support traditional backup agents, use the [agentless multi-disk crash consistent backup](/azure/backup/backup-azure-vms-agentless-multi-disk-crash-consistent-overview) feature that enables automated backup protection without affecting application performance.

**Stopping a VM**. Azure makes a distinction between "stopped" and "deallocated" states. You are charged when the VM status is stopped, but not when the VM is deallocated. In the Azure portal, the **Stop** button deallocates the VM. If you shut down through the OS while logged in, the VM is stopped but **not** deallocated, so you will still be charged.

**Deleting a VM**. If you delete a VM, you have the option to delete or keep its disks. That means you can safely delete the VM without losing data. However, you will still be charged for the disks. You can delete managed disks just like any other Azure resource. To prevent accidental deletion, use a [resource lock](/azure/resource-group-lock-resources) to lock the entire resource group or lock individual resources, such as a VM.

### Alternatives

- [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) - workloads that are critical to business operations should never depend on a single virtual machine. Scale sets provide the ability to spread workloads across nodes and can scale out in times of higher traffic or scale in when traffic is minimal to help minimize costs.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) would be useful to provide load balancing between multiple virtual machines or a VM scale set. It can also be used as alternative to a NAT Gateway to allow access to a workload from the internet while also supporting outbound access.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) would provide load balancing functionality to the Azure Load Balancer, but for HTTP/HTTPS workloads within an Azure region.

- For a more enterprise-level deployment, see **Azure Virtual Machines baseline architecture in an Azure landing zone** under [Next Steps](#next-steps) below.

## Scenario Details

In the diagam above,  this scenario would be useful for providing a non-critical workload that is useful for internal-only users.

### Potential Use Cases

A single VM deployment could be used to host a simple application that does not need to be exposed to the internet and can withstand some downtime. For example, this may be a basic internal reporting application.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist)

As this architecure is only a simple example using a single virtual machine, it has a minimal level of reliability. Any issue with the virtual machine itself or the host where it is running will cause an outage, resulting in any hosted workloads being unavailable. For any workload that needs higher availability, multiple virtual machines should be deployed that contain the same workload, with those instances behind an appropriate load balancing solution. If these are within the same region, those VMs should be deployed across availability zones (where supported), and added to the backend of an Azure Standard Load Balancer or an Application Gateway if the workload is HTTP/HTTPS-based. This allows for the workload to still be available if a single virtual machine in the backend were to be down.

[Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) are another option to help simplify management of multi-node workloads that need the ability to automatically scale the number of instances in or out depending on any of several metrics such as CPU and/or memory consumption.

#### HA/DR

For an increased "blast radius," the workload should be deployed in multiple regions and leverage the [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/) guidance. This could be in an Active-Passive configuration with a failover to the secondary region should the primary region become unavailable, or an Active-Active architecture where both regions serve traffic to consumers. For an example, see **Multi-tier web application built for HA/DR** under [Next Steps](#next-steps) below.

The example in that article uses [Azure Site Recovery (ASR)](/azure/site-recovery/site-recovery-overview) to replicate the disks of individual virtual machines to a secondary region, where ASR can be used to failover those virtual machines to the secondary region with a low RPO/RTO.

Be sure to evaluate your architecture to meet your HA/DR requirements across all components, not just the virtual machines. Include networking, identity, data, etc in all of these decisions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to get a central view of the security state of your Azure resources. Defender for Cloud monitors potential security issues and provides a comprehensive picture of the security health of your deployment. Defender for Cloud is configured per Azure subscription. Enable security data collection as described in [Connect your Azure subscriptions](/azure/defender-for-cloud/connect-azure-subscription). When data collection is enabled, Defender for Cloud automatically scans any VMs created under that subscription.

**Patch management**. If enabled, Defender for Cloud checks whether any security and critical updates are missing.

**Antimalware**. If enabled, Defender for Cloud checks whether antimalware software is installed. You can also use Defender for Cloud to install antimalware software from inside the Azure portal.

**Access control**. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to control access to Azure resources. Azure RBAC lets you assign authorization roles to members of your DevOps team. For example, the Reader role can view Azure resources but not create, manage, or delete them. Some permissions are specific to an Azure resource type. For example, the Virtual Machine Contributor role can restart or deallocate a VM, reset the administrator password, and create a new VM. Other [built-in roles](/azure/role-based-access-control/built-in-roles) that might be useful for this architecture include [DevTest Labs User](/azure/role-based-access-control/built-in-roles#devtest-labs-user) and [Network Contributor](/azure/role-based-access-control/built-in-roles#network-contributor).

> [!NOTE]
> Azure RBAC does not limit the actions that a user logged into a VM can perform. Those permissions are determined by the account type on the guest OS.

**Audit logs**. Use [audit logs](https://azure.microsoft.com/blog/analyze-azure-audit-logs-in-powerbi-more/) to see provisioning actions and other VM events.

**Data encryption**. Enable [encryption at host](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) to achieve end-to-end encryption for your VM data, including temp disks and disk caches. Encryption at host handles encryption on the VM host infrastructure and doesn't consume VM CPU resources, unlike guest-based encryption. You can use [customer-managed keys](/azure/virtual-machines/disk-encryption#customer-managed-keys) with Azure Key Vault for persistent OS and data disks. Temp disks and [ephemeral OS disks](/azure/virtual-machines/ephemeral-os-disks) are encrypted with platform-managed keys. Verify that your selected [VM size supports encryption at host](/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes) before you provision the VM.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

There are various options for VM sizes depending on the usage and workload. The range includes the most economical option of the Bs-series to the newest GPU VMs optimized for machine learning. For information about the available options, see [Azure Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux).

For predictable workloads, use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract and receive significant savings off pay-as-you-go prices. For workloads with no predictable time of completion or resource consumption, consider the **Pay as you go** option.

Use [Azure Spot VMs](/azure/virtual-machines/windows/spot-vms) to run workloads the can be interrupted and do not require completion within a predetermined timeframe or an SLA. Azure deploys Spot VMs if there is available capacity and evicts when it needs the capacity back. Costs associated with Spot virtual machines are significantly lower. Consider Spot VMs for these workloads:

- High-performance computing scenarios, batch processing jobs, or visual rendering applications.
- Test environments, including continuous integration and continuous delivery workloads.
- Large-scale stateless applications.

Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Use Infrastructure-as-Code (IaC) templates to provision Azure resources and their dependencies. These could be written using [Bicep](/azure/azure-resource-manager/bicep/), [Azure Resource Manager templates (ARM templates)][arm-template], or [Terraform](/azure/developer/terraform/), depending on your preference and established tool choices. These templates allow a Continuous Integration/Continuous Deployment (CI/CD) process as part of an [automated deployment](/devops/deliver/iac-github-actions) methodology for deploying and configuring resources. This approach enables versioning of architectures and ensure consistency between environments, as well as enforcing reproducibility, security, and compliance.

To assist in monitoring and diagnosing issues, ensure that diagnostics logs are enabled on your resources and are made available to [Azure Monitor](https://azure.microsoft.com/services/monitor/) to help with analysis and optimization of your resources. These logs can be used to implement alerting and notifications of critical events, and in some cases allow automated remediation or logging a ticket in your ITSM system.


### Performance Efficiency

Performance Efficiency focuses on optimizing cloud workloads for speed, responsiveness, and scalability. For more information see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist)

Some key goals include minimizing latency, ensuring scalable architectures, optimizing resource utilization, and continuously improving system performance

As mentioned above, the decisions made regarding workload architecture, VM SKU and disk configurations can have a large impact on how your workload performs. Making the correct choices could prevent having to re-architect the solution in the future, adding flexibility and saving costs.

Be sure to consider these points when developing your architecture:
- Use VM scale sets if the workload will have a dynamic load. For example, scale out in times of large amounts of traffic and then scale back in when the traffic reduces. This will ensure adequate processing power while still keeping costs under control.
- Choose the appropriate VM and disk SKUs to meet required IOPS during processing. Configure caching to further improve performance
- Use [Proximity Placement Groups (PPGs)](/azure/virtual-machines/co-location) to ensure that VMs are located physically close to each other to achieve better performance. PPGs can also be used in conjunction with availability sets to combine low latency with high availability
- Where possible, enable accelerated networking to minimize latency between components
- Design network architecture to minimize unnecessary hops
- Use Azure Monitor, VM Insights, and other tools to continuously analyze metrics and create updated performance baselines. Use the performance information to determine where to implement changes, and then test against those baselines

### Contributors
*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Donnie Trumpower](https://www.linkedin.com/in/dtrumpower) | Senior Cloud & AI Solutions Architect

## Next steps

- To create a Linux VM, see [Quickstart: Create a Linux virtual machine in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- To install an NVIDIA driver on a Linux VM, see [Install NVIDIA GPU drivers on N-series VMs running Linux](/azure/virtual-machines/linux/n-series-driver-setup)
- To provision a Linux VM, see [Create and Manage Linux VMs with the Azure CLI](/azure/virtual-machines/linux/tutorial-manage-vm)
- [Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access)
- For an example of a more complex architecture, see [Azure Virtual Machines baseline architecture in an Azure landing zone](/azure/architecture/virtual-machines/baseline-landing-zone)
- To deploy a web application across regions, see [Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)

## Related resource

- [Run a Windows VM on Azure](windows-vm.yml)

[arm-template]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
