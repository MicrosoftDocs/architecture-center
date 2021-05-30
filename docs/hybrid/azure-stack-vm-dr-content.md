


This document describes the architecture and design considerations of a solution that delivers an optimized approach to disaster recovery of virtual machine (VM)-based user workloads hosted on Azure Stack Hub.

![The diagram illustrates the architecture of an Azure Stack Hub disaster recovery solution based on Azure Site Recovery. The solution consists of a configuration server and process server components runing on an Azure Stack Hub VM. These components are capable of protecting both Windows Server VMs running such workloads as SQL Server or Sharepoint Server, as well as CentOS and Ubuntu Linux VMs. The Azure components of the solution include an geo-redundant Azure Recovery Services vault handling orchestration tasks and an Azure Storage account serving as the destination of the replication traffic originating from the Azure Stack Hub VMs.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Azure Stack Hub includes self-healing functionality, providing auto-remediation in a range of scenarios involving localized failures of its components. However, large-scale failures, including outages affecting server racks or site-level disasters, require additional considerations. These considerations should be part of the business continuity and disaster recovery strategy for VM-based user workloads. This strategy must also account for recovery of the Azure Stack infrastructure, which is separate from workload recovery.

Traditional, on-premises workload recovery solutions are complex to configure, expensive and labor-intensive to maintain, and challenging to automate, especially when using another on-premises location as the failover site. Microsoft recommends an alternative solution that relies on a combination of the cloud and on-premises components to deliver resilient, performance-based, highly automated, and straightforward ways to manage, secure, and achieve a cost-efficient disaster recovery strategy. The core element of this solution is the Microsoft Azure Recovery Services offering, with the failover site residing in Azure.

Azure Site Recovery with Azure as the failover site eliminates all of these drawbacks. You can use its capabilities to protect both physical and virtual servers, including those running on either Microsoft Hyper-V or VMware ESXi virtualization platforms. You also have the option to leverage the same capabilities to facilitate recovery of workloads running on Azure Stack Hub VMs.

## Architecture of the proposed solution

The cloud components of the proposed solution include the following services:

- An Azure subscription hosting all cloud resources that are part of this solution.
- An Azure Active Directory (Azure AD) tenant associated with the Azure subscription that provides authentication of Azure AD security principals to authorize access to Azure resources.
- An Azure Recovery Services vault in the Azure region closest to an on-premises datacenter that will host the Azure Stack Hub deployment.

  >[!Note] 
  > The choice of the Azure region which is closest to the on-premises datacenter is specific to the sample scenario included in this reference architecture document. From a disaster recovery standpoint, it would be preferable to select an Azure region further away from the location hosting the production environment. The decision, however, might depend on additional factors, such as the need to minimize latency of regional data feeds or to satisfy data residency requirements.

- An Azure ExpressRoute circuit connecting the on-premises datacenters to the Azure region hosting the Azure Recovery Services vault, configured with private peering and Microsoft peering. The former ensures that the latency requirements following a failover during disaster recovery scenarios are satisfied. The purpose of the latter is to minimize the amount of time it takes to replicate changes between the on-premises workloads and the failover site in Azure.
- An Azure Storage account that hosts blobs containing VHD files created by replication of the operating system and data volumes of protected Azure Stack Hub VMs. These VHD files serve as the source for managed disks of Azure VMs which are automatically provisioned following a failover.
- An Azure virtual network that will host the disaster recovery environment, configured in a manner that mirrors the virtual network environment in Azure Stack Hub hosting the production workloads, including components such as load balancers and network security groups. This virtual network is typically connected to the Azure Stack Hub virtual network via an ExpressRoute connection to facilitate workload-level recovery.

  >[!Note] 
  > A site-to-site VPN connection might be sufficient in scenarios where Recovery Point Objectives (RPOs) requirements are less stringent.

- An isolated Azure virtual network intended for test failovers, configured in a manner that mirrors the virtual network environment in Azure Stack Hub hosting the production workloads, including components such as load balancers and network security groups.

The on-premises components of the proposed solution include the following services:

- An Azure Stack Hub integrated system in the connected deployment model, running the current update (2002 as of 9/20), and located within the customer's on-premises datacenter.
- An Azure Stack Hub subscription and a virtual network or multiple peered virtual networks hosting all on-premises VMs that are part of this solution.
- Azure Site Recovery configuration and process servers, running on Windows Server 2016 or 2012 R2 Azure Hub Stack VMs, managing communications with the Azure Recovery Services vault and the routing, optimization, and encryption of replication traffic.

  >[!Note] 
  > By default, a configuration server hosts a single process server. You have the option to deploy dedicated process servers to accommodate a larger volume of replication traffic.

- Azure Stack Hub VMs to be protected, running supported versions of Windows Server, CentOS, or Ubuntu operating systems.
- Azure Site Recovery Mobility service (also referred to as *mobility agent*) installed and running on protected VMs, which tracks changes to local disks, records them into replication logs, and replicates the logs to the process server, which, in turn, routes them to the target Azure storage account. The logs are used to create recovery points for managed disks implemented by using blobs stored in the Azure storage account you designated.

## Core functionality

Azure Site Recovery is a disaster recovery solution that facilitates protection of physical and virtual computers by providing two sets of features:

- Replication of changes to computer disks between the production and disaster recovery locations
- Orchestration of failover and failback between these two locations

Azure Site Recovery offers three types of failovers:

- Test failover. This failover gives you the opportunity to validate your Azure Site Recovery configuration in an isolated environment, without any data loss or impact to the production environment.
- Planned failover. This failover gives you the option to initiate disaster recovery without data loss, typically as part of planned downtime.
- Unplanned failover. This failover serves as the last resort in case of an unplanned outage affecting availability of the primary site and potentially resulting in data loss.

Azure Site Recovery supports several scenarios, such as failover and failback between two on-premises sites, failover and failback between two Azure regions, and migration from third party provider's clouds. However, in the context of this reference architecture document, the focus is on replication of local disks of Azure Stack Hub VMs to Azure Storage, and on VM failover and failback between an Azure Stack Hub stamp and an Azure region.

>[!Note] 
> The Site Recovery scenario which involves replicating between on-premises VMware-based or physical datacenters reaches its end of service on December 31, 2020.

>[!Note] 
> There is no support for Azure Site Recovery between two deployments of Azure Stack Hub.

Details of Azure Site Recovery architecture and its components depend on a number of criteria, including:

- The types of computers to be protected (physical versus virtual).
- For virtualized environments, the type of hypervisor hosting the virtual machines to be protected (Hyper-V versus VMware ESXi).
- For Hyper-V environments, the use of System Center Virtual Machine Manager (SCVMM) for management of Hyper-V hosts.

With Azure Stack Hub, the architecture matches the one applicable to physical computers. This isn't particularly surprising, because in both cases, Azure Site Recovery can't benefit from direct access to a hypervisor. Instead, the mechanism that tracks and replicates changes to local disks is implemented within the protected operating system.

>[!Note] 
> Incidentally, this is also the reason that you need to select **Physical machines** as the **Machine type** when configuring replication of Azure Stack Hub VMs in the Azure Site Recovery interface within the Azure portal. Another implication is a unique approach to failback, which doesn't offer the same degree of automation as the one available in Hyper-V or ESXi-based scenarios.

To accomplish this, Azure Site Recovery relies on the Site Recovery Mobility service (also referred to as *mobility agent*), which is automatically deployed to individual VMs as you enroll them into the scope of Azure Site Recovery-based protection. On each protected VM, the locally installed instance of the mobility agent continuously monitors and forwards changes to the operating system and data disks to the process server. However, to optimize and manage the flow of replication traffic originating from protected VMs, Azure Site Recovery implements an additional set of components running on a separate VM, referred to as the configuration server. 

The configuration server coordinates communications with the Azure Site Recovery vault and manages data replication. In addition, the configuration server hosts a component referred to as the process server, which acts as a gateway, receiving replication data, optimizing it through caching and compression, encrypting it, and finally forwarding it to Azure Storage. Effectively, the configuration server functions as the integration point between Azure Site Recovery and protected VMs running on Azure Stack Hub. You implement that integration by deploying the configuration server and registering it with the Azure Recovery Services vault.

As part of Azure Site Recovery configuration, you define the intended disaster recovery environment, including such infrastructure components as virtual networks, load balancers, or network security groups in the manner that mirrors the production environment. The configuration also includes a replication policy, which determines recovery capabilities and consists of the following parameters:

- RPO threshold. This setting represents the desired recovery point objective that you want to implement and determines the frequency in which Azure Site Recovery generates crash-consistent recovery point snapshots. Its value doesn't affect the frequency of replication because that replication is continuous. Azure Site Recovery will generate an alert, and optionally, an email notification, if the current effective RPO provided by Azure Site Recovery exceeds the threshold that you specify. Azure Site Recovery generates crash-consistent recovery point snapshots every five minutes.

  >[!Note] 
  > A crash consistent snapshot captures data that were on the disk when the snapshot was taken. It doesn't include memory content. Effectively, a crash-consistent snapshot doesn't guarantee data consistency for the operating system or locally installed apps.

- Recovery point retention. This setting represents the duration (in hours) of the retention window for each recovery point snapshot. Protected VMs can be recovered to any recovery point within a retention window. Azure Site Recovery supports up to 24 hours of retention for VMs replicated to Azure Storage accounts with the premium performance tier. There is a 72-hour retention limit when using Azure Storage accounts with the standard performance tier.
- App-consistent snapshot frequency. This setting determines the frequency (in hours) in which Azure Site Recovery generates application-consistent snapshots. An app-consistent snapshot represents a point-in-time snapshot of applications running in a protected VM. There is a limit of 12 app-consistent snapshots. For VMs running Windows Server, Azure Site Recovery leverages Volume Shadow Copy Service (VSS). Azure Site Recovery also supports app-consistent snapshots for Linux, but that requires implementing custom scripts. The scripts are used by the mobility agent when applying an app-consistent snapshot.

  >[!Note] 
  > For details regarding implementing app-consistent snapshots on Azure Stack Hub VMs running Linux, refer to [General questions about Azure Site Recovery.](/azure/site-recovery/site-recovery-faq#can-i-enable-replication-with-app-consistency-in-linux-servers)

For each disk of a protected Azure Stack Hub VM that you designate, data are replicated to a corresponding managed disk in Azure Storage. The disk stores the copy of the source disk and all the recovery point crash-consistent and app-consistent snapshots. As part of a failover, you choose a recovery point crash-consistent or app-consistent snapshot that should be used when attaching the managed disk to the Azure VM, which serves as a replica of the protected Azure Stack Hub VM.

During regular business operations, protected workloads run on Azure Stack Hub VMs, with changes to their disks being continuously replicated through interactions among the mobility agent, process server, and configuration server to the designated Azure Storage account. When you initiate a test, planned, or unplanned failover, Azure Site Recovery automatically provisions Azure VMs using the replicas of disks of the corresponding Azure Stack Hub VMs.

>[!Note] 
> The process of provisioning Azure VMs by using Azure Site Recovery-replicated disks is referred to as *hydration*.

You have the option to orchestrate a failover by creating recovery plans that contain manual and automated steps. To implement the latter, you can leverage Azure Automation runbooks, which consist of custom PowerShell scripts, PowerShell workflows, or Python 2 scripts.

After the primary site becomes available again, Azure Site Recovery supports reversing the direction of replication, allowing you to perform a failback with minimized downtime and without data loss. However, with Azure Stack Hub, this approach isn't  available. Instead, to fail back, it's necessary to download Azure VM disk files, upload them into Azure Stack Hub, and attach them to existing or new VMs.

## Prerequisites

Implementing the recommended solution is contingent on satisfying the following prerequisites:

- Access to an Azure subscription, with permissions sufficient to provision and manage all cloud components of the Azure Site Recovery components, including:
  - Azure Recovery Services vault in the Azure region designated as the disaster recovery site for the Azure Stack Hub production environment.
  - An Azure Storage account hosting content of replicated disks of Azure Stack Hub VMs.
  - An Azure virtual network representing the disaster recovery environment to which hydrated Azure VMs will be connected following a planned or unplanned failover.
  - An isolated Azure virtual network representing the test environment to which hydrated Azure VMs will be connected following a test failover.
  - An Azure ExpressRoute-based connectivity between the on-premises environment, Azure virtual networks, and the Azure storage account used for hosting copies of VHD files with content replicated from disks of protected Azure Stack Hub VMs.
- An Azure Stack Hub user subscription. All Azure Stack Hub VMs protected by an individual Azure Site Recovery configuration server must belong to the same Azure Stack Hub user subscription.
- An Azure Stack Hub virtual network. All protected VMs must have direct connectivity to the VMs hosting the process server component (by default this is the configuration server VM).
- An Azure Stack Hub Windows Server VM that will host the configuration server and a process server. The VM must belong to the same subscription and be attached to the same virtual network as the Azure Stack Hub VMs that need to be protected. In addition, the VM needs to:

   - comply with [Site Recovery configuration server software and hardware requirements](/azure/site-recovery/vmware-physical-azure-support-matrix#site-recovery-configuration-server) 
   - satisfy external connectivity [network requirements](/azure/site-recovery/vmware-azure-deploy-configuration-server#network-requirements) documentation.

   >[!Note] 
   > Additional storage and performance considerations for the configuration and process servers are described in more detail later in this architecture.

   - satisfy internal connectivity requirements. In particular, Azure Stack Hub VMs that you want to protect need to be able to communicate with:

      - the configuration server via TCP port **443** (HTTPS) inbound for replication management
      - the process server via TCP port **9443** to deliver replication data.

   >[!Note] 
  > You can change the port used by the process server for both external and internal connectivity as part of its configuration when running Azure Site Recovery Unified Setup.

- Azure Stack Hub VMs to be protected, running any of the [supported operating systems](/azure/site-recovery/azure-stack-site-recovery) To protect Azure Stack Hub VMs that are running Windows Server operating systems, you must:
  - Create a Windows account with administrative rights. You can specify this account when you enable Azure Site Recovery on these VMs. The process server uses this account to install the Azure Site Recovery Mobility service. In a workgroup environment, make sure to disable Remote User Access control on target Windows Server operating systems by setting the value of the **LocalAccountTokenFilterPolicy** **DWORD** registry entry in the **HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System** key to 1.
  - Enable File and Printer Sharing and Windows Management Instrumentation rules in Windows Defender firewall.
- To protect Azure Stack Hub VMs that are running Linux operating systems, you must:
  - Create a root user account. You can specify this account when you enable Azure Site Recovery on these VMs. The process server uses this account to install the Azure Site Recovery Mobility service.
  - Install the latest openssh, openssh-server, and openssl packages.
  - Enable and run Secure Shell (SSH) port **22**.
  - Enable Secure FTP subsystem and password authentication.

## High level implementation steps

At a high level, the implementation of Azure Site Recovery-based disaster recovery on Azure Stack Hub consists of the following stages:

1. Prepare Azure Stack Hub VMs to be protected by Azure Site Recovery. Ensure that the VMs satisfy Azure Site Recovery prerequisites listed in the previous section.
1. Create and configure an Azure Recovery Services vault. Set up an Azure Recovery Services vault and specify what you want to replicate. Azure Site Recovery components and activities are configured and managed by using the vault.
1. Set up the source replication environment. Provision an Azure Site Recovery configuration server and process server by installing Azure Site Recovery Unified Setup binaries and register it with the vault.

   >[!Note] 
   > You can rerun the Azure Site Recovery Unified Setup to implement additional process servers on Azure Stack Hub VMs.

1. Set up the target replication environment. Create or select an existing Azure storage account and an Azure virtual network in the Azure region that will host the disaster recovery site. During replication, the content of the disks for the protected Azure Stack Hub VMs is copied to the Azure Storage account. During failover, Azure Site Recovery automatically provisions Azure VMs serving as replicas of protected Azure Stack Hub VMs and connects them to the Azure virtual network.
1. Enable replication. Configure replication setting and enable replication for Azure Stack Hub VMs. The mobility service is installed automatically on each Azure Stack Hub VM for which replication is enabled. Azure Site Recovery initiates replication of each Azure Stack Hub VM, according to the policy settings you defined.
1. Perform a test failover. After replication is established, verify that failover will work as expected by performing a test failover.
1. Perform a planned or unplanned failover. Following a successful test failover, you are ready to conduct either a planned or unplanned failover to Azure. You have the option to designate which Azure Stack Hub VMs to include in the failover.
1. Perform a failback. When you are ready to fail back, stop the Azure VMs corresponding to the Azure Stack Hub VMs you failed, download their disk files to on-premises storage, upload them into Azure Stack Hub, and attach them to an existing or new VM.

## Availability considerations

Azure Stack Hub helps increase workload availability through resiliency inherent to its infrastructure. This resiliency provides high availability for Azure Stack Hub VMs protected by Azure Site Recovery and to essential components of the on-premises Azure Site Recovery infrastructure, including the configuration and process servers.

Similarly, you have the option to leverage resiliency of cloud-based components of Azure Site Recovery infrastructure. By default, Azure Recovery Services is geo-redundant, which means that its configuration is automatically replicated to an Azure region that is part of a pre-defined region pair. You have the option to change the replication settings to locally redundant if that is sufficient for your resiliency needs. Note that you can't change this option if the vault contains any protected items. The same resiliency option is available for any Azure Storage accounts with the standard performance tier, although it's possible to change it at any point.

>[!Note] 
> For the listing of Azure region pairs, refer to [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

You can further enhance the degree of this resiliency by designing and implementing solutions which purpose is to extend the scope of workload protection. This is the added value provided by Azure Site Recovery. In the context of Azure Site Recovery running on Azure Stack Hub, there are two main aspects of workload availability that need to be explored in more detail:

- Failover to Azure
- Failback to Azure Stack Hub

You need to consider both when developing a disaster recovery strategy driven by recovery point objectives (RPOs) and recovery time objectives (RTOs). RTO and RPO represent continuity requirements stipulated by individual business functions within an organization. RPO designates a time period representing maximum acceptable data loss following an incident that affected availability of that data. RTO designates the maximum acceptable duration of time it can take to reinstate business functions following an incident that affected the availability of these functions.

### Failover to Azure

It's self-evident that failover to Azure is at the core of availability considerations in the context of Azure Site Recovery-based protection of Azure Stack Hub VMs. To maximize workload availability, the failover strategy should address both the need to minimize potential data loss (RPO) and minimize failover time (RTO).

To minimize potential data loss, you might consider:

- Maximizing throughput and minimizing latency of the replication traffic by following scalability and performance considerations. For more information, refer to the next section of this reference architecture document.
- Increasing the frequency of app-consistent recovery points for database workloads (up to the maximum of one recovery point per hour). App-consistent recovery points are created from app-consistent snapshots. App-consistent snapshots capture app data on disk and in memory. While this approach minimizes potential data loss, it has one major drawback. App-consistent snapshots require the use of [Volume Shadow Copy Service](/windows-server/storage/file-server/volume-shadow-copy-service) on Windows or custom scripts on Linux, to quiesce locally installed apps. The capture process can have negative impacts on performance, especially if resource utilization is high. We do not recommend that you use low frequency for app-consistent snapshots for non-database workloads.

The primary method of minimizing failover time involves the use of Azure Site Recovery recovery plans. A recovery plan orchestrates a failover between the primary and secondary sites, defining the sequence in which protected servers fail over. You can customize a plan by adding manual instructions and automated tasks. Its purpose is to make the process consistent, accurate, repeatable, and automated.

When creating a recovery plan, you assign protected servers to recovery groups for the purpose of failover. Servers in each group fail over together. This helps you to divide the failover process into smaller, easier to manage units, representing sets of servers which can fail over without relying on external dependencies.

To minimize failover time, as part of creating a recovery plan, you should:

- Define groups of Azure Stack Hub VMs that should fail over together.
- Define dependencies between groups of Azure Stack Hub VMs to determine the optimal sequence of a failover.
- Automate failover tasks, if possible.
- Include custom manual actions, if required.

>[!Note] 
> A single recovery plan can contain up to 100 protected servers.

>[!Note] 
> In general, recovery plans can be used for both failover to and failback from Azure. This doesn't apply to Azure Stack Hub, which doesn't support Azure Site Recovery-based failback.

You define a recovery plan and create recovery groups to capture app-specific properties. As an example, let's consider a traditional three-tier app with a SQL Server-based backend, a middleware component, and a web frontend. When creating a recovery plan, you can control the startup order of servers in each tier, with the servers running SQL Server instances coming online first, followed by those in the middleware tier, and joined afterwards by servers hosting the web frontend. This sequence ensures that the app is working by the time the last server starts. To implement it, you can simply create a recovery plan with three recovery groups, containing servers in the respective tiers.

In addition to controlling failover and startup order, you also have the option to add actions to a recovery plan. In general, there are two types of actions:

- Automated. This action is based on Azure Automation runbooks, which involves one of two types of tasks:
  - Provisioning and configuring Azure resources, including, for example, creating a public IP address and associating it with the network interface attached to an Azure VM.
  - Modifying the configuration of the operating system and applications running within an Azure VM that was provisioned following a failover.
- Manual. This action doesn't support automation and is included in a recovery plan primarily for documentation purposes.

>[!Note] 
> To determine the failover time of a recovery plan, perform a test failover and then examine the details of the corresponding Site Recovery job.

>[!Note] 
> To address the RTO requirements for Azure Stack Hub workloads, you should account for recovery of the Azure Stack infrastructure, user VMs, applications, and user data. In the context of this reference architecture document, we are interested only in the last two of these components, although we also present considerations regarding the availability of the Modern Backup Storage functionality.

### Failback to Azure Stack Hub

In Azure Site Recovery-based scenarios, failback, if properly implemented, doesn't involve data loss. This means that the focus of the failover strategy is to minimize failback time (RTO). However, as previously mentioned, when failing back to Azure Stack Hub, you can't rely on your recovery plans. Instead, the failback involves the following sequence of steps:

1. Stop and deallocate Azure VMs in the disaster recovery environment.
1. Identify the URI parameter of each of the managed disks attached to the VMs you intend to download.
1. Download the virtual hard disk (VHD) files identified by the URI parameters you identified in the previous step to your on-premises environment.
1. Upload the VHD files to Azure Stack Hub.
1. Attach the uploaded VHDs to new or existing Azure Stack Hub VMs.
1. Start the Azure Stack Hub VMs.

The optimal approach to minimizing the failback time, is to automate it.

>[!Note] 
> For more information regarding automating the failback procedure described in this section, refer to [Create VM disk storage in Azure Stack Hub](/azure-stack/user/azure-stack-manage-vm-disks?view=azs-2002#use-powershell-to-add-multiple-disks-to-a-vm).

>[!Note] 
> For more information regarding identifying the URI parameter of managed disks, refer to [Download a Windows VHD from Azure](/azure/virtual-machines/windows/download-vhd).

### Workload-specific considerations

Azure Site Recovery integrates with Windows Server-based apps and roles, including SharePoint, Exchange, SQL Server, and Active Directory Domain Services (AD DS). This allows you to leverage the following capabilities to implement app-level protection and recovery:

- Integration with app-level replication technologies, such as SQL Server AlwaysOn Availability Groups, Exchange Database Availability Groups (DAGs), and AD DS replication
- App-consistent snapshots, for single or multiple tier applications
- A rich automation library that provides production-ready, application-specific scripts that can be downloaded and integrated with recovery plans

Alternatively, you have the option to use workload-specific replication mechanisms to provide site-level resiliency. This is a commonly used option when implementing disaster recovery for AD DS domain controllers, SQL Server, or Exchange, all of which natively support replication. Though this requires provisioning Azure VMs hosting these workloads in the disaster recovery environment, which increases the cost, it offers the following benefits:

- Reduces time required for failover and failback
- Simplifies workload-level failover, accommodating scenarios in which site-level failover isn't  required

>[!Note] 
> For more information regarding Azure Site Recovery workload-specific considerations, refer to [About disaster recovery for on-premises apps.](/azure/site-recovery/site-recovery-workload)

## Scalability and performance considerations

When planning to deploy Azure Site Recovery on Azure Stack Hub, you need to consider the amount of processing, storage, and network resources allocated to the configuration and process servers. You might need to adjust the estimated sizing of the Azure Stack Hub VM hosting the Azure Site Recovery components post deployment to accommodate changes in processing or storage requirements. You have three basic options to adjust the sizing:

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

   >[!Note] 
  > While it's possible to segregate network traffic by attaching a second network adapter to a server, with Azure Stack Hub VMs, all VM traffic to the internet shares the same uplink. A second, virtual network adapter won't segregate traffic at the physical transport level.

- Modify throughput of the network connection to Azure. To accommodate larger volumes of replication traffic, you might consider leveraging Azure ExpressRoute with Microsoft peering for connections between Azure Stack Hub virtual networks and Azure Storage. Azure ExpressRoute extends on-premises networks into the Microsoft cloud over a private connection supplied by a connectivity provider. You can buy ExpressRoute circuits for a wide range of bandwidths, from 50 megabits per second (Mbps) to 100 gigabits per second.

   >[!Note] 
  > For details regarding implementing Azure ExpressRoute in Azure Stack Hub scenarios, refer to [Connect Azure Stack Hub to Azure using Azure ExpressRoute](/azure-stack/operator/azure-stack-connect-expressroute?view=azs-2002).

- Modify throttling of replication traffic on the process server. You can control how much bandwidth is used by the replication traffic on the VMs that are hosting process servers from the graphical interface of the Microsoft Azure Recovery Services agent. The supported capabilities include setting the limits for work and non-work hours, with the bandwidth values ranging from 512 kilobits per second to 1,023 Mbps. Alternatively, you can apply the same configuration by using the **Set-OBMachineSetting** PowerShell cmdlet.
- Modify network bandwidth allocated per protected VM on the process server. To accomplish this, modify the value of **UploadThreadsPerVM** entry within the **HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Azure Backup\\Replication** key. By default, the value is set to 4, but you can increase it to 32 if there's enough network bandwidth available.

## Manageability considerations

The primary considerations regarding manageability of Azure Site Recovery-based disaster recovery of Azure Stack Hub VMs include:

- Implementation of Azure Site Recovery on Azure Stack Hub
- Failover and failback procedures
- Delegation of roles and responsibilities

### Implementation of Azure Site Recovery on Azure Stack Hub

To implement Azure Site Recovery on Azure Stack Hub in a small to medium sized single-tenant environment, you can follow the manual provisioning process driven by the graphical interface of Recovery Services Vault in the Azure portal. For multi-tenant implementations, you might want to consider automating parts of the implementation process, because you will typically need to set up a separate configuration server VM and a separate Recovery Services vault for each tenant. You also have the option to automate deployment of the mobility agent by following the procedure described in [Prepare source machine for push installation of mobility agent](/azure/site-recovery/vmware-azure-install-mobility-service).

### Failover and failback procedures

To simplify the management of failover, consider implementing recovery plans for all protected workloads. For more information, refer to the [Availability considerations](#availability-considerations) section earlier in this reference architecture document. You will also find recommendations for optimizing the management of the failback procedure.

### Delegation of roles and responsibilities

Planning for and implementing disaster recovery of Azure Stack Hub VM-based workloads by using Azure Site Recovery typically involves interaction of stakeholders:

- Azure Stack Hub operators manage Azure Stack Hub infrastructure, ensuring that there are sufficient compute, storage, and network resources necessary for implementing a comprehensive disaster recovery solution and making these resources available to tenants. They also collaborate with application and data owners to help determine the optimal approach to deploying their workloads to Azure Stack Hub.
- Azure administrators manage Azure resources necessary to implement hybrid disaster recovery solutions.
- Azure AD administrators manage Azure AD resources, including user and group objects that are used to provision, configure, and manage Azure resources.
- Azure Stack Hub tenant IT staff designs, implements, and manages Azure Site Recovery, including failover and failback.
- Azure Stack Hub users need to provide RPO and RTO requirements and submit requests to implement disaster recovery for their workloads.

Make sure there'sa clear understanding of the roles and responsibilities attributed to application owners and operators in the context of protection and recovery. Users are responsible for protecting VMs. Operators are responsible for the operational status of the Azure Stack Hub infrastructure.

>[!Note] 
> For guidance regarding fine-grained delegation of permissions in Azure Site Recovery scenarios, refer to [Manage Site Recovery access with Azure role-based access control (Azure RBAC)](/azure/site-recovery/site-recovery-role-based-linked-access-control).

## Security considerations

Managing disaster recovery of user VM-based workloads in hybrid scenarios warrants additional security considerations. These considerations can be grouped into the following categories:

- Encryption in transit. This includes communication between protected Azure Stack Hub VMs, on-premises Azure Site Recovery components, and cloud-based Azure Site Recovery components:
  - Mobility agent installed on the protected VMs always communicates with the process server via Transport Layer Security (TLS) 1.2.
  - It's possible for communication from the configuration server to Azure and from the process server to Azure to use TLS 1.1 or 1.0. To increase the level of security for hybrid connectivity, you should consider enforcing the use of TLS 1.2.

   >[!Note] 
  > For details regarding configuring TLS 1.2-based encryption, refer to [Transport Layer Security (TLS) registry settings](/windows-server/security/tls/tls-registry-settings) and [Update to enable TLS 1.1 and TLS 1.2 as default secure protocols in WinHTTP in Windows](https://support.microsoft.com/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-default-secure-protocols-in-wi)

- Encryption at rest. This includes Azure Storage and Azure VMs in the disaster recovery site.
  - Azure Storage is encrypted at rest for all storage accounts using 256-bit Advanced Encryption Standard encryption and is Federal Information Processing Standard 140-2 compliant. Encryption is enabled automatically and can't be disabled. By default, encryption uses Microsoft-managed keys, but customers have the option to use their own keys stored in an Azure Key vault.
  - Managed disks of Azure VMs are automatically encrypted by using *server-side encryption of Azure managed disks*, which also applies to their snapshots, by relying on using platform-managed encryption keys.

In addition, you can enforce restricted access to the Azure Storage accounts hosting content of Azure Site Recovery-replicated disks. To do this, enable the managed identity for the Recovery Services vault and assign to that managed identity the following Azure role-based access control (Azure RBAC) roles at the Azure Storage account level:

- Resource Manager-based storage accounts (standard performance tier):
  - Contributor
  - Storage Blob Data Contributor
- Resource Manager-based storage accounts (premium performance tier):
  - Contributor
  - Storage Blob Data Owner

The Azure Recovery Services vault offers mechanisms that further protect its content, including the following protections:

- Azure RBAC. This allows for delegation and segregation of responsibilities according to the principle of least privilege. There are three Azure Site Recovery-related built-in roles that restrict access to Azure Site Recovery operations:
  - Site Recovery Contributor. This role has all the permissions required to manage Azure Site Recovery operations in an Azure Recovery Services vault. A user with this role, however, can't create or delete the vault or assign access rights to other users. This role is best suited for disaster recovery administrators who can enable and manage disaster recovery for an Azure Stack Hub tenant.
  - Site Recovery Operator. This role has permissions to execute and manage failover and failback operations. A user with this role can't enable or disable replication, create or delete vaults, register new infrastructure, or assign access rights to other users. This role is best suited for a disaster recovery operator who can fail over Azure Stack Hub VMs when instructed by application owners and IT administrators in an actual or simulated disaster scenario.
  - Site Recovery Reader. This role has permissions to track all Azure Site Recovery management operations. This role is best suited for IT staff responsible for monitoring the status of protected Azure Stack Hub VMs and raising support tickets if required. 
- Azure Resource Locks. You have the option to create and assign read-only and delete locks to an Azure Site Recovery vault to mitigate the risk of the vault being accidentally and maliciously changed or deleted.
- Soft delete. The purpose of soft delete is to help protect the vault and its data from accidental or malicious deletions. With soft delete, any deleted content is retained for 14 additional days, allowing for its retrieval during that period. The additional 14-day retention of vault content doesn't incur any cost. Soft delete is enabled by default.
- Protection of security-sensitive operations. Azure Recovery Services vault allows you to enable an additional layer of authentication whenever a security-sensitive operation, such as disabling protection, is attempted. This extra validation helps ensure that authorized users perform such operations.
- Monitoring and alerts of suspicious activity. Azure Recovery Services provides built-in monitoring and alerting of security-sensitive events related to the vault operations.

## DevOps considerations

While configuring VM-level recovery by using Azure Site Recovery is primarily a responsibility of IT operations, there are some DevOps-specific considerations that should be incorporated into a comprehensive disaster recovery strategy. Azure Stack Hub facilitates implementing Infrastructure-as-Code (IaC), which incorporates the automated deployment of a variety of workloads, including VM-based applications and services. You can leverage this capability to streamline the provisioning of Azure Site Recovery-based disaster recovery scenarios, which simplifies the initial setup in multiple tenant scenarios.

For example, you can use the same Azure Resource Manager templates to provision all of the network resources necessary to accommodate VM-based workloads in an Azure Stack Hub stamp for your application in a single, coordinated operation. You can use the same template to provision a matching set of resources in Azure to provision a disaster recovery site. To account for any differences between the two environments, you can simply specify different values of template parameters in each case.

## Cost considerations

When considering the cost of the Azure Site Recovery-based disaster recovery solution described in this reference architecture document, you need to account for both on-premises and cloud-based components. The Azure Stack Hub pricing model determines the pricing of on-premises components. As with Azure, Azure Stack Hub offers a pay-as-you-use arrangement, available through enterprise agreements and the Cloud Solution Provider program. This arrangement includes a monthly price for each Windows Server VM. If you have the option to leverage existing Windows Server licenses, you can significantly reduce the cost to the base VM pricing. However, with Azure Site Recovery, you will usually need only a single Azure Stack Hub VM per tenant, which is required to implement the tenant-specific configuration server.

Azure-related charges are associated with the use of the following resources:

- Azure Recovery Services. The pricing is determined by the number of protected instances. It's worth noting that every protected instance incurs no Azure Site Recovery charges for the first 31 days.
- Azure Storage. The pricing reflects a combination of the following factors:
  - Performance tier
  - Volume of data stored
  - Volume of outbound data transfer
  - Quantity and types of operations performed (for standard performance tier only)
  - Data redundancy (for standard performance tier only)
- Azure ExpressRoute. The pricing is based on one of two models:
  - Unlimited data. This model includes a monthly fee with all inbound and outbound data transfers included.
  - Metered data. This model includes a monthly fee with all inbound data transfers free of charge and outbound data transfers charged per GB.

   >[!Note] 
  > This assessment doesn't include cost of physical connections delivered by third party connectivity providers.

- Azure VMs. The pricing of Azure VMs reflects a combination of two components:
  - Compute cost. The VM size, its uptime, and the licensing model of its operating system determine the cost.
  - Managed disk cost. The disk size and performance tier determine the cost.

   >[!Note] 
  > It's worth noting that hydration eliminates the need to run Azure VMs during regular business operations, with workloads running on Azure Stack Hub, which considerably reduces the compute costs of Azure Site Recovery-based implementations, especially in comparison to traditional disaster recovery solutions.

   >[!Note] 
  > The prices of resources vary between Azure regions.

   >[!Note] 
  > For details regarding pricing, refer to [Azure Pricing](https://azure.microsoft.com/pricing/).

## Alternative solutions

The recommended solution described in this reference architecture document isn't  the only way to provide disaster recovery functionality for Azure Stack Hub VM-based workloads. Customers have other options, including:

- A failover to another Azure Stack Hub stamp. Users that need to protect against a datacenter or site outage might be able to use another Azure Stack Hub deployment to implement disaster recovery provisions. With primary and secondary locations, users can deploy applications in an active/passive configuration across two environments. For less critical workloads, it might be acceptable to leverage unused capacity in the secondary location to perform on-demand restoration of applications from backup. You also have the option to implement a recovery site in another datacenter, which, in turn, leverages Azure Site Recovery to provision a replica of the recovery site in Azure. Several factors determine whether the use of Azure Site Recovery with Azure serving as the failover site is a viable solution. These factors include government regulations, corporate policies, and latency requirements. 

   >[!Note] 
  > As of July 2020, Azure Site Recovery doesn't support this scenario, which means that the implementation would need to rely on a third party or in-house solution.

- Backup and restore. Backing up your applications and datasets enables you to recover quickly from downtime because of data corruption, accidental deletions, or localized outages. For Azure Stack Hub VM-based applications, you can use an in-guest agent to protect application data, operating system configuration, and data stored on volumes. Backing up a VM using a guest OS agent typically includes capturing operating system configuration, files, folders, volumes, application binaries, and application data. Recovering an application from an agent requires recreating the VM, followed by installing the operating system and the guest agent. At that point, you can restore data into the guest OS.
- Backup of disk snapshots. It's possible to use snapshots to capture an Azure Stack Hub VM configuration and the disks attached to a stopped VM. This requires backup products that integrate with Azure Stack Hub APIs to capture VM configuration and create disk snapshots.

   >[!Note] 
  > As of July 2020, using disk snapshots for VM in a running state isn't  supported. Creating a snapshot of a disk attached to a running VM might degrade the performance or impact the availability of the operating system or application in the VM.

- Backup and restore VMs using an external backup solution in the same datacenter followed by the replication of backups to another location. This allows you to restore Azure Stack Hub VMs to the same or a different Azure Stack Hub instance, or to Azure.

## Summary

In conclusion, Azure Stack Hub is a unique offering, which differs in many aspects from other virtualization platforms. As such, it warrants special considerations in regard to business continuity strategy for its workloads. By leveraging Azure services, you can simplify designing and implementing this strategy. In this architecture reference document, we explored the use of Microsoft Azure Site Recovery for protecting Azure Stack Hub VM-based workloads in the connected deployment model. This approach allows customers to benefit from resiliency and manageability of Azure Stack Hub and from the hyperscale and global presence of the Azure cloud.

It's important to note that the disaster recovery solution described here focused exclusively on VM-based workloads of Azure Stack Hub. This is only part of an overall business continuity strategy that should account for other Azure Stack Hub workload types and scenarios that affect their availability.

[architectural-diagram]: ./images/azure-stack-vm-dr.png
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-vm-dr.vsdx