---
title: Use Azure Stack HCI stretched clusters for disaster recovery
description: Disaster recovery with lossless automatic failover of Azure Stack HCI virtualized workloads between two on-premises locations
author: githubusername
ms.date: 00/00/0000
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - category
ms.custom: fcp
---

# Use Azure Stack HCI stretched clusters for disaster recovery

This reference architecture illustrates how to enhance resiliency of Azure Stack HCI by using stretched clustering. 

![Actve-active and active-passive Azure Stack HCI stretched cluster][architectural-diagram]

*Download a [Visio file][architectual-diagram-visio-source] of this architecture.*

Typical uses for this architecture include:

- Disaster recovery with automatic failover of Azure Stack HCI virtualized workloads and file shares between two physical locations within the range of 5 ms round trip network latency (corresponding to about 30 mile physical distance). 

## Architecture

The architecture incorporates the following components and capabilities:

- **Azure Stack HCI (20H2)**. Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. The stretched cluster can consists of between 4 and 16 physical nodes. 
- **Storage Replica**. Storage Replica is Windows Server technology that enables replication of volumes between servers or clusters for disaster recovery.
- **Live Migration**. Live migration is a Hyper-V feature in Windows Server that allows you to seamlessly move running virtual machines (VMs) from one Hyper-V host to another without perceived downtime. 
- **Cloud Witness**. Cloud Witness is a type of Failover Cluster quorum witness that uses Microsoft Azure Blob Storage to provide a vote on cluster quorum.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them. 

### Use stretched clusters to implement automated disaster recovery for virtualized workloads and file shares hosted on Azure Stack HCI.

Enhance built-in resiliency of Azure Stack HCI by implementing a stretched Azure Stack HCI cluster consisting of two groups of nodes, with one group per site. Each group must contain at minimum 2 nodes. The total number of nodes in a cluster cannot exceed the maximum number of nodes supported by an Azure Stack HCI cluster. The nodes must satisfy the standard [HCI hardware requirements][hci-hardware-requirements]. 

A stretched Azure Stack HCI cluster relies on Storage Replica to perform synchronous storage replication, between storage volumes hosted by the two groups of nodes in their respective physical sites. In case of a failure affecting the availability of the primary site, the cluster automatically transitions its workloads to nodes in the surviving site, minimizing potential downtime. In case of a planned or expected downtime at the primary site, you have the option of using Hyper-V Live Migration to seamlessly transition its workloads to the other site, avoiding downtime altogether.

> [!NOTE]
> The synchronous replication ensures crash-consistency, with zero data loss at the file-system level during a failover. 

> [!CAUTION]
> The synchronous replication requirement applicable to stretched clusters imposes a limit of 5ms round trip network latency between two groups of cluster nodes in the replicated sites. Depending on the physical network connectivity characteristics, this constraint typically translates into about 20-30 miles distance.

> [!NOTE]
> Replication traffic is automatically protected in transit by relying on signing and encryption provided by Storage Replica.

## Architectural excellence

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framework] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Cost optimization

- Active-active vs active-passive configuration. A stretched Azure Stack HCI cluster support the active-passive and active-active modes. In the active-passive modes, a designated primary site replicates unidirectionally to another site providing the disaster recovery capability. In the active-active mode, two sites replicate their respective volumes unidirectionally to each other, providing the failover capability in case of a failure of the other site. The latter of these two modes helps you minimize the business continuity costs by eliminating the need for a dedicated disaster recovery site. 

- Cloud Witness vs File Share Witness. A witness resource is mandatory component of Azure Stack HCI clusters. To implement it, you can choose either an Azure cloud witness or a file share witness. An Azure cloud witness relies on a blob in an Azure storage account you designate to provide the arbitration point to prevent split-brain scenarios. A file share witness relies on an SMB file share to accomplish the same objective. 

> [!NOTE]
> Azure Cloud Witness is the recommended choice for Azure Stack HCI stretched clusters, provided all server nodes in the cluster have a reliable internet connection. The corresponding ongoing Azure charges are practically negligible, since they consist of the price of a small blob with infrequent updates corresponding to changes to the cluster state. In scenarios that involve stretched clusters, a file share witness should reside in a third site, which significantly raises potential implementation costs, unless such site is already available and has existing, reliable connections to the sites hosting the stretched cluster nodes. 

- Data Deduplication. Azure Stack HCI and Storage Replica support data deduplication. Starting with Windows Server 2019, deduplication is available on volumes formatted with ReFS, which is the recommended file system for Azure Stack HCI. Deduplication helps increase usable storage capacity by identifying duplicate portions of files and only storing them once. 

> [!CAUTION]
> While you should install Data Deduplication server role service on the source and destination servers, it's important not to enable Data Deduplication on the destination nodes of an Azure Stack HCI stretched cluster. Since Data Deduplication manages writes, it should run only on source cluster nodes. Destination nodes always receive deduplicated copies of each volume.

### Operational excellence

- Automatic failover and recovery. A failure of the primary site triggers an automatic failover. Following the failover, the process of establishing the replication from the new primary/former secondary site back to the new secondary/former primary site is automatic as well. In addition, the cluster prevents failback until the replicated volumes are fully synchronized in order to prevent the possibility of data loss.

- Simplified provisioning and management experience by using Windows Admin Center. The Create Cluster wizard in [Windows Admin Center provides a wizard-driven interface that guides you through the process of creating an Azure Stack HCI stretched cluster][create-cluster-with-wac]. It detects if cluster nodes reside in two distinct Active Directory Domain Services (AD DS) sites or if their IP addresses belong to two different subnets and, if so, automatically creates and configures the corresponding cluster sites, each representing a separate fault domain. It also allows you to designate the preferred site. Similarly, [Windows Admin Center simplifies the process of provisioning replicated volumes][create-stretched-volumes-with-wac]. 

> [NOTE]
> Creating volumes and virtual disks for stretched clusters is more involved than for single-site clusters. Stretched clusters require a minimum of four volumes, comprised of two data volumes and two log volumes, with each pair of data and log volume in each site. When you create a replicated data volume by using Windows Admin Center, the process automatically provisions the log volume in the primary site and both data and log replicated volumes in the secondary site, ensuring that each of them has the required size and configuration settings.

- Support for [automated stretched cluster provisioning][create-cluster-with-powershell] and [storage management][create-stretched-volumes-with-powershell] by using Windows PowerShell. You can run PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer

- Integration with a range of Azure services that provide additional operational advantages. You have the option to integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Azure Monitor][azure-monitor] and Azure Automation solutions, including [Change Tracking and Inventory][change-tracking-and-inventory] and [Update Management][update-management]. Following an initial mandatory registration procedure, Azure Stack HCI clusters can leverage Azure Arc for monitoring and billing. Azure Arc integration offers enhanced integration with other hybrid services, such as [Azure Policy][azure-policy-guest-configuration] and [Log Analytics][resource-context-log-analytics-access-mode]. The registration triggers creation of an Azure Resource Manager resource, represent an Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI.

### Performance efficiency

- Optimized replication traffic. When designing infrastructure for Azure Stack HCI stretched clusters, you need to take into account additional Storage Replica, Live Migration, and Storage Replica Cluster Performance History traffic flowing between the sites. Your design should benefit from Storage Replica network performance optimizations, including [SMB Multichannel and SMB Direct][smb-direct-and-multichannel] over RoCE or iWARP, depending on the type of RDMA implementation. Synchronous replication requires at least one 1 Gb RDMA or Ethernet/TCP connection between stretched cluster sites, but, depending on the volume of replication traffic, you might need a [faster RDMA connection][site-to-site-network-reqs]. You should also provision multiple connections between sites, which besides resiliency benefits, allows you to [separate Storage Replica traffic from Hyper-V live migration traffic][set-srnetworkconstraint]. 

- Support for seeded initial sync. You have the option to [implement seeded initial sync][sr-initial-sync] in scenarios where initial sync time needs to be minimized or where there is limited bandwidth available between the two sites hosting the stretched cluster.

- Optimized processing of storage I/O. You should ensure [optimal configuration of replicated data and log volumes][sr-volume-reqs], including the choice of their performance tier, volume and sector sizing, disk type, and file system. 

> [NOTE]
> Windows Admin Center automatically assigns the optimal configuration if you use it for [provisioning stretched cluster volumes][create-stretched-volumes-with-wac]. 

### Reliability

- Site-level fault domains. Each physical site of an Azure Stack HCI stretched cluster represent distinct fault domains, providing additional resiliency. A fault domain is a set of hardware components that share a single point of failure. To be fault tolerant to a particular level, you need multiple fault domains at that level. 

> [NOTE]
> If each location corresponds to a separate AD DS site, the cluster provisioning process will automatically configure site assignment. If there are no separate AD DS sites representing the two locations but the nodes are on two different subnets, the cluster provisioning process will identify sites based on the subnet assignments.
If the notes are on the same subnet, you need to define site assignment explicitly.

- Site awareness. Site awareness allows you to control placement of virtualized workloads by designating their preferred sites. Specifying the preferred site for a stretched cluster offers several benefits, including the ability to affinitize workloads at the site level and to customize quorum voting options. By default, during a cold start, all virtual machines are placed in the preferred site, although it is also possible to configure preferred site at the cluster role or group level. This allows for allocating specific virtual machines to their respective sites in the active-active mode. From the quorum perspective, preferred site selection affects the allocation of votes in the manner that favors that site. For example, if connectivity between the two sites hosting stretched cluster nodes is lost and the cluster witness is not reachable, the preferred site remains online, while the nodes in the other site are evicted.

- Improved Storage Spaces Direct volume repair speed (aka resync). Storage Spaces Direct provides automatic resync following events that affect availability of some disks in its storage pool, such as shutting down one of cluster nodes or a localized hardware failure. Azure Stack HCI implements an [enahnced resync process][sr-resync] which operates at much finer granularity than Windows Server 2019, significantly reducing duration of the resync operation. This minimizes potential impact 
of multiple, overlapping hardware failures. 

- Resiliency limits. Azure Stack HCI provides multiple levels of resiliency, but due to its hyper-converged architecture, that resiliency is subject to limits imposed not only by the [cluster quorum][cluster-quorum], but also by the [pool quorum][pool-quorum]. You can eliminate this limit by implementing [cluster sets][cluster-sets], combining multiple Azure Stack HCI clusters to create an HCI platform consisting of hundreds of nodes.

- Integration with a range of Azure services that provide additional resiliency advantages. You have the option to integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Azure Backup][azure-backup] and [Azure Site Recovery][azure-site-recovery].

- Accelerated failover. You can optimize network infrastructure and its configuration in the manner that expedites completion of a site-level failover, leveraging, for example, software-defined networking, stretched VLANs, network abstraction devices, and shorter TTL of DNS records representing clustered resources. You might want to also consider lowering the [default ResiliencyPeriod][resiliencydefaultperiod], which determines the period of time during which a clustered VM is allowed to run in the isolated state.

### Security

- Protection in transit. Storage Replica offers built-in security of its replication traffic, which includes packet signing, AES-128-GCM full data encryption, support for Intel AES-NI encryption acceleration, and pre-authentication integrity man-in-the-middle attack prevention. Storage Replica also utilizes Kerberos AES256 for authentication between the replicating nodes.

- Encryption at rest. Azure Stack HCI supports BitLocker encryption for its data volumes, facilitating compliance with standards such as FIPS 140-2 and HIPAA.

- Integration with a range of Azure services that provide additional security advantages. You have the option to integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Azure Security Center][azure-security-center]

- Firewall-friendly configuration. Storage Replica traffic requires [a limited number of open ports between the replicating nodes][sr-firewall-reqs].

> [!CAUTION]
> Storage Replica and Azure Stack HCI stretched clusters must operate within an Active Directory Domain Services (AD DS) environment. When planning for deployment of Azure Stack HCI stretched clusters, you must ensure connectivity to AD DS domain controllers in each site hosting cluster nodes.


[architectural-diagram]: images/azure_stack_hci_dr.png
[architectural-diagram-visio-source]: diagrams/azure_stack_hci_dr.vsdx
[azure-service]: https://docs.microsoft.com/azure/
[azure-well-architected-framerwork]: https://docs.microsoft.com/azure/architecture/framework/
[microsoft-component]: https://docs.microsoft.com/
[hci-hardware-requirements]: https://docs.microsoft.com/azure-stack/hci/deploy/before-you-start#server-requirements
[create-cluster-with-wac]: https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster
[create-cluster-with-powershell]: https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell
[create-stretched-volumes-with-wac]: https://docs.microsoft.com/azure-stack/hci/manage/create-stretched-volumes
[create-stretched-volumes-with-powershell]: https://docs.microsoft.com/azure-stack/hci/manage/create-stretched-volumes
[azure-policy-guest-configuration]: https://docs.microsoft.com/azure/governance/policy/concepts/guest-configuration
[resource-context-log-analytics-access-mode]: https://docs.microsoft.com/azure/azure-monitor/platform/design-logs-deployment#access-mode
[azure-monitor]: https://docs.microsoft.com/azure-monitor/insights/vminsights-overview
[change-tracking-and-inventory]: https://docs.microsoft.com/azure/automation/change-tracking
[smb-direct-and-multichannel]: https://docs.microsoft.com/windows-server/storage/file-server/smb-direct
[site-to-site-network-reqs]: https://docs.microsoft.com/azure-stack/hci/deploy/before-you-start#site-to-site-requirements-stretched-cluster
[set-srnetworkconstraint]: https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint?view=win10-ps
[sr-initial-sync]: https://docs.microsoft.com/windows-server/storage/storage-replica/storage-replica-frequently-asked-questions#FAQ12
[sr-volume-reqs]: https://docs.microsoft.com/windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#provision-operating-system-features-roles-storage-and-network
[sr-resync]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-storage-resync
[cluster-quorum]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-quorum#cluster-quorum-overview
[pool-quorum]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-quorum#pool-quorum-overview
[cluster-sets]: https://docs.microsoft.com/windows-server/storage/storage-spaces/cluster-sets
[azure-backup]: https://docs.microsoft.com/azure-stack/hci/manage/use-azure-backup
[azure-site-recovery]: https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery
[resiliencydefaultperiod]: https://techcommunity.microsoft.com/t5/failover-clustering/virtual-machine-compute-resiliency-in-windows-server-2016/ba-p/372027
[azure-security-center]: https://docs.microsoft.com/azure-stack/hci/concepts/security#part-2-use-azure-security-center
[sr-firewall-reqs]: https://docs.microsoft.com/en-us/windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#prerequisites