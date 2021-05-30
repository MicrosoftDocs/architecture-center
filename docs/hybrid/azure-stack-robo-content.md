This reference architecture illustrates how to design infrastructure for highly available virtualized and containerized workloads in Remote Office/Branch Office (ROBO) scenarios.

![Diagram illustrating an Azure Stack HCI ROBO scenario, with a two-node Azure Stack HCI cluster using a switchless interconnect and a USB-based quorum. The cluster leverages a number of Azure services, including Azure Arc that provides the ability to implement Azure Policy, Azure Automation that includes Azure update management functionality, Azure Monitor, as well as Azure File Sync, Azure Network Adapter, Azure Security Center, Azure Backup, Azure Site Recovery, and Storage Replica.][architectural-diagram]

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

Typical uses for this architecture include the following ROBO scenarios:

- Implement highly-available, container-based edge workloads and virtualized, business-essential applications in a cost-effective manner.
- Lower total cost of ownership (TCO) through Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.
- Control and audit security and compliance by leveraging virtualization-based protection, certified hardware, and cloud-based services.

## Architecture

The architecture incorporates the following components and capabilities:
- **[Azure Stack HCI (20H2)][azs-hci]**. Azure Stack HCI is a hyper-converged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. The stretched cluster can consist of between four and 16 physical nodes.
- **[File share witness][file-share-witness]**. A file share witness is a Server Message Block (SMB) share that Failover Cluster uses as a vote in the cluster quorum. Starting with Windows Server 2019, it's possible to use [a USB drive connected to a router][usb-file-share-witness] for this purpose.
- **[Azure Arc][azure-arc]**. A cloud-based service that extend the Azure Resource Manager&ndash;based management model to non-Azure resources including virtual machines (VMs), Kubernetes clusters, and containerized databases.
- **[Azure Policy][azure-policy]**. A cloud-based service that evaluates Azure and on-premises resources through integration with Azure Arc by comparing properties to customizable business rules.
- **[Azure Monitor][azure-monitor]**. A cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments.
- **[Azure Security Center][azure-security-center]**. Azure Security Center is a unified infrastructure security management system that strengthens the security posture of your data centers, and provides advanced threat protection across your hybrid workloads in the cloud - whether they're in Azure or not - as well as on premises.
- **[Azure Automation][azure-automation]**. Azure Automation delivers a cloud-based automation and configuration service that supports consistent management across your Azure and non-Azure environments.
- **[Change Tracking and Inventory][azure-change-tracking-and-inventory]**. A feature of Azure Automation that tracks changes in Windows Server and Linux servers hosted in Azure, on-premises, and other cloud environments to help you pinpoint operational and environmental issues with software managed by the Distribution Package Manager.
- **[Update Management][azure-update-management]**. A feature of Azure Automation that streamlines management of OS updates for Windows Server and Linux machines in Azure, in on-premises environments, and in other cloud environments.
- **[Azure Backup][azure-backup]**. The Azure Backup service provides simple, secure, and cost-effective solutions to back up your data and recover it from the Microsoft Azure cloud.
- **[Azure Site Recovery][azure-site-recovery]**. A cloud-based service that helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery manages replication and failover of workloads running on both physical and virtual machines between their primary site and a secondary location.
- **[Azure File Sync][azure-file-sync]**. A cloud-based service that provides the ability to synchronize and cache content of Azure file shares by using Windows Servers across your Azure and non-Azure environments.
- **[Storage Replica][storage-replica]**. A Windows Server technology that enables replication of volumes between servers or clusters for disaster recovery.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Use Azure Stack HCI switchless interconnect and lightweight quorum for highly-available and cost-effective ROBO infrastructure. 

In ROBO scenarios, a primary business concern is minimizing costs. Yet many ROBO workloads are of utmost criticality with very little tolerance for downtime. Azure Stack HCI offers the optimal solution by offering both resiliency and cost-effectiveness. Using Azure Stack HCI, you can leverage built-in [resiliency of Storage Spaces Direct][s2d-resiliency] and [Failover Clustering][failover-clustering] technologies to implement highly-available compute, storage, and network infrastructure for containerized and virtualized ROBO workloads. For cost-effectiveness, you can use as few as two cluster nodes with only four disks and 64 gigabytes (GB) of memory per node. To further minimize costs, you can use switchless interconnects between nodes, thereby eliminating the need for redundant switch devices. To finalize cluster configuration, you can implement [a file share witness simply by using a USB drive][usb-file-share-witness] connected to a router hosting uplinks from cluster nodes. For maximum resiliency, on a 2-node cluster you have the option of configuring Storage Spaces Direct volumes with either [nested two-way mirror, or nested mirror accelerated parity][s2d-nested-resiliency]. Unlike the traditional two-way mirroring, these options tolerate multiple simultaneous hardware failures without data loss.

> [!NOTE]
> With nested resiliency, a 2-node cluster and all of its volumes will remain online following a failure of a single node and a single disk on the surviving node.

### Fully integrate Azure Stack HCI deployments with Azure to minimize TCO in ROBO scenarios.

As part of the Azure Stack product family, Azure Stack HCI is inherently dependent on Azure. Therefore, to optimize features and support, you must [register it][azs-hci-register-arc] within 30 days of deploying your first Azure Stack HCI cluster. This generates a corresponding Azure Resource Manager resource, which effectively extends the Azure management plane to Azure Stack HCI, and automatically enabling [Azure portal-based monitoring][azs-hci-portal-view], support, and billing functionality.

To minimize Azure Stack HCI cluster and workload management overhead, you should also consider leveraging the following Azure services, which provide their corresponding capabilities:

- [Azure Monitor][azs-hci-monitor]. Collect telemetry generated by clusters and their VMs for monitoring, analytics, and alerting.
- [Azure Automation, Update Management feature][az-auto-update-mgmt]. Use for Azure Stack HCI VM automated patch deployment and reporting.
- [Azure Automation, Change Tracking and Inventory feature][az-auto-ct-and-inv]Track Azure Stack HCI VM configuration changes.
- [Azure Automation DSC][az-auto-vm-dsc-hybrid-worker]. Automate desired state configuration of Azure Stack HCI VMs.
- [Azure Backup][azs-hci-vm-backup]. Manage backup of Azure Stack HCI VMs and their workloads.
- [Azure Site Recovery][azs-hci-vm-dr]. Implement and orchestrate disaster recovery for Azure Stack HCI VMs.
- [Azure File Sync][az-file-sync]. Synchronize and tier file shares hosted on Azure Stack HCI clusters.
- [Azure Kubernetes Service (AKS)][azs-hci-aks]. Implement container orchestration.

To further benefit from Azure capabilities, you can extend the scope of Azure Arc integration to the Azure Stack HCI virtualized and containerized workloads by implementing the following functionality:

- [Azure Arc enabled servers][arc-enabled-servers]. Use for virtualized workloads running Azure Stack HCI VMs.
- [Azure Arc enabled data services][arc-enabled-data-services]. Use for containerized Azure SQL Managed Instance or PostgresSQL Hyperscale running on AKS hosted by Azure Stack HCI VMs.

> [!CAUTION]
> AKS on Azure Stack HCI and Azure Arc enabled data services are in preview at the time of publishing this reference architecture.

With the scope of Azure Arc extended to Azure Stack HCI VMs, you'll be able to [automate their configuration by using Azure VM extensions][arc-vm-extensions] and evaluate their [compliance with industry regulations and corporate standards by using Azure Policy][arc-azure-policy].

### Leverage Azure Stack HCI virtualization-based protection, certified hardware, and cloud-based services to enhance security and compliance stance in ROBO scenarios.

ROBO scenarios present unique challenges with security and compliance. With no&mdash;or at best&mdash;limited local IT support and lack of dedicated datacenters, it's particularly important to protect their workloads from both internal and external threats. Azure Stack HCI's capabilities and its integration with Azure services can address this problem.

Azure Stack HCI&ndash;certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. These technologies, combined with [virtualization-based security (VBS)][azs-hci-vbs], help protect security-sensitive workloads. BitLocker Drive Encryption allows you to encrypt Storage Spaces Direct volumes at rest while SMB encryption provides automatic encryption in transit, facilitating compliance with standards such as Federal Information Processing Standard 140-2 (FIPS 140-2) and Health Insurance Portability and Accountability Act (HIPAA).

In addition, you can onboard Azure Stack HCI VMs in [Azure Security Center][az-security-center] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Similarly, by onboarding Azure Stack HCI VMs in Azure Arc, you gain the ability to use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Architectural excellence

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Cost optimization

Cost optimization considerations include:

- Switchless vs switch-based cluster interconnects. The switchless interconnect topology consists of redundant connections between single-port or dual-port Remote Direct Memory Access (RDMA) adapters on each node (which forms a full mesh), with each node connected directly to every other node. While this is straightforward to implement in a 2-node cluster, larger clusters require additional network adapters in each node's hardware.
- Cloud-style billing model. Azure Stack HCI pricing follows the [monthly subscription billing model][azs-hci-billing], with a flat rate per physical processor core in an Azure Stack HCI cluster.

> [!CAUTION]
> While there are no on-premises software licensing requirements for cluster nodes hosting the Azure Stack HCI infrastructure, Azure Stack HCI VMs might require individual OS licenses. Additional usage charges might also apply if you use other Azure services.

### Operational excellence

Operational excellence considerations include:

- Simplified provisioning and management experience with Windows Admin Center. The [**Create Cluster Wizard** in Windows Admin Center][azs-hci-create-with-wac] provides a wizard-driven interface that guides you through creating an Azure Stack HCI cluster. Similarly, [Windows Admin Center simplifies the process of managing Azure Stack HCI VMs][azs-hci-manage-vms-with-wac].
- Automation capabilities. Azure Stack HCI provides a wide range of automation capabilities, with OS updates combined with full-stack updates including firmware and drivers provided by Azure Stack HCI vendors and partners. With Cluster-Aware Updating (CAU), OS updates run unattended while Azure Stack HCI workloads remain online. This results in seamless transitions between cluster nodes that eliminate impact from post-patching reboots. Azure Stack HCI also offers support for [automated cluster provisioning][azs-hci-create-with-powershell] and [VM management][azs-hci-manage-vms-with-powershell] by using Windows PowerShell. You can run Windows PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of additional automation scenarios for [virtualized][arc-vm-extensions] and [containerized][azs-hci-k8s-gitops] workloads.
- Decreased management complexity. Switchless interconnect eliminates the risk of switch device failures and the need for their configuration and management.

### Performance efficiency

Performance efficiency considerations include:

- [Storage resiliency][s2d-resiliency] versus usage efficiency, versus performance. Planning for Azure Stack HCI volumes involves identifying the optimal balance between resiliency, usage efficiency, and performance. The challenge results from the fact that maximizing one of these characteristics typically has a negative impact on at least one of the other two. For example, increasing resiliency reduces the usable capacity, while the resulting performance might vary depending on the resiliency type. In the case of nested two-way mirror volumes or nested mirror accelerated parity volumes, higher resiliency leads to lower capacity efficiency compared to traditional two-way mirroring. At the same time, the nested two-way mirror volume offers better performance than the nested mirror accelerated parity volume, but at the cost of lower usage efficiency.
- [Storage Spaces Direct disk configuration][s2d-disks]. Storage Spaces Direct supports hard disk drives (HDDs), solid-state drives (SSDs), and NVMe drive types. The drive type  directly impacts storage performance due to differences in performance characteristics between each type, and the caching mechanism, which is an integral part of Storage Spaces Direct configuration. Depending on the Azure Stack HCI workloads and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a drive configuration that provides [balance between performance and capacity][s2d-drive-balance-performance-capacity].
- Storage caching optimization. Storage Spaces Direct provides a [built-in, persistent, real-time, read and write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. In addition, Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can [improve Hyper-V performance][azs-hci-csv-cache].
- Compute performance optimization. Azure Stack HCI offers support for graphics processing unit (GPU) acceleration, targeting [high-performance AI/ML workloads][azs-hci-gpu-acceleration] that are geared towards edge scenarios.
- Networking performance optimization. As part of your design, be sure to include projected [traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] when determining your [optimal network hardware configuration][azs-hci-networking]. This includes provisions addressing [switchless interconnect minimum bandwidth requirements][azs-hci-switchless-interconnects-reqs].

### Reliability

Reliability considerations include:

- Improved Storage Spaces Direct volume repair speed (also referred to as *resync*). Storage Spaces Direct provides automatic resync following events that affect availability of storage pool disks, such as shutting down a cluster node or a localized hardware failure. Azure Stack HCI implements an [enhanced resync process][sr-resync] that operates at much finer granularity than Windows Server 2019 and significantly reduces the resync operation time. This minimizes potential impact of multiple overlapping hardware failures.
- Failover Clustering witness selection. The lightweight, USB drive&ndash;based witness eliminates dependencies on reliable internet connectivity, which is required when using cloud witness-based configuration.

### Security

Security considerations include:

- [Azure Stack HCI basic security][azs-hci-basic-security]. Leverage Azure Stack HCI hardware components (such as Secure Boot, UEFI, and TPM) to build a secure foundation for Azure Stack HCI VM-level security, including Device Guard and Credential Guard. Use [Windows Admin Center role-based access control][wac-rbac] to delegate management tasks by following the principle of least privilege.
- [Azure Stack HCI advanced security][azs-hci-advanced-security]. Apply Microsoft security baselines to Azure Stack HCI clusters and their Windows Server workloads by using Active Directory Domain Services (AD DS) with Group Policy. You can use [Microsoft Advanced Threat Analytics (ATA)][ms-ata] to detect and remediate cyber threats targeting AD DS domain controllers providing authentication services to Azure Stack HCI clusters and their Windows Server workloads.

[architectural-diagram]: images/azure_stack_robo.png
[architectural-diagram-visio-source]: https://archcenter.blob.core.windows.net/cdn/azure_stack_robo.vsdx
[azure-well-architected-framerwork]: ../framework/index.md
[azs-hci]: /azure-stack/hci/overview
[azure-arc]: /azure/azure-arc/overview
[azure-monitor]: /azure/azure-monitor/overview
[azure-backup]: /azure/backup/backup-overview
[azure-security-center]: /azure/security-center/security-center-introduction
[file-share-witness]: /windows-server/failover-clustering/file-share-witness
[azure-policy]: /azure/governance/policy/overview
[azure-automation]: /azure/automation/automation-intro
[azure-change-tracking-and-inventory]: /azure/automation/change-tracking/overview
[azure-update-management]: /azure/automation/update-management/overview
[azure-site-recovery]: /azure/site-recovery/site-recovery-overview
[azure-file-sync]: /azure/storage/files/storage-sync-files-deployment-guide?tabs=azure-portal%2cproactive-portal
[storage-replica]: /windows-server/storage/storage-replica/storage-replica-overview
[usb-file-share-witness]: https://techcommunity.microsoft.com/t5/failover-clustering/new-file-share-witness-feature-in-windows-server-2019/ba-p/372149
[s2d-resiliency]: /windows-server/storage/storage-spaces/storage-spaces-fault-tolerance
[failover-clustering]: /windows-server/failover-clustering/failover-clustering-overview
[s2d-nested-resiliency]: /windows-server/storage/storage-spaces/nested-resiliency#why-nested-resiliency
[azs-hci-register-arc]: /azure-stack/hci/deploy/register-with-azure
[azs-hci-portal-view]: /azure-stack/hci/manage/azure-portal
[azs-hci-monitor]: /azure-stack/hci/manage/azure-monitor
[az-auto-vm-dsc-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker#azure-automation-state-configuration-on-a-hybrid-runbook-worker
[az-auto-update-mgmt]: /azure/automation/update-management/update-mgmt-overview
[az-auto-ct-and-inv]: /azure/automation/change-tracking
[azs-hci-vm-backup]: /azure-stack/hci/manage/use-azure-backup
[azs-hci-vm-dr]: /azure-stack/hci/manage/azure-site-recovery
[az-file-sync]: /azure/storage/files/storage-sync-files-planning
[azs-hci-aks]: /azure-stack/aks-hci/overview
[arc-enabled-servers]: /azure/azure-arc/servers/overview
[arc-enabled-data-services]: /azure/azure-arc/data/overview
[arc-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[arc-azure-policy]: /azure/azure-arc/servers/security-controls-policy
[azs-hci-vbs]: /windows-hardware/design/device-experiences/oem-vbs
[az-security-center]: /azure-stack/hci/concepts/security#part-2-use-azure-security-center
[azs-hci-billing]: /azure-stack/hci/concepts/billing
[azs-hci-create-with-wac]: /azure-stack/hci/deploy/create-cluster
[azs-hci-create-with-powershell]: /azure-stack/hci/deploy/create-cluster-powershell
[azs-hci-manage-vms-with-wac]: /azure-stack/hci/manage/vm
[azs-hci-manage-vms-with-powershell]: /azure-stack/hci/manage/vm-powershell
[az-auto-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker
[azs-hci-k8s-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[s2d-disks]: /windows-server/storage/storage-spaces/choosing-drives
[s2d-drive-max-performance]: /windows-server/storage/storage-spaces/choosing-drives#option-1--maximizing-performance
[s2d-drive-max-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-3--maximizing-capacity
[s2d-drive-balance-performance-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-2--balancing-performance-and-capacity
[s2d-cache]: /windows-server/storage/storage-spaces/understand-the-cache
[s2d-cache-sizing]: /windows-server/storage/storage-spaces/choosing-drives#cache
[azs-hci-csv-cache]: /azure-stack/hci/manage/use-csv-cache#planning-considerations
[azs-hci-gpu-acceleration]: /azure-stack/hci/manage/attach-gpu-to-linux-vm
[azs-hci-networking]: /azure-stack/hci/concepts/plan-host-networking
[azs-hci-network-bandwidth-allocation]: /azure-stack/hci/concepts/plan-host-networking#traffic-bandwidth-allocation
[azs-hci-switchless-interconnects-reqs]: /azure-stack/hci/concepts/plan-host-networking#interconnects-for-2-3-node-clusters
[sr-resync]: /windows-server/storage/storage-spaces/understand-storage-resync
[azs-hci-basic-security]: /azure-stack/hci/concepts/security#part-1-build-a-secure-foundation
[wac-rbac]: /windows-server/manage/windows-admin-center/plan/user-access-options#role-based-access-control
[azs-hci-advanced-security]: /azure-stack/hci/concepts/security#part-3-add-advanced-security
[ms-ata]: /advanced-threat-analytics/what-is-ata