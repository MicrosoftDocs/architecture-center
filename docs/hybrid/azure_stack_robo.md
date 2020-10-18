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

# Use Azure Stack HCI switchless interconnect and lightweight quorum for Remote Office/Branch Office (ROBO)

This reference architecture illustrates how to design infrastructure for highly available virtualized and containerized workloads in ROBO scenarios

![Azure Stack HCI 2-node cluster with switchless interconnect and a USB-based witness for Remote Office/Branch Office][architectural-diagram]

*Download a [Visio file][architectual-diagram-visio-source] of this architecture.*

Typical uses for this architecture include the following ROBO scenarios:

- Implement highly-available container-based edge workloads and virtualized business-essential applications in a cost-effective manner
- Lower total cost of ownership through Microsoft-certified solutions, cloud-based automation, centralized management, and centralized monitoring 
- Control and audit security and compliance by leveraging virtualization-based protection, certified hardware, and cloud-based services

## Architecture

The architecture incorporates the following components and capabilities:

- **Azure Stack HCI (20H2)**. Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. A cluster can consists of between 2 and 16 physical nodes. 
- **File share witness**. A file share witness is an SMB share that Failover Cluster uses as a vote in the cluster quorum. Starting with Windows Server 2019, it is possible to use for this purpose [a USB drive connected to a router][usb-file-share-witness].
- **Azure Arc**. Azure Arc is a cloud-based service that extend the Azure Resource Manager-based management model to non-Azure resources including virtual machines, Kubernetes clusters, and containerized databases. 
- **Azure Policy**. Azure Policy is a cloud-based service that evaluates Azure and, through integration with Azure Arc, on-premises resources by comparing their properties to customizable business rules.
- **Azure Monitor**. Azure Monitor is a cloud-bases service that maximizes the availability and performance of applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on telemetry from Azure and non-Azure locations.
<!-- It should be "cloud-based" instead of "cloud-bases". -->
- **Azure Security Center**. Azure Security Center is a unified infrastructure security management system that provides advanced threat protection and helps strengthen the security posture across Azure and non-Azure locations.
- **Azure Automation**. Azure Automation delivers a cloud-based automation and desired state configuration service that supports consistent management across Azure and non-Azure locations.
- **Change Tracking and Inventory**. Change Tracking and Inventory is a feature of Azure Automation that tracks changes in Windows and Linux servers across Azure and non-Azure locations to help you identify and troubleshoot operational and environmental issues.
- **Update Management**. Update Management in Azure Automation is a feature of Azure Automation that streamlines management of operating system updates for Windows and Linux machines across Azure and non-Azure locations.
- **Azure Backup**. Azure Backup is a cloud-based solution that provides simple, secure, and cost-effective solutions to back up and recover data across Azure and non-Azure locations.
- **Azure Site Recovery**. Azure Site Recovery is a cloud-based service that helps ensure business continuity by keeping business apps and workloads running during outages. Site Recovery handles replication and failover of workloads running on physical and virtual machines between their primary site and a secondary location. 
- **Azure File Sync**. Azure File Sync is a cloud-based service that provides the ability to synchronize and cache content of Azure file shares by using Windows Servers across Azure and non-Azure locations.
- **Storage Replica**. Storage Replica is Windows Server technology that enables replication of volumes between servers or clusters for disaster recovery.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Use Azure Stack HCI switchless interconnect and lightweight quorum to implement a highly-available infrastructure for containerized and virtualized ROBO workloads in a cost-effective manner.

In ROBO scenarios, one of the primary business concerns is minimizing cost. Yet, many ROBO workloads are of utmost criticality, with very little tolerance for temporary downtime. Azure Stack HCI offers a sound compromise between these two conflicting priorities. On one hand, it allows you to leverage built-in [resiliency of Storage Spaces Direct][s2d-resiliency] and [Failover Clustering][failover-clustering] technologies that are integral part of Azure Stack HCI to implement highly-available compute, storage, and network infrastructure for containerized and virtualized ROBO workloads. On the other, your solution can consist of as few as 2 cluster nodes with only 4 disks and 64 GB of memory per node. To further minimize the cost, you can take advantage of switchless interconnects between nodes, eliminating the need for redundant switch devices. To finalize cluster configuration, you can implement [the file share witness by using simply a USB drive][usb-file-share-witness] connected to a router hosting uplinks from cluster nodes. For maximum resiliency, on a 2-node cluster, you have the option of configuring Storage Spaces Direct volumes with either [nested two-way mirror or nested mirror accelerated parity][s2d-nested-resiliency], which, unlike the traditional two-way mirroring, tolerate multiple simultaneous hardware failures without data loss. 
<!-- "a sound compromise" might not be translatable. Consider replacing with "a good balance". -->

> [!NOTE]
> With nested resiliency, a 2-node cluster and all of its volumes will remain online following a failure of a single node and a single disk on the surviving node. 

### Fully integrate Azure Stack HCI deployments with Azure to minimize total cost of ownership in ROBO scenarios. 

Azure Stack HCI is inherently dependent on Azure. Within 30 days following the initial deployment of an Azure Stack HCI cluster, you need to [register it][azs-hci-register-arc] with Azure Arc, which generates a corresponding Azure Resource Manager resource. This effectively extends the Azure management plane to Azure Stack HCI, enabling automatically [the Azure portal-based monitoring][azs-hci-portal-view], support, and billing functionality. 

To minimize overhead of managing Azure Stack HCI clusters and their workloads, you should also consider leveraging a range of Azure services, which provide the following capabilities:

- [monitoring, analytics, and alerting using telemetry generated by clusters and their VMs with Azure Monitor][azs-hci-monitor]
- [automated patch deployment and reporting of Azure Stack HCI VMs with Update Management in Azure Automation][az-auto-update-mgmt]
- [change tracking and inventory of Azure Stack HCI VMs with the Change Tracking and Inventory feature of Azure Automation][az-auto-ct-and-inv]
- [automating implementation of desired state configuration of Azure Stack HCI VMs with Azure Automation][az-auto-vm-dsc-hybrid-worker]
- [managed backup of Azure Stack HCI VMs and their workloads with Azure Backup][azs-hci-vm-backup]
- [implementation and orchestration of disaster recovery of Azure Stack HCI VMs with Azure Site Recovery][azs-hci-vm-dr]
- [synchronization and tiering of file shares with Azure File Sync][az-file-sync]
- container orchestration with [Azure Kubernetes Service (AKS) on Azure Stack HCI][azs-hci-aks]

To further benefit from Azure capabilities, extend the scope of Azure Arc integration to Azure Stack HCI virtualized and containerized workloads by implementing the following functionality:

- [Azure Arc enabled servers][arc-enabled-servers] for virtualized workloads running Azure Stack HCI VMs
<!-- Missing period at the end of the sentence. -->
- [Azure Arc enabled data services][arc-enabled-data-services] for containerized SQL Manage Instance or PostgresSQL Hyperscale running on AKS hosted by Azure Stack HCI VMs.

> [!CAUTION]
> AKS on Azure Stack HCI and Azure Arc enabled data services are in preview at the time of authoring this reference architecture.

With the scope of Azure Arc extended to Azure Stack HCI VMs, you will be able to [automate their configuration by using Azure VM extensions][arc-vm-extensions] and evaluate their [compliance with industry regulations and corporate standards by using Azure Policy][arc-azure-policy]. 

### Leverage Azure Stack HCI virtualization-based protection, certified hardware, and cloud-based services to enhance security and compliance stance in ROBO scenarios.

ROBO scenarios present unique challenges regarding security and compliance. With no or, at best, limited local IT support and lack of dedicated data center, it is particularly important to protect their workloads from external and internal threats. You can provide this functionality by leveraging the capabilities included in Azure Stack HCI and delivered through its integration with Azure services. 

Azure Stack HCI certified hardware ensures built-in Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. These technologies, combined with [virtualization-based security (VBS)][azs-hci-vbs] to help protect security-sensitive workloads. BitLocker allows you to encrypt Storage Spaces Direct volumes at rest while SMB encryption provides automatically encryption in transit, facilitating compliance with standards such as FIPS 140-2 and HIPAA.
<!-- "to" needs to be removed from the second sentence. Sentece should read "These technologies, combined with virtualization-based security (VBS) help protect security-sensitive workloads." -->

In addition, you can onboard Azure Stack HCI VMs in [Azure Security Center][az-security-center] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Similarly, by onboarding Azure Stack HCI VMs in Azure Arc, you gain the ability to use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards. 


## Architectural excellence

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Cost optimization

- Switchless vs switch-based cluster interconnects. The switchless interconnect topology consists of redundant connections between single or dual port Remote direct memory access (RDMA) adapters on each node forming a full mesh, with each node connected directly to every other node. With a 2-node cluster this is straightforward to accomplish, but for larger clusters, it is necessary to incorporate additional network adapters into the hardware on each node. 

- Cloud-style billing model. Azure Stack HCI pricing follows the [monthly subscription billing model][azs-hci-billing], with a flat rate per physical processor core in an Azure Stack HCI cluster. 

> [!CAUTION]
> There are no on-premises software licensing requirements for cluster nodes hosting the Azure Stack HCI infrastructure, but Azure Stack HCI VMs may require individual operating system licenses. Additional usage charges might apply if you use other Azure services.

### Operational excellence

- Simplified provisioning and management experience by using Windows Admin Center. The Create Cluster wizard in [Windows Admin Center provides a wizard-driven interface that guides you through the process of creating an Azure Stack HCI cluster][azs-hci-create-with-wac]. Similarly, [Windows Admin Center simplifies the process of managing Azure Stack HCI VMs][azs-hci-manage-vms-with-wac].

- Automation capabilities. Azure Stack HCI provides a wide range of automation opportunities, with full-stack updates including firmware and drivers combined with OS updates, supported by Azure Stack HCI vendors and partners. With [Cluster-Aware Updating (CAU)], operating system updates run unattended while Azure Stack HCI workloads remain online, transitioning seamlessly between cluster nodes to eliminate the impact of post-patching reboots. Azure Stack HCI also offers support for [automated cluster provisioning][azs-hci-create-with-powershell] and [VM management][azs-hci-manage-vms-with-powershell] by using Windows PowerShell. You can run PowerShell locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of additional automation scenarios for [virtualized][arc-vm-extensions] and [containerized][azs-hci-k8s-gitops] workloads.

- Decreased management complexity. Switchless interconnect eliminates the risk of failures of switch devices and the need for their configuration and management. 

### Performance efficiency

- [Storage resiliency][s2d-resiliency] vs usage efficiency vs performance. Planning for Azure Stack HCI volumes involves identifying the optimal balance between resiliency, usage efficiency, and performance. The challenge results from the fact that maximizing one of these characteristics typically has a negative impact on at least one of the other two. For example, increasing resiliency reduces the usable capacity, while the resulting performance might vary depending on the resiliency type. In case of the nested two-way mirror or nested mirror accelerated parity volumes, higher resiliency leads to lower capacity efficiency comparing with traditional two-way mirroring. At the same time, the nested two-way mirror offers better performance than the nested mirror accelerated parity, but at the cost of lower usage efficiency.

- [Storage Spaces Direct disk configuration][s2d-disks]. Storage Spaces Direct supports HDDs, SSDs, and NVMe drive types. The choice of the drive type directly impacts storage performance, due to differences in performance characteristics between each type, and the caching mechanism, which is an integral part of Storage Spaces Direct configuration. Depending on characteristics of Azure Stack HCI workloads and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a drive configuration that provides [balance between performance and capacity][s2d-drive-balance-performance-capacity]. 

- Storage caching optimization. Storage Spaces Direct provides a [built-in, persistent, real-time, read and write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to [accommodate the working set of your applications and workloads][s2d-cache-sizing]. In addition, Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can [improve Hyper-V performance][azs-hci-csv-cache].

- Compute performance optimization. Azure Stack HCI offers support for GPU acceleration targeting [high-performance AI/ML workloads][azs-hci-gpu-acceleration], geared towards edge scenarios. 

- Networking performance optimization. As part of your design, you should take into account projected [traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] in order to determine the [optimal network hardware configuration][azs-hci-networking]. This includes provisions addressing [switchless interconnect minimum bandwidth requirements][azs-hci-switchless-interconnects-reqs].

### Reliability

- Improved Storage Spaces Direct volume repair speed (aka resync). Storage Spaces Direct provides automatic resync following events that affect availability of some disks in its storage pool, such as shutting down one of cluster nodes or a localized hardware failure. Azure Stack HCI implements an [enhanced resync process][sr-resync] which operates at much finer granularity than Windows Server 2019, significantly reducing duration of the resync operation. This minimizes potential impact of multiple, overlapping hardware failures. 

- Failover Clustering witness selection. The lightweight, USB-drive based witness eliminates the dependency on a reliable Internet connectivity, required when using cloud witness-based configuration.

### Security

- [Azure Stack HCI basic security][azs-hci-basic-security]. Leverage Azure Stack HCI hardware components such as Secure Boot, UEFI, and TPM to build a secure foundation for Azure Stack HCI VMs including Device Guard and Credential Guard. Use [Windows Admin Center role-based access control][wac-rbac] to delegate management tasks in the manner that follows the principle of least privilege. 

- [Azure Stack HCI advanced security][azs-hci-advanced-security]. Apply Microsoft security baselines to Azure Stack HCI clusters and their Windows Server workloads by using Active Directory Domain Services (AD DS) Group Policy. Detect and remediate cyber threats targeting AD DS domain controllers providing authentication services to Azure Stack HCI clusters and their Windows Server workloads by using [Microsoft Advanced Threat Analytics (ATA)][ms-ata].

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
