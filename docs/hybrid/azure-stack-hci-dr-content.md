The following reference architecture illustrates how to design and implement disaster recovery of Azure Stack HCI by using stretched clustering.

## Architecture

[ ![Diagram illustrating an active-active and an active-passive Azure Stack HCI stretched cluster, with storage volumes and cluster performance history replicating via Storage Replica. In the active-active mode, there is replication traffic in each direction, with both sites hosting Azure Stack HCI VMs. In the active-passive mode, replication is unidirectional, with the active site hosting Azure Stack HCI VMs.](images/azure-stack-hci-dr.svg)](images/azure-stack-hci-dr.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

### Components

The architecture incorporates the following components and capabilities:

- **[Azure Stack HCI (20H2)][azs-hci]**. [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci) is a hyper-converged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. The stretched cluster can consist of between four and 16 physical nodes.
- **[Storage Replica][storage-replica]**. Storage Replica is a Windows Server technology that enables volume replication between servers or clusters for the purpose of disaster recovery.
- **[Live migration][live-migration]**. Live migration is a Hyper-V feature in Windows Server that allows you to seamlessly move running virtual machines (VMs) from one Hyper-V host to another without perceived downtime.
- **[Cloud Witness][cloud-witness]**. Cloud Witness is a Failover Cluster quorum witness that uses Microsoft Azure Blob Storage to provide a vote on cluster quorum.

## Scenario details

You typically use this architecture for disaster recovery with automatic failover of Azure Stack HCI VMs and file shares between two physical locations within a range of 5 ms round-trip network latency.

## Recommendations

The following recommendation applies for most scenarios. Follow the recommendation unless you have a specific requirement that overrides it.

### Use stretched clusters to implement automated disaster recovery for virtualized workloads and file shares hosted on Azure Stack HCI

To enhance the built-in resiliency of Azure Stack HCI, implement a stretched Azure Stack HCI cluster that consists of two groups of nodes, with one group per site. Each group must contain a minimum of two nodes. The total number of nodes in a cluster cannot exceed the maximum number of nodes supported by an Azure Stack HCI cluster. The nodes must satisfy the standard [HCI hardware requirements][hci-hardware-requirements].

A stretched Azure Stack HCI cluster relies on Storage Replica to perform synchronous storage replication between storage volumes hosted by the two groups of nodes in their respective physical sites. If a failure affects the availability of the primary site, the cluster automatically transitions its workloads to nodes in the surviving site to minimize potential downtime. For planned or expected downtimes at the primary site, you can use Hyper-V Live Migration to seamlessly transition workloads to the other site, avoiding downtime altogether.

> [!NOTE]
> Synchronous replication ensures crash consistency with zero data loss at the file-system level during a failover.

> [!CAUTION]
> The synchronous replication requirement applicable to stretched clusters imposes a limit of 5 ms round-trip network latency between two groups of cluster nodes in the replicated sites. Depending on the physical network connectivity characteristics, this constraint typically translates into about 20-30 physical miles.

> [!NOTE]
> Storage Replica's signing and encryption capability automatically protects replication traffic.

## Considerations

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framework] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- **Site-level fault domains.** Each physical site of an Azure Stack HCI stretched cluster represents distinct fault domains that provide additional resiliency. A fault domain is a set of hardware components that share a single point of failure. To be fault tolerant to a particular level, you need multiple fault domains at that level.

> [!NOTE]
> If each location corresponds to a separate AD DS site, the cluster provisioning process automatically configures site assignment. If there are no separate AD DS sites representing the two locations, but the nodes are on two different subnets, the cluster provisioning process will identify sites based on the subnet assignments. If the nodes are on the same subnet, you must define site assignment explicitly.

- **Site awareness.** Site awareness allows you to control placement of virtualized workloads by designating their preferred sites. Specifying the preferred site for a stretched cluster offers many benefits, including the ability to group workloads at the site level and to customize quorum voting options. By default, during a cold start, all virtual machines use the preferred site, although it is also possible to configure the preferred site at the cluster role or group level. This allows you to allocate specific virtual machines to their respective sites in  active-active mode. From the quorum perspective, preferred site selection affects the allocation of votes in a manner that favors that site. For example, if connectivity between the two sites hosting stretched cluster nodes fails and the cluster witness is not reachable, the preferred site remains online, while the nodes in the other site are evicted.

- **Improved Storage Spaces Direct volume repair speed.** Storage Spaces Direct provides automatic resync following events that affect availability of disks within its storage pool, such as shutting down one of the cluster nodes or a localized hardware failure. Azure Stack HCI implements an [enhanced resync process][sr-resync] that operates at a much finer granularity than Windows Server 2019. This process significantly reduces the duration of the resync operation and minimizes the potential impact of multiple, overlapping hardware failures.

- **Resiliency limits.** Azure Stack HCI provides multiple levels of resiliency, but because of its hyper-converged architecture, that resiliency is subject to limits imposed not only by the [cluster quorum][cluster-quorum], but also by the [pool quorum][pool-quorum].

- **Integration with a range of Azure services that provide additional resiliency advantages.** You can integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Azure Backup][azure-backup] and [Azure Site Recovery][azure-site-recovery].

- **Accelerated failover.** You can optimize the network infrastructure and its configuration to expedite completion of a site-level failover. For example, you can leverage stretched virtual LANs (VLANs), network abstraction devices, and shorter Time to Live (TTL) values in DNS records representing clustered resources. In addition, consider lowering the [default resiliency period][resiliencydefaultperiod], which determines the period of time during which a clustered VM is allowed to run in the isolated state.

> [!CAUTION]
> Using Stretched clusters with SDN is considered an advanced configuration and you should contact your Systems Integrator or Microsoft Support for further assistance.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- **Protection in transit.** Storage Replica offers built-in security for its replication traffic, which includes packet signing, AES-128-GCM full data encryption, support for Intel AES-NI encryption acceleration, and pre-authentication integrity man-in-the-middle attack prevention. Storage Replica also utilizes Kerberos AES256 for authentication between the replicating nodes.

- **Encryption at rest.** Azure Stack HCI supports BitLocker Drive Encryption for its data volumes, thus facilitating compliance with standards such as FIPS 140-2 and HIPAA.

- **Integration with a range of Azure services that provide additional security advantages.** You can integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Microsoft Defender for Cloud][azure-security-center]

- **Firewall-friendly configuration.** Storage Replica traffic requires [a limited number of open ports between the replicating nodes][sr-firewall-reqs].

> [!CAUTION]
> Storage Replica and Azure Stack HCI stretched clusters must operate within an AD DS environment. When planning your Azure Stack HCI stretched clusters deployment, ensure connectivity to AD DS domain controllers in each site hosting cluster nodes.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- **Active-active versus active-passive configuration.** Stretched Azure Stack HCI clusters support the active-passive and active-active modes. In active-passive mode, a designated primary site unidirectionally replicates to another site that provides the disaster recovery capability. In active-active mode, two sites replicate their respective volumes unidirectionally to each other, providing failover capability in case of a failure in either site. The active-active mode helps minimize business continuity costs by eliminating the need for a dedicated disaster recovery site.

- **Cloud Witness versus File Share Witness.** A witness resource is a mandatory component within Azure Stack HCI clusters. To implement it, choose either an Azure cloud witness or a file share witness. An Azure cloud witness relies on a blob in an Azure storage account that you designate as the arbitration point to prevent split-brain scenarios. A file share witness relies on a Server Message Block (SMB) file share to accomplish the same objective.

> [!NOTE]
> Azure Cloud Witness is the recommended choice for Azure Stack HCI stretched clusters, provided all server nodes in the cluster have reliable internet connections. The corresponding Azure charges are negligible; they are based on the price of a small blob with infrequent updates corresponding to changes to the cluster state. In scenarios that involve stretched clusters, a file share witness should reside in a third site, which can significantly raise implementation costs unless the third site is already available and has existing, reliable connections to the sites hosting the stretched cluster nodes.

- **Data Deduplication.** Azure Stack HCI and Storage Replica support data deduplication. Starting with Windows Server 2019, deduplication is available on volumes formatted with Resilient File System (ReFS), which is the recommended file system for Azure Stack HCI. Deduplication helps increase usable storage capacity by identifying duplicate portions of files and only storing them once.

> [!CAUTION]
> Although you should install the Data Deduplication server role service on both the source and destination servers, do not enable Data Deduplication on the destination nodes within an Azure Stack HCI stretched cluster. Because Data Deduplication manages writes, it should run only on source cluster nodes. Destination nodes always receive deduplicated copies of each volume.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- **Automatic failover and recovery.** A primary-site failure triggers automatic failover. Following the failover, the process of establishing replication from the new primary/former secondary site back to the new secondary/former primary site is automatic as well. To prevent potential data loss, the cluster prevents failback until the replicated volumes fully synchronize.

- **Simplified provisioning and management experience by using Windows Admin Center.** The Create Cluster wizard in [Windows Admin Center provides a wizard-driven interface that guides you through the process of creating an Azure Stack HCI stretched cluster][create-cluster-with-wac]. The wizard detects whether cluster nodes reside in two distinct Active Directory Domain Services (AD DS) sites or whether their IP addresses belong to two different subnets. If they reside in two different subnets,  the wizard automatically creates and configures the corresponding cluster sites with each representing a separate fault domain. It also allows you to designate the preferred site. Similarly, [Windows Admin Center simplifies the process of provisioning replicated volumes][create-stretched-volumes-with-wac].

> [!NOTE]
> Creating volumes and virtual disks for stretched clusters is more involved than for single-site clusters. Stretched clusters require a minimum of four volumes, comprised of two data volumes and two log volumes, with a data/log volume pair at each site. When you create a replicated data volume by using Windows Admin Center, the process automatically provisions the log volume in the primary site and both data and log replicated volumes in the secondary site, ensuring that each of them has the required size and configuration settings.

- **Support for [automated stretched cluster provisioning][create-cluster-with-powershell] and [storage management][create-stretched-volumes-with-powershell] by using Windows PowerShell.** You can run PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer.

- **Integration with a range of Azure services that provide additional operational advantages.** You can integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as [Azure Monitor][azure-monitor] and Azure Automation solutions, including [Change Tracking and Inventory][change-tracking-and-inventory] and [Update Management][update-management]. Following an initial mandatory registration procedure, Azure Stack HCI clusters can leverage Azure Arc for monitoring and billing. Azure Arc integration offers enhanced integration with other hybrid services, such as [Azure Policy][azure-policy-guest-configuration] and [Log Analytics][resource-context-log-analytics-access-mode]. Registration triggers creation of an Azure Resource Manager resource representing an Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- **Optimized replication traffic.** When designing infrastructure for Azure Stack HCI stretched clusters, consider additional Storage Replica, Live Migration, and Storage Replica Cluster Performance History traffic flowing between the sites. Synchronous replication requires at least 1 Gb remote direct memory access (RDMA) or Ethernet/TCP connection between stretched cluster sites. However, depending on the volume of replication traffic, you might need a [faster RDMA connection][site-to-site-network-reqs]. You should also provision multiple connections between sites, which provides resiliency benefits and allows you to [separate Storage Replica traffic from Hyper-V live migration traffic][set-srnetworkconstraint].

> [!CAUTION]
> RDMA is enabled by default for all traffic between cluster nodes in the same site on the same subnet. RDMA is disabled and not supported between sites or between different subnets. You should either disable SMB Direct for cross-site traffic or implement [additional provisions][site-to-site-rdma-considerations] that separate it from cross-node traffic within the same site.

- **Support for seeded initial sync.** You can [implement seeded initial sync][sr-initial-sync] in scenarios where initial sync time needs to be minimized or where there is limited bandwidth available between the two sites hosting the stretched cluster.

- **Optimized processing of storage I/O.** Ensure [optimal configuration of replicated data and log volumes][sr-volume-reqs], including their performance tier, volume and sector sizing, disk type, and file system.

> [!NOTE]
> Windows Admin Center automatically assigns the optimal configuration if you use it for [provisioning stretched cluster volumes][create-stretched-volumes-with-wac].

## Next steps

- [Azure Stack HCI solution overview](/azure-stack/hci/overview)
- [Failover Clustering in Windows Server and Azure Stack HCI](/windows-server/failover-clustering/failover-clustering-overview)
- [Deploy a Cloud Witness for a Failover Cluster](/windows-server/failover-clustering/deploy-cloud-witness)
- [What's new in Azure Stack HCI](/azure-stack/hci/whats-new)
- [Azure Stack HCI FAQ](/azure-stack/hci/faq)

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](/azure/architecture/guide/technology-choices/hybrid-considerations)
- [Use Azure Stack HCI switchless interconnect and lightweight quorum for remote office or branch office](/azure/architecture/hybrid/azure-stack-robo)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)
- [Azure Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-hci-dr.vsdx
[azure-well-architected-framework]: /azure/architecture/framework
[microsoft-component]: /
[azs-hci]: /azure-stack/hci/overview
[storage-replica]: /windows-server/storage/storage-replica/storage-replica-overview
[cloud-witness]: /windows-server/failover-clustering/deploy-cloud-witness
[live-migration]: /windows-server/virtualization/hyper-v/manage/live-migration-overview
[hci-hardware-requirements]: /azure-stack/hci/deploy/before-you-start#server-requirements
[create-cluster-with-wac]: /azure-stack/hci/deploy/create-cluster
[create-cluster-with-powershell]: /azure-stack/hci/deploy/create-cluster-powershell
[create-stretched-volumes-with-wac]: /azure-stack/hci/manage/create-stretched-volumes
[create-stretched-volumes-with-powershell]: /azure-stack/hci/manage/create-stretched-volumes
[azure-policy-guest-configuration]: /azure/governance/policy/concepts/guest-configuration
[resource-context-log-analytics-access-mode]: /azure/azure-monitor/platform/design-logs-deployment#access-mode
[azure-monitor]: /azure/azure-monitor/insights/vminsights-overview
[change-tracking-and-inventory]: /azure/automation/change-tracking
[update-management]: /azure/automation/update-management/overview
[site-to-site-network-reqs]: /azure-stack/hci/concepts/plan-host-networking#site-to-site-requirements-stretched-cluster
[site-to-site-rdma-considerations]: /azure-stack/hci/concepts/plan-host-networking#rdma-considerations
[set-srnetworkconstraint]: /powershell/module/storagereplica/set-srnetworkconstraint?view=win10-ps
[sr-initial-sync]: /windows-server/storage/storage-replica/storage-replica-frequently-asked-questions#FAQ12
[sr-volume-reqs]: /windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#provision-operating-system-features-roles-storage-and-network
[sr-resync]: /windows-server/storage/storage-spaces/understand-storage-resync
[cluster-quorum]: /windows-server/storage/storage-spaces/understand-quorum#cluster-quorum-overview
[pool-quorum]: /windows-server/storage/storage-spaces/understand-quorum#pool-quorum-overview
[cluster-sets]: /windows-server/storage/storage-spaces/cluster-sets
[azure-backup]: /azure-stack/hci/manage/use-azure-backup
[azure-site-recovery]: /azure-stack/hci/manage/azure-site-recovery
[resiliencydefaultperiod]: https://techcommunity.microsoft.com/t5/failover-clustering/virtual-machine-compute-resiliency-in-windows-server-2016/ba-p/372027
[azure-security-center]: /azure-stack/hci/concepts/security#part-2-use-azure-security-center
[sr-firewall-reqs]: /windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage#prerequisites
