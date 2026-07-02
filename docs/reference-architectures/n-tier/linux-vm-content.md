To provision a virtual machine (VM) in Azure, you need more components than the VM itself. A complete deployment includes networking and storage resources. This article describes best practices for running a secure Linux VM on Azure.

## Architecture

:::image type="complex" source="./images/single-vm-diagram.svg" border="false" lightbox="./images/single-vm-diagram.svg" alt-text="Diagram that shows a VM deployment in Azure.":::
  The diagram shows a typical Linux VM deployment. A large dashed box represents the resource group. Inside the resource group, a second dashed box represents the virtual network. Within the virtual network, two subnets are shown side by side. The upper subnet contains a Network Address Translation (NAT) Gateway and a VM, with an attached NIC. A network security group (NSG) sits beneath the NAT Gateway. The NAT Gateway connects leftward via an arrow to the public IP address outside the virtual network, which in turn connects to the internet. The lower subnet contains Azure Bastion and an NSG. A small connection at the bottom-right of the Azure Bastion subnet suggests external management connectivity. At the top of the diagram, above the virtual network, a temp storage icon labeled physical SSD represents the temporary local disk attached to the VM host. To the right of the virtual network box, within the resource group boundary, there's a column of three managed disks. Arrows from the VM point to each of these disks. The lower-right area of the resource group contains a diagnostic logs icon and a logs storage account icon.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/linux-vm-single-vm-diagram.vsdx) of this architecture.*

## Workflow

This example shows a basic deployment that uses the required components for a single VM. The VM can run workloads and reach the public internet while avoiding direct exposure to external threats. In this architecture:

- Workloads on the VM have no direct internet exposure. Access is restricted to resources within the same virtual network or a peered virtual network, such as in a hub-and-spoke configuration.

- You manage the VM by using Azure Bastion via Secure Shell (SSH). There's no direct access from the public internet to the VM for management.

- The Network Address Translation (NAT) Gateway and its associated public IP address provide outbound external internet access.

### Components

This architecture uses the following components.

#### Resource group

A [resource group](/azure/azure-resource-manager/resource-group-overview) is a logical container that holds related Azure resources. Resource groups let you deploy, monitor, and delete related resources together, and track their costs as a unit.

In general, group resources by shared lifecycle and ownership. Use consistent, descriptive names for resources to make them easier to identify and understand. For more information, see [Define your naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

#### Virtual machine

You can provision a VM from a list of published images, a custom managed image, or a virtual hard disk (VHD) uploaded to Azure Blob Storage. Azure supports popular Linux distributions, including Debian, Red Hat Enterprise Linux (RHEL), and Ubuntu. To learn more, see [Endorsed Linux distributions](/azure/virtual-machines/linux/endorsed-distros).

Azure provides many different [VM sizes](/azure/virtual-machines/sizes/overview). If you move an existing workload to Azure, start with the VM size that most closely matches your on-premises servers. After you deploy the VM, measure the performance of your actual workload in terms of CPU, memory, and disk input-output operations per second (IOPS), and adjust the size as needed.

Choose an Azure region that's closest to your internal users or customers. Not all VM sizes are available in all regions. For more information, see [Azure geographies](https://azure.microsoft.com/explore/global-infrastructure/geographies/#services). For a list of the VM sizes available in a specific region, run the following command from the Azure CLI:

```azurecli
az vm list-sizes --location <location>
```

For information about choosing a published VM image, see [Find Azure Marketplace image information](/azure/virtual-machines/linux/cli-ps-findimage).

#### Disks

For the best disk input-output (I/O) performance, we recommend [Premium SSDs](/azure/virtual-machines/linux/premium-storage), which store data on solid-state drives (SSDs). The capacity of the provisioned disk determines cost, IOPS, and throughput (data transfer rate). Consider all three factors when you select a disk size. Premium SSDs include free bursting, which helps you meet peak demand without overprovisioning and reduces the cost of unused capacity when combined with an understanding of workload patterns.

> [!NOTE]
> Premium SSD v2 and Ultra disks can only be used for data disks. They aren't supported for operating system (OS) disks.

[Managed disks](/azure/virtual-machines/managed-disks-overview) simplify disk management by handling the storage for you. Managed disks don't require a storage account. You specify the size and type of disk and it's deployed as a highly available resource. Managed disks also reduce costs by providing the performance that you need without overprovisioning, which helps you avoid paying for unused provisioned capacity.

By default, the OS disk is a managed disk stored in [Azure Disk Storage](/azure/virtual-machines/managed-disks-overview), so it persists even when the host machine is down. For stateless workloads, where fast provisioning and no OS persistence is desired, use [ephemeral OS disks](/azure/virtual-machines/ephemeral-os-disks). These disks place the OS image on the VM host's local storage instead of remote Azure Storage, which reduces read latency, speeds up reimaging, and eliminates the managed disk cost. However, all data on an ephemeral OS disk is lost on stop (deallocate), reimage, or host maintenance healing events. Ephemeral OS disks don't support snapshots or Azure Backup. Use ephemeral OS disks only when VMs are fully redeployable from automation.

By default, many Linux images don't set up swap space. If your workload requires swap, create it on the temporary disk by using [cloud-init](/azure/virtual-machines/linux/cloudinit-configure-swapfile) rather than on the OS disk or a data disk.

We recommend that you create one or more [data disks](/azure/virtual-machines/disks-types) for application data. Data disks are persistent managed disks backed by Storage.

When you create a disk, it's unformatted. Sign in to the VM to format the disk. In the Linux shell, data disks are displayed as `/dev/sdc`, `/dev/sdd`, and later letters in the series. You can run `lsblk` to list the block devices, including the disks. To use a data disk, create a partition and file system, and mount the disk. For example:

```bash
# Create a partition.

sudo fdisk /dev/sdc     # Enter 'n' to partition, 'w' to write the change.

# Create a file system.

sudo mkfs -t ext3 /dev/sdc1

# Mount the drive.

sudo mkdir /data1
sudo mount /dev/sdc1 /data1
```

When you add a data disk, a logical unit number (LUN) ID is assigned to the disk. You can also specify the LUN ID if, for example, you're replacing a disk and want to retain the same LUN ID, or you have an application that looks for a specific LUN ID. However, LUN IDs must be unique for each disk.

For Premium storage disks, you might want to change the I/O scheduler to optimize for performance on SSDs. A common recommendation is to use the No Operation (NOOP) scheduler for SSDs, but you should use a tool such as [iostat](https://en.wikipedia.org/wiki/Iostat) to monitor disk I/O performance for your workload.

Many VMs are created with a temporary disk, which is stored on a physical drive on the host machine. It's *not* saved in Storage and might be deleted during reboots and other VM lifecycle events. Use this disk only for temporary data, such as page or swap files. For Linux VMs, the temporary disk is `/dev/disk/azure/resource-part1` and is mounted at `/mnt/resource` or `/mnt`.

#### Network

The networking components include the following resources:

- **Virtual network:** Every VM is deployed into a virtual network that gets segmented into subnets.

- **Network interface card (NIC):** The NIC connects the VM to the virtual network and handles all inbound and outbound traffic. Each [VM size](/azure/virtual-machines/sizes) defines a maximum number of NICs.

- **Public IP address:** A public IP address *can* be used to communicate with the VM from outside Azure via SSH. However, this option is discouraged because it's a potential security risk.

  > [!WARNING]
  > Avoid attaching a public IP address directly to a VM. *Only* do so in extreme circumstances and include other security measures, such as using network security groups (NSGs) to filter traffic.

  For management access to a VM, use Azure Bastion for browser-based SSH access, or connect privately through a VPN or Azure ExpressRoute.

  - The public IP address can be dynamic or static. The default is dynamic. Reserve a [static IP address](/azure/virtual-network/virtual-networks-reserved-public-ip) when you need a fixed IP address that doesn't change, for example, if you need to create a DNS 'A' record or add the IP address to a safe list.

  - You can also create a fully qualified domain name (FQDN) for the IP address. You can then register a [CNAME record](https://en.wikipedia.org/wiki/CNAME_record) in DNS that points to the FQDN. For more information, see [Create a fully qualified domain name for a VM](/azure/virtual-machines/create-fqdn).
    
- **NSG:** Use [NSGs](/azure/virtual-network/network-security-groups-overview) to allow or deny network traffic to VMs and subnets. Associate them with the subnets or with individual NICs attached to VMs.

  All NSGs contain a set of [default security rules](/azure/virtual-network/security-overview#default-security-rules), including a rule that blocks all inbound internet traffic. You can't delete the default rules, but you can override them with other rules. For example, you can create rules that allow inbound internet traffic to specific ports, such as port 443 for HTTPS.

- **Azure Network Address Translation (NAT) Gateway:** [Azure NAT Gateway](/azure/nat-gateway) allows all instances in a private subnet to connect outbound to the internet while remaining fully private. Only packets that arrive as response packets to an outbound connection can pass through a NAT gateway. Unsolicited inbound connections from the internet aren't permitted. 

  > [!NOTE]
  > To improve default security, implicit outbound internet access is being deprecated for all new virtual networks. You need to explicitly configure outbound internet connectivity by using other resources such as NAT Gateway, Azure Standard Load Balancers, or firewalls. For more information, see [Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access).

- **Azure Bastion:** [Azure Bastion](/azure/bastion/) is a fully managed platform as a service (PaaS) solution that provides secure access to VMs via private IP addresses. With this configuration, VMs don't need a public IP address that exposes them to the internet, which increases their security posture. Azure Bastion provides secure Remote Desktop Protocol (RDP) or SSH connectivity to your VMs directly over Transport Layer Security (TLS) by using various methods, including the Azure portal, or native SSH or RDP clients.

### Operations

This section covers key operational practices for managing a Linux VM in Azure.

- **SSH:** Before you create a Linux VM, generate a 2048-bit RSA public-private key pair. Use the public key file when you create the VM. For more information, see [Create and use an SSH public-private key pair](/azure/virtual-machines/linux/mac-create-ssh-keys).

- **Diagnostics:** Enable monitoring and diagnostics, including basic health metrics, diagnostics infrastructure logs, and [boot diagnostics](https://azure.microsoft.com/blog/boot-diagnostics-for-virtual-machines-v2/). Boot diagnostics can help you diagnose boot failure if your VM gets into a nonbootable state. Store diagnostic logs in a Storage account. A standard locally redundant storage (LRS) account is sufficient for diagnostic logs. For more information, see [Best practices for monitoring and diagnostics](../../best-practices/monitoring.md).

- **Availability:** [Planned maintenance](/azure/virtual-machines/maintenance-and-updates) or [unplanned downtime](/azure/virtual-machines/availability) might affect your VM. You can use [VM reboot logs](https://azure.microsoft.com/blog/viewing-vm-reboot-logs) to determine whether planned maintenance caused a VM reboot. For higher availability, deploy multiple VMs across [availability zones](/azure/virtual-machines/availability#availability-zones) within a region. This deployment provides a higher [service-level agreement (SLA)](https://aka.ms/csla). Where availability zones aren't supported, [availability sets](/azure/virtual-machines/availability#availability-sets) can help provide protection against host failures or host updates. However, availability zones are the recommended option where possible.

- **Backups:** To protect against accidental data loss, use the [Azure Backup](/azure/backup/) service to back up your VMs to storage. Depending on the region, you can use geo-redundant storage or zone-redundant storage for backups. Azure Backup provides application-consistent backups. For performance-sensitive workloads or specialized Linux distributions that don't support traditional backup agents, use the [agentless multi-disk crash consistent backup](/azure/backup/backup-azure-vms-agentless-multi-disk-crash-consistent-overview) feature to automate backup protection without affecting application performance.

- **Stopping a VM:** Azure makes a distinction between *stopped* and *deallocated* states. You're charged when the VM status is stopped, but not when the VM is deallocated. In the Azure portal, the **Stop** button deallocates the VM. If you shut down the VM through the OS while logged in, the VM is stopped but *not* deallocated, so you still pay.

- **Deleting a VM:** If you delete a VM, you can choose to delete or keep its disks, which lets you retain the data. However, you still pay for the disks. You can delete managed disks like any other Azure resource. To prevent accidental deletion, use a [resource lock](/azure/resource-group-lock-resources) to lock the entire resource group or lock individual resources, such as a VM.

### Alternatives

- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) provide the ability to spread workloads across nodes. Workloads that are critical to business operations should never depend on a single VM. You can add or remove VM instances automatically based on demand, and can scale out in times of higher traffic or scale in when traffic is lower to help minimize costs.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) distributes traffic between multiple VMs or a virtual machine scale set. It can also be used as an alternative to a NAT Gateway to allow access to a workload from the internet while also supporting outbound access.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) provides load balancing functionality to the Azure Load Balancer for HTTP/HTTPS workloads within an Azure region.

- For an enterprise-level deployment, see [Azure Virtual Machines baseline architecture in an Azure landing zone](../../virtual-machines/baseline-landing-zone.yml).

## Scenario details

The previous diagram shows a basic deployment of a single VM in a virtual network. This scenario is useful for providing a noncritical workload for internal-only users.

### Potential use cases

This architecture suits a simple application that doesn't need public internet exposure and can tolerate occasional downtime. A basic internal reporting tool is a typical use case.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This example architecture uses a single VM, so it provides a minimal level of reliability. Any problem with the VM, or with the host where it runs, causes an outage and makes hosted workloads unavailable. For any workload that needs higher availability, deploy multiple VMs that contain the same workload and place those instances behind an appropriate load-balancing solution. If they're located within the same region, deploy those VMs across availability zones (where supported), and add them to the back end of an Azure Standard Load Balancer or an Application Gateway if the workload is HTTP/HTTPS-based. This architecture allows the workload to remain available if a single VM in the back end goes down.

[Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview) are another option to help simplify management of multiple-node workloads that need the ability to automatically scale the number of instances in or out depending on any of several metrics such as CPU and memory consumption.

#### High availability and disaster recovery (HA/DR)

To reduce blast radius and improve resiliency, deploy the workload in multiple regions and use the [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) guidance. This deployment could be in an active-passive configuration, with failover to the secondary region if the primary region becomes unavailable, or an active-active architecture where both regions serve traffic to consumers. 

For an example, see [Multitier web application built for high availability and disaster recovery](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml). The example in that article uses [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) to replicate the disks of individual VMs to a secondary region. You can use Site Recovery to fail over those VMs to the secondary region by using a low recovery point objective (RPO) and recovery time objective (RTO).

Be sure to evaluate your architecture to meet your HA/DR requirements across all components, not only the VMs. In all of these decisions, include considerations such as networking, identity, and data.

### Security

Security provides protections against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider these points when you develop your architecture:

- Use [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to get a central view of the security state of your Azure resources. Defender for Cloud monitors potential security problems and provides a comprehensive picture of the security health of your deployment. Configure Defender for Cloud per Azure subscription and [enable security data collection](/azure/defender-for-cloud/connect-azure-subscription). Defender for Cloud automatically scans VMs created under that subscription.

   - **Patch management:** When enabled, Defender for Cloud identifies missing security and critical updates.

   - **Anti-malware:** When enabled, Defender for Cloud checks whether anti-malware software is installed. You can also use Defender for Cloud to install anti-malware software directly from the Azure portal.

- Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) to control access to Azure resources. With Azure RBAC, you grant users only the permissions that they need to do their job. For example, the Reader role can view Azure resources but can't create, manage, or delete them. Some permissions are specific to an Azure resource type. For example, the Virtual Machine Contributor role can restart or deallocate a VM, reset the administrator password, and create a new VM. Other [built-in roles](/azure/role-based-access-control/built-in-roles) that might be useful for this architecture include [DevTest Labs User](/azure/role-based-access-control/built-in-roles#devtest-labs-user) and [Network Contributor](/azure/role-based-access-control/built-in-roles#network-contributor).

   > [!NOTE]
   > Azure RBAC doesn't limit the actions that a user logged into a VM can perform. The account type on the guest OS determines those permissions.

- Use [audit logs](/azure/security/fundamentals/log-audit) to see provisioning actions and other VM events.

- Enable [encryption at host](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) to achieve end-to-end encryption for your VM data, including temporary disks and disk caches. Encryption at host handles encryption on the VM host infrastructure and doesn't consume VM CPU resources, unlike guest-based encryption. You can use [customer-managed keys](/azure/virtual-machines/disk-encryption#customer-managed-keys) with Azure Key Vault for persistent OS and data disks. Temporary disks and [ephemeral OS disks](/azure/virtual-machines/ephemeral-os-disks) are encrypted with platform-managed keys. Verify that your selected [VM size supports encryption at host](/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes) before you provision the VM.

### Cost Optimization

Cost Optimization focuses on finding ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

There are various options for VM sizes depending on the usage and workload. The range includes the most economical option of the Bs-series to the newest GPU VMs optimized for machine learning. For information about the available options, see [Azure Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux).

For predictable workloads, use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plans/#benefits-and-features). A one-year or three-year contract can reduce compute costs substantially compared to pay-as-you-go rates. For workloads with no predictable time of completion or resource consumption, consider the *Pay as you go* option.

[Azure Spot VMs](/azure/virtual-machines/spot-vms) use spare Azure capacity at significantly reduced rates. Azure can evict Spot VMs with short notice when it needs the capacity back, so they're only suitable for fault-tolerant workloads with no strict completion deadline. Consider spot VMs for:

- High-performance computing scenarios, batch processing jobs, or visual rendering applications.
- Test environments, including continuous integration and continuous delivery workloads.
- Large-scale stateless applications.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Use infrastructure as code (IaC) templates to provision Azure resources and their dependencies. You can write these templates by using [Bicep](/azure/azure-resource-manager/bicep/), [Azure Resource Manager](/azure/azure-resource-manager/templates/overview), or [Terraform](/azure/developer/terraform/). These templates can be used as part of a continuous integration and continuous deployment (CI/CD) pipeline via [automated deployment](/devops/deliver/iac-github-actions). This approach provides version control over your architecture, ensures consistency between environments, and enforces reproducibility, security, and compliance.

To help monitor and diagnose problems, enable diagnostic logs on your resources and send them to [Azure Monitor](/azure/azure-monitor/overview) for analysis and optimization. You can use these logs to implement alerting and notifications of critical events, and in some cases allow automated remediation or logging of tickets in your IT Service Management (ITSM) system.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance Efficiency helps you minimize latency, achieve scalable architectures, optimize resource utilization, and continuously improve system performance. The decisions that you make regarding workload architecture, VM size, and disk configurations can greatly affect your workload performance. Making the right choices can prevent the need to rearchitect the solution in the future, add flexibility, and save costs.

Consider these points when you develop your architecture:

- Use virtual machine scale sets if the workload has a dynamic load. For example, scale out during times of high traffic and then scale back in when traffic drops. This approach ensures adequate processing power while keeping costs under control.

- Choose the appropriate VM and disk SKUs to meet required IOPS during processing. Configure caching to further improve performance.

- If your workload is unusually latency-sensitive, use [proximity placement groups (PPGs)](/azure/virtual-machines/co-location) to ensure that multiple VMs are located physically close to each other to achieve better performance. You can also combine PPGs with availability sets to achieve low latency and high availability within a single physical datacenter.

- Where possible, enable accelerated networking to minimize latency between components.

- Design network architecture to minimize unnecessary hops.

- Use Azure Monitor and other tools to continuously analyze metrics and create updated performance baselines. Use the performance information to determine where to implement changes, and then test against those baselines.

## Contributors

*Microsoft maintains this article. The following contributors originally wrote the article.*

Principal author:

- [Donnie Trumpower](https://www.linkedin.com/in/dtrumpower) | Senior Cloud & AI Solutions Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Quickstart: Create a Linux VM in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- [Install NVIDIA GPU drivers on N-series VMs running Linux](/azure/virtual-machines/linux/n-series-driver-setup)
- [Tutorial: Create and manage Linux VMs with the Azure CLI](/azure/virtual-machines/linux/tutorial-manage-vm)
- [Default outbound access in Azure](/azure/virtual-network/ip-services/default-outbound-access)

## Related resources

- [Run a Windows VM on Azure](windows-vm.yml)
- [Virtual Machines baseline architecture in an Azure landing zone](../../virtual-machines/baseline-landing-zone.yml)
- [Multitier web application built for high availability and disaster recovery](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)

