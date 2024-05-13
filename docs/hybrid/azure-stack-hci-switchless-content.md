This reference architecture illustrates how to design infrastructure for highly available virtualized and containerized workloads for retail, manufacturing or remote office scenarios.

The primary focus of this architecture is not the application workload that will be hosted on Azure Stack HCI. Instead, this article provides guidance for configuring and deploying the HCI cluster infrastructure, on which the application will depend upon. These components include physical nodes, storage and networking, in addition to Azure services that will be used for the day to day management and monitoring.

This architecture serves as a starting point for a [3-node Azure Stack HCI cluster using a storage switchless networking design](/azure-stack/hci/plan/three-node-switchless-two-switches-two-links). The workload applications deployed on an Azure STack HCI cluster should also be well-architected; such as deploying multiple instances (_high-availability_) of any critical workload services, and with appropriate business continuity and disaster recovery (_BC/DR_) controls in place. These workload design aspects have been intentionally excluded from this guidance to maintain the focus on the HCI cluster infrastructure, review the five well-architected pillars for guidance on workload design guidelines and recommendations.

## Article layout

| Architecture | Design decision | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; Workload resources <br> &#9642; Supporting resources <br> &#9642; User flows <br> |&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; Disks <br> &#9642; [Networking](#network-layout) <br> &#9642; Monitoring <br> &#9642; Update management|  <br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization) <br> &#9642; [Operational Excellence](#operational-excellence) <br> &#9642; [Performance Efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-3Nodes-Switchless-DualLink) demonstrates how to deploy a 3-node Azure Stack HCI storage switchless cluster using an ARM template and parameter file.

## Architecture

[![Diagram illustrating a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity. The cluster uses a number of Azure services, including Azure Arc, Key Vault, Azure Storage, Azure Update Management, Azure Monitor, Azure Policy, Microsoft Defender, Azure Backup, Extended Security Updates and Azure Site Recovery.](images/azure-stack-hci-switchless.svg)](images/azure-stack-hci-switchless.svg#lightbox)

*Download a [Visio file][architectural-diagram-visio-source] of this architecture.*

For information about these resources, see Azure product documentation listed in [Related resources](#related-resources).

### Components

This architecture consists of Azure Stack HCI, Azure Arc and several Azure services that offer supporting resources for Azure Stack HCI and optionally the running workload, these services and their roles are described in the following sections.

### Workflow

The architecture incorporates the following capabilities:

- **[Azure Stack HCI][azs-hci]** is a hyper-converged infrastructure (HCI) solution that hosts virtualized workloads and storage in a hybrid on-premises environment or edge location. Azure Stack HCI clusters can scale from a single node to a maximum of sixteen nodes.
- **[Azure Arc][azure-arc]** is a cloud-based service that extends the Azure Resource Manager-based management model to Azure Stack HCI and other non-Azure locations. Azure Arc provides the ability to manage resources including virtual machines (VMs), Kubernetes clusters, and containerized data services using Azure as the control and management plane.
- **[Key Vault][key-vault]** is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys.
- **[Cloud Witness][cloud-witness]** is a type of failover cluster quorum witness that uses an Azure Storage Account to provide Azure Stack HCI cluster node quorum voting capabilities.
- **[Update Management][azure-update-management]** is a unified service to help manage and govern updates for all your machines. You can monitor Windows and Linux update compliance across your deployments in Azure, on-premises, or other cloud platforms from a single dashboard.
- **[Azure Monitor][azure-monitor]** is a cloud-based service that maximizes the availability and performance of your applications and services by delivering a comprehensive solution for collecting, analyzing, and acting on diagnostic logs and telemetry from your cloud and on-premises workloads.
- **[Azure Policy][azure-policy]** evaluates Azure and on-premises resources through integration with Azure Arc by comparing properties to determine compliance based on customizable business rules.
- **[Microsoft Defender for Cloud][ms-defender-for-cloud]** is a unified infrastructure security management system that strengthens the security posture of your data centers, and provides advanced threat protection across your hybrid workloads in the cloud - whether they're in Azure or not - and on premises.
- **[Azure Backup][azure-backup]** service provides simple, secure, and cost-effective solutions to back up your data and recover it from the Microsoft Azure cloud.
- **[Azure Site Recovery][azure-site-recovery]** provides business continuity and disaster recovery (BC/DR) capabilities, by enabling business apps and workloads to failover in the event of a disaster or outage. Site Recovery manages replication and failover of workloads running on both physical and virtual machines, between their primary site and a secondary location.

### Cluster design choices

When designing an Azure Stack HCI cluster is is important to have a baseline performance expectation. Several characteristics influence the decision-making process, including:

- CPU, memory, and storage input/output operations per second (IOPS)
- Processors architecture
- Number of cluster nodes
- Update

## Scenario details

### Potential use cases

Typical use cases for this architecture pattern include the ability to run highly available (HA) workloads for retail, manufacturing or remote office scenarios:

- Deploy and manage highly available (HA) virtualized or container-based edge workloads deployed in a single location, to enable business-critical applications and services to operate in a resilient, cost-effective and scalable manner.
- Lower total cost of ownership (TCO) through Microsoft-certified solutions, cloud-based deployment, centralized management, monitoring and alerting.
- Centralized provisioning capability to deploy workloads to multiple Azure Stack HCI clusters using Azure and Azure Arc, such as portal, command-line-interface (cli) or infrastructure as code (IaC) templates for automation and repeatability.
- Requirement to adhere to strict security, compliance and audit requirements. Azure Stack HCI has a hardened security posture configured "by default", using technologies such as certified hardware, secure boot, trust platform module (TPM), virtualization-based security, credential guard and application control policies (WDAC) enforced, and the ability integrate with modern cloud-based security & threat management services, such as Microsoft Defender for Cloud and Azure Sentinel.

## Network layout

Opening paragraph...

### Physical network topology

Physical network topology description

[![Diagram illustrating the physical networking topology for a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity.](images/azure-stack-hci-3node-physical-network.png)](images/azure-stack-hci-3node-physical-network.png#lightbox)

### Logical network topology

Logical network topology description. Network ATC and Intents
[![Diagram illustrating the logical networking topology for a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity.](images/azure-stack-hci-3node-logical-network.png)](images/azure-stack-hci-3node-logical-network.png#lightbox)

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirements that override them.

### Azure Stack HCI switchless storage for retail, manufacturing or remote office scenarios

For retail, manufacturing or remote office scenarios, a primary business concern is minimizing costs, yet the workloads that power these business scenarios are of utmost criticality, with very little tolerance for downtime. Azure Stack HCI offers the optimal solution by offering high levels of resiliency, and a cost-effective and scalable solution. Deploying Azure Stack HCI using multiple cluster nodes, provides built-in [storage fault tolerance and efficiency using Storage Spaces Direct][s2d-resiliency] and [Failover Clustering][failover-clustering] technologies to implement highly available compute, storage, and network infrastructure for containerized and virtualized workloads. For cost-effectiveness, you can scale deployments from a single node cluster, up to two or three nodes, with only four data disks and 64 gigabytes (GB) of memory per node. To further minimize costs, it is possible to use a "switchless storage design", which interconnects each physical node directly with one or more links, thereby eliminating the requirement for dedicated switches for storage. For maximum storage reliability and workload resiliency, it is recommended to deploy a minimum of 3-nodes in the HCI cluster and use the default configuration of a [3-way mirror for the infrastructure and user volumes](/azure-stack/hci/concepts/fault-tolerance#three-way-mirror).

### Azure Stack HCI directly integrates with Azure using Azure Arc, lowering the total cost of ownership (TCO) and operational overheads

Azure Stack HCI 23H2 (and above) is deployed and managed from Azure, providing  built-in integration of Azure Arc and deployment of the [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) component as part of HCI cluster deployment process. Azure Stack HCI cluster nodes are enrolled with [Azure Arc for Servers](/azure-stack/hci/deploy/deployment-arc-register-server-permissions) as a prerequisite to initiating the cloud based deployment of the cluster. Once deployed, an HCI cluster can be monitored using Azure Monitor and Log Analytics, by enabling Azure Stack HCI Insights. [Feature updates for Azure Stack HCI are released periodically to enhance customer experience](/azure-stack/hci/release-information-23h2), these updates are controlled and managed using [Azure Update Management][azure-update-management]. Workload resources, such as [Azure Arc VMs](/azure-stack/hci/manage/create-arc-virtual-machines), [Arc-enabled AKS][arc-enabled-aks] and [Azure Virtual Desktop (AVD) node pools](/azure/virtual-desktop/deploy-azure-virtual-desktop) can be deployed using Azure, by selecting an [Azure Stack HCI cluster's "custom location"](/azure-stack/hci/manage/azure-arc-vm-management-overview#components-of-azure-arc-vm-management) as the target for the workload deployment, these components provide centralized administration, management, and support. For customers that have existing Windows Server Datacenter Core Licenses with active Software Assurance (SA), it is possible to further reduce costs by applying Azure Hybrid Benefit to Azure Stack HCI, and Windows Server VMs and AKS clusters to optimize the costs for these services.

To minimize the Azure Stack HCI cluster and workload operational management costs, consider using the Azure services below, which provide the following capabilities:

- [Azure Monitor][azs-hci-monitor] to collect diagnostic logs and telemetry generated by HCI clusters and the Arc VM or Arc AKS workload for the purposes of monitoring, analytics, and alerting.
- [Azure Update Management][azure-update-management] to manage updates for Azure Stack HCI clusters and Virtual Machines, to automate the deployment and reporting processes for security updates.
- [Azure Automation][azure-automation]. Azure Automation delivers a cloud-based automation, and configuration service that supports consistent management across your Azure and non-Azure environments.
- [Azure Automation, Change Tracking, and Inventory feature][az-auto-ct-and-inv]. Track Azure Stack HCI VM configuration changes, this can be enable using Azure Arc.
- [Azure Automation DSC][az-auto-vm-dsc-hybrid-worker]. Automate a desired state configuration of Azure Stack HCI VMs.
- [Azure Backup][azs-hci-vm-backup]. Manage the backup of Azure Stack HCI VMs and their workloads.
- [Azure Site Recovery][azs-hci-vm-dr]. Implement and orchestrate disaster recovery for Azure Stack HCI VMs.
- [Azure File Sync][az-file-sync]. Synchronize and tier file shares that are hosted on Azure Stack HCI clusters.
- [Arc-enabled Azure Kubernetes Service (AKS)][azs-hci-aks] Implement container orchestration.
- [Azure Virtual Desktop (AVD)][azs-hci-avd]. Implement node pools for VDI workloads on Azure Stack HCI.

To further benefit from Azure capabilities, you can extend the scope of Azure Arc integration to the Azure Stack HCI virtualized and containerized workloads, by implementing the following functionality:

- [Azure Arc-enabled VMs][arc-enabled-vms] for applications or services that run as virtualized workloads in Azure Stack HCI VMs.
- [Azure Arc-enabled AKS][arc-enabled-aks] for containerized applications or services that will benefit from using Kubernetes as their orchestration platform.
- [Azure Arc enabled data services][arc-enabled-data-services] for containerized Azure SQL Managed Instance or PostgreSQL Hyperscale that use Arc-enabled AKS hosted on Azure Stack HCI.

With the scope of Azure Arc extended to Azure Stack HCI VMs, it is possible to [automate the Guest OS configuration using Azure Arc VM extensions][arc-vm-extensions] and evaluate [compliance with industry regulations and corporate standards by using Azure Policy][arc-azure-policy].

### Azure Stack HCI default security configuration provides defense in depth approach, simplifying security and compliance costs

The deployment and management of IT services for retail, manufacturing and remote office scenarios present unique challenges for security and compliance. With no&mdash;or at best&mdash;limited local IT support and lack of dedicated datacenters, it is particularly important to protect workloads from both internal and external threats. Azure Stack HCI's default security hardening and deep integration with Azure services can help address these challenges.

Azure Stack HCI&ndash;certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. These technologies, combined with [virtualization-based security (VBS)][azs-hci-vbs], help protect security-sensitive workloads. BitLocker Drive Encryption allows you to encrypt Boot disk volume and Storage Spaces Direct volumes at rest while SMB encryption provides automatic encryption in transit, facilitating compliance with regulatory standards.

In addition, you can onboard Azure Stack HCI VMs in [Microsoft Defender for Cloud][ms-defender-for-cloud] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Similarly, by managing Azure Stack HCI VMs in Azure Arc, you gain the ability to use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Considerations

The [Microsoft Azure Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Reliability considerations include:

- Improved Storage Spaces Direct volume repair speed (also referred to as *resync*). Storage Spaces Direct provides automatic resync following events that affect availability of storage pool disks, such as shutting down a cluster node or a localized hardware failure. Azure Stack HCI implements an [enhanced resync process][sr-resync] that operates at much finer granularity than Windows Server 2019 and significantly reduces the resync operation time. This minimizes potential impact of multiple overlapping hardware failures.
- Failover Clustering witness selection. The lightweight, Cloud Witness&ndash;based witness eliminates dependencies in setting up a separate server or maintain additional infrastructure such as file share witness. The use of cloud witness for quorum is easier to manage and reduces operational overhead.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Security considerations include:

- [Azure Stack HCI basic security][azs-hci-basic-security]. Utilize Azure Stack HCI hardware components (such as Secure Boot, UEFI, and TPM) to build a secure foundation for Azure Stack HCI VM-level security, including Device Guard and Credential Guard. Use [Azure role-based access control][azure-rbac] to delegate management tasks by following the principle of least privilege.
- [Azure Stack HCI security default][azs-hci-security-default]. Apply default security settings for your Azure Stack HCI cluster during deployment to keep the nodes in a known good state. You can use the security default settings to manage cluster security, drift control, and Secured core server settings on your cluster.
[Azure Stack HCI advanced security][azs-hci-advanced-security] You can use [Microsoft Advanced Threat Analytics (ATA)][ms-ata] to detect and remediate cyber threats targeting AD DS domain controllers providing authentication services to Azure Stack HCI clusters and their Windows Server workloads.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Cost optimization considerations include:

- Switchless vs switch-based cluster interconnects. The switchless interconnect topology consists of redundant connections between single-port or dual-port Remote Direct Memory Access (RDMA) adapters on each node (which forms a full mesh), with each node connected directly to every other node. While this is straightforward to implement in a 2-node or 3-node cluster, larger clusters require additional network adapters in each node's hardware.
- Cloud-style billing model. Azure Stack HCI pricing follows the [monthly subscription billing model][azs-hci-billing], with a flat rate per physical processor core in an Azure Stack HCI cluster (additional usage charges apply if you use other Azure services). If you own on-premises core licenses for Windows Server Datacenter edition, with active Software Assurance (SA) you might choose to exchange these licenses to activate Azure Stack HCI cluster and Windows Server VM subscription fee.

> [!TIP]
> You can get cost savings with Azure Hybrid Benefit if you have Windows Server Datacenter licenses with active Software Assurance. For more information about Azure Hybrid Benefit, see [Azure Hybrid Benefit for Azure Stack HCI][azs-hybrid-benefit].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Operational excellence considerations include:

- Simplified provisioning and management experience integrated with Azure. The [**Cloud Based Deployment** in Azure][azs-hci-deploy-via-portal] provides a wizard-driven interface that guides you through creating an Azure Stack HCI cluster. Similarly, [Azure Portal simplifies the process of managing Azure Stack HCI Clusters and Azure Arc VMs][azs-hci-manage-cluster-at-scale] and [azs-hci-manage-arc-vms]. The portal based deployment of Azure Stack HCI cluster can be [automated using ARM template][azs-hci-deploy-via-template]
- Automation capabilities for Virtual Machines. Azure Stack HCI provides a wide range of automation capabilities for managing workloads such as Virtual Machines, with the [automated deployment of Arc VMs using Azure CLI, ARM or Bicep Template][azs-hci-automate-arc-vms], with Virtual Machine OS updates using Azure Arc Extension for Updates and Azure Update Manager[azs-update-manager]. Azure Stack HCI also offers support for [Azure Arc VM management][azs-hci-vm-automate-cli] by using Azure CLI and [Non-Azure Arc VMs][azs-hci-manage-non-arc-vms] by using Windows PowerShell. You can run Azure CLI commands locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of additional automation scenarios for [virtual machine][arc-vm-extensions] workloads through Azure Arc extensions.
- Automation capabilities for Containers on AKS (Azure Kubernetes Service). Azure Stack HCI provides a wide range of automation capabilities for managing workloads such as containers on AKS, with the [automated deployment of AKS clusters using Azure CLI][azs-hci-automate-arc-aks], with AKS workload cluster updates using Azure Arc Extension for [Kubernetes Updates][azs-hci-automate-aks-update]. Azure Stack HCI also offers support for [Azure Arc AKS management][azs-hci-aks-automate-cli] by using Azure CLI. You can run Azure CLI commands locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with Azure Arc facilitates a wide range of additional automation scenarios for [containerized][azs-hci-k8s-gitops] workloads through Azure Arc extensions.
- Decreased management complexity. Switchless interconnect eliminates the risk of switch device failures and the need for their configuration and management.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Performance efficiency considerations include:

- [Storage resiliency][s2d-resiliency] versus usage efficiency, versus performance. Planning for Azure Stack HCI volumes involves identifying the optimal balance between resiliency, usage efficiency, and performance. This challenge results from the fact that maximizing one of these characteristics typically has a negative impact on at least one of the other two. For example, increasing resiliency reduces the usable capacity, while the resulting performance might vary depending on the resiliency type selected. When resiliency and performance matters most, and when using three or more nodes, the default storage configuration during Azure Stack HCI cloud deployment will be a three-way mirror for the infrastructure and user volumes.
- [Storage Spaces Direct][s2d-disks] supports multiple physical disk types that vary is performance and capacity; spinning hard disk drives (HDDs), solid-state drives (SSDs) and NVMe drives (aka "flash drives"), and [Persistent memory (PMem) storage](/azure-stack/hci/concepts/deploy-persistent-memory), often referred to as "storage-class memory" or SCM. The selected physical drive types directly impact storage performance due to differences in performance characteristics between each type, and the caching mechanism, which is an integral part of any Storage Spaces Direct configuration. Depending on the Azure Stack HCI workloads and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a drive configuration that provides a [balance between performance and capacity][s2d-drive-balance-performance-capacity].
- Storage caching optimization. Storage Spaces Direct provides a [built-in, persistent, real-time, read and write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. In addition, Azure Stack HCI is compatible with the Cluster Shared Volume (CSV) in-memory read cache. Using system memory to cache reads can [improve Hyper-V performance][azs-hci-csv-cache].
- Compute performance optimization in Azure Stack HCI and be achieved through the use of graphics processing unit (GPU) acceleration, such as requirements for data insights or inferencing for [high-performance AI/ML workloads][azs-hci-gpu-acceleration] that require deployment at edge locations due to data gravity and/or security requirements.
- Networking performance optimization. As part of your design, be sure to include projected [network traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] when determining your [optimal network hardware configuration][azs-hci-networking]. This includes provisions to address [switchless interconnect minimum bandwidth requirements for storage traffic][azs-hci-switchless-interconnects-reqs], such as implementions with two (or more) physical network interface adapters (NICs) for the storage Network ATC intent, which provides additional bandwidth and resiliency for high storage performance and/or business-critical scenarios.

> [!IMPORTANT]
> We recommend using mirroring for most performance-sensitive workloads. If you have three or more servers, we recommend using the default storage configuration (three-way mirroring), instead of two-way mirroring. To learn more about how to balance performance and capacity to meet your workload requirements, see [Plan volumes][s2d-plan-volumes].

## Related resources

See product documentation for details on specific Azure services:

- [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Azure Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Azure Backup](https://azure.microsoft.com/products/backup)

Additional information:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](/azure/architecture/guide/technology-choices/hybrid-considerations)
- [Azure Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)
- [Use Azure Stack HCI stretched clusters for disaster recovery](azure-stack-hci-dr.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)

## Next steps

Product documentation:

- [About Site Recovery](/azure/site-recovery/site-recovery-overview)
- [Azure Automation State Configuration overview](/azure/automation/automation-dsc-overview)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Change Tracking and Inventory overview](/azure/automation/change-tracking/overview)
- [Manage registered servers with Azure File Sync](/azure/storage/file-sync/file-sync-server-registration)
- [Update Management overview](/azure/automation/update-management/overview)
- [What are Azure Arc-enabled data services?](/azure/azure-arc/data/overview)
- [What is Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is the Azure Backup service?](/azure/backup/backup-overview)

Microsoft Learn modules:

- [Configure Azure files and Azure File Sync](/training/modules/configure-azure-files-file-sync)
- [Configure Azure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to Azure Kubernetes Service](/training/modules/intro-to-azure-kubernetes-service)
- [Keep your virtual machines updated](/training/modules/keep-your-virtual-machines-updated)
- [Protect your virtual machine settings with Azure Automation State Configuration](/training/modules/protect-vm-settings-with-dsc)
- [Protect your virtual machines by using Azure Backup](/training/modules/protect-virtual-machines-with-azure-backup)

[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-hci-switchless.vsdx
[azure-well-architected-framerwork]: /azure/architecture/framework
[azs-hci]: /azure-stack/hci/overview
[azure-arc]: /azure/azure-arc/overview
[azure-monitor]: /azure/azure-monitor/overview
[azure-backup]: /azure/backup/backup-overview
[ms-defender-for-cloud]: /azure/security-center/security-center-introduction
[cloud-witness]: /windows-server/failover-clustering/deploy-cloud-witness
[azure-policy]: /azure/governance/policy/overview
[azure-update-management]: /azure/update-manager/
[azure-site-recovery]: /azure/site-recovery/site-recovery-overview
[key-vault]: /azure/key-vault/general/basic-concepts
[s2d-resiliency]: /windows-server/storage/storage-spaces/storage-spaces-fault-tolerance
[failover-clustering]: /windows-server/failover-clustering/failover-clustering-overview
[azs-hci-monitor]: /azure-stack/hci/manage/azure-monitor
[azure-automation]: /azure/automation/automation-intro
[az-auto-vm-dsc-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker#azure-automation-state-configuration-on-a-hybrid-runbook-worker
[az-auto-ct-and-inv]: /azure/automation/change-tracking
[azs-hci-vm-backup]: /azure-stack/hci/manage/use-azure-backup
[azs-hci-vm-dr]: /azure-stack/hci/manage/azure-site-recovery
[az-file-sync]: /azure/storage/files/storage-sync-files-planning
[azs-hci-aks]: /azure-stack/aks-hci/overview
[azs-hci-avd]: /azure/virtual-desktop/deploy-azure-virtual-desktop?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&tabs=portal
[arc-enabled-vms]: /azure-stack/hci/manage/azure-arc-vm-management-overview
[arc-enabled-aks]: /azure/aks/hybrid/aks-create-clusters-portal
[azs-hci-automate-arc-aks]: /azure/aks/hybrid/aks-create-clusters-cli?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json
[azs-hci-automate-aks-update]: /azure/aks/hybrid/cluster-upgrade
[azs-hybrid-benefit]: /azure-stack/hci/concepts/azure-hybrid-benefit-hci
[arc-enabled-data-services]: /azure/azure-arc/data/overview
[arc-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[arc-azure-policy]: /azure/azure-arc/servers/security-controls-policy
[azs-hci-vbs]: /windows-hardware/design/device-experiences/oem-vbs
[azs-hci-billing]: /azure-stack/hci/concepts/billing
[azs-hci-deploy-via-portal]: /azure-stack/hci/deploy/deploy-via-portal
[azs-hci-deploy-via-template]: /azure-stack/hci/deploy/deployment-azure-resource-manager-template
[azs-hci-manage-cluster-at-scale]: /azure-stack/hci/manage/manage-at-scale-dashboard
[azs-hci-manage-arc-vms]: /azure-stack/hci/manage/azure-arc-vm-management-overview
[azs-hci-automate-arc-vms]: /azure-stack/hci/manage/create-arc-virtual-machines?tabs=azurecli
[azs-hci-vm-automate-cli]: /cli/azure/stack-hci-vm
[azs-hci-aks-automate-cli]: /cli/azure/aksarc
[azs-hci-manage-non-arc-vms]: /azure-stack/hci/manage/vm-powershell
[az-auto-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker
[azs-hci-k8s-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[s2d-disks]: /windows-server/storage/storage-spaces/choosing-drives
[s2d-drive-max-performance]: /windows-server/storage/storage-spaces/choosing-drives#option-1--maximizing-performance
[s2d-drive-max-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-3--maximizing-capacity
[s2d-drive-balance-performance-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-2--balancing-performance-and-capacity
[s2d-cache]: /windows-server/storage/storage-spaces/understand-the-cache
[s2d-cache-sizing]: /windows-server/storage/storage-spaces/choosing-drives#cache
[s2d-plan-volumes]: /azure-stack/hci/concepts/plan-volumes#choosing-the-resiliency-type
[azs-hci-csv-cache]: /azure-stack/hci/manage/use-csv-cache#planning-considerations
[azs-hci-gpu-acceleration]: /azure-stack/hci/manage/attach-gpu-to-linux-vm
[azs-hci-networking]: /azure-stack/hci/concepts/plan-host-networking
[azs-hci-network-bandwidth-allocation]: /azure-stack/hci/concepts/plan-host-networking#traffic-bandwidth-allocation
[azs-hci-switchless-interconnects-reqs]: /azure-stack/hci/concepts/plan-host-networking#interconnects-for-2-3-node-clusters
[sr-resync]: /windows-server/storage/storage-spaces/understand-storage-resync
[azs-hci-basic-security]: /azure-stack/hci/concepts/security#part-1-build-a-secure-foundation
[azure-rbac]: /azure/role-based-access-control/overview
[azs-hci-security-default]: /azure-stack/hci/manage/manage-secure-baseline
[azs-hci-advanced-security]: /azure-stack/hci/concepts/security
[ms-ata]: /advanced-threat-analytics/what-is-ata
