---
title: Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office
description: Cost-effective approach to implement highly-available virtualized and containerized workloads in Remote Office/Branch Office scenarios
author: githubusername
ms.date: 00/00/0000
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - category
ms.custom: fcp
---

# Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office

This reference architecture illustrates how to design infrastructure for highly available virtualized and containerized workloads in Remote Office/Branch Office (ROBO) scenarios.

![Azure Stack HCI 2-node cluster with switchless interconnect and a USB-based witness for Remote Office/Branch Office][architectural-diagram]

*Download a [Visio file][architectual-diagram-visio-source] of this architecture.*<!-- Does it matter that architectual (should be architectural) is spelled wrong in this link? -->

Typical uses for this architecture include the following ROBO scenarios:

- Implement highly-available, container-based edge workloads and virtualized, business-essential applications in a cost-effective manner.
- Lower total cost of ownership (TCO) through Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring.
- Control and audit security and compliance by leveraging virtualization-based protection, certified hardware, and cloud-based services.

## Architecture

The architecture incorporates the following components and capabilities:
<!-- For the following list, unless you have a template you need to adhere to, consider shortening these bullets by deleting the name in italics. For example, "**Azure Arc**. A cloud-based service that... Otherwise, it's fine the way it is.-->
- **Azure Stack HCI (20H2)**. *Microsoft Azure Stack* HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux operating system (OS) workloads and their storage in a hybrid on-premises environment. A cluster can consist of between 2 and 16 physical nodes.
- **File share witness**. A *file share witness* is a Server Message Block (SMB) share that Failover Cluster<!-- As a standalone term, "failover cluster" is lowercase. If we are referring to a name, the only thing I can find capitalized is "Failover Cluster Manager." Please revisit this name. --> uses as a vote in the cluster quorum. Starting with Windows Server 2019, it's possible to use [a USB drive connected to a router][usb-file-share-witness] for this purpose.
- **Azure Arc**. *Azure Arc* is a cloud-based service that extend the Azure Resource Manager&ndash;based management model to non-Azure resources including virtual machines (VMs), Kubernetes clusters, and containerized databases.
- **Azure Policy**. *Azure Policy* is a cloud-based service that evaluates Azure&mdash;and on-premises resources through integration with Azure Arc&mdash;by comparing properties to customizable business rules.
- **Azure Monitor**. *Azure Monitor* is a cloud-based service that maximizes the availability and performance of applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from Azure and non-Azure locations.
- **Azure Security Center**. *Azure Security Center* is a unified infrastructure security management system that provides advanced threat protection<!-- Can we come up with another term for "advanced threat protection," as this is part of the name of an Azure product? --> and helps strengthen the security posture across Azure and non-Azure locations.
- **Azure Automation**. *Azure Automation* is an Azure service that delivers a cloud-based automation and desired state configuration service<!-- Can we come up with another word for "service" here? --> that supports consistent management across Azure and non-Azure locations.
- **Change Tracking and Inventory**. *Change Tracking and Inventory* is a feature of Azure Automation that tracks changes in Windows Server <!-- Verify this is Windows Server. Otherwise, when we refer to just "Windows," this is the client OS. -->and Linux servers across Azure and non-Azure locations to help identify and troubleshoot operational and environmental issues.
- **Update Management**. *Update Management* in Azure Automation is a feature of Azure Automation that streamlines management of OS updates for Windows<!-- Windows Server? --> and Linux machines across Azure and non-Azure locations.
- **Azure Backup**. *Azure Backup* is a cloud-based solution that provides simple, secure, and cost-effective solutions to back up and recover data across Azure and non-Azure locations.
- **Azure Site Recovery**. *Azure Site Recovery* is a cloud-based service that helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery manages replication and failover of workloads running on both physical and virtual machines between their primary site and a secondary location.
- **Azure File Sync**. *Azure File Sync* is a cloud-based service that provides the ability to synchronize and cache content of Azure file shares by using Windows Servers across Azure and non-Azure locations.
- **Storage Replica**. *Storage Replica* is Windows Server technology that enables replication of volumes between servers or clusters for disaster recovery.

## Recommendations

The following recommendations<!-- This language is confusing for me because I didn't realize that the headings were the recommendations. I'm assuming this is boilerplate though? If not, we should change it around to make it clearer. --> apply for most scenarios. Follow the recommendations in the subtopics unless you have a specific requirement that overrides them.

### Use Azure Stack HCI switchless interconnect and lightweight quorum to implement a highly-available infrastructure for containerized and virtualized ROBO workloads in a cost-effective manner<!-- Can we shorten this at all to make it more identifiable as a recommendation? Perhaps, "Use Azure Stack HCI switchless interconnect for highly-available and cost-effective workloads?" The next recommendation is more readable. This one seems more like a sentence in a pgph. -->

In ROBO scenarios, a primary business concern is minimizing costs. Yet many ROBO workloads are of utmost criticality with very little tolerance for downtime. Azure Stack HCI offers the optimal solution by offering both resiliency and cost-effectiveness. Using Azure Stack HCI, you can leverage built-in [resiliency of Storage Spaces Direct][s2d-resiliency] and [Failover Clustering][failover-clustering] technologies to implement highly-available compute, storage, and network infrastructure for containerized and virtualized ROBO workloads. For cost-effectiveness, you can use as few as two cluster nodes with only four disks and 64 gigabytes (GB) of memory per node. To further minimize costs, you can use switchless interconnects between nodes, thereby eliminating the need for redundant switch devices. <!-- These next sentences seem like we are switching back to resiliency, and not cost-effectiveness. If this is true, we should try to put all of the resiliency items together, even if we need to break it into two different pgphs. -->To finalize cluster configuration, you can implement [a file share witness simply by using a USB drive][usb-file-share-witness] connected to a router hosting uplinks from cluster nodes. For maximum resiliency, on a 2-node cluster you have the option of configuring Storage Spaces Direct volumes with either [nested two-way mirror, or nested mirror accelerated parity][s2d-nested-resiliency]. Unlike the traditional two-way mirroring, these options tolerate multiple simultaneous hardware failures without data loss.

> [!NOTE]
> With nested resiliency, a 2-node cluster and all of its volumes will remain online following a failure of a single node and a single disk on the surviving node.

### Fully integrate Azure Stack HCI deployments with Azure to minimize TCO in ROBO scenarios

Azure Stack HCI is inherently dependent on Azure<!-- Can we change this to "As part of the Azure product family, Azure Stack HCI is inherently connected to Azure." -->. Therefore, to optimize features and support, you must [register it][azs-hci-register-arc] within 30 days of deploying your first Azure Stack HCI cluster. This generates a corresponding Azure Resource Manager resource, which effectively extends the Azure management plane to Azure Stack HCI, and automatically enabling [Azure portal-based monitoring][azs-hci-portal-view], support<!-- what kind of support? -->, and billing functionality.

To minimize Azure Stack HCI cluster and workload management overhead, you should also consider leveraging the following Azure services, which provide their corresponding capabilities:<!-- I suggested changes below that would emphasize the product they should leverage, and then why. -->

- [Monitoring, analytics, and alerting using telemetry generated by clusters and their VMs with Azure Monitor][azs-hci-monitor]<!-- Suggest changing to "Azure Monitor. Use telemetry generated by clusters and their VMs for monitoring, analytics, and alerting." -->
- [Automated patch deployment and reporting of Azure Stack HCI VMs with Update Management in Azure Automation][az-auto-update-mgmt]<!-- Suggest changing to "Azure Automation, Update Management feature. Use for Azure Stack HCI VM automated patch deployment and reporting. -->
- [Change tracking and inventory of Azure Stack HCI VMs with the Change Tracking and Inventory feature of Azure Automation][az-auto-ct-and-inv]<!-- Suggest changing to "Azure Automation, Change Tracking and Inventory feature. Track Azure Stack HCI VM changes (can we be more specific about what types of changes?)."  -->
- [Automating implementation of desired state configuration of Azure Stack HCI VMs with Azure Automation][az-auto-vm-dsc-hybrid-worker]<!-- Suggest changing to "Azure Automation. Automate desired state configuration implementation of Azure Stack HCI VMs." -->
- [Managed backup of Azure Stack HCI VMs and their workloads with Azure Backup][azs-hci-vm-backup]<!-- Suggest changing to "Azure Backup. Manage backup of Azure Stack HCI VMs and their workloads." -->
- [Implementation and orchestration of disaster recovery of Azure Stack HCI VMs with Azure Site Recovery][azs-hci-vm-dr]<!-- Suggest changing to "Azure Site Recovery. Implement and orchestrate disaster recovery for Azure Stack HCI." -->
- [Synchronization and tiering of file shares with Azure File Sync][az-file-sync]<!-- Suggest changing to "Azure File Sync. Synchronize and tier file shares." -->
- [Container orchestration with Azure Kubernetes Service (AKS) on Azure Stack HCI][azs-hci-aks]<!-- Suggest changing to "Azure Stack HCI. Orchestrate containers with Azure Kubernetes Service (AKS) -->

To further benefit from Azure capabilities, you can extend the scope of Azure Arc integration to the Azure Stack HCI virtualized and containerized workloads by implementing the following functionality:

- [Azure Arc enabled servers][arc-enabled-servers]. Use for virtualized workloads running Azure Stack HCI VMs.
- [Azure Arc enabled data services][arc-enabled-data-services]. Us for containerized Azure SQL Managed Instance or PostgresSQL Hyperscale running on AKS hosted by Azure Stack HCI VMs.<!-- This should be either "...Azure SQL Managed Instance, or PostgresSQL Hyperscale running on AKS hosted by Azure Stack HCI VMs" or "...Azure SQL Managed Instance or PostgresSQL Hyperscale, running on AKS hosted by Azure Stack HCI VMs." -->

> [!CAUTION]
> AKS on Azure Stack HCI and Azure Arc enabled data services are in preview at the time of writing<!-- "publishing?" --> this reference architecture.

With the scope of Azure Arc extended to Azure Stack HCI VMs, you'll be able to [automate their configuration by using Azure VM extensions][arc-vm-extensions] and evaluate their [compliance with industry regulations and corporate standards by using Azure Policy][arc-azure-policy].

### Leverage Azure Stack HCI virtualization-based protection, certified hardware, and cloud-based services to enhance security and compliance stance in ROBO scenarios<!-- To shorten this to match the crispness of the previous level 3 heading (line 56), I would change this to "Leverage Azure Stack HCI virtualization-based protection, certified hardware, and cloud-based services to enhance security and compliance stance in ROBO scenarios" -->

ROBO scenarios present unique challenges with security and compliance. With no&mdash;or at best&mdash;limited local IT support and lack of dedicated datacenters, it's particularly important to protect their workloads from both internal and external threats. Azure Stack HCI's capabilities and its integration with Azure services can address this problem.

Azure Stack HCI&ndash;certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. These technologies, combined with [virtualization-based security (VBS)][azs-hci-vbs], help protect security-sensitive workloads. BitLocker Drive Encryption allows you to encrypt Storage Spaces Direct volumes at rest while SMB encryption provides automatic encryption in transit, facilitating compliance with standards such as Federal Information Processing Standard 140-2 (FIPS 140-2)<!-- Apparently there's a FIPS 140-03 now? --> and Health Insurance Portability and Accountability Act (HIPAA).

In addition, you can onboard Azure Stack HCI VMs in [Azure Security Center][az-security-center] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Similarly, by onboarding Azure Stack HCI VMs in Azure Arc, you gain the ability to use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Architectural excellence

The *[Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork]* is a set of guiding tenets that are followed in this reference architecture. The following considerations in the subtopics are framed in the context of these tenets.

### Cost optimization
<!-- We need a sentence here introducing the bulleted list. -->
- Switchless vs switch-based cluster interconnects. The switchless interconnect topology consists of redundant connections between single-port or dual-port Remote Direct Memory Access (RDMA) adapters on each node (which forms a full mesh<!-- Can we add the answer to a full mesh what? For example, "which forms a full mesh shield?" -->), with each node connected directly to every other node. While a 2-node cluster is a more straightforward implementation<!-- Please verify I got this right. -->, larger clusters require additional network adapters in each node's hardware.
- Cloud-style billing model. Azure Stack HCI pricing follows the [monthly subscription billing model][azs-hci-billing], with a flat rate per physical processor core in an Azure Stack HCI cluster.

> [!CAUTION]
> While there are no on-premises software licensing requirements for cluster nodes hosting the Azure Stack HCI infrastructure, Azure Stack HCI VMs might require individual OS licenses<!-- Do these incur a charge? -->. Additional usage charges might also apply if you use other Azure services.

### Operational excellence
<!-- We need a sentence here introducing the following bulleted list. -->
- Simplified provisioning and management experience with Windows Admin Center. The [**Create Cluster Wizard** in Windows Admin Center][azs-hci-create-with-wac] provides a wizard-driven interface that guides you through creating an Azure Stack HCI cluster. Similarly, [Windows Admin Center simplifies the process of managing Azure Stack HCI VMs][azs-hci-manage-vms-with-wac].
- Automation capabilities. Azure Stack HCI provides a wide range of automation capabilities, with full-stack updates including firmware and drivers combined with OS updates and supported by Azure Stack HCI vendors and partners.<!-- Can we break this sentence into two? --> With Cluster-Aware Updating (CAU), OS updates run unattended while Azure Stack HCI workloads remain online. This results in seamless transitions between cluster nodes that eliminate impact from post-patching reboots. Azure Stack HCI also offers support for [automated cluster provisioning][azs-hci-create-with-powershell] and [VM management][azs-hci-manage-vms-with-powershell] by using Windows PowerShell. You can run Windows PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of additional automation scenarios for [virtualized][arc-vm-extensions] and [containerized][azs-hci-k8s-gitops] workloads.
- Decreased management complexity. Switchless interconnect eliminates the risk of switch device failures and the need for their configuration and management.

### Performance efficiency
<!-- We need a sentence here introducing the following bulleted list. -->
- [Storage resiliency][s2d-resiliency] versus usage efficiency, versus performance. Planning for Azure Stack HCI volumes involves identifying the optimal balance between resiliency, usage efficiency, and performance. The challenge results from the fact that maximizing one of these characteristics typically has a negative impact on at least one of the other two. For example, increasing resiliency reduces the usable capacity, while the resulting performance might vary depending on the resiliency type. In the case of nested two-way mirror volumes or nested mirror accelerated parity volumes, higher resiliency leads to lower capacity efficiency compared to traditional two-way mirroring. At the same time, the nested two-way mirror volume<!-- Verify that "volume" is correct. --> offers better performance than the nested mirror accelerated parity volume, but at the cost of lower usage efficiency.
- [Storage Spaces Direct disk configuration][s2d-disks]. Storage Spaces Direct supports hard disk drives (HDDs), solid-state drives (SSDs), and NVMe drive types. The drive type  directly impacts storage performance due to differences in performance characteristics between each type, and the caching mechanism, which is an integral part of Storage Spaces Direct configuration. Depending on the Azure Stack HCI workloads and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a drive configuration that provides [balance between performance and capacity][s2d-drive-balance-performance-capacity].
- Storage caching optimization. Storage Spaces Direct provides a [built-in, persistent, real-time, read and write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. In addition, Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can [improve Hyper-V performance][azs-hci-csv-cache].
- Compute performance optimization. Azure Stack HCI offers support for graphics processing unit (GPU)<!-- Verify this is the correct definition for GPU - there are two different ones in Term Studio. --> acceleration, targeting [high-performance AI/ML workloads][azs-hci-gpu-acceleration] that are geared towards edge scenarios.
- Networking performance optimization. As part of your design, be sure to include projected [traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] when determining your [optimal network hardware configuration][azs-hci-networking]. This includes provisions addressing [switchless interconnect minimum bandwidth requirements][azs-hci-switchless-interconnects-reqs].

### Reliability
<!-- We need a sentence here introducing the following bulleted list. -->
- Improved Storage Spaces Direct volume repair speed (also referred to as *resync*). Storage Spaces Direct provides automatic resync following events that affect availability of storage pool disks, such as shutting down a cluster node or a localized hardware failure. Azure Stack HCI implements an [enhanced resync process][sr-resync] that operates at much finer granularity than Windows Server 2019 and significantly reduces the resync operation time. This minimizes potential impact of multiple overlapping hardware failures.
- Failover Clustering witness selection. The lightweight, USB drive&ndash;based witness eliminates dependencies on reliable internet connectivity, which is required when using cloud witness-based configuration.

### Security
<!-- We need a sentence here introducing the following bulleted list. -->
- [Azure Stack HCI basic security][azs-hci-basic-security]. Leverage Azure Stack HCI hardware components (such as Secure Boot, UEFI, and TPM) to build a secure foundation for Azure Stack HCI VMs including Device Guard and Credential Guard<!-- Device Guard and Credential Guard are features, not VMs. -->. Use [Windows Admin Center role-based access control][wac-rbac] to delegate management tasks by following the principle of least privilege.
- [Azure Stack HCI advanced security][azs-hci-advanced-security]. Apply Microsoft security baselines to Azure Stack HCI clusters and their Windows Server workloads by using Active Directory Domain Services (AD DS) with Group Policy. You can use [Microsoft Advanced Threat Analytics (ATA)][ms-ata] to detect and remediate cyber threats targeting AD DS domain controllers providing authentication services to Azure Stack HCI clusters and their Windows Server workloads.

[architectural-diagram]: images/azure_stack_robo.png
[architectural-diagram-visio-source]: diagrams/azure_stack_robo.vsdx
[azure-service]: https://docs.microsoft.com/azure/
[azure-well-architected-framerwork]: https://docs.microsoft.com/azure/architecture/framework/
[usb-file-share-witness]: https://techcommunity.microsoft.com/t5/failover-clustering/new-file-share-witness-feature-in-windows-server-2019/ba-p/372149
[s2d-resiliency]: https://docs.microsoft.com/windows-server/storage/storage-spaces/storage-spaces-fault-tolerance
[failover-clustering]: https://docs.microsoft.com/windows-server/failover-clustering/failover-clustering-overview
[s2d-nested-resiliency]: https://docs.microsoft.com/windows-server/storage/storage-spaces/nested-resiliency
[azs-hci-register-arc]: https://docs.microsoft.com/azure-stack/hci/deploy/register-with-azure
[azs-hci-portal-view]: https://docs.microsoft.com/azure-stack/hci/manage/azure-portal
[azs-hci-monitor]: https://docs.microsoft.com/azure-stack/hci/manage/azure-monitor
[az-auto-vm-dsc-hybrid-worker]: https://docs.microsoft.com/azure/automation/automation-hybrid-runbook-worker#azure-automation-state-configuration-on-a-hybrid-runbook-worker
[az-auto-update-mgmt]: https://docs.microsoft.com/azure/automation/update-management/update-mgmt-overview
[az-auto-ct-and-inv]: https://docs.microsoft.com/azure/automation/change-tracking
[azs-hci-vm-backup]: https://docs.microsoft.com/azure-stack/hci/manage/use-azure-backup
[azs-hci-vm-dr]: https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery
[az-file-sync]: https://docs.microsoft.com/azure/storage/files/storage-sync-files-planning
[azs-hci-aks]: https://docs.microsoft.com/azure-stack/aks-hci/overview
[arc-enabled-servers]: https://docs.microsoft.com/azure/azure-arc/servers/overview
[arc-enabled-data-services]: https://docs.microsoft.com/azure/azure-arc/data/overview
[arc-vm-extensions]: https://docs.microsoft.com/azure/azure-arc/servers/manage-vm-extensions
[arc-azure-policy]: https://docs.microsoft.com/azure/azure-arc/servers/security-controls-policy
[azs-hci-vbs]: https://docs.microsoft.com/windows-hardware/design/device-experiences/oem-vbs
[az-security-center]: https://docs.microsoft.com/azure-stack/hci/concepts/security#part-2-use-azure-security-center
[azs-hci-billing]: https://docs.microsoft.com/azure-stack/hci/concepts/billing
[azs-hci-create-with-wac]: https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster
[azs-hci-create-with-powershell]: https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell
[azs-hci-manage-vms-with-wac]: https://docs.microsoft.com/azure-stack/hci/manage/vm
[azs-hci-manage-vms-with-powershell]: https://docs.microsoft.com/azure-stack/hci/manage/vm-powershell
[az-auto-hybrid-worker]: https://docs.microsoft.com/azure/automation/automation-hybrid-runbook-worker
[azs-hci-k8s-gitops]: https://docs.microsoft.com/azure/azure-arc/kubernetes/use-gitops-connected-cluster
[s2d-disks]: https://docs.microsoft.com/windows-server/storage/storage-spaces/choosing-drives
[s2d-drive-max-performance]: https://docs.microsoft.com/windows-server/storage/storage-spaces/choosing-drives#option-1--maximizing-performance
[s2d-drive-max-capacity]: https://docs.microsoft.com/windows-server/storage/storage-spaces/choosing-drives#option-3--maximizing-capacity
[s2d-drive-balance-performance-capacity]: https://docs.microsoft.com/windows-server/storage/storage-spaces/choosing-drives#option-2--balancing-performance-and-capacity
[s2d-cache]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-the-cache
[s2d-cache-sizing]: https://docs.microsoft.com/windows-server/storage/storage-spaces/choosing-drives#cache
[azs-hci-csv-cache]: https://docs.microsoft.com/azure-stack/hci/manage/use-csv-cache#planning-considerations
[azs-hci-gpu-acceleration]: https://docs.microsoft.com/azure-stack/hci/manage/attach-gpu-to-linux-vm
[azs-hci-networking]: https://docs.microsoft.com/azure-stack/hci/concepts/plan-host-networking
[azs-hci-network-bandwidth-allocation]: https://docs.microsoft.com/azure-stack/hci/concepts/plan-host-networking#traffic-bandwidth-allocation
[azs-hci-switchless-interconnects-reqs]: https://docs.microsoft.com/azure-stack/hci/concepts/plan-host-networking#interconnects-for-2-3-node-clusters
[sr-resync]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-storage-resync
[azs-hci-basic-security]: https://docs.microsoft.com/azure-stack/hci/concepts/security#part-1-build-a-secure-foundation
[wac-rbac]: https://docs.microsoft.com/windows-server/manage/windows-admin-center/plan/user-access-options#role-based-access-control
[azs-hci-advanced-security]: https://docs.microsoft.com/azure-stack/hci/concepts/security#part-3-add-advanced-security
[ms-ata]: https://docs.microsoft.com/advanced-threat-analytics/what-is-ata
