This baseline reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Local 2311 and later infrastructure, to provide a reliable platform for highly available virtualized and containerized workloads. This architecture describes the resource components and cluster design choices for the physical machines that provide local compute, storage, and networking capabilities. It also describes how to use Azure services to simplify and streamline the day-to-day management of Azure Local for at-scale operations.

For more information about workload architecture patterns that are optimized to run on Azure Local, see the content located in the **Azure Local workloads** navigation menu.

This architecture is a starting point for how to use the storage switched network design to deploy a multi-node Azure Local instance. The workload applications deployed on an Azure Local instance should be well architected. Well-architected workload applications must be deployed using multiple instances or high availability of any critical workload services and have appropriate business continuity and disaster recovery (BCDR) controls in place. These BCDR controls include regular backups and disaster recovery failover capabilities. To focus on the HCI infrastructure platform, these workload design aspects are intentionally excluded from this article.

For more information about guidelines and recommendations for the five pillars of the Azure Well-Architected Framework, see the [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-local).

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Scenario details](#scenario-details) <br>&#9642; [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; [Physical disk drives](#physical-disk-drives) <br> &#9642; [Network design](#network-design) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost optimization](#cost-optimization) <br> &#9642; [Operational excellence](#operational-excellence) <br> &#9642; [Performance efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [Azure local template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to use an Azure Resource Management template (ARM template) and parameter file to deploy a switched multi-server deployment of Azure Local. Alternatively, the [Bicep example](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) demonstrates how to use a Bicep template to deploy an Azure Local instance and its prerequisites resources.

## Architecture

:::image type="complex" source="images/azure-local-baseline.png" alt-text="Diagram that shows a multi-node Azure Local instance reference architecture with dual Top-of-Rack (ToR) switches for external north-south connectivity." lightbox="images/azure-local-baseline.png" border="false":::
    Diagram that shows a multi-node Azure Local instance reference architecture with dual Top-of-Rack (ToR) switches for external north-south connectivity. The cluster uses many Azure services.
:::image-end:::

For more information, see [Related resources](#related-resources).

## Potential use cases

Typical use cases for Azure Local include the ability to run high availability (HA) workloads in on-premises or edge locations, providing a platform to address requirements such as:

- Provide a cloud connected solution that is deployed on-premises to address data sovereignty, regulation and compliance, or latency requirements.

- Deploy and manage HA-virtualized or container-based workloads that are deployed in a single or multiple edge locations. To enable business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- Ability to lower the total cost of ownership (TCO) by deploying a solution that is Microsoft and hardware OEM partner certified, that uses a modern cloud-based deployment process, and that provides an Azure consistent centralized management and monitoring experience.

- Provide a centralized provisioning capability using Azure and Azure Arc, enabling deployment of workloads across multiple locations consistently and securely. Tools like the Azure portal, Azure CLI, or using infrastructure as code (IaC) templates (_ARM, Bicep and Terraform_) for increased automation and repeatability. Enabling the rapid deploy and management of AKS clusters for containerized, and/or Azure Local VMs for traditional virtualized workloads.

- Adhere to strict security, compliance, and audit requirements. Azure Local is deployed with a hardened security posture configured by default, or _secure-by-default_. Azure Local incorporates certified hardware, Secure Boot, Trusted Platform Module (TPM), virtualization-based security (VBS), Credential Guard, and enforced Application Control policies. With the ability to integrate with modern cloud-based security and threat-management services like Microsoft Defender for Cloud and Microsoft Sentinel, to provide extended detection and response (XDR) and security information event management (SIEM) capabilities.

### Scenario details

The following sections provide more information about the scenarios and potential use cases for this reference architecture. These sections include a list of business benefits and example workload resource types that you can deploy on Azure Local.

#### Use Azure Arc with Azure Local

Azure Local directly integrates with Azure using Azure Arc to lower the TCO and operational overhead. Azure Local is deployed and managed through Azure, which provides built-in integration of Azure Arc through deployment of the [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) component. This resource bridge component is deployed as part of the Azure Local instance cloud deployment process. Azure Local machines are enrolled with [Azure Arc for servers](/azure/azure-local/deploy/deployment-arc-register-server-permissions) as a prerequisite for starting the cloud deployment of your Azure Local instance. During deployment, mandatory extensions are installed on each machine, such as Lifecycle Manager, Microsoft Edge Device Management, and Telemetry and Diagnostics extensions. Post deployment, you can use Azure Monitor and Log Analytics to monitor the solution, by enabling [Insights for Azure Local](/azure/azure-local/concepts/monitoring-overview). [Feature updates for Azure Local](/azure/azure-local/release-information-23h2) are released every six months to enhance customer experience. Updates for Azure Local are controlled and managed using [Azure Update Manager][azure-update-management].

You can deploy workload resources such as [Azure Arc virtual machines (VMs)](/azure/azure-local/manage/create-arc-virtual-machines), [Azure Arc-enabled Azure Kubernetes Service (AKS)][arc-enabled-aks], and [Azure Virtual Desktop session hosts](/azure/virtual-desktop/deploy-azure-virtual-desktop) that use the Azure portal by selecting an [Azure Local instance custom location](/azure/azure-local/manage/azure-arc-vm-management-overview#components-of-azure-arc-vm-management) as the target for the workload deployment. These components provide centralized administration, management, and support. If you have active Software Assurance on your existing Windows Server Datacenter core licenses, you can reduce costs further by applying Azure Hybrid Benefit to Azure Local, Windows Server VMs, and AKS clusters. This optimization helps manage costs effectively for these services.

Azure and Azure Arc integration extend the capabilities of Azure Local virtualized and containerized workloads to include:

- [Azure Local VMs][arc-enabled-vms] for traditional applications or services that run in VMs on Azure Local.

- [AKS on Azure Local][arc-enabled-aks] for containerized applications or services that benefit from using Kubernetes as their orchestration platform.

- [Azure Virtual Desktop][azs-hci] to deploy your session hosts for Azure Virtual Desktop workloads on Azure Local (on-premises). You can use the control and management plane in Azure to initiate the host pool creation and configuration.

- [Azure Arc-enabled data services][arc-enabled-data-services] for containerized Azure SQL Managed Instance or an Azure Database for PostgreSQL server that use Azure Arc-enabled AKS that's hosted on Azure Local.

- The [Azure Arc-enabled Azure Event Grid extension for Kubernetes](/azure/event-grid/kubernetes/install-k8s-extension) to deploy the [Event Grid broker and Event Grid operator](/azure/event-grid/kubernetes/concepts#event-grid-on-kubernetes-components) components. This deployment enables capabilities such as Event Grid topics and subscriptions for event processing.

- [Azure Arc-enabled machine learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere) with an AKS cluster that's deployed on Azure Local as the compute target to run Azure Machine Learning. You can use this approach to train or deploy machine learning models at the edge.

Azure Arc-connected workloads provide enhanced Azure consistency and automation for Azure Local deployments, like automating guest OS configuration with [Azure Local VM extensions][arc-vm-extensions] or evaluating compliance with industry regulations or corporate standards through [Azure Policy][arc-azure-policy]. You can activate Azure Policy through the Azure portal or IaC automation.

#### Take advantage of the Azure Local default security configuration

The Azure Local default security configuration provides a defense-in-depth strategy to simplify security and compliance costs. The deployment and management of IT services for retail, manufacturing, and remote office scenarios presents unique security and compliance challenges. Securing workloads against internal and external threats is crucial in environments that have limited IT support or a lack or dedicated datacenters. Azure Local has default security hardening and deep integration with Azure services to help you address these challenges.

Azure Local-certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and TPM support. Use these technologies in combination with [VBS][azs-hci-vbs] to help protect your security-sensitive workloads. You can use BitLocker Drive Encryption to encrypt boot disk volumes and storage spaces direct volumes at rest. Server Message Block (SMB) encryption provides automatic encryption of traffic between physical machines in the cluster (on the storage network) and signing of SMB traffic between the cluster physical machines and other systems. SMB encryption also helps prevent relay attacks and facilitates compliance with regulatory standards.

You can onboard Azure Local VMs in [Defender for Cloud][ms-defender-for-cloud] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Manage Azure Local VMs in Azure Arc so that you can use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Components

This architecture consists of physical server hardware that you can use to deploy Azure Local instances in on-premises or edge locations. To enhance platform capabilities, Azure Local integrates with Azure Arc and other Azure services that provide supporting resources. Azure Local provides a resilient platform to deploy, manage, and operate user applications or business systems. Platform resources and services are described in the following sections.

### Platform resources

The architecture requires the following mandatory resources and components:

- [Azure Local][azs-hci] is a hyperconverged infrastructure (HCI) solution that's deployed on-premises or in edge locations using physical server hardware and networking infrastructure. Azure Local provides a platform to deploy and manage virtualized workloads such as VMs, Kubernetes clusters, and other services that are enabled by Azure Arc. Azure Local instances can scale from a single-machine deployment to a maximum of sixteen physical machines using validated, integrated, or premium hardware categories that are provided by original equipment manufacturer (OEM) partners.

- [Azure Arc][azure-arc] is a cloud-based service that extends the management model based on Azure Resource Manager to Azure Local and other non-Azure locations. Azure Arc uses Azure as the control and management plane to enable the management of various resources such as VMs, Kubernetes clusters, and containerized data and machine learning services.

- [Azure Key Vault][key-vault] is a cloud service that you can use to securely store and access secrets. A secret is anything that you want to tightly restrict access to, such as API keys, passwords, certificates, cryptographic keys, local admin credentials, and BitLocker recovery keys.

- [Cloud witness][cloud-witness] is a feature that uses Azure Storage to act as a failover cluster quorum. Azure Local (_two machine instances only_) use a cloud witness as the quorum for voting, which ensures high availability for the cluster. The storage account and witness configuration are created during the Azure Local cloud deployment process.

- [Update Manager][azure-update-management] is a unified service designed to manage and govern updates for Azure Local. You can use Update Manager to manage workloads that are deployed on Azure Local, including guest OS update compliance for Windows and Linux VMs that can be enabled using Azure policy. This unified approach streamlines patch management across Azure, on-premises environments, and other cloud platforms through a single dashboard.

### Platform-supporting resources

The architecture includes the following optional supporting services to enhance the capabilities of the platform:

- [Monitor][azure-monitor] is a cloud-based service for collecting, analyzing, and acting on diagnostic logs and telemetry from your cloud and on-premises workloads. You can use Monitor to maximize the availability and performance of your applications and services through a comprehensive monitoring solution. Deploy Insights for Azure Local to simplify the creation of the Monitor data collection rule (DCR) and quickly enable monitoring of Azure Local instances.

- [Azure Policy][azure-policy] is a service that evaluates Azure and on-premises resources. Azure Policy evaluates resources through integration with Azure Arc using the properties of those resources to business rules, called _policy definitions_, to determine compliance or capabilities that you can use to apply VM Guest Configuration using policy settings.

- [Defender for Cloud][ms-defender-for-cloud] is a comprehensive infrastructure security management system. It enhances the security posture of your datacenters and delivers advanced threat protection for hybrid workloads, whether they reside in Azure or elsewhere, and across on-premises environments.

- [Azure Backup][azure-backup] is a cloud-based service that provides a secure and cost-effective solution to back up your data and recover it from the Microsoft Cloud. Azure Backup Server is used to take backup of VMs that are deployed on Azure Local and store them in the Backup service.

- [Site Recovery][azure-site-recovery] is a disaster recovery service that provides BCDR capabilities by enabling business apps and workloads to fail over if there's a disaster or outage. Site Recovery manages replication and failover of workloads that run on physical servers and VMs between their primary site (on-premises) and a secondary location (Azure).

## Cluster design choices

It's important to understand the workload performance and resiliency requirements when you design an Azure Local instance. These requirements include recovery time objective (RTO) and recovery point objective (RPO) times, compute (CPU), memory, and storage requirements for all workloads that are deployed on the Azure Local instance. Several characteristics of the workload affect the decision-making process and include:

- Central processing unit (CPU) architecture capabilities, including hardware security technology features, the number of CPUs, the GHz frequency (speed) and the number of cores per CPU socket.

- Graphics processing unit (GPU) requirements of the workload, such as for AI or machine learning, inferencing, or graphics rendering.

- The memory per machine, or the quantity of physical memory required to run the workload.

- The number of physical machines in the instance that are 1 to 16 machines in scale. The maximum number of physical machines is four when you use the [storage switchless network architecture](/azure/architecture/hybrid/azure-local-switchless).

  - To maintain compute resiliency, you need to reserve at least N+1 physical machines worth of capacity in the instance. This strategy enables node draining for updates or recovery from sudden outages like power outages or hardware failures.

  - For business-critical or mission-critical workloads, consider reserving N+2 physical machines worth of capacity to increase resiliency. For example, if two physical machines in the instance are offline, the workload can remain online. This approach provides resiliency for scenarios in which a machine that's running a workload goes offline during a planned update procedure and results in two instance physical machines being offline simultaneously.
  
- Storage resiliency, capacity, and performance requirements:

  - **Resiliency**: We recommend that you deploy three or more physical machines to enable three-way mirroring, which provides three copies of the data, for the infrastructure and user volumes. Three-way mirroring increases performance and maximum reliability for storage.
  
  - **Capacity**: The total required usable storage after fault tolerance, or _copies_, is taken into consideration. This number is approximately 33% of the raw storage space of your capacity tier disks when you use three-way mirroring.
  
  - **Performance**: Input/output operations per second (IOPS) of the platform that determines the storage throughput capabilities for the workload when multiplied by the block size of the application.

To design and plan an Azure Local deployment, we recommend that you use the [Azure Local sizing tool][azs-hci-sizer-tool] and create a _New Project_ for sizing your Azure Local instances. Using the sizing tool requires that you understand your workload requirements. When considering the number and size of workload VMs that run on your instance, make sure to consider factors such as the number of vCPUs, memory requirements, and necessary storage capacity for the VMs.

The sizing tool **Preferences** section guides you through questions that relate to the system type (Premier, Integrated System, or Validated Node) and CPU family options. It also helps you select your resiliency requirements for the instance. Make sure to:

- Reserve a minimum of N+1 physical machines worth of capacity, (or one node), across the instance. This ensures you can apply Solution Updates, (draining and restarting each node, one by one), without incurring workload downtime.

- Reserve N+2 physical machines worth of capacity across the instance for additional resiliency. This option enables the system to withstand a machine failure during an update or other unexpected event that affects two machines simultaneously. It also ensures that there's enough capacity in the instance for the workload to run on the remaining online machines.

This scenario requires use of three-way mirroring for user volumes, which is the default for instances that have three or more physical machines.

The output from the Azure Local sizing tool is a list of recommended hardware solution SKUs that can provide the required workload capacity and platform resiliency requirements based on the input values in the Sizer Project. For more information about available OEM hardware partner solutions, see [Azure Local Solutions Catalog](https://azurestackhcisolutions.azure.microsoft.com/#catalog). To help rightsize solution SKUs to meet your requirements, contact your preferred hardware solution provider or system integration (SI) partner.

### Physical disk drives

[Storage Spaces Direct][s2d-disks] supports multiple physical disk drive types that vary in performance and capacity. When you design an Azure Local instance, work with your chosen hardware OEM partner to determine the most appropriate physical disk drive types to meet the capacity and performance requirements of your workload. Examples include spinning Hard Disk Drives (HDDs), or Solid State Drives (SSDs) and NVMe drives. These drives are often called _flash drives_, or [Persistent memory (PMem) storage](/azure/azure-local/concepts/deploy-persistent-memory), which is known as _storage-class memory (SCM)_.

The reliability of the platform depends on the performance of critical platform dependencies, such as physical disk types. Make sure to choose the right disk types for your requirements. Use all-flash storage solutions such as NVMe or SSD drives for workloads that have high-performance or low-latency requirements. These workloads include but aren't limited to highly transactional database technologies, production AKS clusters, or any mission-critical or business-critical workloads that have low-latency or high-throughput storage requirements. Use all-flash deployments to maximize storage performance. All-NVMe drive or all-SSD drive configurations, especially at a small scale, improve storage efficiency and maximize performance because no drives are used as a cache tier. For more information, see [All-flash based storage](/azure/azure-local/concepts/cache#all-flash-deployment-possibilities).

:::image type="complex" source="images/azure-local-baseline-storage-architecture.png" alt-text="Diagram that shows a multi-node Azure Local instance storage architecture for a hybrid storage solution, using NVMe drives as the cache tier and SSD drives for capacity." lightbox="images/azure-local-baseline-storage-architecture.png" border="false":::
    Diagram that shows a multi-node Azure Local instance storage architecture for a hybrid storage solution, using NVMe drives as the cache tier and SSD drives for capacity. The diagram shows the physical and logical layers used by Storage Spaces Direct (S2d) to provide highly available and resilient storage, it includes virtual machine (VM) live migration.
:::image-end:::

The performance of your cluster storage is influenced by the physical disk drive type, which varies based on the performance characteristics of each drive type and the caching mechanism that you choose. The physical disk drive type is an integral part of any Storage Spaces Direct design and configuration. Depending on the Azure Local workload requirements and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a mixed-drive type configuration that [balances performance and capacity][s2d-drive-balance-performance-capacity].

For general purpose workloads that require large capacity persistent storage, [a hybrid storage configuration](/azure/azure-local/concepts/cache#hybrid-deployment-possibilities) could provide the most usable storage, such as using NVMe or SSDs drives for the cache tier and HDDs drives for capacity. The tradeoff is that spinning drives have lower performance / through-put capabilities compared to flash drives, which can impact storage performance if your workload exceeds the [cache working set][s2d-cache-sizing], and HDDs have a lower mean time between failure value compared to NVMe and SSD drives.

Storage Spaces Direct provides a [built-in, persistent, real-time, read, write, server-side cache][s2d-cache] that maximizes storage performance. The cache should be sized and configured to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. Storage Spaces Direct virtual disks, or _volumes_, are used in combination with cluster shared volume (CSV) in-memory read cache to [improve Hyper-V performance][azs-hci-csv-cache], especially for unbuffered input access to workload virtual hard disk (VHD) or virtual hard disk v2 (VHDX) files.

> [!TIP]
> For high-performance or latency-sensitive workloads, we recommend that you use an [all-flash storage (all NVMe or all SSD) configuration](/azure/azure-local/concepts/choose-drives#option-1--maximizing-performance) and a cluster size of three or more physical machines. Deploying this design with the _default storage configuration_ settings uses [three-way mirroring](/azure/azure-local/concepts/fault-tolerance#three-way-mirror) for the infrastructure and user volumes. This deployment strategy provides the highest performance and resiliency. When you use an all-NVMe or all-SSD configuration, you benefit from the full usable storage capacity of each flash drive. Unlike hybrid or mixed NVMe + SSD setups, there's no capacity reserved for caching when using a single drive type. This ensures optimal utilization of your storage resources. For more information about how to balance performance and capacity to meet your workload requirements, see [Plan volumes - When performance matters most][s2d-plan-volumes-performance].

### Network design

Network design is the overall arrangement of components within the network's physical infrastructure and logical configurations. You can use the same physical network interface card (NIC) ports for all combinations of management, compute, and storage network intents. Using the same NIC ports for all intent-related purposes is called a _fully converged networking configuration_.

Although a fully converged networking configuration is supported, the optimal configuration for performance and reliability is for the storage intent to use dedicated network adapter ports. Therefore, this baseline architecture provides example guidance for how to deploy a multi-node Azure Local instance using the storage switched network architecture with two network adapter ports that are converged for management and compute intents and two dedicated network adapter ports for the storage intent. For more information, see [Network considerations for cloud deployments of Azure Local](/azure/azure-local/plan/cloud-deployment-network-considerations).

This architecture requires two or more physical machines and up to a maximum of 16 machines in scale. Each machine requires four network adapter ports that are connected to two Top-of-Rack (ToR) switches. The two ToR switches should be interconnected through multi-chassis link aggregation group (MLAG) links. The two network adapter ports that are used for the storage intent traffic must support [Remote Direct Memory Access (RDMA)](/azure/azure-local/concepts/host-network-requirements#rdma). These ports require a minimum link speed of 10 Gbps, but we recommend a speed of 25 Gbps or higher. The two network adapter ports used for the management and compute intents are converged using switch embedded teaming (SET) technology. SET technology provides link redundancy and load-balancing capabilities. These ports require a minimum link speed of 1 Gbps, but we recommend a speed of 10 Gbps or higher.

#### Physical network topology

The following physical network topology shows the physical network connections between the Azure Local machines and networking components.

You need the following components when you design a multi-node storage switched Azure Local deployment that uses this baseline architecture:

:::image type="content" source="images/azure-local-baseline-physical-network.png" alt-text="Diagram that shows the physical networking topology for a multi-node Azure Local instance that uses a storage switched architecture with dual ToR switches." lightbox="images/azure-local-baseline-physical-network.png" border="false":::

- Dual ToR switches:

  - Dual ToR network switches are required for network resiliency, and the ability to service or apply firmware updates, to the switches without incurring downtime. This strategy prevents a single point of failure (SPoF).
  
  - The dual ToR switches are used for the storage, or east-west, traffic. These switches use two dedicated Ethernet ports that have specific storage virtual local area networks (VLANs) and priority flow control (PFC) traffic classes that are defined to provide lossless RDMA communication.
  
  - These switches connect to the physical machines through Ethernet cables.
  
- Two or more physical machines and up to a maximum of 16 physical machines:

  - Each machine is a physical server that runs Azure Stack HCI OS.
  
  - Each machine requires four network adapter ports in total: two RDMA-capable ports for storage and two network adapter ports for management and compute traffic.
  
  - Storage uses the two dedicated RDMA-capable network adapter ports that connect with one path to each of the two ToR switches. This approach provides link-path redundancy and dedicated prioritized bandwidth for SMB Direct storage traffic.
  
  - Management and compute uses two network adapter ports that provide one path to each of the two ToR switches for link-path redundancy.
  
- External connectivity:

  - Dual ToR switches connect to the external network, such as your internal corporate LAN, to provide access to the required outbound URLs using your edge border network device. This device can be a firewall or router. These switches route traffic that goes in and out of the Azure Local instance, or north-south traffic.
  
  - External north-south traffic connectivity supports the cluster management intent and compute intents. This is achieved using two switch ports and two network adapter ports per machine that are converged through switch embedded teaming (SET) and a virtual switch within Hyper-V to ensure resiliency. These components work to provide external connectivity for Azure Local VMs and other workload resources deployed within the logical networks that are created in Resource Manager using Azure portal, CLI, or IaC templates.

#### Logical network topology

The logical network topology shows an overview of how network data flows between devices, regardless of their physical connections.

A summarization of the logical setup for this multi-node storage switched baseline architecture for Azure Local is as follows:

:::image type="content" source="images/azure-local-baseline-logical-network.png" alt-text="Diagram that shows the logical networking topology for a multi-node Azure Local instance using the storage switched architecture with dual ToR switches." lightbox="images/azure-local-baseline-logical-network.png" border="false":::

- Dual ToR switches:

  - Before you deploy the cluster, the two ToR network switches need to be configured with the required VLAN IDs, maximum transmission unit settings, and datacenter bridging configuration for the _management_, _compute_, and _storage_ ports. For more information, see [Physical network requirements for Azure Local](/azure/azure-local/concepts/physical-network-requirements), or ask your switch hardware vendor or SI partner for assistance.
  
- Azure Local uses the [Network ATC approach](/azure/azure-local/deploy/network-atc) to apply network automation and intent-based network configuration.
  
  - Network ATC is designed to ensure optimal networking configuration and traffic flow using network traffic _intents_. Network ATC defines which physical network adapter ports are used for the different network traffic intents (or types), such as for the cluster _management_, workload _compute_, and cluster _storage_ intents.
  
  - Intent-based policies simplify the network configuration requirements by automating the machine network configuration based on parameter inputs that are specified as part of the Azure Local cloud deployment process.
  
- External communication:

  - When the physical machines or workload need to communicate externally by accessing the corporate LAN, internet, or another service, they route using the dual ToR switches. This process is outlined in the previous **physical network topology** section.
  
  - When the two ToR switches act as Layer 3 devices, they handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  
  - Management network intent uses the converged SET team virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - For the compute network intent, you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as VMs, use these IDs to give access to the physical network. The logical networks use the two physical network adapter ports that are converged using an SET team for the compute and management intents.
  
- Storage traffic:

  - The physical machines communicate with each other using two dedicated network adapter ports that are connected to the ToR switches to provide high bandwidth and resiliency for storage traffic.
  
  - The _SMB1_ and _SMB2_ storage ports connect to two separate nonroutable (or Layer 2) networks. Each network has a specific VLAN ID configured that must match the switch ports configuration on the ToR switches' _default storage VLAN IDs: 711 and 712_.
  
  - There's _no default gateway_ configured on the two storage intent network adapter ports within the Azure Stack HCI OS.
  
  - Each cluster node can access Storage Spaces Direct capabilities of the cluster, such as remote physical drives that are used in the storage pool, virtual disks, and volumes. Access to these capabilities is facilitated through the SMB-Direct RDMA protocol over the two dedicated storage network adapter ports that are available in each machine. SMB Multichannel is used for resiliency.
  
  - This configuration provides sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

#### Network switch requirements

Your Ethernet switches must meet the different specifications required by Azure Local and set by the Institute of Electrical and Electronics Engineers Standards Association (IEEE SA). For example, for multi-node storage switched deployments, the storage network is used for [RDMA via RoCE v2 or iWARP](/azure/azure-local/concepts/host-network-requirements#rdma). This process requires IEEE 802.1Qbb PFC to ensure lossless communication for the [storage traffic class](/azure/azure-local/concepts/host-network-requirements#rdma-traffic-class). Your ToR switches must provide support for IEEE 802.1Q for VLANs and IEEE 802.1AB for the Link Layer Discovery Protocol.

If you plan to use existing network switches for an Azure Local deployment, review the [list of mandatory IEEE standards and specifications](/azure/azure-local/concepts/physical-network-requirements#network-switch-requirements) that the network switches and configuration must provide. When purchasing new network switches, review the [list of hardware vendor-certified switch models that support Azure Local network requirements](/azure/azure-local/concepts/physical-network-requirements#network-switches-for-azure-stack-hci).

#### IP address requirements

In a multi-node storage switched deployment, the number of IP addresses needed increases with the addition of each physical machine, up to a maximum of 16 physical machines within a single cluster. For example, to deploy a two-node storage switched configuration of Azure Local, the cluster infrastructure requires a minimum of 11 x IP addresses to be allocated. More IP addresses are required if you use micro-segmentation or software-defined networking. For more information, see [Review two-node storage reference pattern IP address requirements for Azure Local](/azure/azure-local/plan/two-node-ip-requirements).

When you design and plan IP address requirements for Azure Local, remember to account for additional IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Local instance and infrastructure components. If you plan to deploy AKS on Azure Local, see [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

#### Outbound network connectivity

It is important to understand the outbound network connectivity requirements of Azure Local and factor these requirements into your design and implementation plan prior to deploying the solution. Outbound network connectivity is required to enable Azure Local to communicate with Azure and Azure Arc for management and control plane operations. For example, to provide the ability to provision Azure Arc-enabled resources such as Azure Local VMs or AKS clusters, in addition using Azure management services such as Azure Update Manager and Azure Monitor.

The up-front planning and due diligence for how you will enable network communication to the required public endpoints is critically important if you are integrating Azure Local into an existing on-premises datacenter network. Especially if you have strict egress rules configured on your proxy and/or firewall devices, or if you are using "**SSL inspection technologies**" as a part of your existing network security controls, because SSL inspection is not supported for Azure Local network communication.

#### Why is outbound network connectivity so important?

Outbound network connectivity is required from your Azure Local instance, this includes the physical machines, [Arc resource bridge (ARB)](/azure/azure-arc/resource-bridge/overview) appliance, AKS clusters and Azure Local VMs if using Azure Arc for VM Guest OS management. These devices have local agents or services that connect to the public endpoints using outbound network access for real time communication, this provides connectivity to the management / control plane resource providers that run in Azure. For example, connectivity is required for operators to be able to use Azure portal, Azure CLI or an ARM, Bicep or Terraform template to provision and/or manage Azure Local VMs and Arc enabled AKS clusters. Azure and the Arc resource bridge work in combination with your Azure Local instance's [custom location](/azure/azure-arc/platform/conceptual-custom-locations) resource, enabling you to target the specific Azure Local instance for any resource CRUD (_create, read, update or delete_) operations for your Arc-enabled workload resources.

To enable connectivity typically involves configuring your firewall, proxy and/or internet egress technology to allow outbound access to the required public endpoints. Key considerations for Azure Local outbound network requirements:

- Azure Local does not support SSL / TLS packet inspection along any of the networking paths from your Azure Local instances to the public endpoints. Additionally, Private Link and Express route are not supported for the connectivity to the required public endpoints. For details information, refer to [Firewall requirements for Azure Local](/azure/azure-local/concepts/firewall-requirements).

- Consider using the [Azure Arc gateway](/azure/azure-local/deploy/deployment-azure-arc-gateway-overview) to simplify connectivity requirements, as this significantly reduces the number of required endpoints that need to be added to your firewall or proxy rules for the deployment and management of Azure Local.

- When deploying Azure Local using a Proxy Server to control and manage internet egress access, review the [Proxy requirements](/azure/azure-local/plan/cloud-deployment-network-considerations#proxy-requirements)

### Monitoring

To enhance monitoring and alerting, enable [Monitor Insights on Azure Local](/azure/azure-local/concepts/monitoring-overview). Insights can scale to monitor and manage multiple on-premises instances using an Azure consistent experience. Insights uses cluster performance counters and event log channels to monitor key Azure Local features. Logs are collected by the DCR that's configured through Monitor and Log Analytics.

Insights for Azure Local is built using Monitor and Log Analytics, which ensures an always up-to-date, scalable solution that's highly customizable. Insights provides access to default workbooks with basic metrics, along with specialized workbooks created for monitoring key features of Azure Local. These components provide a near real-time monitoring solution and enable the creation of graphs, customization of visualizations through aggregation and filtering, and configuration of custom resource health alert rules.

### Update management

Azure Local instances and the deployed workload resources, such as Azure Local VMs, need to be updated and patched regularly. By regularly applying updates, you ensure that your organization maintains a strong security posture, and you improve the overall reliability and supportability of your estate. We recommend that you use automatic and periodic manual assessments for early discovery and application of security patches and OS updates.

#### Infrastructure updates

Azure Local is continuously updated to improve the customer experience and add new features and functionality. This process is managed through release trains, which deliver feature updates every six months, these are released in April (YY04) and October (YY10). In addition to regular feature updates, Azure Local is updated with monthly cumulative updates that include OS security and reliability updates, in addition to extensions and agent updates.

Update Manager is an Azure service that you can use to apply, view, and manage updates for Azure Local. This service provides a mechanism to view all Azure Local instances across your entire infrastructure and edge locations using the Azure portal to provide a centralized management experience. For more information, see the following resources:

- [About Azure Local release information](/azure/azure-local/release-information-23h2#about-azure-stack-hci-version-23h2-releases)

- [Azure Local lifecycle cadence](/azure/azure-local/update/about-updates-23h2#lifecycle-cadence)

- [Review update phases of Azure Local](/azure/azure-local/update/update-phases-23h2)

- [Use Azure Update Manager to update Azure Local](/azure/azure-local/update/azure-update-manager-23h2)

It's important to check for new driver and firmware updates regularly, such as every three to six months. If you use a Premier solution category version for your Azure Local hardware, the [Solution Builder Extension package updates](/azure/azure-local/update/solution-builder-extension) are integrated with Update Manager to provide a simplified update experience. If you use Validated Nodes or an Integrated System category, there might be a requirement to download and run an OEM-specific update package that contains the firmware and driver updates for your hardware. To determine how updates are supplied for your hardware, contact your hardware OEM or SI partner.

#### Workload guest OS patching

You can enroll Azure Local VMs that are deployed on Azure Local into [Azure Update Manager (AUM)][azure-update-management] to provide a unified patch management experience using the same mechanism used to update the Azure Local instance physical machines. You can use AUM to create [Guest maintenance configurations](/azure/virtual-machines/maintenance-configurations#guest). These configurations control settings such as the Reboot setting _reboot if necessary_, the schedule (dates, times, and repeat options), and either a dynamic (subscription) or static list of the Azure Local VMs for the scope. These settings control the configuration for when OS security patches are installed inside your workload VM's guest OS.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Identify the potential failure points

Every architecture is susceptible to failures. You can anticipate failures and be prepared with mitigations with failure mode analysis. The following table describes four examples of potential points of failure in this architecture:

| Component | Risk | Likelihood | Effect/mitigation/note | Outage |
|-----------|------|------------|------------------------|--------|
| Azure Local instance outage | Power, network, hardware, or software failure | Medium | To prevent a prolonged application outage caused by the failure of an Azure Local instance for business or mission-critical use cases, your workload should be architected using HA and DR principles. For example, you can use industry-standard workload data replication technologies to maintain multiple copies of persistent state data that are deployed using multiple Azure Local VMs or AKS instances that are deployed on separate Azure Local instances and in separate physical locations. | Potential outage. |
| Azure Local single physical machine outage | Power, hardware, or software failure | Medium | To prevent a prolonged application outage caused by the failure of a single Azure Local machine, your Azure Local instance should have multiple physical machines. Your workload capacity requirements during the cluster design phase determine the number of physical machines. We recommend that you have three or more physical machines. We also recommended that you use three-way mirroring, which is the default storage resiliency mode for clusters with three or more physical machines. To prevent a SPoF and increase workload resiliency, deploy multiple instances of your workload using two or more Azure Local VMs or container pods that run in multiple AKS worker nodes. If a single machine fails, the Azure Local VMs and workload / application services are restarted on the remaining online physical machines in the cluster. | Potential outage. |
| Azure Local VM or AKS worker node (workload) | Misconfiguration | Medium | Application users are unable to sign in or access the application. Misconfigurations should be caught during deployment. If these errors happen during a configuration update, DevOps team must roll back changes. You can redeploy the VM if necessary. Redeployment takes less than 10 minutes to deploy but can take longer according to the type of deployment. | Potential outage. |
| Connectivity to Azure | Network outage | Medium | Azure Local requires network connectivity to Azure for control plane operations to be available. For example, for the ability to provision new Azure Local VMs or AKS clusters, install Solution Updates using Azure Update Manager, or monitor health status of the instance using Azure Monitor. If connectivity to Azure is unavailable, the instance will operate in a degraded state, where these capabilities are not available, however existing workloads that are already running on Azure Local will continue to run. [If network connectivity to Azure is not restored within 30 days](/azure/azure-local/faq#how-long-can-azure-local-run-with-the-connection-down), the instance will enter an "Out Of Policy" status, which can limit functionality. The [Azure Resource Bridge (ARB) appliance cannot be offline for more than 45-days](/azure/azure-arc/resource-bridge/troubleshoot-resource-bridge#arc-resource-bridge-is-offline), as this can impact the validity of the security key that is used for authentication. | Management operations unavailable. |

For more information, see [Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis).

#### Reliability targets

This section describes an example scenario. A fictitious customer called _Contoso Manufacturing_ uses this reference architecture to deploy Azure Local. They want to address their requirements and deploy and manage workloads on-premises. Contoso Manufacturing has an internal service-level objective (SLO) target of 99.8% that business and application stakeholders agree on for their services.

- An SLO of 99.8% uptime, or availability, results in the following periods of allowed downtime, or unavailability, for the applications that are deployed using Azure Local VMs that run on Azure Local:

  - Weekly: 20 minutes and 10 seconds

  - Monthly: 1 hour, 26 minutes, and 56 seconds

  - Quarterly: 4 hours, 20 minutes, and 49 seconds

  - Yearly: 17 hours, 23 minutes, and 16 seconds

- **To help meet the SLO targets**, Contoso Manufacturing implements the principle of least privilege (PoLP) to restrict the number of Azure Local instance administrators to a small group of trusted and qualified individuals. This approach helps prevent downtime due to any inadvertent or accidental actions performed on production resources. Furthermore, the security event logs for on-premises Active Directory Domain Services (AD DS) domain controllers are monitored to detect and report any user account group membership changes, known as _add_ and _remove_ actions, for the _Azure Local instance administrators_ group using a security information event management (SIEM) solution. Monitoring increases reliability and improves the security of the solution.

  For more information, see [Recommendations for identity and access management](/azure/well-architected/security/identity-access).

- **Strict change control procedures** are in place for Contoso Manufacturing's production systems. This process requires that all changes are tested and validated in a representative test environment before implementation in production. All changes submitted to the weekly change advisory board process must include a detailed implementation plan (or link to source code), risk level score, a comprehensive rollback plan, post-release testing and verification, and clear success criteria for a change to be reviewed or approved.

  For more information, see [Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Monthly security patches and quarterly baseline updates** are applied to production Azure Local instance only after they're validated by the preproduction environment. Update Manager and the cluster-aware updating feature automate the process of using [VM live migration](/windows-server/virtualization/hyper-v/manage/live-migration-overview) to minimize downtime for business-critical workloads during the monthly servicing operations. Contoso Manufacturing standard operating procedures require that security, reliability, or baseline build updates are applied to all production systems within four weeks of their release date. Without this policy, production systems are perpetually unable to stay current with monthly OS and security updates. Out-of-date systems negatively affect platform reliability and security.

  For more information, see [Recommendations for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Contoso Manufacturing implements daily, weekly, and monthly backups** to retain the last 6 x days of daily backups (Mondays to Saturdays), the last 3 x weekly (each Sunday) and 3 x monthly backups, with each _Sunday week 4_ being retained to become the month 1, month 2, and month 3 backups using a _rolling calendar based schedule_ that's documented and auditable. This approach meets Contoso Manufacturing requirements for an adequate balance between the number of data recovery points available and reducing costs for the offsite or cloud backup storage service.

  For more information, see [Recommendations for designing a disaster recovery strategy](/azure/well-architected/reliability/disaster-recovery).

- **Data backup and recovery processes are tested** for each business system every six months. This strategy provides assurance that BCDR processes are valid and that the business is protected if a datacenter disaster or cyber incident occurs.

  For more information, see [Recommendations for designing a reliability testing strategy](/azure/well-architected/reliability/testing-strategy).

- **The operational processes and procedures** described previously in the article, and the recommendations in the [Well-Architected Framework service guide for Azure Local](/azure/well-architected/service-guides/azure-local), enable Contoso Manufacturing to meet their 99.8% SLO target and effectively scale and manage Azure Local and workload deployments across multiple manufacturing sites that are distributed around the world.

  For more information, see [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

#### Redundancy

Consider a workload that you deploy on a single Azure Local instance as a _locally redundant deployment_. The cluster provides high availability at the platform level, but you must deploy the cluster in a single rack. For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Local instances, ideally in separate physical locations.

Use industry-standard, high-availability patterns for workloads that provide active/passive replication, synchronous replication, or asynchronous replication such as [SQL Server Always On](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server). You can also use an external network load balancing (NLB) technology that routes user requests across the multiple workload instances that run on Azure Local instances that you deploy in separate physical locations. Consider using a partner external NLB device. Or you can evaluate the [load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview) that support traffic routing for hybrid and on-premises services, such as an Azure Application Gateway instance that uses Azure ExpressRoute or a VPN tunnel to connect to an on-premises service.

For more information, see [Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security considerations include:

- **A secure foundation for the Azure Local platform**: [Azure Local][azs-hci-basic-security] is a secure-by-default product that uses validated hardware components with a TPM, UEFI, and Secure Boot to build a secure foundation for the Azure Local platform and workload security. When deployed with the default security settings, Azure Local has Application Control, Credential Guard, and BitLocker enabled. To simplify delegating permissions using the PoLP, use [Azure Local built-in role-based access control (RBAC) roles][azs-hci-rbac] such as Azure Local Administrator for platform administrators and Azure Local VM Contributor or Azure Local VM Reader for workload operators.

- **Default security settings**: [Azure Local security default][azs-hci-security-default] applies default security settings for your Azure Local instance during deployment and [enables drift control](/azure/azure-local/manage/manage-secure-baseline) to keep the physical machines in a known good state. You can use the security default settings to manage cluster security, drift control, and secured core server settings on your cluster.

- **Security event logs**: [Azure Local syslog forwarding][azs-hci-security-syslog] integrates with security monitoring solutions by retrieving relevant security event logs to aggregate and store events for retention in your own SIEM platform.

- **Protection from threats and vulnerabilities**: [Defender for Cloud][azs-hci-defender-for-cloud] protects your Azure Local instance from various threats and vulnerabilities. This service helps improve the security posture of your Azure Local environment and can protect against existing and evolving threats.

- **Threat detection and remediation**: [Microsoft Advanced Threat Analytics][ms-ata] detects and remediates threats, such as those targeting AD DS, that provide authentication services to Azure Local instance machines and their Windows Server VM workloads.

- **Network isolation**: Isolate networks if needed. For example, you can provision multiple logical networks that use separate VLANs and network address ranges. When you use this approach, ensure that the management network can reach each logical network and VLAN so that Azure Local instance physical machines can communicate with the VLAN networks through the ToR switches or gateways. This configuration is required for management of the workload, such as allowing infrastructure management agents to communicate with the workload guest OS.

  For more information, see [Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Cost optimization considerations include:

- **Cloud-style billing model for licensing**: Azure Local pricing follows the [monthly subscription billing model][azs-hci-billing] with a flat rate per physical processor core in an Azure Local instance. Extra usage charges apply if you use other Azure services. If you own on-premises core licenses for Windows Server Datacenter edition with active Software Assurance, you might choose to exchange these licenses to activate Azure Local instance and Windows Server VM subscription fees.

- **Automatic VM Guest patching for Azure Local VMs**: This feature helps reduce the overhead of manual patching and the associated maintenance costs. Not only does this action help make the system more secure, but it also optimizes resource allocation and contributes to overall cost efficiency.

- **Cost monitoring consolidation**: To consolidate monitoring costs, use [Azure Local Insights](/azure/azure-local/concepts/monitoring-overview#insights) and patch using [Update Manager for Azure Local](/azure/azure-local/update/about-updates-23h2). Insights uses Monitor to provide rich metrics and alerting capabilities. The lifecycle manager component of Azure Local integrates with Update Manager to simplify the task of keeping your clusters up to date by consolidating update workflows for various components into a single experience. Use Monitor and Update Manager to optimize resource allocation and contribute to overall cost efficiency.

  For more information, see [Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

- **Initial workload capacity and growth**: When you plan your Azure Local deployment, consider your initial workload capacity, resiliency requirements, and future growth considerations. Consider if using a two, three or four-node storage switchless architecture could reduce costs, such as removing the need to procure storage-class network switches. Procuring extra storage class network switches can be an expensive component of new Azure Local instance deployments. Instead, you can use existing switches for management and compute networks, which simplify the infrastructure. If your workload capacity and resiliency needs don't scale beyond a four-node configuration, consider if you can use existing switches for the management and compute networks, and use the [storage switchless architecture](azure-local-switchless.yml) to deploy Azure Local.

  For more information, see [Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

> [!TIP]
> You can save on costs with Azure Hybrid Benefit if you have Windows Server Datacenter licenses with active Software Assurance. For more information, see [Azure Hybrid Benefit for Azure Local][azs-hybrid-benefit].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Operational excellence considerations include:

- **Simplified provisioning and management experience integrated with Azure**: The [Cloud Based Deployment in Azure][azs-hci-deploy-via-portal] provides a wizard-driven interface that shows you how to create an Azure Local instance. Similarly, Azure simplifies the process of [managing Azure Local instances][azs-hci-manage-cluster-at-scale] and [Azure Local VMs](/azure/azure-local/manage/azure-arc-vm-management-overview). You can automate the portal-based deployment of the Azure Local instance using [this ARM template][azs-hci-deploy-via-template]. Using templates provides consistency and automation to deploy Azure Local at scale, specifically in edge scenarios such as retail stores or manufacturing sites that require an Azure Local instance to run business-critical workloads.

- **Automation capabilities for Virtual Machines**: Azure Local provides a wide range of automation capabilities for managing workloads, such as Azure Local VMs, with the [automated deployment of Azure Local VMs using Azure CLI, ARM, or Bicep template][azs-hci-automate-arc-vms], with Virtual Machine OS updates using Azure Arc Extension for Updates and [Azure Update Manager][azure-update-management] to update each Azure Local instance. Azure Local also provides support for [Azure Local VM management][azs-hci-vm-automate-cli] using Azure CLI and [non-Azure Local VMs][azs-hci-manage-non-arc-vms] using Windows PowerShell. You can run Azure CLI commands locally from one of the Azure Local machines or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of extra automation scenarios for [VM workloads][arc-vm-extensions] through Azure Arc extensions.

    For more information, see [Recommendations for using IaC](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- **Automation capabilities for containers on AKS**: Azure Local provides a wide range of automation capabilities for managing workloads, such as containers, on AKS. You can [automate the deployment of AKS clusters using Azure CLI][azs-hci-automate-arc-aks]. Update AKS workload clusters using the Azure Arc extension for [Kubernetes updates][azs-hci-automate-aks-update]. You can also manage [Azure Arc-enabled AKS][azs-hci-aks-automate-cli] using Azure CLI. You can run Azure CLI commands locally from one of the Azure Local machines or remotely from a management computer. Integrate with Azure Arc for a wide range of extra automation scenarios for [containerized workloads][azs-hci-k8s-gitops] through Azure Arc extensions.

    For more information, see:
            - [Recommendations for enabling automation](/azure/well-architected/operational-excellence/enable-automation).
            - [Compare management capabilities of VMs on Azure Local](/azure/azure-local/concepts/compare-vm-management-capabilities).

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance efficiency considerations include:

- **Workload storage performance**: Consider using the [DiskSpd](/previous-versions/azure/azure-local/manage/diskspd-overview) tool to test workload storage performance capabilities of an Azure Local instance. You can use the VMFleet tool to generate load and measure the performance of a storage subsystem. Evaluate whether you should use [VMFleet](https://github.com/microsoft/diskspd/wiki/VMFleet) to measure storage subsystem performance.

  - We recommend that you establish a baseline for your Azure Local instances performance before you deploy production workloads. DiskSpd uses various command-line parameters that enable administrators to test the storage performance of the cluster. The main function of DiskSpd is to issue read and write operations and output performance metrics, such as latency, throughput, and IOPs.

    For more information, see [Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test).

- **Workload storage resiliency**: Consider the benefits of [storage resiliency][s2d-resiliency], usage (or capacity) efficiency, and performance. Planning for Azure Local volumes includes identifying the optimal balance between resiliency, usage efficiency, and performance. You might find it difficult to optimize this balance because maximizing one of these characteristics typically has a negative effect on one or more of the other characteristics. Increasing resiliency reduces the usable capacity. As a result, the performance might vary, depending on the resiliency type selected. When resiliency and performance are the priority, and when you use three or more physical machines, the default storage configuration employs three-way mirroring for both infrastructure and user volumes.

    For more information, see [Recommendations for capacity planning](/azure/well-architected/performance-efficiency/capacity-planning).

- **Network performance optimization**: Consider network performance optimization. As part of your design, be sure to include projected [network traffic bandwidth allocation][azs-hci-network-bandwidth-allocation] when determining your [optimal network hardware configuration][azs-hci-networking].

  - To optimize compute performance in Azure Local, you can use GPU acceleration. GPU acceleration is beneficial for [high-performance AI or machine learning workloads][azs-hci-gpu-acceleration] that involve data insights or inferencing. These workloads require deployment at edge locations due to considerations like data gravity or security requirements. In a hybrid deployment or on-premises deployment, it's important to take your workload performance requirements, including GPUs, into consideration. This approach helps you select the right services when you design and procure your Azure Local instances.

    For more information, see [Recommendations for selecting the right services](/azure/well-architected/performance-efficiency/select-services).

## Deploy this scenario

The following section provides an example list of the high-level tasks or typical workflow used to deploy Azure Local, including prerequisite tasks and considerations. This workflow list is intended as an example guide only. It isn't an exhaustive list of all required actions, which can vary based on organizational, geographic, or project-specific requirements.

**Scenario: there is a project or use case requirement to deploy a hybrid cloud solution in an on-premises or edge location** to provide local compute for data processing capabilities and a desire to use Azure-consistent management and billing experiences. More details are described in the [potential use cases](#potential-use-cases) section of this article. The remaining steps assume that Azure Local is the chosen infrastructure platform solution for the project.

1. **Gather workload and use case requirements from relevant stakeholders**. This strategy enables the project to confirm that the features and capabilities of Azure Local meet the workload scale, performance, and functionality requirements. This review process should include understanding the workload scale, or size, and required features such as Azure Local VMs, AKS, Azure Virtual Desktop, or Azure Arc-enabled Data Services or Azure Arc-enabled Machine Learning service. The workload RTO and RPO (reliability) values and other nonfunctional requirements (performance/load scalability) should be documented as part of this requirements gathering step.

1. **Review the Azure Local sizer output for the recommended hardware partner solution**. This output includes details of the recommended physical server hardware make and model, number of physical machines, and the specifications for the CPU, memory, and storage configuration of each physical node that are required to deploy and run your workloads.

1. **Use the [Azure Local sizing tool][azs-hci-sizer-tool] to create a new project that models the workload type and scale**. This project includes the size and number of VMs and their storage requirements. These details are inputted together with choices for the system type, preferred CPU family, and your resiliency requirements for high availability and storage fault tolerance, as explained in the previous [Cluster design choices](#cluster-design-choices) section.

1. **Review the Azure Local Sizer output for the recommended hardware partner solution**. This solution includes details of the recommended physical server hardware (make and model), number of physical machines, and the specifications for the CPU, memory, and storage configuration of each physical node that are required to deploy and run your workloads.

1. **Contact the hardware OEM or SI partner to further qualify the suitability of the recommended hardware version versus your workload requirements**. If available, use OEM-specific sizing tools to determine OEM-specific hardware sizing requirements for the intended workloads. This step typically includes discussions with the hardware OEM or SI partner for the commercial aspects of the solution. These aspects include quotations, availability of the hardware, lead times, and any professional or value-add services that the partner provides to help accelerate your project or business outcomes.

1. **Deploy two ToR switches for network integration**. For high availability solutions, Azure Local instances require two ToR switches to be deployed. Each physical machine requires four NICs, two of which must be RDMA capable, which provides two links from each machine to the two ToR switches. Two NICs, one connected to each switch, are converged for outbound north-south connectivity for the compute and management networks. The other two RDMA capable NICs are dedicated for the storage east-west traffic. If you plan to use existing network switches, ensure that the make and model of your switches are on the [approved list of network switches supported by Azure Local](/azure/azure-local/concepts/physical-network-requirements#network-switches-for-azure-local).

1. **Work with the hardware OEM or SI partner to arrange delivery of the hardware**. The SI partner or your employees are then required to integrate the hardware into your on-premises datacenter or edge location, such as racking and stacking the hardware, physical network, and power supply unit cabling for the physical machines.

1. **Perform the Azure Local instance deployment**. Depending on your chosen solution version (Premier solution, Integrated system, or Validated Nodes), either the hardware partner, SI partner, or your employees can [deploy the Azure Local software](/azure/azure-local/deploy/deployment-introduction). This step starts by onboarding the physical machines Azure Stack HCI OS into Azure Arc-enabled servers, then starting the Azure Local cloud deployment process. Customers and partners can raise a support request directly with Microsoft in the [Azure portal](https://portal.azure.com/) by selecting the _Support + Troubleshooting_ icon or by contacting their hardware OEM or SI partner, depending on the nature of the request and the hardware solution category.

   > [!TIP]
   > ![GitHub logo](../_images/github.svg) The [Azure Stack HCI OS, version 23H2 system reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to deploy a switched multi node deployment of Azure Local using an ARM template and parameter file. Alternatively, [the Bicep example](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) demonstrates how to use a Bicep template to deploy an Azure Local instance, including its prerequisites resources.

1. **Deploy highly available workloads on Azure Local using Azure portal, CLI, or ARM + Azure Arc templates for automation**. Use the _custom location_ resource of the new Azure Local instance as the target region when you [deploy workload resources such as Azure Local VMs, AKS, Azure Virtual Desktop session hosts, or other Azure Arc-enabled services](#use-azure-arc-with-azure-local) that you can enable through AKS extensions and containerization on Azure Local.

1. **Install monthly updates to improve the security and reliability of the platform**. To keep your Azure Local instances up to date, it's important to install Microsoft software updates and hardware OEM driver and firmware updates. These updates improve the security and reliability of the platform. [Update Manager](/azure/azure-local/update/azure-update-manager-23h2) applies the updates and provides a centralized and scalable solution to install updates across a single cluster or multiple clusters. Check with your hardware OEM partner to determine the process for installing hardware driver and firmware updates because this process can vary depending on your chosen hardware solution category type (Premier solution, Integrated system, or Validated Nodes). For more information, see [Infrastructure updates](#infrastructure-updates).

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments using Azure Arc](azure-arc-sql-server.yml)

## Next steps

Product documentation:

- [Azure Local release information](/azure/azure-local/release-information-23h2)
- [AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2)
- [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Local monitoring?](/azure/azure-local/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Local](/azure/azure-local/manage/azure-site-recovery)
- [Monitor overview](/azure/azure-monitor/overview)
- [Change tracking and inventory overview](/azure/automation/change-tracking/overview)
- [Update Manager overview](/azure/update-manager/overview)
- [What are Azure Arc-enabled data services?](/azure/azure-arc/data/overview)
- [What are Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is the Backup service?](/azure/backup/backup-overview)

Product documentation for details on specific Azure services:

- [Azure Local](https://azure.microsoft.com/products/local/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

Microsoft Learn modules:

- [Configure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc-enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Scale model deployment with Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/scale-model-deployment-with-azure-machine-learning-anywhere/ba-p/2888753)
- [Realizing Machine Learning anywhere with AKS and Azure Arc-enabled Machine Learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-arc-blog/realizing-machine-learning-anywhere-with-azure-kubernetes/ba-p/3470783)
- [Machine learning on AKS hybrid and Stack HCI using Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-stack-blog/machine-learning-on-aks-hybrid-amp-stack-hci-using-azure-arc/ba-p/3816127)
- [Introduction to Kubernetes compute target in Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere?view=azureml-api-2)
- [Keep your VMs updated](/training/modules/keep-your-virtual-machines-updated)
- [Protect your VM settings with Automation state configuration](/training/modules/protect-vm-settings-with-dsc)
- [Protect your VMs using Backup](/training/modules/protect-virtual-machines-with-azure-backup)

[arc-azure-policy]: /azure/azure-arc/servers/security-controls-policy
[arc-enabled-aks]: /azure/aks/hybrid/cluster-architecture
[arc-enabled-data-services]: /azure/azure-arc/data/overview
[arc-enabled-vms]: /azure/azure-local/manage/azure-arc-vm-management-overview
[arc-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[az-auto-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker
[azs-hci-aks-automate-cli]: /cli/azure/aksarc
[azs-hci-automate-aks-update]: /azure/aks/hybrid/cluster-upgrade
[azs-hci-automate-arc-aks]: /azure/aks/hybrid/aks-create-clusters-cli?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json
[azs-hci-automate-arc-vms]: /azure/azure-local/manage/create-arc-virtual-machines?tabs=azurecli
[azs-hci]: /azure/well-architected/service-guides/azure-local
[azs-hci-basic-security]: /azure/azure-local/concepts/security-features
[azs-hci-billing]: /azure/azure-local/concepts/billing
[azs-hci-csv-cache]: /azure/azure-local/manage/use-csv-cache#planning-considerations
[azs-hci-defender-for-cloud]: /azure/azure-local/manage/manage-security-with-defender-for-cloud
[azs-hci-deploy-via-portal]: /azure/azure-local/deploy/deploy-via-portal
[azs-hci-deploy-via-template]: /azure/azure-local/deploy/deployment-azure-resource-manager-template
[azs-hci-gpu-acceleration]: /windows-server/virtualization/hyper-v/deploy/use-gpu-with-clustered-vm?pivots=azure-stack-hci
[azs-hci-k8s-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[azs-hci-manage-cluster-at-scale]: /azure/azure-local/manage/manage-at-scale-dashboard
[azs-hci-manage-non-arc-vms]: /azure/azure-local/manage/vm-powershell
[azs-hci-network-bandwidth-allocation]: /azure/azure-local/concepts/host-network-requirements#traffic-bandwidth-allocation
[azs-hci-networking]: /azure/azure-local/concepts/host-network-requirements
[azs-hci-rbac]: /azure/azure-local/manage/assign-vm-rbac-roles
[azs-hci-security-default]: /azure/azure-local/manage/manage-secure-baseline
[azs-hci-security-syslog]: /azure/azure-local/manage/manage-syslog-forwarding
[azs-hci-sizer-tool]: https://azurestackhcisolutions.azure.microsoft.com/#catalog
[azs-hci-vbs]: /windows-hardware/design/device-experiences/oem-vbs
[azs-hci-vm-automate-cli]: /cli/azure/stack-hci-vm
[azs-hybrid-benefit]: /azure/azure-local/concepts/azure-hybrid-benefit-hci
[azure-arc]: /azure/azure-arc/overview
[azure-backup]: /azure/backup/backup-overview
[azure-monitor]: /azure/azure-monitor/overview
[azure-policy]: /azure/governance/policy/overview
[azure-site-recovery]: /azure/site-recovery/site-recovery-overview
[azure-update-management]: /azure/update-manager/
[cloud-witness]: /windows-server/failover-clustering/deploy-cloud-witness
[key-vault]: /azure/key-vault/general/basic-concepts
[ms-ata]: /advanced-threat-analytics/what-is-ata
[ms-defender-for-cloud]: /azure/security-center/security-center-introduction
[s2d-cache-sizing]: /azure/azure-local/concepts/cache#sizing-the-cache
[s2d-cache]: /azure/azure-local/concepts/cache#server-side-architecture
[s2d-disks]: /windows-server/storage/storage-spaces/choosing-drives
[s2d-drive-balance-performance-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-2--balancing-performance-and-capacity
[s2d-drive-max-capacity]: /windows-server/storage/storage-spaces/choosing-drives#option-3--maximizing-capacity
[s2d-drive-max-performance]: /windows-server/storage/storage-spaces/choosing-drives#option-1--maximizing-performance
[s2d-plan-volumes-performance]: /azure/azure-local/concepts/plan-volumes#when-performance-matters-most
[s2d-resiliency]: /windows-server/storage/storage-spaces/storage-spaces-fault-tolerance
