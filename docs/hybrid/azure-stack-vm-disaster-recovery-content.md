This article describes the architecture and design considerations of a solution that delivers an optimized approach to the disaster recovery of workloads that run on virtual machines (VMs) that are hosted on Azure Stack Hub.

## Architecture

![The diagram illustrates the architecture of an Azure Stack Hub disaster recovery solution that's based on Azure Site Recovery. The solution consists of a configuration server and process server components that run on an Azure Stack Hub VM. These components are capable of protecting Windows Server VMs that run such workloads as SQL Server and Sharepoint Server. They can also protect CentOS and Ubuntu Linux VMs. The Azure components of the solution include a geo-redundant Azure Recovery Services vault that handles orchestration tasks and an Azure Storage account that serves as the destination of the replication traffic that originates from the Azure Stack Hub VMs.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Workflow

The cloud components of the proposed solution include the following services:

- An Azure subscription that hosts all cloud resources that are part of this solution.
- An [Azure Active Directory (Azure AD)](/azure/active-directory) tenant associated with the Azure subscription that provides authentication of Azure AD security principals to authorize access to Azure resources.
- An [Azure Recovery Services](/azure/backup/backup-azure-recovery-services-vault-overview) vault in the Azure region that's closest to an on-premises datacenter that hosts the Azure Stack Hub deployment.

  > [!NOTE]
  > The choice of the Azure region that's closest to the on-premises datacenter is specific to the sample scenario that's included in this article. From a disaster recovery standpoint, it's better to select an Azure region that's further away from the location that hosts the production environment. The decision, however, can depend on other factors, such as the need to minimize the latency of regional data feeds or to satisfy data residency requirements.

- An [Azure ExpressRoute](/azure/expressroute) circuit that connects the on-premises datacenters to the Azure region that hosts the Azure Recovery Services vault, configured with private peering and Microsoft peering. The former ensures that latency requirements are met after a failover. The purpose of the latter is to minimize the amount of time that it takes to replicate changes between the on-premises workloads and the failover site in Azure.
- An [Azure Storage](/azure/storage/blobs) account that holds blobs that contain the VHD files that are created by replication of the operating system and data volumes of protected [Azure Stack Hub VMs](/azure-stack/user/azure-stack-compute-overview). These VHD files serve as the source for the managed disks of Azure VMs that are automatically provisioned after a failover.
- An [Azure virtual network](/azure/virtual-network) that hosts the disaster recovery environment. It's configured in a manner that mirrors the virtual network environment in the Azure Stack Hub that hosts the production workloads, including components such as load balancers and network security groups. This virtual network is typically connected to the Azure Stack Hub virtual network via an ExpressRoute connection to facilitate workload-level recovery.

  > [!NOTE]
  > Sometimes a site-to-site VPN connection suffices in scenarios where Recovery Point Objective (RPO) requirements are less stringent.

- An isolated Azure virtual network intended for test failovers, configured in a manner that mirrors the virtual network environment in Azure Stack Hub hosting the production workloads, including components such as load balancers and network security groups.

The on-premises components of the proposed solution include the following services:

- An Azure Stack Hub integrated system in the connected deployment model. The system runs the current update (2002 as of 9/20) and is in the customer's on-premises datacenter.
- An Azure Stack Hub subscription and a virtual network, or multiple peered virtual networks, that hosts all the on-premises VMs for this solution.
- Azure Site Recovery configuration and process servers that run on Windows Server 2016 or 2012 R2 Azure Hub Stack VMs. The servers manage communications with the Azure Recovery Services vault, and the routing, optimization, and encryption of replication traffic.

  > [!NOTE]
  > By default, a configuration server hosts a single process server. You can deploy dedicated process servers to accommodate a larger volume of replication traffic.

- The Azure Stack Hub VMs that are to be protected. They run supported versions of the Windows Server, CentOS, and Ubuntu operating systems.
- The Site Recovery Mobility service (also referred to as *mobility agent*) that runs on protected VMs. It tracks changes to local disks, records the changes in replication logs, and replicates the logs to the process server. The process server routes them to the target Azure storage account. The logs are used to create recovery points for managed disks that are implemented by using blobs that are stored in the Azure storage account that you designate.

### Components

- [Azure Active Directory](https://azure.microsoft.com/products/active-directory)
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network)
- [Azure Recovery Services](https://azure.microsoft.com/products/site-recovery)
- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs)
- [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub)

### Alternatives

The recommended solution that's described in this article isn't the only way to provide disaster recovery functionality for Azure Stack Hub VM-based workloads. Customers have other options, including:

- A failover to another Azure Stack Hub stamp. Users that need to protect against a datacenter or site outage might be able to use another Azure Stack Hub deployment to implement disaster recovery provisions. With primary and secondary locations, users can deploy applications in an active/passive configuration across two environments. For less critical workloads, it might be acceptable to use unused capacity in the secondary location to perform on-demand restoration of applications from backup. You can also implement a recovery site in another datacenter, which, in turn, uses Site Recovery to provision a replica of the recovery site in Azure. Several factors determine whether the use of Site Recovery with Azure serving as the failover site is a viable solution. These factors include government regulations, corporate policies, and latency requirements.

  > [!NOTE]
  > As of July 2020, Site Recovery doesn't support this scenario, which means that the implementation has to use a partner or in-house solution.

- Back up and restore. Backing up your applications and datasets makes it possible for you to recover quickly from downtime that results from data corruption, accidental deletions, or localized outages. For Azure Stack Hub VM-based applications, you can use an in-guest agent to protect application data, operating system configurations, and data that's stored on volumes. Backing up a VM by using a guest OS agent typically includes capturing operating system configurations, files, folders, volumes, application binaries, and application data. Recovering an application from an agent requires recreation of the VM, followed by installation of the operating system and the guest agent. At that point, you can restore data into the guest OS.
- Backup of disk snapshots. It's possible to use snapshots to capture an Azure Stack Hub VM configuration and the disks that are attached to a stopped VM. This process requires backup products that integrate with Azure Stack Hub APIs to capture VM configuration and create disk snapshots.

  > [!NOTE]
  > As of July 2020, using disk snapshots for a running VM isn't supported. Creating a snapshot of a disk that's attached to a running VM might degrade the performance or affect the availability of the operating system or of the application in the VM.

- Back up and restore VMs by using an external backup solution in the same datacenter, and then replicate the backups to another location. In this way, you can restore Azure Stack Hub VMs to the same Azure Stack Hub instance, or to a different one, or to Azure.

## Scenario details

Azure Stack Hub includes self-healing functionality, providing auto-remediation in a range of scenarios that involve localized failures of its components. However, large-scale failures, including outages that affect server racks or site-level disasters, require additional considerations. These considerations should be part of the business continuity and disaster recovery strategy for VM-based user workloads. This strategy must also account for recovery of the Azure Stack infrastructure, which is separate from workload recovery.

Traditional on-premises workload recovery solutions are complex to configure, expensive and labor-intensive to maintain, and difficult to automate, especially when you use another on-premises location as the failover site. Microsoft recommends an alternative solution that relies on a combination of cloud and on-premises components to deliver resilient, performance-based, highly automated, and straightforward ways to implement, secure, and manage a cost-efficient disaster recovery strategy. The core element of this solution is Site Recovery, with the failover site residing in Azure.

### Potential use cases

Site Recovery with Azure as the failover site eliminates all of the aforementioned drawbacks. You can use its capabilities to protect both physical and virtual servers, including those running on either Microsoft Hyper-V or VMware ESXi virtualization platforms. You can also use the same capabilities to facilitate the recovery of workloads that run on Azure Stack Hub VMs.

### Core functionality

Site Recovery is a disaster recovery solution that facilitates protection of physical and virtual computers by providing two sets of features:

- Replication of changes to computer disks that are between the production and disaster recovery locations
- Orchestration of failover and failback between these two locations

Site Recovery offers three types of failovers:

- Test failover. This failover gives you the opportunity to validate your Site Recovery configuration in an isolated environment, without any data loss or impact to the production environment.
- Planned failover. This failover gives you the option to initiate disaster recovery without data loss, typically as part of planned downtime.
- Unplanned failover. This failover serves as the last resort in case of an unplanned outage affecting availability of the primary site and potentially resulting in data loss.

Site Recovery supports several scenarios, such as failover and failback between two on-premises sites, failover and failback between two Azure regions, and migration from third party provider clouds. However, in the context of this article, the focus is on replication of local disks of Azure Stack Hub VMs to Azure Storage, and on VM failover and failback between an Azure Stack Hub stack and an Azure region.

> [!NOTE]
> The Site Recovery scenario which involves replicating between on-premises VMware-based or physical datacenters reaches its end of service on December 31, 2020.

> [!NOTE]
> There's no support for Site Recovery between two deployments of Azure Stack Hub.

Details of Site Recovery architecture and its components depend on a number of criteria, including:

- The types of computers to be protected (physical versus virtual).
- For virtualized environments, the type of hypervisor hosting the virtual machines to be protected (Hyper-V versus VMware ESXi).
- For Hyper-V environments, the use of System Center Virtual Machine Manager (SCVMM) for management of Hyper-V hosts.

With Azure Stack Hub, the architecture matches the one applicable to physical computers. This isn't particularly surprising, because in both cases, Site Recovery can't benefit from direct access to a hypervisor. Instead, the mechanism that tracks and replicates changes to local disks is implemented within the protected operating system.

> [!NOTE]
> Incidentally, this is also the reason that you need to select **Physical machines** as the **Machine type** when configuring replication of Azure Stack Hub VMs in the Site Recovery interface within the Azure portal. Another implication is a unique approach to failback, which doesn't offer the same degree of automation as the one available in Hyper-V or ESXi-based scenarios.

To accomplish this, Site Recovery relies on the Site Recovery Mobility service (also referred to as *mobility agent*), which is automatically deployed to individual VMs as you enroll them into the scope of Site Recovery-based protection. On each protected VM, the locally installed instance of the mobility agent continuously monitors and forwards changes to the operating system and data disks to the process server. However, to optimize and manage the flow of replication traffic originating from protected VMs, Site Recovery implements an additional set of components running on a separate VM, referred to as the configuration server.

The configuration server coordinates communications with the Site Recovery vault and manages data replication. In addition, the configuration server hosts a component referred to as the process server, which acts as a gateway, receiving replication data, optimizing it through caching and compression, encrypting it, and finally forwarding it to Azure Storage. Effectively, the configuration server functions as the integration point between Site Recovery and protected VMs running on Azure Stack Hub. You implement that integration by deploying the configuration server and registering it with the Azure Recovery Services vault.

As part of Site Recovery configuration, you define the intended disaster recovery environment, including such infrastructure components as virtual networks, load balancers, or network security groups in the manner that mirrors the production environment. The configuration also includes a replication policy, which determines recovery capabilities and consists of the following parameters:

- RPO threshold. This setting represents the desired recovery point objective that you want to implement and determines the frequency in which Site Recovery generates crash-consistent recovery point snapshots. Its value doesn't affect the frequency of replication because that replication is continuous. Site Recovery will generate an alert, and optionally, an email notification, if the current effective RPO provided by Site Recovery exceeds the threshold that you specify. Site Recovery generates crash-consistent recovery point snapshots every five minutes.

  > [!NOTE]
  > A crash consistent snapshot captures data that was on the disk when the snapshot was taken. It doesn't include memory content. Effectively, a crash-consistent snapshot doesn't guarantee data consistency for the operating system or locally installed apps.

- Recovery point retention. This setting represents the duration (in hours) of the retention window for each recovery point snapshot. Protected VMs can be recovered to any recovery point within a retention window. Site Recovery supports up to 24 hours of retention for VMs replicated to Azure Storage accounts with the premium performance tier. There's a 72-hour retention limit when using Azure Storage accounts with the standard performance tier.
- App-consistent snapshot frequency. This setting determines the frequency (in hours) in which Site Recovery generates application-consistent snapshots. An app-consistent snapshot represents a point-in-time snapshot of applications running in a protected VM. There's a limit of 12 app-consistent snapshots. For VMs running Windows Server, Site Recovery uses Volume Shadow Copy Service (VSS). Site Recovery also supports app-consistent snapshots for Linux, but that requires implementing custom scripts. The scripts are used by the mobility agent when applying an app-consistent snapshot.

  > [!NOTE]
  > For details regarding implementing app-consistent snapshots on Azure Stack Hub VMs running Linux, refer to [General questions about Site Recovery.](/azure/site-recovery/site-recovery-faq#can-i-enable-replication-with-app-consistency-in-linux-servers)

For each disk of a protected Azure Stack Hub VM that you designate, data is replicated to a corresponding managed disk in Azure Storage. The disk stores the copy of the source disk and all the recovery point crash-consistent and app-consistent snapshots. As part of a failover, you choose a recovery point crash-consistent or app-consistent snapshot that should be used when attaching the managed disk to the Azure VM, which serves as a replica of the protected Azure Stack Hub VM.

During regular business operations, protected workloads run on Azure Stack Hub VMs, with changes to their disks being continuously replicated through interactions among the mobility agent, process server, and configuration server to the designated Azure Storage account. When you initiate a test, planned, or unplanned failover, Site Recovery automatically provisions Azure VMs using the replicas of disks of the corresponding Azure Stack Hub VMs.

> [!NOTE]
> The process of provisioning Azure VMs by using Site Recovery-replicated disks is referred to as *hydration*.

You have the option to orchestrate a failover by creating recovery plans that contain manual and automated steps. To implement the latter, you can use Azure Automation runbooks, which consist of custom PowerShell scripts, PowerShell workflows, or Python 2 scripts.

After the primary site becomes available again, Site Recovery supports reversing the direction of replication, allowing you to perform a failback with minimized downtime and without data loss. However, with Azure Stack Hub, this approach isn't available. Instead, to fail back, it's necessary to download Azure VM disk files, upload them into Azure Stack Hub, and attach them to existing or new VMs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Azure Stack Hub helps increase workload availability through resiliency inherent to its infrastructure. This resiliency provides high availability for Azure Stack Hub VMs protected by Site Recovery and to essential components of the on-premises Site Recovery infrastructure, including the configuration and process servers.

Similarly, you have the option to use resiliency of cloud-based components of Site Recovery infrastructure. By default, Azure Recovery Services is geo-redundant, which means that its configuration is automatically replicated to an Azure region that's part of a pre-defined region pair. You have the option to change the replication settings to locally redundant if that's sufficient for your resiliency needs. Note that you can't change this option if the vault contains any protected items. The same resiliency option is available for any Azure Storage accounts with the standard performance tier, although it's possible to change it at any point.

> [!NOTE]
> For the listing of Azure region pairs, refer to [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

You can further enhance the degree of this resiliency by designing and implementing solutions that extend the scope of workload protection. This is the added value provided by Site Recovery. In the context of Site Recovery running on Azure Stack Hub, there are two main aspects of workload availability that need to be explored in more detail:

- Failover to Azure
- Failback to Azure Stack Hub

You need to consider both when developing a disaster recovery strategy driven by recovery point objectives (RPOs) and recovery time objectives (RTOs). RTO and RPO represent continuity requirements stipulated by individual business functions within an organization. RPO designates a time period representing maximum acceptable data loss following an incident that affected availability of that data. RTO designates the maximum acceptable duration of time it can take to reinstate business functions following an incident that affected the availability of these functions.

#### Failover to Azure

Failover to Azure is at the core of availability considerations in the context of Site Recovery-based protection of Azure Stack Hub VMs. To maximize workload availability, the failover strategy should address both the need to minimize potential data loss (RPO) and minimize failover time (RTO).

To minimize potential data loss, you might consider:

- Maximizing throughput and minimizing latency of the replication traffic by following scalability and performance considerations. For more information, refer to the next section of this article.
- Increasing the frequency of app-consistent recovery points for database workloads (up to the maximum of one recovery point per hour). App-consistent recovery points are created from app-consistent snapshots. App-consistent snapshots capture app data on disk and in memory. While this approach minimizes potential data loss, it has one major drawback. App-consistent snapshots require the use of [Volume Shadow Copy Service](/windows-server/storage/file-server/volume-shadow-copy-service) on Windows or custom scripts on Linux, to quiesce locally installed apps. The capture process can hurt performance, especially if resource utilization is high. We don't recommend that you use low frequency for app-consistent snapshots for non-database workloads.

The primary method of minimizing failover time involves the use of Site Recovery recovery plans. A recovery plan orchestrates a failover between the primary and secondary sites, defining the sequence in which protected servers fail over. You can customize a plan by adding manual instructions and automated tasks. Its purpose is to make the process consistent, accurate, repeatable, and automated.

When creating a recovery plan, you assign protected servers to recovery groups for the purpose of failover. Servers in each group fail over together. This helps you to divide the failover process into smaller, easier to manage units, representing sets of servers which can fail over without relying on external dependencies.

To minimize failover time, as part of creating a recovery plan, you should:

- Define groups of Azure Stack Hub VMs that should fail over together.
- Define dependencies between groups of Azure Stack Hub VMs to determine the optimal sequence of a failover.
- Automate failover tasks, if possible.
- Include custom manual actions, if required.

> [!NOTE]
> A single recovery plan can contain up to 100 protected servers.

> [!NOTE]
> In general, recovery plans can be used for both failover to and failback from Azure. This doesn't apply to Azure Stack Hub, which doesn't support Site Recovery-based failback.

You define a recovery plan and create recovery groups to capture app-specific properties. As an example, let's consider a traditional three-tier app with a SQL Server-based back end, a middleware component, and a web front end. When creating a recovery plan, you can control the startup order of servers in each tier, with the servers running SQL Server instances coming online first, followed by those in the middleware tier, and joined afterwards by servers hosting the web front end. This sequence ensures that the app is working by the time the last server starts. To implement it, you can simply create a recovery plan with three recovery groups, containing servers in the respective tiers.

In addition to controlling failover and startup order, you also have the option to add actions to a recovery plan. In general, there are two types of actions:

- Automated. This action is based on Azure Automation runbooks, which involves one of two types of tasks:
  - Provisioning and configuring Azure resources, including, for example, creating a public IP address and associating it with the network interface attached to an Azure VM.
  - Modifying the configuration of the operating system and applications running within an Azure VM that was provisioned following a failover.
- Manual. This action doesn't support automation and is included in a recovery plan primarily for documentation purposes.

> [!NOTE]
> To determine the failover time of a recovery plan, perform a test failover and then examine the details of the corresponding Site Recovery job.

> [!NOTE]
> To address the RTO requirements for Azure Stack Hub workloads, you should account for recovery of the Azure Stack infrastructure, user VMs, applications, and user data. In the context of this article, we are interested only in the last two of these components, although we also present considerations regarding the availability of the Modern Backup Storage functionality.

#### Failback to Azure Stack Hub

In Site Recovery-based scenarios, failback, if properly implemented, doesn't involve data loss. This means that the focus of the failover strategy is to minimize failback time (RTO). However, as previously mentioned, when failing back to Azure Stack Hub, you can't rely on your recovery plans. Instead, the failback involves the following sequence of steps:

1. Stop and deallocate Azure VMs in the disaster recovery environment.
1. Identify the URI parameter of each of the managed disks attached to the VMs you intend to download.
1. Download the virtual hard disk (VHD) files identified by the URI parameters you identified in the previous step to your on-premises environment.
1. Upload the VHD files to Azure Stack Hub.
1. Attach the uploaded VHDs to new or existing Azure Stack Hub VMs.
1. Start the Azure Stack Hub VMs.

The optimal approach to minimizing the failback time is to automate it.

> [!NOTE]
> For more information regarding automating the failback procedure described in this section, refer to [Create VM disk storage in Azure Stack Hub](/azure-stack/user/azure-stack-manage-vm-disks?view=azs-2002#use-powershell-to-add-multiple-disks-to-a-vm).

> [!NOTE]
> For more information regarding identifying the URI parameter of managed disks, refer to [Download a Windows VHD from Azure](/azure/virtual-machines/windows/download-vhd).

#### Workload-specific considerations

Site Recovery integrates with Windows Server-based apps and roles, including SharePoint, Exchange, SQL Server, and Active Directory Domain Services (AD DS). This allows you to use the following capabilities to implement app-level protection and recovery:

- Integration with app-level replication technologies, such as SQL Server AlwaysOn Availability Groups, Exchange Database Availability Groups (DAGs), and AD DS replication
- App-consistent snapshots, for single or multiple tier applications
- A rich automation library that provides production-ready, application-specific scripts that can be downloaded and integrated with recovery plans

Alternatively, you have the option to use workload-specific replication mechanisms to provide site-level resiliency. This is a commonly used option when implementing disaster recovery for AD DS domain controllers, SQL Server, or Exchange, all of which natively support replication. Though this requires provisioning Azure VMs hosting these workloads in the disaster recovery environment, which increases the cost, it offers the following benefits:

- Reduces time required for failover and failback
- Simplifies workload-level failover, accommodating scenarios in which site-level failover isn't required

> [!NOTE]
> For more information regarding Site Recovery workload-specific considerations, refer to [About disaster recovery for on-premises apps.](/azure/site-recovery/site-recovery-workload)

### Security

Managing disaster recovery of user VM-based workloads in hybrid scenarios warrants additional security considerations. These considerations can be grouped into the following categories:

- Encryption in transit. This includes communication between protected Azure Stack Hub VMs, on-premises Site Recovery components, and cloud-based Site Recovery components:
  - Mobility agent installed on the protected VMs always communicates with the process server via Transport Layer Security (TLS) 1.2.
  - It's possible for communication from the configuration server to Azure and from the process server to Azure to use TLS 1.1 or 1.0. To increase the level of security for hybrid connectivity, you should consider enforcing the use of TLS 1.2.

   > [!NOTE]
  > For details regarding configuring TLS 1.2-based encryption, refer to [Transport Layer Security (TLS) registry settings](/windows-server/security/tls/tls-registry-settings) and [Update to enable TLS 1.1 and TLS 1.2 as default secure protocols in WinHTTP in Windows](https://support.microsoft.com/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi)

- Encryption at rest. This includes Azure Storage and Azure VMs in the disaster recovery site.
  - Azure Storage is encrypted at rest for all storage accounts using 256-bit Advanced Encryption Standard encryption and is Federal Information Processing Standard 140-2 compliant. Encryption is enabled automatically and can't be disabled. By default, encryption uses Microsoft-managed keys, but customers have the option to use their own keys stored in an Azure Key vault.
  - Managed disks of Azure VMs are automatically encrypted by using *server-side encryption of Azure managed disks*, which also applies to their snapshots, by relying on using platform-managed encryption keys.

In addition, you can enforce restricted access to the Azure Storage accounts hosting content of Site Recovery-replicated disks. To do this, enable the managed identity for the Recovery Services vault and assign to that managed identity the following Azure role-based access control (Azure RBAC) roles at the Azure Storage account level:

- Resource Manager-based storage accounts (standard performance tier):
  - Contributor
  - Storage Blob Data Contributor
- Resource Manager-based storage accounts (premium performance tier):
  - Contributor
  - Storage Blob Data Owner

The Azure Recovery Services vault offers mechanisms that further protect its content, including the following protections:

- Azure RBAC. This allows for delegation and segregation of responsibilities according to the principle of least privilege. There are three Site Recovery-related built-in roles that restrict access to Site Recovery operations:
  - Site Recovery Contributor. This role has all the permissions required to manage Site Recovery operations in an Azure Recovery Services vault. A user with this role, however, can't create or delete the vault or assign access rights to other users. This role is best suited for disaster recovery administrators who can enable and manage disaster recovery for an Azure Stack Hub tenant.
  - Site Recovery Operator. This role has permissions to execute and manage failover and failback operations. A user with this role can't enable or disable replication, create or delete vaults, register new infrastructure, or assign access rights to other users. This role is best suited for a disaster recovery operator who can fail over Azure Stack Hub VMs when instructed by application owners and IT administrators in an actual or simulated disaster scenario.
  - Site Recovery Reader. This role has permissions to track all Site Recovery management operations. This role is best suited for IT staff responsible for monitoring the status of protected Azure Stack Hub VMs and raising support tickets if required.
- Azure Resource Locks. You have the option to create and assign read-only and delete locks to a Site Recovery vault to mitigate the risk of the vault being accidentally and maliciously changed or deleted.
- Soft delete. The purpose of soft delete is to help protect the vault and its data from accidental or malicious deletions. With soft delete, any deleted content is retained for 14 additional days, allowing for its retrieval during that period. The additional 14-day retention of vault content doesn't incur any cost. Soft delete is enabled by default.
- Protection of security-sensitive operations. Azure Recovery Services vault allows you to enable an additional layer of authentication whenever a security-sensitive operation, such as disabling protection, is attempted. This extra validation helps ensure that authorized users perform such operations.
- Monitoring and alerts of suspicious activity. Azure Recovery Services provides built-in monitoring and alerting of security-sensitive events related to the vault operations.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

When considering the cost of the Site Recovery-based disaster recovery solution described in this article, you need to account for both on-premises and cloud-based components. The Azure Stack Hub pricing model determines the pricing of on-premises components. As with Azure, Azure Stack Hub offers a pay-as-you-use arrangement, available through enterprise agreements and the Cloud Solution Provider program. This arrangement includes a monthly price for each Windows Server VM. If you have the option to use existing Windows Server licenses, you can significantly reduce the cost to the base VM pricing. However, with Site Recovery, you will usually need only a single Azure Stack Hub VM per tenant, which is required to implement the tenant-specific configuration server.

Azure-related charges are associated with the use of the following resources:

- Azure Recovery Services. The pricing is determined by the number of protected instances. It's worth noting that every protected instance incurs no Site Recovery charges for the first 31 days.
- Azure Storage. The pricing reflects a combination of the following factors:
  - Performance tier
  - Volume of data stored
  - Volume of outbound data transfer
  - Quantity and types of operations performed (for standard performance tier only)
  - Data redundancy (for standard performance tier only)
- Azure ExpressRoute. The pricing is based on one of two models:
  - Unlimited data. This model includes a monthly fee with all inbound and outbound data transfers included.
  - Metered data. This model includes a monthly fee with all inbound data transfers free of charge and outbound data transfers charged per GB.

   > [!NOTE]
  > This assessment doesn't include the costs of physical connections delivered by third party connectivity providers.

- Azure VMs. The pricing of Azure VMs reflects a combination of two components:
  - Compute cost. The VM size, its uptime, and the licensing model of its operating system determine the cost.
  - Managed disk cost. The disk size and performance tier determine the cost.

  > [!NOTE]
  > It's worth noting that hydration eliminates the need to run Azure VMs during regular business operations, with workloads running on Azure Stack Hub, which considerably reduces the compute costs of Site Recovery-based implementations, especially in comparison to traditional disaster recovery solutions.

  > [!NOTE]
  > The prices of resources vary between Azure regions.

  > [!NOTE]
  > For details regarding pricing, refer to [Azure Pricing](https://azure.microsoft.com/pricing).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

The primary considerations regarding manageability of Site Recovery-based disaster recovery of Azure Stack Hub VMs include:

- Implementation of Site Recovery on Azure Stack Hub
- Failover and failback procedures
- Delegation of roles and responsibilities
- DevOps

#### Implementation of Site Recovery on Azure Stack Hub

To implement Site Recovery on Azure Stack Hub in a small to medium sized single-tenant environment, you can follow the manual provisioning process driven by the graphical interface of Recovery Services Vault in the Azure portal. For multi-tenant implementations, you might want to consider automating parts of the implementation process, because you will typically need to set up a separate configuration server VM and a separate Recovery Services vault for each tenant. You also have the option to automate deployment of the mobility agent by following the procedure described in [Prepare source machine for push installation of mobility agent](/azure/site-recovery/vmware-azure-install-mobility-service).

#### Failover and failback procedures

To simplify the management of failover, consider implementing recovery plans for all protected workloads. For more information, refer to the [Reliability](#reliability) section earlier in this article. You will also find recommendations for optimizing the management of the failback procedure.

#### Delegation of roles and responsibilities

Planning for and implementing disaster recovery of Azure Stack Hub VM-based workloads by using Site Recovery typically involves interaction of stakeholders:

- Azure Stack Hub operators manage Azure Stack Hub infrastructure, ensuring that there are sufficient compute, storage, and network resources necessary for implementing a comprehensive disaster recovery solution and making these resources available to tenants. They also collaborate with application and data owners to help determine the optimal approach to deploying their workloads to Azure Stack Hub.
- Azure administrators manage Azure resources necessary to implement hybrid disaster recovery solutions.
- Azure AD administrators manage Azure AD resources, including user and group objects that are used to provision, configure, and manage Azure resources.
- Azure Stack Hub tenant IT staff designs, implements, and manages Site Recovery, including failover and failback.
- Azure Stack Hub users need to provide RPO and RTO requirements and submit requests to implement disaster recovery for their workloads.

Make sure there's a clear understanding of the roles and responsibilities attributed to application owners and operators in the context of protection and recovery. Users are responsible for protecting VMs. Operators are responsible for the operational status of the Azure Stack Hub infrastructure.

> [!NOTE]
> For guidance regarding fine-grained delegation of permissions in Site Recovery scenarios, refer to [Manage Site Recovery access with Azure role-based access control (Azure RBAC)](/azure/site-recovery/site-recovery-role-based-linked-access-control).

#### DevOps

While configuring VM-level recovery by using Site Recovery is primarily a responsibility of IT operations, there are some DevOps-specific considerations that should be incorporated into a comprehensive disaster recovery strategy. Azure Stack Hub facilitates implementing Infrastructure-as-Code (IaC), which incorporates the automated deployment of a variety of workloads, including VM-based applications and services. You can use this capability to streamline the provisioning of Site Recovery-based disaster recovery scenarios, which simplifies the initial setup in multiple tenant scenarios.

For example, you can use the same Azure Resource Manager templates to provision all of the network resources necessary to accommodate VM-based workloads in an Azure Stack Hub stamp for your application in a single, coordinated operation. You can use the same template to provision a matching set of resources in Azure to provision a disaster recovery site. To account for any differences between the two environments, you can simply specify different values of template parameters in each case.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

When planning to deploy Site Recovery on Azure Stack Hub, you need to consider the amount of processing, storage, and network resources allocated to the configuration and process servers. You might need to adjust the estimated sizing of the Azure Stack Hub VM hosting the Site Recovery components post deployment to accommodate changes in processing or storage requirements. You have three basic options to adjust the sizing:

- Implement vertical scaling. This involves modifying the amount and type of processor, memory, and disk resources of the Azure Stack Hub VM hosting the configuration server including the process server. To estimate resource requirements, you can use the information in the following table:

  *Table 1: Configuration and process server sizing requirements*

   | CPU                                      | Memory | Cache disk | Data change rate | Protected machines  |
   |------------------------------------------|--------|------------|------------------|---------------------|
   | 8 vCPUs 2 sockets \* 4 cores @ 2\.5 GHz  | 16GB   | 300 GB     | 500 GB or less   | < 100 machines      |
   | 12 vCPUs 2 sockets \* 6 cores @ 2\.5 GHz | 18 GB  | 600 GB     | 500 GB\-1 TB     | 100 to 150 machines |
   | 16 vCPUs 2 sockets \* 8 cores @ 2\.5 GHz | 32 GB  | 1 TB       | 1\-2 TB          | 150\-200 machines   |

- Implement horizontal scaling. This involves provisioning or deprovisioning Azure Stack Hub VMs with the process server installed to match processing demands of protected Azure Stack Hub VMs. In general, if you have to scale your deployment to more than 200 source machines, or you have a total daily churn rate of more than two terabytes (TB), you need additional process servers to handle replication traffic. To estimate the number and configuration of additional process servers, refer to [Size recommendations for the process server](/azure/site-recovery/site-recovery-plan-capacity-vmware#size-recommendations-for-the-process-server).

- Modify replication policy. This involves changing parameters of the replication policy, with focus on app-consistent snapshots.

From the networking standpoint, there are several different methods to adjust bandwidth available for replication traffic:

- Modify VM size. The size of Azure Stack Hub VMs determines the maximum network bandwidth. However, it's important to note that there are no bandwidth guarantees. Instead, VMs can utilize the amount of available bandwidth up to the limit determined by their size.
- Replace uplink switches. Azure Stack Hub systems support a range of hardware switches, offering several choices of uplink speeds. Each Azure Stack Hub cluster node has two uplinks to the top of rack switches for fault tolerance. The system allocates half of the uplink capacity for critical infrastructure. The remainder is shared capacity for Azure Stack Hub services and all user traffic. Systems deployed with faster speeds have more bandwidth available for replication traffic.

   > [!NOTE]
  > While it's possible to segregate network traffic by attaching a second network adapter to a server, with Azure Stack Hub VMs, all VM traffic to the internet shares the same uplink. A second, virtual network adapter won't segregate traffic at the physical transport level.

- Modify throughput of the network connection to Azure. To accommodate larger volumes of replication traffic, you might consider using Azure ExpressRoute with Microsoft peering for connections between Azure Stack Hub virtual networks and Azure Storage. Azure ExpressRoute extends on-premises networks into the Microsoft cloud over a private connection supplied by a connectivity provider. You can buy ExpressRoute circuits for a wide range of bandwidths, from 50 megabits per second (Mbps) to 100 gigabits per second.

   > [!NOTE]
  > For details regarding implementing Azure ExpressRoute in Azure Stack Hub scenarios, refer to [Connect Azure Stack Hub to Azure using Azure ExpressRoute](/azure-stack/operator/azure-stack-connect-expressroute?view=azs-2002).

- Modify throttling of replication traffic on the process server. You can control how much bandwidth is used by the replication traffic on the VMs that are hosting process servers from the graphical interface of the Microsoft Azure Recovery Services agent. The supported capabilities include setting the limits for work and non-work hours, with the bandwidth values ranging from 512 kilobits per second to 1,023 Mbps. Alternatively, you can apply the same configuration by using the **Set-OBMachineSetting** PowerShell cmdlet.
- Modify network bandwidth allocated per protected VM on the process server. To accomplish this, modify the value of **UploadThreadsPerVM** entry within the **HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Azure Backup\\Replication** key. By default, the value is set to 4, but you can increase it to 32 if there's enough network bandwidth available.

## Deploy this scenario

### Prerequisites

Implementing the recommended solution is contingent on satisfying the following prerequisites:

- Access to an Azure subscription, with permissions sufficient to provision and manage all cloud components of the Site Recovery components, including:
  - Azure Recovery Services vault in the Azure region designated as the disaster recovery site for the Azure Stack Hub production environment.
  - An Azure Storage account hosting content of replicated disks of Azure Stack Hub VMs.
  - An Azure virtual network representing the disaster recovery environment to which hydrated Azure VMs will be connected following a planned or unplanned failover.
  - An isolated Azure virtual network representing the test environment to which hydrated Azure VMs will be connected following a test failover.
  - An Azure ExpressRoute-based connectivity between the on-premises environment, Azure virtual networks, and the Azure storage account used for hosting copies of VHD files with content replicated from disks of protected Azure Stack Hub VMs.
- An Azure Stack Hub user subscription. All Azure Stack Hub VMs protected by an individual Site Recovery configuration server must belong to the same Azure Stack Hub user subscription.
- An Azure Stack Hub virtual network. All protected VMs must have direct connectivity to the VMs hosting the process server component (by default this is the configuration server VM).
- An Azure Stack Hub Windows Server VM that will host the configuration server and a process server. The VM must belong to the same subscription and be attached to the same virtual network as the Azure Stack Hub VMs that need to be protected. In addition, the VM needs to:

  - Comply with [Site Recovery configuration server software and hardware requirements](/azure/site-recovery/vmware-physical-azure-support-matrix#site-recovery-configuration-server)
  - Satisfy external connectivity [network requirements](/azure/site-recovery/vmware-azure-deploy-configuration-server#network-requirements) documentation.

   > [!NOTE]
   > Additional storage and performance considerations for the configuration and process servers are described in more detail later in this architecture.

  - Satisfy internal connectivity requirements. In particular, Azure Stack Hub VMs that you want to protect need to be able to communicate with:

    - The configuration server via TCP port **443** (HTTPS) inbound for replication management
    - The process server via TCP port **9443** to deliver replication data.

    > [!NOTE]
    > You can change the port used by the process server for both external and internal connectivity as part of its configuration when running Site Recovery Unified Setup.

- Azure Stack Hub VMs to be protected, running any of the [supported operating systems](/azure/site-recovery/azure-stack-site-recovery) To protect Azure Stack Hub VMs that are running Windows Server operating systems, you must:
  - Create a Windows account with administrative rights. You can specify this account when you enable Site Recovery on these VMs. The process server uses this account to install the Site Recovery Mobility service. In a workgroup environment, make sure to disable Remote User Access control on target Windows Server operating systems by setting the value of the **LocalAccountTokenFilterPolicy** **DWORD** registry entry in the **HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System** key to 1.
  - Enable File and Printer Sharing and Windows Management Instrumentation rules in Microsoft Defender firewall.
- To protect Azure Stack Hub VMs that are running Linux operating systems, you must:
  - Create a root user account. You can specify this account when you enable Site Recovery on these VMs. The process server uses this account to install the Site Recovery Mobility service.
  - Install the latest openssh, openssh-server, and openssl packages.
  - Enable and run Secure Shell (SSH) port **22**.
  - Enable Secure FTP subsystem and password authentication.

### High-level implementation steps

At a high level, the implementation of Site Recovery-based disaster recovery on Azure Stack Hub consists of the following stages:

1. Prepare Azure Stack Hub VMs to be protected by Site Recovery. Ensure that the VMs satisfy Site Recovery prerequisites listed in the previous section.
1. Create and configure an Azure Recovery Services vault. Set up an Azure Recovery Services vault and specify what you want to replicate. Site Recovery components and activities are configured and managed by using the vault.
1. Set up the source replication environment. Provision a Site Recovery configuration server and process server by installing Site Recovery Unified Setup binaries and register it with the vault.

   > [!NOTE]
   > You can rerun the Site Recovery Unified Setup to implement additional process servers on Azure Stack Hub VMs.

1. Set up the target replication environment. Create or select an existing Azure storage account and an Azure virtual network in the Azure region that will host the disaster recovery site. During replication, the content of the disks for the protected Azure Stack Hub VMs is copied to the Azure Storage account. During failover, Site Recovery automatically provisions Azure VMs serving as replicas of protected Azure Stack Hub VMs and connects them to the Azure virtual network.
1. Enable replication. Configure replication setting and enable replication for Azure Stack Hub VMs. The mobility service is installed automatically on each Azure Stack Hub VM for which replication is enabled. Site Recovery initiates replication of each Azure Stack Hub VM, according to the policy settings you defined.
1. Perform a test failover. After replication is established, verify that failover will work as expected by performing a test failover.
1. Perform a planned or unplanned failover. Following a successful test failover, you are ready to conduct either a planned or unplanned failover to Azure. You have the option to designate which Azure Stack Hub VMs to include in the failover.
1. Perform a failback. When you are ready to fail back, stop the Azure VMs corresponding to the Azure Stack Hub VMs you failed, download their disk files to on-premises storage, upload them into Azure Stack Hub, and attach them to an existing or new VM.

## Summary

In conclusion, Azure Stack Hub is a unique offering, which differs in many aspects from other virtualization platforms. As such, it warrants special considerations in regard to business continuity strategy for its workloads. By using Azure services, you can simplify designing and implementing this strategy. In this architecture reference article, we explored the use of Microsoft Site Recovery for protecting Azure Stack Hub VM-based workloads in the connected deployment model. This approach allows customers to benefit from resiliency and manageability of Azure Stack Hub and from the hyperscale and global presence of the Azure cloud.

It's important to note that the disaster recovery solution described here focused exclusively on VM-based workloads of Azure Stack Hub. This is only part of an overall business continuity strategy that should account for other Azure Stack Hub workload types and scenarios that affect their availability.

[architectural-diagram]: ./images/azure-stack-vm-dr.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-vm-dr.vsdx

## Next steps

Product documentation:

- [About Site Recovery](/azure/site-recovery/site-recovery-overview)
- [Azure Stack Hub overview](/azure-stack/operator/azure-stack-overview)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure Blob storage?](/azure/storage/blobs/storage-blobs-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

Microsoft Learn modules:

- [Azure Stack Hub](/training/modules/azure-stack-hub)
- [Configure Azure Active Directory](/training/modules/configure-azure-active-directory)
- [Configure storage accounts](/training/modules/configure-storage-accounts)
- [Configure virtual networks](/training/modules/configure-virtual-networks)
- [Design and implement Azure ExpressRoute](/training/modules/design-implement-azure-expressroute)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Back up files and applications on Azure Stack Hub](azure-stack-backup.yml)
- [Hybrid connections](../solution-ideas/articles/hybrid-connectivity.yml)
- [Hybrid file share with disaster recovery for remote and local branch workers](../example-scenario/hybrid/hybrid-file-share-dr-remote-local-branch-workers.yml)
