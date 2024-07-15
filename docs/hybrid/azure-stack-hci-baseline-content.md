This baseline reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Stack HCI 23H2 (_and later_) infrastructure to ensure a reliable platform that deploys and manages highly-available, virtualized, and containerized workloads. This architecture describes the resource components and cluster design choices for the physical nodes that provide local compute, storage, and networking features. It also describes how to use Azure services to simplify and streamline the day-to-day management of Azure Stack HCI.

This architecture is a starting point for how to use the storage switched network design to deploy a multinode Azure Stack HCI cluster. The workload applications deployed on an Azure Stack HCI cluster should be well architected. Well-architected workload applications can deploy multiple instances (_high availability_) of any critical workload services and have appropriate business continuity and disaster recovery (BC/DR) controls in place, such as regular backups and disaster recovery failover capabilities. To focus on the HCI infrastructure platform, these workload design aspects are intentionally excluded from this article. For more information about guidelines and recommendations for the five pillars of the Well-Architected Framework, see the [Azure Stack HCI Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci).

For more information about workload architecture patterns that are optimized to run on Azure Stack HCI, see the content located in the **Azure Stack HCI workloads** navigation menu.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Scenario details and benefits](#scenario-details-and-benefits) <br>&#9642; [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; [Physical disk drives](#physical-disk-drives) <br> &#9642; [Networking](#network-design) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization) <br> &#9642; [Operational Excellence](#operational-excellence) <br> &#9642; [Performance Efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg). This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to use an Azure Resource Management template (ARM template) and parameter file to deploy a Switched Multi Server Deployment of Azure Stack HCI. Alternatively, this example demonstrates [how to use a Bicep template](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) to deploy an Azure Stack HCI cluster, including its prerequisites resources.

## Architecture

[![Diagram that shows a multinode Azure Stack HCI cluster reference architecture, with dual ToR switches for external North-South connectivity. The cluster uses a number of Azure services, including Azure Arc, Azure Key Vault, Azure Storage, Azure Update Management, Azure Monitor, Azure Policy, Microsoft Defender, Azure Backup, Extended Security Updates, and Azure Site Recovery.](images/azure-stack-hci-baseline.png)](images/azure-stack-hci-baseline.png#lightbox)

_Download a [Visio file][architectural-diagram-visio-source] of this architecture._

For more information, see [Related resources](#related-resources).

## Potential use cases

Typical use cases for Azure Stack HCI include the ability to run high availability (HA) workloads in an on-premises or edge location, which provides a solution to address workload requirements. You can:

- Provide a hybrid-cloud solution that's deployed on premises to address data sovereignty, regulation and compliance, or latency requirements.

- Deploy and manage HA-virtualized or container-based edge workloads that are deployed in a single location or in multiple locations. This strategy enables business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- Lower the total cost of ownership (TCO) through use of solutions that are certified by Microsoft, cloud-based deployment, centralized management, monitoring, and alerting.

- Provide a centralized provisioning capability to deploy workloads across multiple locations consistently and securely using Azure and Azure Arc. Use tools like Azure portal, command-line-interface (CLI), or infrastructure as code (IaC) templates to drive automation and repeatability by using Kubernetes for containerization or traditional workload virtualization.

- Adhere to strict security, compliance, and audit requirements. Azure Stack HCI is deployed with a hardened security posture configured by default (_secure-by-default_). Azure Stack HCI incorporates certified hardware, Secure Boot, Trusted Platform Module (TPM), Virtualization-Based Security, Credential Guard, and enforced Windows Defender Application Control (WDAC) policies. It also integrates with modern cloud-based security and threat management services like Defender for Cloud and Azure Sentinel.

### Scenario details and benefits

The following sections provide more information about the scenarios and potential use cases for this reference architecture. These sections include a list of business benefits and example workload resource types that you can deploy on Azure Stack HCI.

#### Azure Stack HCI directly integrates with Azure by using Azure Arc to lower TCO and operational overhead

Azure Stack HCI is deployed and managed through Azure, which provides built-in integration of Azure Arc through deployment of the [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) component. This component is installed during the HCI cluster deployment process. Azure Stack HCI cluster nodes are enrolled with [Azure Arc for Servers](/azure-stack/hci/deploy/deployment-arc-register-server-permissions) as a prerequisite to initiating the cloud-based deployment of the cluster. During deployment, the mandatory extensions are installed on each cluster node, such as “Lifecycle Manager (LCM),” “Microsoft Edge Device Management,” and “Telemetry and Diagnostics.” After deploying an HCI cluster, you can use Azure Monitor and Log Analytics to monitor it by enabling Azure Stack HCI Insights. [Feature updates for Azure Stack HCI](/azure-stack/hci/release-information-23h2) are released periodically to enhance customer experience. These updates are controlled and managed through [Azure Update Management][azure-update-management].

You can deploy workload resources such as [Azure Arc VMs](/azure-stack/hci/manage/create-arc-virtual-machines), [Azure Arc-enabled AKS][arc-enabled-aks], and [Azure Virtual Desktop (AVD) session hosts](/azure/virtual-desktop/deploy-azure-virtual-desktop) that use Azure portal by selecting an [Azure Stack HCI cluster custom location](/azure-stack/hci/manage/azure-arc-vm-management-overview#components-of-azure-arc-vm-management) as the target for the workload deployment. These components provide centralized administration, management, and support. Customers that have active Software Assurance (SA) on their existing Windows Server Datacenter Core licenses can reduce costs further by applying Azure Hybrid Benefit to Azure Stack HCI, Windows Server VMs, and AKS clusters. This optimization helps manage costs effectively for these services.

Azure and Azure Arc integration extend the capabilities of Azure Stack HCI virtualized and containerized workloads to include:

- [Azure Arc VMs][arc-enabled-vms] for traditional applications or services that run in virtual machines (VM) on Azure Stack HCI.

- [Azure Kubernetes Service (AKS) on HCI][arc-enabled-aks] for containerized applications or services that benefit from using Kubernetes as their orchestration platform.

- [Azure Virtual Desktop (AVD)][azs-hci-avd] to deploy your session hosts for AVD workloads on Azure Stack HCI (_on-premises_) by using the control and management plane in Azure to initiate the host pool creation and configuration.

- [Azure Arc-enabled data services][arc-enabled-data-services] for containerized Azure SQL Managed Instance or PostgreSQL server that use Azure Arc-enabled AKS hosted on Azure Stack HCI.

- [Azure Arc-enabled Event Grid extension for Kubernetes](/azure/event-grid/kubernetes/install-k8s-extension) to deploy the [Event Grid broker and an Event Grid operator](/azure/event-grid/kubernetes/concepts#event-grid-on-kubernetes-components) components. This deployment enables capabilities such as Event Grid topics and subscriptions for event processing.

- [Azure Arc-enabled Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere) with an AKS cluster deployed on Azure Stack HCI as the compute target to run Azure Machine Learning. This approach provides capabilities to train or deploy machine learning models at the edge.

Azure Arc-connected workloads provide enhanced Azure consistency and automation for Azure Stack HCI deployments, like automating guest OS configuration with [Azure Arc VM extensions][arc-vm-extensions] or evaluating compliance with industry regulations or corporate standards through [Azure Policy][arc-azure-policy], which can be activated through the Azure portal or IaC automation.

#### Azure Stack HCI default security configuration provides a defense in depth approach to simplify security and compliance costs

The deployment and management of IT services for retail, manufacturing, and remote office scenarios presents unique security and compliance challenges. Securing workloads against internal and external threats is crucial in environments with limited IT support or a lack or dedicated datacenters. Azure Stack HCI's default security hardening and deep integration with Azure services can help you address these challenges.

Azure Stack HCI-certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. Use these technologies in combination with [VBS][azs-hci-vbs] to help protect security-sensitive workloads. You can use BitLocker Drive Encryption to encrypt Boot disk volume and Storage Spaces Direct volumes at rest. Server message block (SMB) encryption provides automatic encryption of traffic between servers in the cluster (_on the storage network_) and signing of SMB traffic between the cluster nodes and other systems. SMB encryption also helps prevent relay attacks and facilitates compliance with regulatory standards.

You can onboard Azure Stack HCI VMs in [Defender for Cloud][ms-defender-for-cloud] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. By managing Azure Stack HCI VMs in Azure Arc, you can use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Architecture components

This architecture consists of physical server hardware that's used to deploy Azure Stack HCI clusters in on-premises or edge locations. Azure Stack HCI integrates with Azure Arc and several other Azure services that provide supporting resources to enhance platform capabilities. Azure Stack HCI provides a resilient platform to deploy, manage, and operate end-user applications or business systems (_workloads_). These platform resources and services are described in the following sections.

### Platform resources

The architecture requires the following mandatory resources and components:

- [Azure Stack HCI][azs-hci] is a hyper-converged infrastructure (HCI) solution deployed on-premises or in edge locations by using physical server hardware and networking infrastructure. Azure Stack HCI provides a platform to deploy and manage virtualized workloads such as VMs, Kubernetes clusters, and other services enabled through Azure Arc. Azure Stack HCI clusters can scale from a single-node deployment to a maximum of 16 nodes by using validated, integrated, or premium hardware stock keeping units (SKUs) provided by original equipment manufacturer (OEM) partners.

- [Azure Arc][azure-arc] is a cloud-based service that extends the management model based on Azure Resource Manager to Azure Stack HCI and other non-Azure locations. Azure Arc enables the management of various resources such as VMs, Kubernetes clusters, and containerized data and machine learning services by using Azure as the control and management plane.

- [Azure Key Vault][key-vault] is a cloud service that you can use to securely store and access secrets. A secret is anything that you want to tightly restrict access to, such as API keys, passwords, certificates, cryptographic keys, local admin credentials, and BitLocker recovery keys.

- [Cloud Witness][cloud-witness] is a feature of Azure Storage that serves as a type of failover cluster quorum. Azure Stack HCI cluster nodes use this quorum for quorum voting capabilities. These capabilities enable high availability of the cluster. The storage account and witness configuration are created during the Azure Stack HCI cloud deployment process.

- [Azure Update Management][azure-update-management] is a unified service designed to manage and govern updates for Azure Stack HCI. It allows you to manage workloads deployed on HCI, including Windows and Linux VMs’ Guest OS update compliance. This unified approach streamlines patch management across Azure, on-premises environments, and other cloud platforms through a single dashboard.

### Platform supporting resources

The architecture can incorporate the following optional supporting services that you can use to enhance the platform capabilities:

- [Monitor][azure-monitor] is a cloud-based service for collecting, analyzing, and acting on diagnostic logs and telemetry from your cloud and on-premises workloads. You can use Monitor to maximize the availability and performance of your applications and services through a comprehensive monitoring solution. Deploy Azure Stack HCI Insights to simplify the creation of the Monitor data collection rule (DCR) and quickly enable monitoring of Azure Stack HCI clusters.

- [Azure Policy][azure-policy] is a service that evaluates Azure and on-premises resources through integration with Azure Arc by the properties of those resources to business rules called _Policy Definitions to determine compliance or capabilities that can be used to apply VM Guest Configuration using policy settings.

- [Defender for Cloud][ms-defender-for-cloud] is a unified infrastructure security management system that strengthens the security posture of your datacenters and provides advanced threat protection across your hybrid workloads in the cloud - whether they're in Azure or not - and on premises.

- [Azure Backup][azure-backup] is a solution that provides simple, secure, and cost-effective solutions to back up your data, including VMs, and recover it from the Microsoft Azure cloud. Backup Server (MABS) is used to take backup of VMs deployed on Azure Stack HCI to Backup service.

- [Site Recovery][azure-site-recovery] is a service that provides business continuity and disaster recovery (BC/DR) capabilities by enabling business apps and workloads to fail over if there's a disaster or outage. Site Recovery manages replication and failover of workloads that run on both physical and VMs, between their primary site (_on-premises_) and a secondary location (_Azure_).

## Cluster design choices

When you design an Azure Stack HCI cluster, it's important to understand the workload performance and resiliency requirements. These requirements include recovery time objective (RTO) and recovery point objective (RPO) times and compute (CPU), and memory and storage requirements for all workloads that are deployed on the Azure Stack HCI cluster. Several characteristics of the workload affects the decision-making process, including:

- Processor CPU architecture capabilities, such as the Ghz frequency (_speed_), and number of cores per socket.

- Graphics processing unit GPU requirements of the workload, such as for AI/ML, inferencing, or graphics rendering.

- Memory per node, or the quantity of physical memory required to run the workload.

- Number of physical nodes in the cluster, one to 16 nodes in scale. Note that three nodes are the maximum if using the [Storage Switchless network architecture](/azure/architecture/hybrid/azure-stack-hci-switchless).

  - Resiliency for compute: Requires a minimum reservation of N+1 nodes worth of capacity in the cluster to ensure that it's always possible to drain a node to perform updates or for the workload to restart if an unplanned outage, such as power or hardware failure, of a single node occurs.
  
  - For business-critical or mission-critical workloads, consider reserving N+2 nodes worth of capacity to provide increased resiliency. For example, if two nodes in the cluster are offline, the workload can remain online. This approach provides resiliency for scenarios in which a node running a workload goes offline during a planned update procedure (_resulting in two nodes being offline simultaneously_).
  
- Storage resiliency, capacity, and performance requirements.

  - Resiliency: We recommend that you deploy three or more nodes to enable use of the three-way mirroring capability (_3 x copies of data_) for the infrastructure and user volumes. Doing so increases performance in addition to maximum reliability for storage.
  
  - Capacity: Total required usable storage after fault tolerance (_copies_) is taken into consideration. This number is approximately 33% of the raw storage space of your capacity tier disks when using three-way mirroring.
  
  - Performance: Input/output operations per second (IOPS) of the platform that determines the storage throughput capabilities for the workload when multiplied by the applications' block size.

To design and plan an Azure Stack HCI deployment, we recommend that you use the [Azure Stack HCI - Sizer Tool][azs-hci-sizer-tool] and create a _New Project_ for sizing your HCI clusters. To use the Sizer requires that you understand your workload requirements. In terms of the number and size of workload VMs that run on the cluster, this includes number of vCPUs and amount of memory and storage that's required for the VMs.

The Sizer Tool *Preferences* section guides you through questions that relate to the System type (_Premier, Integrated System, or Validated Node_) and CPU family options. It also helps you select your resiliency requirements for the cluster, such as:

- Reserve a minimum of N+1 nodes worth of capacity (_one node_) across the cluster.

- Reserve N+2 nodes worth of capacity across the cluster for extra resiliency. This option enables the system to withstand a node failure during an update or other unexpected event that affects two nodes simultaneously. It also ensures that there’s enough capacity in the cluster for the workload to run on the remaining online nodes.

This scenario requires use of three-way mirroring for user volumes, which is the default for clusters with three or more physical nodes.

The output from the Azure Stack HCI Sizer Tool is a list of recommended hardware solution SKUs that are able to provide the required workload capacity and platform resiliency requirements, based on the input values in the Sizer Project. If you wish to browse the full list of all OEM hardware partner solutions available, see the [Azure Stack HCI Solutions Catalog](https://aka.ms/hci-catalog#catalog), and also speak to your preferred hardware solution provider or system integration (SI) partner to help size their solution SKUs to meet your requirements.

### Physical disk drives

[Storage Spaces Direct][s2d-disks] supports multiple physical disk drive types that vary in performance and capacity. When you design an Azure Stack HCI cluster, work with your chosen hardware OEM partner to determine the most appropriate physical disk drive types to meet the capacity and performance requirements of your workload. Examples include spinning Hard Disk Drives (HDDs), or Solid-State Drives (SSDs) and NVMe drives, which are both often called _flash drives_, or [Persistent Memory (PMem) storage](/azure-stack/hci/concepts/deploy-persistent-memory), which is referred to as _Storage-Class Memory (SCM)_.

The reliability of the platform depends on how well the critical platform dependencies, such as physical disk types, perform. Make sure to choose the right disk types for your requirements. Use all-flash (NVMe or SSD) based solutions for workloads that have high-performance or low-latency requirements. These workloads include but aren't limited to highly transactional database technologies, production AKS clusters, or any mission-critical or business-critical workloads with low-latency or high-throughput storage requirements. Use all-flash deployments to maximize storage performance. All-NVMe or all-SSD configurations (_especially at a small scale_) improve storage efficiency and maximize performance because no drives are used as a cache tier. For more information, see [all-flash-based storage](/azure-stack/hci/concepts/cache#all-flash-deployment-possibilities).

For general purpose workloads, [a hybrid storage (_NVMe or SSDs for cache and HDDs for capacity_) configuration](/azure-stack/hci/concepts/cache#hybrid-deployment-possibilities) might provide more storage space. But the tradeoff is that spinning disks have lower performance if your workload exceeds the [cache working set][s2d-cache-sizing], and HDDs have a lower mean time between failure value compared to NVMe/SSDs.

The selected physical disk drive type has a direct affect on the performance of your cluster storage determined by the differences in the performance characteristics of each drive type and the caching mechanism used. The physical disk drive type is an integral part of any Storage Spaces Direct design and configuration. Depending on the Azure Stack HCI workload requirements and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a mixed drive type configuration that provides a [balance between performance and capacity][s2d-drive-balance-performance-capacity].

**Storage caching optimization:** Storage Spaces Direct provides a [built-in, persistent, real-time, read, and write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. Storage Spaces Direct virtual disks (_volumes_) are used in combination with Cluster Shared Volumes (CSV) In-Memory Read Cache to [improve Hyper-V performance][azs-hci-csv-cache], such as for unbuffered I/O access to workload VHD or VHDX files.

> [!TIP]
> For high performance or latency sensitive workloads, we recommend that you use an [all-flash storage (_all NVMe or all SSD_) configuration](/azure-stack/hci/concepts/choose-drives#option-1--maximizing-performance) and a cluster size of three or more physical nodes. Deploying this design using the _default storage configuration_ settings uses [Three-Way Mirroring](/azure-stack/hci/concepts/fault-tolerance#three-way-mirror) for the infrastructure and user volumes, which provides the highest performance and resiliency. Another advantage of using an all-NVMe or all-SSD configuration, is that you get the usable storage capacity of every flash drive, as there is no capacity spent from the flash drives for caching (_unlike hybrid or mixed NVMe + SSD drive type configurations_). To learn more about how to balance performance and capacity to meet your workload requirements, see [Plan volumes - When performance matters most][s2d-plan-volumes-performance].

### Network design

Network design refers to the overall arrangement of components within the network, both physical and logical. It's possible to use the same physical network interface card (NIC) ports for any/all combination of the management, compute, and storage network intents. When you use the same NIC ports for all intent purposes, it's referred to as a _fully converged networking configuration_.

Although using a fully converged networking configuration is supported, **the optimal configuration for performance and reliability is for the storage intent to use dedicated network adapter ports**. Therefore, this baseline architecture provides example guidance for deploying a **multinode Azure Stack HCI cluster using the storage switched network architecture**, with two network adapter ports that are Converged for the management and compute intents, and two dedicated network adapter ports for the storage intent. For more information, see [Network considerations for cloud deployments of Azure Stack HCI](/azure-stack/hci/plan/cloud-deployment-network-considerations).

This architecture requires two or more physical nodes (_servers_), up to a maximum of 16 nodes in scale. Each node requires four network adapter ports that are connected to two ToR switches, the two switches should be interconnected by using multi-chassis link aggregation group (MLAG) links. The two network adapter ports that are used for the [storage intent traffic must support remote direct memory access (RDMA)](/azure-stack/hci/concepts/host-network-requirements#rdma), with a minimum link speed of 10 Gbps, although we recommend 25 Gbps (_or higher_). The two network adapter ports used for the management and compute intents are Converged using switch embedded teaming (SET) technology, which provides link redundancy and load-balancing capabilities. These ports require a minimum link speed of 1 Gbps, but we recommend 10 Gbps or higher.

#### Physical network topology

The physical network topology shows the actual physical connections between nodes and networking components. When you design a multinode storage-switched Azure Stack HCI deployment using this baseline architecture, you need the following components:

- Dual ToR switches:

  - Dual (_two_) ToR network switches are required to provide network resiliency, and the ability to service (_apply firmware updates_) the switches without incurring downtime and prevents a single point of failure.
  
  - These two ToR switches are used for the storage (_east / west_) traffic and use two dedicated ethernet ports with specific storage VLANs and priority flow control (PFC) traffic classes that are defined to provide lossless RDMA communication.
  
  - These switches connect to the nodes through ethernet cables.
  
- Two or more nodes (_servers_), up to a maximum of 16 nodes:

  - Each node is a physical server that runs Azure Stack HCI OS.
  
  - Each node requires four network adapter ports in total: two RDMA-capable ports for storage and two network adapter ports for the management and compute traffic.
  
  - Storage uses the two dedicated RDMA capable network adapter ports that connect with one path to each of the two ToR switches. This approach provides link path redundancy and dedicated prioritized bandwidth for SMB-Direct storage traffic.
  
  - Management and compute uses two network adapter ports that provide one path to each of the two ToR switches for link path redundancy.
  
- External connectivity:

  - The dual ToR switches connect to the external network, such as your internal corporate LAN to provide access to the required outbound URLs using your edge border network device (_firewall or router_). These switches route traffic going in and out of the Azure Stack HCI cluster North-South traffic.
  
  - External North-South traffic connectivity is used for the _cluster management_ intent and the _compute_ intents using two switch ports and two network adapter ports per node that are Converged using a switch embedded teaming (SET) and a virtual switch within Hyper-V to provide resiliency. These components work to provide external connectivity for Arc VMs, and other workload resources deployed within the logical networks that are created in Resource Manager using Azure portal, CLI, or IaC templates.
  
[![Diagram that shows the physical networking topology for a multinode Azure Stack HCI cluster that uses a storage switched architecture with dual ToR switches.](images/azure-stack-hci-baseline-physical-network.png)](images/azure-stack-hci-baseline-physical-network.png#lightbox)

#### Logical network topology

The logical network topology provides an overview for how the network data flows between devices, regardless of their physical connections. A summarization of the logical setup for this multinode storage switched baseline architecture for Azure Stack HCI is as follows:

- Dual ToR switches:

  - Prior to deployment of the cluster, the two ToR network switches need to be configured with the required VLAN IDs, MTU settings and DCB configuration for the Management and Compute ports and the Storage ports, review [physical network requirements](/azure-stack/hci/concepts/physical-network-requirements) for more information, or work your switch hardware vendor or SI partner for assistance.
  
- Azure Stack HCI applies network automation and _intent-based network configuration_ using the [NetworkATC service](/azure-stack/hci/deploy/network-atc).

  - NetworkATC is designed to ensure optimal networking configuration and traffic flow using network _Intents_ such as defining which physical network adapter ports are used for the different network traffic intents (_types_), such as for the cluster _management, workload _compute_, and cluster _storage_ intents.
  
  - Intent-based policies simplify the network configuration requirements, by automating the node network configuration based on parameter inputs that are specified as part of the Azure Stack HCI cloud deployment process.
  
- External communication:

  - When the nodes or workload need to communicate externally, such as accessing the corporate LAN, internet, or another service, they route using the dual ToR switches, as outlined in the earlier physical network topology section.
  
  - When the two ToR switches act as Layer 3 devices, they handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  
  - Management network intent uses the Converged SET Team virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - Compute network intent: you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as VMs, use these IDs to provide access to the physical network. The logical networks use the two physical network adapter ports that are Converged using a SET Team for the Compute and Management intents.
  
- Storage traffic:

  - The physical nodes communicate with each other using two dedicated network adapter ports that are connected to the ToR switches to provide high bandwidth and resiliency for storage traffic.
  
  - The _SMB1_ and _SMB2_ storage ports connect to **two separate non-routable (_layer 2_) networks**. Each network has a specific VLAN ID configured that must match the switch ports configuration on the ToR switches' (_default storage VLAN IDs: 711 and 712_).
  
  - There is no default gateway configured on the two storage intent network adapter ports within the Azure Stack HCI node OS.
  
  - Each node can access storage spaces direct (S2D) capabilities of the cluster, such as remote physical disks used in the storage pool, virtual disks, and volumes using the SMB-Direct (_RDMA_) protocol over the **two dedicated storage network adapter ports** available in each node, SMB Multichannel is used for resiliency.
  
  - This configuration provides sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

[![Diagram that shows the logical networking topology for a multinode Azure Stack HCI cluster using the storage switched architecture with dual ToR switches.](images/azure-stack-hci-baseline-logical-network.png)](images/azure-stack-hci-baseline-logical-network.png#lightbox)

#### Network switch requirements

Your Ethernet switches must meet the different specifications set by the Institute of Electrical and Electronics Engineers Standards Association (IEEE SA) that Azure Stack HCI requires. For example, for multinode storage switched deployments, the storage network is used for [remote direct memory access (RDMA) using RoCE v2 or iWARP](/azure-stack/hci/concepts/host-network-requirements#rdma), which requires IEEE 802.1Qbb priority flow control (PFC) to ensure **lossless communication** for the [storage traffic class](/azure-stack/hci/concepts/host-network-requirements#rdma-traffic-class). Your ToR switches must provide support for IEEE 802.1Q for virtual local area networks (VLANs) and IEEE 802.1AB for link layer discovery protocol (LLDP).

If you plan to use existing network switches for an Azure Stack HCI deployment, review the [list of mandatory IEEE standards and specifications the network switches and configuration must provide](/azure-stack/hci/concepts/physical-network-requirements#network-switch-requirements), to gain an understanding of the IEEE standards required for Azure Stack HCI. When purchasing new network switches, contact your switch vendor to ensure the devices meet the Azure Stack HCI IEEE specification requirements (_linked previously_), or review the [list of hardware vendor certified switch models that support Azure Stack HCI network requirements](/azure-stack/hci/concepts/physical-network-requirements#network-switches-for-azure-stack-hci).

#### IP address requirements

For a multinode storage switched deployment, the number of IP addresses required increases as the number of physical nodes increases, up to the maximum of 16 nodes in a single cluster. To provide an example, to deploy a two-node storage switched configuration of Azure Stack HCI, the cluster infrastructure / platform would require a minimum of 11 x IP addresses to be allocated. More IP addresses are required if using micro-segmentation or software defined networking (SDN). For more information, see [the two-node storage reference pattern IP address requirements for Azure Stack HCI](/azure-stack/hci/plan/two-node-ip-requirements).

When you design and plan IP address requirements for Azure Stack HCI, consider that more IP addresses or network ranges are required for your workload, in addition to the IP addresses required for the Azure Stack HCI cluster and infrastructure components. For example, review [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements) if you plan to deploy AKS on Azure Stack HCI.

### Monitoring

To enhance monitoring and alerting, enable [Monitor Insights on Azure Stack HCI](/azure-stack/hci/concepts/monitoring-overview). Insights can scale to monitor and manage multiple on-premises clusters by using an Azure consistent experience. Insights uses cluster performance counters and Event Log channels to monitor key Azure Stack HCI features. These logs are collected by the data collection rule (DCR) that’s configured through Monitor and Log Analytics.

Because Azure Stack HCI Insights is built using Monitor and Log Analytics, it's an always up-to-date, scalable solution that's highly customizable. Insights provides access to default workbooks with basic metrics, along with specialized workbooks created for monitoring key features of Azure Stack HCI. These components provide a near real-time monitoring solution, with the ability to create graphs, customize visualization using aggregation and filtering functionality and configuring custom resource health alert rules.

### Update management

Azure Stack HCI clusters and the deployed workload resources, such as Arc VMs, need to be updated and patched regularly. By regularly applying updates, you ensure that your organization maintains a strong security posture, and you improve the overall reliability and supportability of your estate. We recommend automatic and periodic manual assessments for early discovery and application of security patches and OS updates.

#### Infrastructure updates

Azure Stack HCI is continually updated to enhance customer experience and provide more features and functionality. This process is delivered using Release Trains, which provide new Baseline Builds on a quarterly basis. These builds are applied to Azure Stack HCI clusters to keep them up to date. In addition to regular Baseline Build updates, Azure Stack HCI is updated with monthly OS security and reliability updates.

Azure Update Manager is an Azure service that you can use to apply, view, and manage updates for Azure Stack HCI. This service provides a mechanism to view all Azure Stack HCI clusters across your entire infrastructure and edge locations by using Azure portal to provide a centralized management experience. For more information, see the following resources:

- [About Azure Stack HCI Release Information](/azure-stack/hci/release-information-23h2#about-azure-stack-hci-version-23h2-releases)

- [Azure Stack HCI Lifecycle cadence](/azure-stack/hci/update/about-updates-23h2#lifecycle-cadence)

- [Review update phases of Azure Stack HCI](/azure-stack/hci/update/update-phases-23h2)

- [Use Azure Update Manager to update Azure Stack HCI](/azure-stack/hci/update/azure-update-manager-23h2)

It's important to check for new driver and firmware updates regularly, such as every three to six months. If you use a Premier solution category SKU for your Azure Stack HCI hardware, the [Solution Builder Extension (SBE) package updates](/azure-stack/hci/update/solution-builder-extension) are integrated with Azure Update Manager to provide a simplified update experience. If you use validated nodes or an integrated system category, there could be a requirement to download and execute an OEM specific update package that contains the firmware and driver updates for your hardware. To determine how updates are supplied for your hardware, contact your hardware OEM or solution integrator (SI) partner.

#### Workload Guest OS patching

You can enroll Arc VMs that are deployed on Azure Stack HCI by using [Azure Update Manager (AUM)][azure-update-management] to provide a unified patch management experience by using the same mechanism used to update the Azure Stack HCI cluster physical nodes. You can use AUM to create [Guest maintenance configurations](/azure/virtual-machines/maintenance-configurations#guest). These configurations control settings such as the Reboot setting _reboot if necessary_, the Schedule (_dates / times and repeat options_), and either Dynamic (_subscription_) or static list of the Arc VMs for the scope. These settings control the configuration for when OS security patches are installed inside your workload VM's Guest OS.

## Well-Architected Framework considerations

The [Well-Architected Framework][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

### Reliability

Reliability ensures your application can meet the commitments you make to your business or customers. For more information, see the [Reliability pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#reliability).

#### Identify the potential failure points

Every architecture is susceptible to failures. The exercise of failure mode analysis lets you anticipate failures and be prepared with mitigations. The following table describes four examples of potential failure points in this architecture:

| Component | Risk | Likelihood | Effect/Mitigation/Note | Outage |
|-----------|------|------------|------------------------|--------|
| Azure Stack HCI cluster outage | Power, network, hardware, or software failure | Medium | For business or mission-critical use cases, to prevent a prolonged application outage caused by the failure of an Azure Stack HCI cluster, your workload should be architected using high-availability and disaster recovery principles. For example, you can use industry standard workload data replication technologies to maintain multiple copies of persistent state data that are deployed using multiple Arc VMs or AKS instances that are deployed on separate Azure Stack HCI clusters, and in separate physical locations. | Potential outage |
| Azure Stack HCI single physical node outage | Power, hardware, or software failure | Medium | To prevent a prolonged application outage caused by the failure of a single Azure Stack HCI node, your Azure Stack HCI cluster should have multiple physical nodes. Your workload capacity requirements during the cluster design phase determine the number of nodes. We recommend that you have three or more nodes. We also recommended that you use three-way mirroring, which is the default storage resiliency mode for clusters with three or more nodes. To prevent a single point of failure and increase workload resiliency, deploy multiple instances of your workload by using two or more Arc VMs or container pods that run in multiple AKS worker nodes. If a single node fails, the Arc VMs and workload / application services are restarted on the remaining online physical nodes in the cluster. | Potential outage |
| Arc VM or AKS worker node (_workload_) | Misconfiguration | Medium | Application users are unable to sign in or access the application. Misconfigurations should be caught during deployment. If these errors happen during a configuration update, DevOps team must roll back changes. It's possible to redeploy the VM if necessary, which should take less than 10 minutes to deploy, however it can take longer depending on the type of deployment. | Potential outage |
| Connectivity to Azure | Network outage | Medium | The cluster needs to reach the Azure control plane regularly for billing, management, and monitoring capabilities. If your cluster loses connectivity to Azure, it operates in a degraded state. For example, it wouldn't be possible to deploy new Arc VMs or AKS clusters. Any existing workloads that are already running on the HCI cluster continues to run, but you should restore the connection within 48 to 72 hours to ensure uninterrupted operation.| None |

> Refer to Well-Architected Framework: [RE:03 - Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis).

#### Reliability targets

Example scenario: a **fictitious customer "Contoso Manufacturing"** uses this reference architecture to deploy Azure Stack HCI to help address their requirements to deploy and manage workloads on-premises. Contoso Manufacturing has an internal **service-level objective (SLO) target of 99.8%** agreed with business and application stakeholders for their services.

- An SLO of 99.8% uptime/availability results in the following periods of allowed downtime/unavailability for the applications that are deployed using Arc VMs running on Azure Stack HCI:

  Weekly: 20 minutes and 10 seconds

  Monthly: 1 hour, 26 minutes, and 56 seconds

  Quarterly: 4 hours, 20 minutes, and 49 seconds

  Yearly: 17 hours, 23 minutes, and 16 seconds

- **To help achieve the SLO targets**, Contoso Manufacturing has implemented the _principle of least privilege_ to restrict the number of Azure Stack HCI cluster administrators to a small group of trusted and qualified individuals. This helps prevent downtime due to any inadvertent or accidental actions being performed on production resources. Furthermore, the on-premises Active Directory Domain Services (AD DS) domain controllers security event logs are monitored to detect and report any user account group membership changes (_add / remove actions_) for the *Azure Stack HCI cluster administrators* group using a security information event management (SIEM) solution. In addition to increasing Reliability, this monitoring also improves the Security of the solution.

  > For more information, see [Security SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).

- **Strict change control procedures** are in place Contoso Manufacturing's production systems. This process requires that all changes are tested and validated in a representative test environment before implementation in production. All changes submitted to the weekly change advisory board (CAB) process must include a detailed implementation plan (_or link to source code_), risk level score, a comprehensive rollback plan, along with post change testing / validation and clear success criteria for a change to be reviewed or approved.

  > For more information, see [Operational Excellence OE:11 - Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Monthly security patches and quarterly baseline updates** are applied to production Azure Stack HCI clusters only after the preproduction environment validates them. Azure Update Management and Cluster Aware Updating (CAU) automate the process of using [VM Live Migration](/windows-server/virtualization/hyper-v/manage/live-migration-overview) to minimize downtime for business-critical workloads during the monthly servicing operations. Contoso Manufacturing standard operating procedures require that security, reliability, or baseline build updates are applied to all production systems within four weeks of their release date. Without this policy, production systems would “always be behind” or perpetually be unable to stay current with monthly OS and security updates, which would affect reliability and security of the platform.

  > For more information, see [Security SE:01 - Recommendations for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Contoso Manufacturing implements daily, weekly, and monthly backups** to retain the last 6 x days of daily backups (_Monday to Saturdays_), the last 3 x weekly (_each Sunday_) and 3 x monthly backups, with each _Sunday week 4_ being retained to become the Month 1, Month 2, and Month 3 backups using a _rolling calendar based schedule_ that's documented and auditable. This approach meets Contoso Manufacturing requirements for an adequate balance between the number of data recovery points available and reducing costs for the offsite / cloud backup storage service.

  > For more information, see [Reliability RE:09 - Recommendations for designing a disaster recovery strategy](/azure/well-architected/reliability/disaster-recovery).

- **Data backup and recovery processes are tested** for each business system every six months. This strategy provides assurance that business continuity and disaster recovery (BCDR) processes are valid and that the business is protected if a datacenter disaster or cyber incident occurs.

  > For more information, see [Reliability RE:08 - Recommendations for designing a reliability testing strategy](/azure/well-architected/reliability/testing-strategy).

- The operational processes and procedures outlined previously, together with the recommendations in the [Well-Architected Framework (WAF) Service Guide for Azure Stack HCI](/azure/well-architected/service-guides/azure-stack-hci) enable Contoso Manufacturing to achieve their 99.8% SLO target and effectively scale and manage Azure Stack HCI and workload deployments across multiple manufacturing sites that are distributed around the world.

  > For more information, see [Reliability RE:04 - Recommendations for defining reliability targets.](/azure/well-architected/reliability/metrics).

#### Redundancy

Consider a workload that you deploy on a single Azure Stack HCI cluster as a _locally redundant deployment_. The cluster provides high availability at the platform level, but remember to deploy a cluster in a single rack. For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Stack HCI clusters, ideally in separate physical locations.

- Use industry-standard, high-availability patterns for workloads, such as a design that provides active/passive synchronous or asynchronous data replication ([_such as SQL Server Always On_](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server)). Another example is an external network load balancing (NLB) technology that can route user requests across the multiple workload instances that run on Azure Stack HCI clusters that you deploy in separate physical locations. Consider using a partner external NLB device. Or evaluate the [load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview) that support traffic routing for hybrid and on-premises services, such as an Azure Application Gateway instance that uses Azure ExpressRoute or a VPN tunnel to connect to an on-premises service.

  > For more information, see [RE:05 - Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see the [Security pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#security).

Security considerations include:

- [Azure Stack HCI][azs-hci-basic-security] is a secure-by-default product that uses validated hardware components that use a TPM, UEFI and Secure Boot to build a secure foundation for the Azure Stack HCI platform and workload security. When deployed with the default security settings, the product has Windows Defender Application Control (WDAC), Credential Guard, and BitLocker enabled. Use [Azure Stack HCI built-in role-based access control (RBAC) roles][azs-hci-rbac] such as 'Azure Stack HCI Administrator' for platform administrators, and 'Azure Stack HCI VM Contributor' or 'Azure Stack HCI VM Reader' for workload operators to simplify delegating permissions by using the PoLP.

- [Azure Stack HCI security default][azs-hci-security-default] applies default security settings for your Azure Stack HCI cluster during deployment, and [enables drift control](/azure-stack/hci/manage/manage-secure-baseline) to keep the nodes in a known good state. You can use the security default settings to manage cluster security, drift control, and Secured core server settings on your cluster.

- [Azure Stack HCI Syslog Forwarding][azs-hci-security-syslog] integrates with security monitoring solutions by retrieving relevant security event logs to aggregate and store events for retention in your own SIEM platform.

- [Defender for Cloud][azs-hci-defender-for-cloud] protects your Azure Stack HCI clusters from various threats and vulnerabilities. This strategy helps improve the security posture of your Azure Stack HCI environment and can protect against existing and evolving threats.

- [Microsoft Advanced Threat Analytics (ATA)][ms-ata] detects and remediates threats, such as those targeting Active Directory Domain Services (AD DS), that provide authentication services to Azure Stack HCI cluster nodes and their Windows Server VM workloads.

- Isolate networks if needed. For example, you can provision multiple logical networks that use separate virtual local area networks (vLANs) and network address ranges. When you use this approach, ensure that the management network can reach each logical network and vLAN so that Azure Stack HCI cluster nodes can communicate with the vLAN networks through the ToR switches or gateways. This configuration is required for management of the workload, such as allowing infrastructure management agents to communicate with the workload guest OS.

  > For more information, see [Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, the [Cost optimization pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#cost-optimization).

Cost optimization considerations include:

- Cloud-style billing model for licensing. Azure Stack HCI pricing follows the [monthly subscription billing model][azs-hci-billing], with a flat rate per physical processor core in an Azure Stack HCI cluster (extra usage charges apply if you use other Azure services). If you own on-premises core licenses for Windows Server Datacenter edition, with active Software Assurance (SA) you might choose to exchange these licenses to activate Azure Stack HCI cluster and Windows Server VM subscription fee.

- Automatic VM Guest patching for Arc VMs help to reduce the overhead of manual patching and the associated maintenance costs. Not only does this action help make the system more secure, but it also optimizes resource allocation, contributing to overall cost efficiency.

- Consolidate monitoring costs by using [Azure Stack HCI Insights](/azure-stack/hci/concepts/monitoring-overview#insights) and patching using [Azure Update Management for Azure Stack HCI](/azure-stack/hci/update/about-updates-23h2). Insights provides rich metrics and alerting capabilities using Monitor. The Life-Cycle Manager (LCM) component of Azure Stack HCI integrates with Azure Update Manager to simplify the task of keeping your clusters up to date, by consolidating update workflows for various components into a single experience. Using Monitor and Azure Update Manager optimizes resource allocation, and contributes to overall cost efficiency.

  - > For more information, see [CO:13 - Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

- Depending on your initial workload capacity and resiliency requirements, and planning for future growth, consider if using a _two or three-node storage switchless architecture_ could reduce cost, such as removing the requirement to procure _storage class network switches_. Procuring extra _storage class_, network switches can be an expensive component of new Azure Stack HCI cluster deployments. If your workload capacity and resiliency requirements **not scale beyond three-nodes**, consider if you could use existing switches for the management and compute networks, and deploy Azure Stack HCI using the [three-node storage switchless architecture](azure-stack-hci-switchless.yml).

- > For more information, see [CO:07 - Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

> [!TIP]
> You can get cost savings with Azure Hybrid Benefit if you have Windows Server Datacenter licenses with active Software Assurance. For more information about Azure Hybrid Benefit, see [Azure Hybrid Benefit for Azure Stack HCI][azs-hybrid-benefit].

### Operational excellence

Operational excellence covers the operational processes that are used to deploy the Azure Stack HCI cluster and keep the platform running in production. For more information, see the [Operational excellence pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#operational-excellence).

Operational excellence considerations include:

- Simplified provisioning and management experience integrated with Azure. The [Cloud Based Deployment in Azure][azs-hci-deploy-via-portal] provides a wizard-driven interface that shows you how to create an Azure Stack HCI cluster. Similarly, Azure simplifies the process of [managing Azure Stack HCI clusters][azs-hci-manage-cluster-at-scale] and [Arc VMs](/azure-stack/hci/manage/azure-arc-vm-management-overview). You can automate the portal-based deployment of the Azure Stack HCI cluster by [using the ARM template][azs-hci-deploy-via-template]. This template provides consistency and automation to deploy Azure Stack HCI at scale, specifically in edge scenarios such as retail stores or manufacturing sites that require an Azure Stack HCI cluster to run business-critical workloads.

- Automation capabilities for Virtual Machines. Azure Stack HCI provides a wide range of automation capabilities for managing workloads, such as Virtual Machines, with the [automated deployment of Arc VMs by using Azure CLI, ARM, or Bicep template][azs-hci-automate-arc-vms], with Virtual Machine OS updates using Azure Arc Extension for Updates and [Azure Update Manager][azure-update-management] to update each Azure Stack HCI cluster. Azure Stack HCI also provides support for [Azure Arc VM management][azs-hci-vm-automate-cli] by using Azure CLI and [Non-Azure Arc VMs][azs-hci-manage-non-arc-vms] by using Windows PowerShell. You can run Azure CLI commands locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of extra automation scenarios for [VM workloads][arc-vm-extensions] through Azure Arc extensions.

> For more information, see [OE:05 - Recommendations for using IaC](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- Automation capabilities for Containers on AKS. Azure Stack HCI provides a wide range of automation capabilities for managing workloads such as containers on AKS, with the [automated deployment of AKS clusters using Azure CLI][azs-hci-automate-arc-aks], with AKS workload cluster updates using Azure Arc Extension for [Kubernetes Updates][azs-hci-automate-aks-update]. Azure Stack HCI also provides support for [Azure Arc AKS management][azs-hci-aks-automate-cli] by using Azure CLI. You can run Azure CLI commands locally from one of the Azure Stack HCI servers or remotely from a management computer. Integration with Azure Arc facilitates a wide range of extra automation scenarios for [containerized][azs-hci-k8s-gitops] workloads through Azure Arc extensions.

> For more information, see [OE:10 - Recommendations for enabling automation](/azure/well-architected/operational-excellence/enable-automation).

### Performance efficiency

Performance efficiency defines the controls put in place to enable the workload to meet the demands placed on it by users in an efficient manner. For more information, see the [Performance efficiency pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#performance-efficiency).

Performance efficiency considerations include:

- Consider using [DiskSpd to test workload storage performance](/azure-stack/hci/manage/diskspd-overview) capabilities of the Azure Stack HCI cluster. You can also use VMFleet to generate load and measure the performance of a storage subsystem. Evaluate whether you should use [VMFleet for measuring storage subsystem performance](https://github.com/microsoft/diskspd/wiki/VMFleet).

  - **Recommendation**: Establish a baseline for your Azure Stack HCI clusters performance before you deploy production workloads. DiskSpd enables administrators to test the storage performance of the cluster by using various command line parameters. The main function of DiskSpd is to issue read and write operations and output performance metrics, such as latency, throughput, and IOPs.

> For more information, see [PE:06 - Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test).

- [Storage resiliency][s2d-resiliency] versus usage (_capacity_) efficiency, versus performance. Planning for Azure Stack HCI volumes includes identifying the optimal balance between resiliency, usage efficiency, and performance. This challenge results from the fact that maximizing one of these characteristics typically has a negative effect on at least one of the other two. Increasing resiliency reduces the usable capacity, while the resulting performance might vary depending on the resiliency type selected. When resiliency and performance matters most, and when using three or more nodes, the _default storage configuration_ uses three-way mirroring for the infrastructure and user volumes.

> For more information, see [PE:02 - Recommendations for capacity planning](/azure/well-architected/performance-efficiency/capacity-planning).

- Network performance optimization. As part of your design, be sure to include projected [network traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] when determining your [optimal network hardware configuration][azs-hci-networking].

- Compute performance optimization in Azure Stack HCI can be achieved by using graphics processing unit (GPU) acceleration, such as requirements for data insights or inferencing for [high-performance AI/ML workloads][azs-hci-gpu-acceleration] that require deployment at edge locations due to data gravity or security requirements. In a hybrid / on-premises deployment, it's important to take your workload performance requirements (_including GPUs_) into consideration to enable you to select (_procure_) the right services when you design and procuring your Azure Stack HCI clusters.

> For more information, see [PE:03 - Recommendations for selecting the right services](/azure/well-architected/performance-efficiency/select-services).

## Deploy this scenario

The following section provides an _example list of the high-level tasks or typical workflow_ used to deploy Azure Stack HCI, including prerequisites tasks and considerations. This workflow list is intended as an **example guide only**. It isn't an exhaustive list of all required actions because actions can vary based on organizational, geographic, or project-specific requirements.

**Scenario: there is a project or use case requirement to deploy a hybrid cloud solution in an on-premises or edge location** to provide local compute for data processing capabilities, and a desire to use Azure consistent management and billing experiences. More details are outlined in the [Potential use cases](#potential-use-cases) section of this article. The remaining steps assume that Azure Stack HCI is the chosen infrastructure platform solution for the project.

1. **Workload and use case requirements should be gathered from relevant stakeholders**, to enable the project to confirm that the features and capabilities of Azure Stack HCI meet the workload scale, performance, and functionality requirements. This review process should include understanding the workload scale (_size_) and required features such as Arc VMs, AKS, Azure Virtual Desktop (AVD), or Azure Arc-enabled Data Services or Azure Arc-enabled Machine Learning (ML) service. The workload RTO and RPO (_reliability_) values and other nonfunctional requirements (_performance / load scalability_) should be documented as part of this requirements gathering step.

1. **Review the Azure Stack HCI Sizer output for the recommended hardware partner solution**. This output includes details of the recommended physical server hardware (_make and model_), number of physical nodes, and the specifications for the CPU, memory, and storage configuration of each physical node that are required to deploy and run your workloads.

1. **Use the [Azure Stack HCI Sizer Tool][azs-hci-sizer-tool] to create a new Project that models the workload type and scale**. This project includes the size and number of VMs and their storage requirements. These details are inputted together with choices for the System type, preferred CPU family, and your Resiliency requirements for high availability and Storage fault tolerance, as explained in the previous [Cluster design choices](#cluster-design-choices) section.

1. **Review the Azure Stack HCI Sizer output for the recommended hardware partner solution**. This solution includes details of the recommended physical server hardware (_make and model_), number of physical nodes and the specifications for the CPU, memory, and storage configuration of each physical node, that are required to deploy and run your workloads.

1. **Contact the hardware OEM or system integrator (SI) partner to further qualify the suitability** of the recommended hardware SKU vs your workload requirements. Use OEM specific sizing tools (_if available_) to determine OEM specific hardware sizing requirements for the intended workloads. This step typically includes discussions with the hardware OEM or SI partner for the commercial aspects of the solution such as quotations, availability of the hardware, lead times, and any professional or value-add services that the partner provides to help accelerate your project or business outcomes.

1. **Network integration**: For high availability solutions, HCI clusters require two ToR switches to be deployed. Each physical node requires four NICs, (_two must be RDMA capable_) which provide two links from each node to the two ToR switches. Two NICs, one connected to each switch, are converged for outbound North-South connectivity for the compute and management networks. The other two RDMA capable NICs are dedicated for the storage (_east / west_) traffic. If you plan to use existing network switches, ensure the make and model of your switches are on the [approved list of network switches supported by Azure Stack HCI](/azure-stack/hci/concepts/physical-network-requirements#network-switches-for-azure-stack-hci).

1. **Work with the hardware OEM or SI partner to arrange delivery of the hardware**. The partner or your employees are then required to integrate the hardware into your on-premises datacenter or edge location, such as racking and stacking the hardware, physical network, and power supply unit (PSU) cabling for the physical nodes.

1. **Perform the Azure Stack HCI cluster deployment.** Depending on your chosen solution SKU (_Premier solution, Integrated system or Validated nodes_) either the hardware/SI partner, or your employees are now able to [deploy the Azure Stack HCI software](/azure-stack/hci/deploy/deployment-introduction). This step starts by onboarding the physical nodes HCI operating system into Azure Arc-enabled servers, then starting the Azure Stack HCI cloud deployment process. Customers and partners can raise a support request (SR) directly with Microsoft in [Azure portal](https://portal.azure.com/), by selecting the *Support + Troubleshooting* icon, or by contacting their hardware OEM or SI partner depending on the nature of the request and the hardware solution category.

   > [!TIP]
   > ![GitHub logo](../_images/github.svg) **Deployment automation**: This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to deploy a **Switched Multi Server Deployment** of Azure Stack HCI using an ARM template and parameter file. Alternatively, this example demonstrates [how to use a Bicep template](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) to deploy an Azure Stack HCI cluster, including it's prerequisites resources.

1. **Deploy highly-available workloads on Azure Stack HCI** using Azure portal, CLI, or ARM + Arc templates for automation. Use the _custom location_ resource of the new HCI cluster as the target region when [deploying workload resources such as Arc VMs, AKS, Azure Virtual Desktop (AVD) session hosts, or other Azure Arc-enabled services](#azure-stack-hci-directly-integrates-with-azure-by-using-azure-arc-to-lower-tco-and-operational-overheads) that you can enable through AKS extensions and containerization on Azure Stack HCI.

1. **Install monthly updates to improve the security and reliability of the platform**. To keep your Azure Stack HCI clusters up to date, it's important to install Microsoft software updates and hardware OEM driver and firmware updates. These updates improve the security and reliability of the platform. [Azure Update Manager](/azure-stack/hci/update/azure-update-manager-23h2) applies the updates and provides a centralized and scalable solution to install updates across a single cluster or multiple clusters. Check with your hardware OEM partner to determine the process for installing hardware driver and firmware updates, as this process can vary depending on your chosen hardware solution category type (_Premier solution, Integrated system or Validated nodes_). For more information, see [Infrastructure updates](#infrastructure-updates).

## Related resources

See product documentation for details on specific Azure services:

- [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

More information:

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](/azure/architecture/guide/technology-choices/hybrid-considerations)
- [Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)

## Next steps

Product documentation:

- [Azure Stack HCI, version 23H2 release information](/azure-stack/hci/release-information-23h2)
- [AKS on Azure Stack HCI](/azure/aks/hybrid/aks-whats-new-23h2)
- [Azure Virtual Desktop for Azure Stack HCI](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Stack HCI monitoring?](/azure-stack/hci/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Stack HCI](/azure-stack/hci/manage/azure-site-recovery)
- [Monitor overview](/azure/azure-monitor/overview)
- [Change Tracking and Inventory overview](/azure/automation/change-tracking/overview)
- [Update Management overview](/azure/automation/update-management/overview)
- [What are Azure Arc-enabled Data Services?](/azure/azure-arc/data/overview)
- [What is Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is the Backup service?](/azure/backup/backup-overview)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere)

Microsoft Learn modules:

- [Configure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc-enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Scale model deployment with Azure Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/scale-model-deployment-with-azure-machine-learning-anywhere/ba-p/2888753)
- [Realizing Machine Learning anywhere with AKS and Azure Arc-enabled Machine Learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-arc-blog/realizing-machine-learning-anywhere-with-azure-kubernetes/ba-p/3470783)
- [Machine learning on AKS hybrid and Stack HCI using Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-stack-blog/machine-learning-on-aks-hybrid-amp-stack-hci-using-azure-arc/ba-p/3816127)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere?view=azureml-api-2)
- [Keep your VMs updated](/training/modules/keep-your-virtual-machines-updated)
- [Protect your VM settings with Automation State Configuration](/training/modules/protect-vm-settings-with-dsc)
- [Protect your VMs by using Backup](/training/modules/protect-virtual-machines-with-azure-backup)

[arc-azure-policy]: /azure/azure-arc/servers/security-controls-policy
[arc-enabled-aks]: /azure/aks/hybrid/cluster-architecture
[arc-enabled-data-services]: /azure/azure-arc/data/overview
[arc-enabled-vms]: /azure-stack/hci/manage/azure-arc-vm-management-overview
[arc-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/azure-stack-hci-baseline.vsdx
[az-auto-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker
[azs-hci-aks-automate-cli]: /cli/azure/aksarc
[azs-hci-automate-aks-update]: /azure/aks/hybrid/cluster-upgrade
[azs-hci-automate-arc-aks]: /azure/aks/hybrid/aks-create-clusters-cli?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json
[azs-hci-automate-arc-vms]: /azure-stack/hci/manage/create-arc-virtual-machines?tabs=azurecli
[azs-hci-avd]: /azure/virtual-desktop/deploy-azure-virtual-desktop?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&tabs=portal
[azs-hci-basic-security]: /azure-stack/hci/concepts/security-features
[azs-hci-billing]: /azure-stack/hci/concepts/billing
[azs-hci-csv-cache]: /azure-stack/hci/manage/use-csv-cache#planning-considerations
[azs-hci-defender-for-cloud]: /azure-stack/hci/manage/manage-security-with-defender-for-cloud
[azs-hci-deploy-via-portal]: /azure-stack/hci/deploy/deploy-via-portal
[azs-hci-deploy-via-template]: /azure-stack/hci/deploy/deployment-azure-resource-manager-template
[azs-hci-gpu-acceleration]: /windows-server/virtualization/hyper-v/deploy/use-gpu-with-clustered-vm?pivots=azure-stack-hci
[azs-hci-k8s-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[azs-hci-manage-cluster-at-scale]: /azure-stack/hci/manage/manage-at-scale-dashboard
[azs-hci-manage-non-arc-vms]: /azure-stack/hci/manage/vm-powershell
[azs-hci-network-bandwidth-allocation]: /azure-stack/hci/concepts/plan-host-networking#traffic-bandwidth-allocation
[azs-hci-networking]: /azure-stack/hci/concepts/plan-host-networking
[azs-hci-rbac]: /azure-stack/hci/manage/assign-vm-rbac-roles
[azs-hci-security-default]: /azure-stack/hci/manage/manage-secure-baseline
[azs-hci-security-syslog]: /azure-stack/hci/manage/manage-syslog-forwarding
[azs-hci-sizer-tool]: https://aka.ms/hci-catalog#sizer
[azs-hci-vbs]: /windows-hardware/design/device-experiences/oem-vbs
[azs-hci-vm-automate-cli]: /cli/azure/stack-hci-vm
[azs-hci]: /azure-stack/hci/overview
[azs-hybrid-benefit]: /azure-stack/hci/concepts/azure-hybrid-benefit-hci
[azure-arc]: /azure/azure-arc/overview
[azure-backup]: /azure/backup/backup-overview
[azure-monitor]: /azure/azure-monitor/overview
[azure-policy]: /azure/governance/policy/overview
[azure-site-recovery]: /azure/site-recovery/site-recovery-overview
[azure-update-management]: /azure/update-manager/
[azure-well-architected-framerwork]: /azure/architecture/framework
[cloud-witness]: /windows-server/failover-clustering/deploy-cloud-witness
[key-vault]: /azure/key-vault/general/basic-concepts
[ms-ata]: /advanced-threat-analytics/what-is-ata
[ms-defender-for-cloud]: /azure/security-center/security-center-introduction
[s2d-cache-sizing]: /azure-stack/hci/concepts/cache#sizing-the-cache
[s2d-cache]: /azure-stack/hci/concepts/cache#server-side-architecture
[s2d-disks]: /windows-server/storage/storage-spaces/choosing-drives
[s2d-drive-balance-performance-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-2--balancing-performance-and-capacity
[s2d-drive-max-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-3--maximizing-capacity
[s2d-drive-max-performance]: /windows-server/storage/storage-spaces/choosing-drives#option-1--maximizing-performance
[s2d-plan-volumes-performance]: /azure-stack/hci/concepts/plan-volumes#when-performance-matters-most
[s2d-resiliency]: /windows-server/storage/storage-spaces/storage-spaces-fault-tolerance
