This baseline reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Local 2311 and later infrastructure, to provide a reliable platform for highly available virtualized and containerized workloads. This architecture describes the resource components and cluster design choices for the physical machines that provide local compute, storage, and networking capabilities. It also describes how to use Azure services to simplify the day-to-day management of Azure Local for at-scale operations.

For more information about workload architecture patterns that are optimized to run on Azure Local, see the content located in the **Azure Local workloads** navigation menu.

This architecture is a starting point for how to use the storage switched network design to deploy a multi-node Azure Local instance. The workload applications deployed on an Azure Local instance should be well architected. Well-architected workload applications must be deployed by using multiple instances or high availability (HA) of any critical workload services and have appropriate business continuity and disaster recovery (BCDR) controls in place. These BCDR controls include regular backups and DR failover capabilities. To focus on the hyperconverged infrastructure (HCI) infrastructure platform, these workload design aspects are intentionally excluded from this article.

For more information about guidelines and recommendations for the five pillars of the Azure Well-Architected Framework, see the [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-local).

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach |
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Components](#components) <br>&#9642; [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Scenario details](#scenario-details) <br>&#9642; [Use Azure Arc with Azure Local](#use-azure-arc-with-azure-local) <br>&#9642; [Take advantage of the Azure Local default security configuration](#take-advantage-of-the-azure-local-default-security-configuration) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; [Physical disk drives](#physical-disk-drives) <br> &#9642; [Network design](#network-design) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization) <br> &#9642; [Operational Excellence](#operational-excellence) <br> &#9642; [Performance Efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [Azure local template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to use an Azure Resource Manager template (ARM template) and parameter file to deploy a switched multi-server deployment of Azure Local. Alternatively, the [Bicep example](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) demonstrates how to use a Bicep template to deploy an Azure Local instance and its prerequisites resources.

## Architecture

:::image type="complex" source="images/azure-local-baseline.png" alt-text="Diagram that shows a multi-node Azure Local instance reference architecture with dual top-of-rack (ToR) switches for external north-south connectivity." lightbox="images/azure-local-baseline.png" border="false":::
   The architecture diagram shows an on-premises Azure Local environment connected to Azure. The on-premises environment contains a multi-node Azure Local cluster. The cluster is connected to dual ToR switches for network connectivity. The Azure environment shows several Azure services that integrate with Azure Local. These services include Azure Arc, Azure Monitor, Azure Key Vault, Azure Policy, Microsoft Defender for Cloud, Azure Update Manager, Azure Backup, and Azure Site Recovery.
:::image-end:::

For more information, see [Related resources](#related-resources).

## Components

This architecture consists of physical server hardware that you can use to deploy Azure Local instances in on-premises or edge locations. To enhance platform capabilities, Azure Local integrates with Azure Arc and other Azure services that provide supporting resources. Azure Local provides a resilient platform to deploy, manage, and operate user applications or business systems. Platform resources and services are described in the following sections.

### Platform resources

- [Azure Local][azure-local] is an HCI solution that's deployed on-premises or in edge locations and uses physical server hardware and networking infrastructure. Azure Local provides a platform to deploy and manage virtualized workloads such as virtual machines (VMs), Kubernetes clusters, and other services that Azure Arc enables. Azure Local instances can scale from a single-machine deployment to a maximum of 16 physical machines by using validated, integrated, or premium hardware categories that original equipment manufacturer (OEM) partners provide. In this architecture, Azure Local provides the core platform for hosting and managing virtualized and containerized workloads on-premises or at the edge.

- [Azure Arc][azure-arc] is a cloud-based service that extends the management model based on Resource Manager to Azure Local and other non-Azure locations. Azure Arc uses Azure as the control and management plane to enable the management of various resources such as VMs, Kubernetes clusters, and containerized data and machine learning services. In this architecture, Azure Arc enables centralized management and governance of resources deployed on Azure Local through the Azure control plane.

- [Azure Key Vault][key-vault] is a cloud service that you can use to securely store and access secrets. A secret is anything that you want to tightly restrict access to, such as API keys, passwords, certificates, cryptographic keys, local administrator credentials, and BitLocker recovery keys. In this architecture, Key Vault secures sensitive information and credentials used by workloads and infrastructure components on Azure Local.

- [Cloud witness][cloud-witness] is a feature that uses Azure Storage to serve as a failover cluster quorum. Azure Local (*two machine instances only*) uses a cloud witness as the quorum for voting, which ensures HA for the cluster. The storage account and witness configuration are created during the Azure Local cloud deployment process. In this architecture, cloud witness provides quorum for two-node clusters to maintain high availability.

- [Azure Update Manager][azure-update-management] is a unified service designed to manage and govern updates for Azure Local. You can use Update Manager to manage workloads that are deployed on Azure Local, including guest operating system update compliance for Windows and Linux VMs that can be enabled by using Azure Policy. This unified approach centralizes patch management across Azure, on-premises environments, and other cloud platforms through a single dashboard. In this architecture, Update Manager provides centralized update and patch management for both infrastructure and workloads.

### Platform-supporting resources

- [Azure Monitor][azure-monitor] is a cloud-based service for collecting, analyzing, and acting on diagnostic logs and telemetry from cloud and on-premises workloads. You can use Azure Monitor to maximize the availability and performance of your applications and services through a monitoring solution. Deploy Insights for Azure Local to simplify the creation of the Azure Monitor data collection rule (DCR) and enable monitoring of Azure Local instances. In this architecture, Azure Monitor provides monitoring and telemetry for Azure Local clusters and workloads.

- [Azure Policy][azure-policy] is a service that evaluates Azure and on-premises resources. Azure Policy evaluates resources through integration with Azure Arc by using the properties of those resources to business rules, known as *policy definitions*, to determine compliance or capabilities that you can use to apply VM guest configuration via policy settings. In this architecture, Azure Policy provides an audit and compliance capability for the operating system security configuration of Azure Local machines. The settings are continually applied by using [drift control](/azure/azure-local/manage/manage-secure-baseline#configure-security-settings-during-deployment).

- [Defender for Cloud][ms-defender-for-cloud] is an infrastructure security management system. It enhances the security posture of datacenters and delivers advanced threat protection for hybrid workloads, whether they reside in Azure or elsewhere, and across on-premises environments. In this architecture, Defender for Cloud provides security monitoring and threat protection for workloads running on Azure Local.

- [Azure Backup][azure-backup] is a cloud-based service that provides a secure and cost-effective solution to back up data and recover it from the Microsoft Cloud. Azure Backup Server is used to take backup of VMs that are deployed on Azure Local and store them in the Backup service. In this architecture, Azure Backup protects data and enables recovery for virtual machines hosted on Azure Local.

- [Azure Site Recovery][azure-site-recovery] is a DR service that provides BCDR capabilities by enabling business apps and workloads to fail over if there's a disaster or outage. Site Recovery manages replication and failover of workloads that run on physical servers and VMs between their primary site (on-premises) and a secondary location (Azure). In this architecture, Site Recovery enables DR and failover for workloads running on Azure Local.

## Scenario details

The following sections provide more information about the scenarios and potential use cases for this reference architecture. These sections include a list of business benefits and example workload resource types that you can deploy on Azure Local.

### Use Azure Arc with Azure Local

Azure Local directly integrates with Azure by using Azure Arc to lower the total cost of ownership (TCO) and operational overhead. Azure Local is deployed and managed through Azure, which provides built-in integration of Azure Arc through deployment of the [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) component. This component is deployed as part of the Azure Local instance cloud deployment process. Azure Local machines are enrolled with [Azure Arc for servers](/azure/azure-local/deploy/deployment-arc-register-server-permissions) as a prerequisite for starting the cloud deployment of your Azure Local instance. During deployment, mandatory extensions are installed on each machine, such as Lifecycle Manager, Microsoft Edge Device Management, and telemetry and diagnostics extensions. You can use Azure Monitor and Log Analytics post-deployment to monitor the solution by enabling [Insights for Azure Local](/azure/azure-local/concepts/monitoring-overview). [Feature updates for Azure Local](/azure/azure-local/release-information-23h2) are released every six months to enhance customer experience. Updates for Azure Local are controlled and managed by using [Update Manager][azure-update-management].

You can deploy workload resources such as [Azure Arc VMs](/azure/azure-local/manage/create-arc-virtual-machines), [Azure Arc-enabled AKS][arc-enabled-aks], and [Azure Virtual Desktop session hosts](/azure/virtual-desktop/deploy-azure-virtual-desktop) that use the Azure portal by selecting an [Azure Local instance custom location](/azure/azure-local/manage/azure-arc-vm-management-overview#components-of-azure-local-vm-management) as the target for the workload deployment. These components provide centralized administration, management, and support. If you have active Software Assurance on your existing Windows Server Datacenter core licenses, you can reduce costs further by applying Azure Hybrid Benefit to Azure Local, Windows Server VMs, and AKS clusters. This optimization helps manage costs effectively for these services.

Azure and Azure Arc integration extend the capabilities of Azure Local virtualized and containerized workloads to include the following solutions:

- [Azure Local VMs][arc-enabled-vms] for traditional applications or services that run in VMs on Azure Local.

- [AKS on Azure Local][arc-enabled-aks] for containerized applications or services that benefit from using Kubernetes as their orchestration platform.

- [Virtual Desktop][virtual-desktop] to deploy your session hosts for Virtual Desktop workloads on Azure Local (on-premises). You can use the control and management plane in Azure to initiate the host pool creation and configuration.

- [Azure Arc-enabled data services][arc-enabled-data-services] for containerized Azure SQL Managed Instance.

- [Azure Arc-enabled Azure Container Apps](/azure/container-apps/azure-arc-overview) to run container-based applications and microservices. You can deploy it by using the Container Apps extension for Kubernetes, which enables the provisioning of connected Container Apps environments. After it's enabled on an AKS cluster, you can run services such as [Azure Functions](/azure/container-apps/functions-overview). To support event-driven scaling, you can optionally install the [Kubernetes Event-Driven Autoscaling (KEDA)](https://keda.sh/) extension.

- The [Azure Arc-enabled Azure Event Grid extension for Kubernetes](/azure/event-grid/kubernetes/install-k8s-extension) to deploy the [Event Grid broker and Event Grid operator](/azure/event-grid/kubernetes/concepts#event-grid-on-kubernetes-components) components. This deployment enables capabilities such as Event Grid topics and subscriptions for event processing.

- [Azure Arc-enabled machine learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere) with an AKS cluster that's deployed on Azure Local as the compute target to run Azure Machine Learning. You can use this approach to train or deploy machine learning models at the edge.

Azure Arc-connected workloads provide enhanced Azure consistency and automation for Azure Local deployments, like automating guest operating system configuration with [Azure Local VM extensions][arc-vm-extensions] or evaluating compliance with industry regulations or corporate standards through [Azure Policy][arc-azure-policy]. You can activate Azure Policy through the Azure portal or infrastructure as code (IaC) automation.

### Take advantage of the Azure Local default security configuration

The Azure Local default security configuration provides a defense-in-depth strategy to simplify security and compliance costs. The deployment and management of IT services for retail, manufacturing, and remote office scenarios presents unique security and compliance challenges. Securing workloads against internal and external threats is crucial in environments that have limited IT support or a lack or dedicated datacenters. Azure Local has default security hardening and deep integration with Azure services to help you address these challenges.

Azure Local-certified hardware ensures built-in Secure Boot, Unified Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) support. Use these technologies in combination with [virtualization-based security (VBS)][azure-local-vbs] to help protect your security-sensitive workloads. You can use BitLocker Drive Encryption to encrypt boot disk volumes and Storage Spaces Direct volumes at rest. Server Message Block (SMB) encryption provides automatic encryption of traffic between physical machines in the cluster (on the storage network) and signing of SMB traffic between the cluster physical machines and other systems. SMB encryption also helps prevent relay attacks and facilitates compliance with regulatory standards.

You can onboard Azure Local VMs in [Defender for Cloud][ms-defender-for-cloud] to activate cloud-based behavioral analytics, threat detection and remediation, alerting, and reporting. Manage Azure Local VMs in Azure Arc so that you can use [Azure Policy][arc-azure-policy] to evaluate their compliance with industry regulations and corporate standards.

## Potential use cases

Typical use cases for Azure Local include running HA workloads in on-premises or edge locations. Azure Local provides a platform to address requirements such as the following capabilities:

- Provide a cloud-connected solution that's deployed on-premises to address data sovereignty, regulation and compliance, or latency requirements.

- Deploy and manage HA-virtualized or container-based workloads that are deployed in a single or multiple edge locations. This capability enables business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- Reduce the TCO by deploying a solution certified by Microsoft and its hardware OEM partners. This solution uses a modern cloud-based deployment process and provides an Azure-consistent centralized management and monitoring experience.

- Provide a centralized provisioning capability by using Azure and Azure Arc. This functionality enables deployment of workloads across multiple locations consistently and securely. Tools like the Azure portal, the Azure CLI, or IaC templates (ARM templates, Bicep, and Terraform) improve automation and repeatability. This approach enables rapid deployment and management of Azure Kubernetes Service (AKS) clusters for containerized workloads and Azure Local VMs for traditional virtualized workloads.

- Adhere to strict security, compliance, and audit requirements. Azure Local is deployed with a hardened security posture configured by default, known as *secure-by-default*. Azure Local incorporates certified hardware, Secure Boot, TPM, VBS, Credential Guard, and enforced application control policies. Azure Local has the ability to integrate with modern cloud-based security and threat-management services like Microsoft Defender for Cloud and Microsoft Sentinel. This integration provides extended detection and response (XDR) and security information event management (SIEM) capabilities.

## Cluster design choices

Understand workload performance and reliability requirements. For resiliency, understand the expectations for the platform and workloads to continue operating during hardware or node failures. Also define recovery time objective (RTO) and recovery point objective (RPO) for your recovery strategy. Factor in compute, memory, and storage requirements for all workloads deployed on the Azure Local instance. Several characteristics of the workload affect the decision-making process:

- Central processing unit (CPU) architecture capabilities, including hardware security technology features, the number of CPUs, the gigahertz (GHz) frequency (speed), and the number of cores for each CPU socket.

- Graphics processing unit (GPU) requirements of the workload, such as for AI or machine learning, inferencing, or graphics rendering.

- The memory for each machine, or the quantity of physical memory required to run the workload.

- The number of physical machines in the instance that are 1 to 16 machines in scale. The maximum number of physical machines is four when you use the [storage switchless network architecture](/azure/architecture/hybrid/azure-local-switchless).

  - To maintain compute resiliency, you need to reserve at least N+1 physical machines worth of capacity in the instance. This strategy enables node draining for updates or recovery from sudden outages like power outages or hardware failures.

  - For business-critical or mission-critical workloads, consider reserving N+2 physical machines worth of capacity to increase resiliency. For example, if two physical machines in the instance are offline, the workload can remain online. This approach provides resiliency for scenarios in which a machine that's running a workload goes offline during a planned update procedure and results in two instance physical machines being offline simultaneously.
  
- Storage resiliency, capacity, and performance requirements:

  - **Resiliency:** We recommend that you deploy three or more physical machines to enable three-way mirroring, which provides three copies of the data, for the infrastructure and user volumes. Three-way mirroring increases performance and maximum reliability for storage.
  
  - **Capacity:** The total required usable storage after fault tolerance, or *copies*, is taken into consideration. This number is approximately 33% of the raw storage space of your capacity tier disks when you use three-way mirroring.
  
  - **Performance:** Input/output operations per second (IOPS) of the platform that determines the storage throughput capabilities for the workload when multiplied by the block size of the application.

To design and plan an Azure Local deployment, we recommend that you use the [Azure Local sizing tool][azure-local-sizer-tool] and create a **New Project** for sizing your Azure Local instances. Using the sizing tool requires you to understand your workload requirements. When you consider the number and size of workload VMs that run on your instance, make sure to consider factors such as the number of vCPUs, memory requirements, and necessary storage capacity for the VMs.

The sizing tool **Preferences** section guides you through questions that relate to the system type, including Premier Solution, Integrated System, or Validated Node, and CPU family options. It also helps you select your resiliency requirements for the instance. To set resiliency levels, follow these recommendations:

- Reserve a minimum of N+1 physical machines worth of capacity, or one node, across the instance. This approach ensures that you can apply solution updates by draining and restarting each node one at a time, without causing workload downtime.

- Reserve N+2 physical machines worth of capacity across the instance for extra resiliency. This option enables the system to withstand a machine failure during an update or other unexpected event that affects two machines simultaneously. It also ensures that there's enough capacity in the instance for the workload to run on the remaining online machines.

This scenario requires use of three-way mirroring for user volumes, which is the default for instances that have three or more physical machines.

The output from the Azure Local sizing tool is a list of recommended hardware solution SKUs that can provide the required workload capacity and platform resiliency requirements based on the input values in the Sizer Project. For more information about available OEM hardware partner solutions, see [Azure Local solutions catalog](https://azurestackhcisolutions.azure.microsoft.com/#catalog). To help correctly size solution SKUs to meet your requirements, contact your preferred hardware solution provider or system integration (SI) partner.

### Physical disk drives

[Storage Spaces Direct][s2d-disks] supports multiple physical disk drive types that vary in performance and capacity. When you design an Azure Local instance, work with your chosen hardware OEM partner to determine the most appropriate physical disk drive types to meet the capacity and performance requirements of your workload. Examples include spinning hard disk drives (HDDs), or solid-state drives (SSDs) and Non-Volatile Memory Express (NVMe) drives. These drives are often known as *flash drives*, or [persistent memory (PMem) storage](/azure/azure-local/concepts/deploy-persistent-memory), which is known as *storage-class memory (SCM)*.

The reliability of the platform depends on the performance of critical platform dependencies, such as physical disk types. Make sure to choose the correct disk types for your requirements. Use all-flash storage solutions such as NVMe drives or SSDs for workloads that have high-performance or low-latency requirements. These workloads include but aren't limited to highly transactional database technologies, production AKS clusters, or any mission-critical or business-critical workloads that have low-latency or high-throughput storage requirements. Use all-flash deployments to maximize storage performance. All-NVMe drive or all-SSD configurations, especially at a small scale, improve storage efficiency and maximize performance because no drives are used as a cache tier. For more information, see [All-flash based storage](/azure/azure-local/concepts/cache#all-flash-deployment-possibilities).

:::image type="complex" source="images/azure-local-baseline-storage-architecture.png" alt-text="Diagram that shows a multi-node Azure Local instance storage architecture for a hybrid storage solution. It uses NVMe drives as the cache tier and SSD drives for capacity." lightbox="images/azure-local-baseline-storage-architecture.png" border="false":::
    The diagram shows a multi-node cluster. Each node has two network adapters for storage and two for management and compute. The storage adapters connect to a storage network. The management and compute adapters connect to a management and compute network. Beneath the network layer, the diagram shows the storage stack. It starts with physical disks at the bottom, which include NVMe disks in the cache tiers and SSDs in the capacity tiers. Above the disks is the Storage Spaces Direct storage pool. The next layer in this section is the ReFS file system on a CSV. The next layer includes virtual disks for VMs. The top layer shows two VMs, with an arrow that indicates that they can be live migrated between the nodes.
:::image-end:::

The physical disk drive type influences the performance of your cluster storage. The type of drive varies based on the performance characteristics of each drive type and the caching mechanism that you choose. The physical disk drive type is an integral part of any Storage Spaces Direct design and configuration. Depending on the Azure Local workload requirements and budget constraints, you can choose to [maximize performance][s2d-drive-max-performance], [maximize capacity][s2d-drive-max-capacity], or implement a mixed-drive type configuration that [balances performance and capacity][s2d-drive-balance-performance-capacity].

For general-purpose workloads that require large capacity persistent storage, a [hybrid storage configuration](/azure/azure-local/concepts/cache#hybrid-deployment-possibilities) can provide the most usable storage, such as using NVMe drives or SSDs for the cache tier and HDDs for capacity. The trade-off is that spinning drives have lower performance and throughput capabilities compared to flash drives. These limitations can affect storage performance if your workload exceeds the [cache working set][s2d-cache-sizing]. Also, HDDs have a lower mean time between failure value compared to NVMe drives and SSDs.

Storage Spaces Direct provides a [built-in, persistent server-side cache][s2d-cache] that supports both read and write operations. This cache maximizes storage performance. Size and configure the cache to accommodate the [working set of your applications and workloads][s2d-cache-sizing]. Storage Spaces Direct virtual disks, or *volumes*, are used in combination with cluster shared volume (CSV) in-memory read cache to [improve Hyper-V performance][azure-local-csv-cache]. This combination is especially effective for unbuffered input access to workload virtual hard disk (VHD) or virtual hard disk v2 (VHDX) files.

> [!TIP]
> For high-performance or latency-sensitive workloads, we recommend that you use an [all-flash storage (all NVMe or all SSD) configuration](/azure/azure-local/concepts/choose-drives#option-1--maximizing-performance) and a cluster size of three or more physical machines. Deploying this design with the *default storage configuration* settings uses [three-way mirroring](/azure/azure-local/concepts/fault-tolerance#three-way-mirror) for the infrastructure and user volumes. This deployment strategy provides the highest performance and resiliency. When you use an all-NVMe or all-SSD configuration, you benefit from the full usable storage capacity of each flash drive. Unlike hybrid or mixed NVMe and SSD setups, there's no capacity reserved for caching when you use a single drive type. This configuration ensures optimal utilization of your storage resources. For more information about how to balance performance and capacity to meet your workload requirements, see [Plan volumes - When performance matters most][s2d-plan-volumes-performance].

### Network design

Network design is the overall arrangement of components within the network's physical infrastructure and logical configurations. You can use the same physical network interface card (NIC) ports for all combinations of management, compute, and storage network intents. Using the same NIC ports for all intent-related purposes is known as a *fully converged networking configuration*.

A fully converged networking configuration is supported, but the optimal configuration for performance and reliability is for the storage intent to use dedicated network adapter ports. As a result, this baseline architecture provides example guidance for how to deploy a multi-node Azure Local instance by using the storage switched network architecture with two network adapter ports that are converged for management and compute intents and two dedicated network adapter ports for the storage intent. For more information, see [Network considerations for cloud deployments of Azure Local](/azure/azure-local/plan/cloud-deployment-network-considerations).

This architecture requires two or more physical machines and up to a maximum of 16 machines in scale. Each machine requires four network adapter ports that are connected to two top-of-rack (ToR) switches. The two ToR switches should be interconnected through multi-chassis link aggregation group (MLAG) links. The two network adapter ports that are used for the storage intent traffic must support [Remote Direct Memory Access (RDMA)](/azure/azure-local/concepts/host-network-requirements#rdma). These ports require a minimum link speed of 10 gigabits per second (Gbps), but we recommend a speed of 25 Gbps or higher. The two network adapter ports used for the management and compute intents are converged by using Switch Embedded Teaming (SET) technology. SET technology provides link redundancy and load-balancing capabilities. These ports require a minimum link speed of 1 Gbps, but we recommend a speed of 10 Gbps or higher.

#### Physical network topology

The following physical network topology shows the physical network connections between the Azure Local machines and networking components.

You need the following components when you design a multi-node storage switched Azure Local deployment that uses this baseline architecture.

:::image type="complex" border="false" source="images/azure-local-baseline-physical-network.png" alt-text="Diagram that shows the physical networking topology for a multi-node Azure Local instance that uses a storage switched architecture with dual ToR switches." lightbox="images/azure-local-baseline-physical-network.png":::
  The image shows the physical network topology for a multi-node Azure Local instance that uses a storage switched architecture with dual ToR switches. The diagram highlights the connections between physical machines, ToR switches, and external networks. It emphasizes redundancy and dedicated RDMA-capable ports for storage traffic.
:::image-end:::

- Dual ToR switches:

  - Dual ToR network switches are required for network resiliency and to service or apply firmware updates to the switches without incurring downtime. This strategy prevents a single point of failure (SPoF).
  
  - The dual ToR switches are used for the storage, or east-west, traffic. These switches use two dedicated Ethernet ports that have specific storage virtual local area networks (VLANs) and priority flow control (PFC) traffic classes that are defined to provide lossless RDMA communication.
  
  - These switches connect to the physical machines through Ethernet cables.
  
- Two or more physical machines and up to a maximum of 16 physical machines:

  - Each machine is a physical server that runs Azure Stack HCI operating system.
  
  - Each machine requires four network adapter ports in total: two RDMA-capable ports for storage and two network adapter ports for management and compute traffic.
  
  - Storage uses the two dedicated RDMA-capable network adapter ports that connect with one path to each of the two ToR switches. This approach provides link-path redundancy and dedicated prioritized bandwidth for SMB Direct storage traffic.
  
  - Management and compute uses two network adapter ports that provide one path to each of the two ToR switches for link-path redundancy.
  
- External connectivity:

  - Dual ToR switches connect to the external network, such as your internal corporate local area network (LAN), to provide access to the required outbound URLs by using your edge border network device. This device can be a firewall or router. These switches route traffic that goes in and out of the Azure Local instance, or north-south traffic.
  
  - External north-south traffic connectivity supports the cluster management intent and compute intents. This networking configuration is achieved by using two switch ports and two network adapter ports for each machine that are converged through SET and a virtual switch within Hyper-V to ensure resiliency. These components provide external connectivity for Azure Local VMs and other workload resources deployed within the logical networks that are created in Resource Manager by using the Azure portal, the Azure CLI, or IaC templates.

#### Logical network topology

The logical network topology shows an overview of how network data flows between devices, regardless of their physical connections.

The following example shows a summarization of the logical setup for this multi-node storage switched baseline architecture for Azure Local.

:::image type="complex" source="images/azure-local-baseline-logical-network.png" alt-text="Diagram that shows the logical networking topology for a multi-node Azure Local instance by using the storage switched architecture with dual ToR switches." lightbox="images/azure-local-baseline-logical-network.png" border="false":::
    The diagram shows the logical network topology for a multi-node Azure Local instance that uses a storage switched architecture. It illustrates the flow of network traffic between components. The diagram shows two physical nodes, each with multiple network adapters. Network ATC is used to define intents for management, compute, and storage traffic. The management and compute intents are converged onto a virtual switch that uses a SET. The storage intent uses dedicated RDMA-capable adapters. The diagram also depicts logical networks for VMs and the connection to the external network via the ToR switches.
:::image-end:::

- Dual ToR switches:

  - Before you deploy the cluster, the two ToR network switches need to be configured with the required VLAN IDs, maximum transmission unit settings, and datacenter bridging configuration for the *management*, *compute*, and *storage* ports. For more information, see [Physical network requirements for Azure Local](/azure/azure-local/concepts/physical-network-requirements), or ask your switch hardware vendor or SI partner for assistance.
  
- [Network ATC](/azure/azure-local/deploy/network-atc):
  
  - Azure Local uses the [Network ATC approach](/azure/azure-local/deploy/network-atc) to apply network automation and intent-based network configuration.
  
  - Azure Local uses the [Network ATC approach](/azure/azure-local/deploy/network-atc) to apply network automation and intent-based network configuration.
  
  - Network ATC is designed to ensure optimal networking configuration and traffic flow by using network traffic *intents*. Network ATC defines which physical network adapter ports are used for the different network traffic intents (or types), such as for the cluster *management*, workload *compute*, and cluster *storage* intents.
  
  - Intent-based policies simplify the network configuration requirements by automating the machine network configuration based on parameter inputs that are specified as part of the Azure Local cloud deployment process.
  
- External communication:

  - When the physical machines or workload need to communicate externally by accessing the corporate LAN, internet, or another service, they [route via the dual ToR switches](#physical-network-topology).
  
  - When the two ToR switches serve as Layer 3 devices, they handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  
  - Management network intent uses the converged SET team virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - For the compute network intent, you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as VMs, use these IDs to give access to the physical network. The logical networks use the two physical network adapter ports that are converged by using an SET team for the compute and management intents.
  
- Storage traffic:

  - The physical machines communicate with each other by using two dedicated network adapter ports that are connected to the ToR switches to provide high bandwidth and resiliency for storage traffic.
  
  - The *SMB1* and *SMB2* storage ports connect to two separate nonroutable (or Layer 2) networks. Each network has a specific VLAN ID configured that must match the switch ports configuration on the ToR switches' *default storage VLAN IDs: 711 and 712*.
  
  - There's *no default gateway* configured on the two storage intent network adapter ports within the Azure Stack HCI operating system.
  
  - Each cluster node can access Storage Spaces Direct capabilities of the cluster, such as remote physical drives that are used in the storage pool, virtual disks, and volumes. Access to these capabilities is facilitated through the SMB-Direct RDMA protocol over the two dedicated storage network adapter ports that are available in each machine. SMB Multichannel is used for resiliency.
  
  - This configuration provides sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

#### Network switch requirements

Your Ethernet switches must meet the different specifications required by Azure Local and set by the Institute of Electrical and Electronics Engineers Standards Association (IEEE SA). For example, for multi-node storage switched deployments, the storage network is used for [RDMA via RoCE v2 or iWARP](/azure/azure-local/concepts/host-network-requirements#rdma). This process requires IEEE 802.1Qbb PFC to ensure lossless communication for the [storage traffic class](/azure/azure-local/concepts/host-network-requirements#rdma-traffic-class). Your ToR switches must provide support for IEEE 802.1Q for VLANs and IEEE 802.1AB for the Link Layer Discovery Protocol.

If you plan to use existing network switches for an Azure Local deployment, review the [list of mandatory IEEE standards and specifications](/azure/azure-local/concepts/physical-network-requirements#network-switch-requirements) that the network switches and configuration must provide. When you purchase new network switches, review the [list of hardware vendor-certified switch models that support Azure Local network requirements](/azure/azure-local/concepts/physical-network-requirements#network-switches-for-azure-stack-hci).

#### IP address requirements

In a multi-node storage switched deployment, the number of IP addresses needed increases with the addition of each physical machine, up to a maximum of 16 physical machines within a single cluster. For example, to deploy a two-node storage switched configuration of Azure Local, the cluster infrastructure requires a minimum of 11 x IP addresses to be allocated. More IP addresses are required if you use micro-segmentation or software-defined networking. For more information, see [Review two-node storage reference pattern IP address requirements for Azure Local](/azure/azure-local/plan/two-node-ip-requirements).

When you design and plan IP address requirements for Azure Local, remember to account for extra IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Local instance and infrastructure components. If you plan to deploy AKS on Azure Local, see [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

#### Outbound network connectivity

It's important to understand the outbound network connectivity requirements of Azure Local and factor these requirements into your design and implementation plan before you deploy the solution. Outbound network connectivity is required to enable Azure Local to communicate with Azure and Azure Arc for management and control plane operations. For example, outbound connectivity is necessary to provision Azure Arc-enabled resources such as Azure Local VMs or AKS clusters, and to use Azure management services like Update Manager and Azure Monitor.

Upfront planning and due diligence for enabling network communication to the required public endpoints is critically important when you integrate Azure Local into an existing on-premises datacenter network. This requirement is especially important if you have strict egress rules configured on proxy or firewall devices. Also, if your network security controls include Secure Sockets Layer (SSL) inspection technologies, be aware that SSL inspection isn't supported for Azure Local network communication.

#### Why outbound network connectivity matters

Outbound network connectivity is required from your Azure Local instance. This requirement includes the physical machines, the [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) appliance, AKS clusters, and Azure Local VMs if you use Azure Arc for VM guest operating system management. These devices have local agents or services that connect to public endpoints by using outbound network access for real-time communication, which enables connectivity to the management and control plane resource providers that run in Azure. For example, outbound connectivity is necessary for operators to use the Azure portal, the Azure CLI, or IaC tools such as ARM, Bicep, or Terraform templates to provision resources, manage them, or perform both actions. Azure and the Azure Arc resource bridge work in combination with your Azure Local instance's [custom location](/azure/azure-arc/platform/conceptual-custom-locations) resource. This combination enables you to target the specific Azure Local instance for any resource CRUD (*create, read, update, or delete*) operations for your Azure Arc-enabled workload resources.

To enable connectivity, configure your firewall, proxy, or internet egress technology, or a combination of these components, to allow outbound access to the required public endpoints. Consider the following key considerations for Azure Local outbound network requirements:

- Azure Local doesn't support SSL / TLS packet inspection along any of the networking paths from your Azure Local instances to the public endpoints. Additionally, Private Link and Azure ExpressRoute aren't supported for the connectivity to the required public endpoints. For more information, see [Firewall requirements for Azure Local](/azure/azure-local/concepts/firewall-requirements).

- Consider using the [Azure Arc gateway](/azure/azure-local/deploy/deployment-azure-arc-gateway-overview) to simplify connectivity requirements. This approach significantly reduces the number of required endpoints that need to be added to your firewall or proxy rules for the deployment and management of Azure Local.

- When you deploy Azure Local by using a proxy server to control and manage internet egress access, review the [proxy requirements](/azure/azure-local/plan/cloud-deployment-network-considerations#proxy-requirements).

### Monitoring

Insights for Azure Local is built on Azure Monitor and Log Analytics, which ensures an always up-to-date, scalable solution that's highly customizable. Insights provides access to default workbooks with basic metrics, along with specialized workbooks created for monitoring key features of Azure Local. These components provide a near real-time monitoring solution and enable the creation of graphs, customization of visualizations through aggregation and filtering, and configuration of custom resource health alert rules.

To enhance monitoring and alerting, enable [Azure Monitor Insights on Azure Local](/azure/azure-local/concepts/monitoring-overview). Insights can scale to monitor and manage multiple on-premises instances through an Azure-consistent experience. Insights uses cluster performance counters and event log channels to monitor key Azure Local features. The DCR that's configured through Azure Monitor and Log Analytics collects the logs.

### Update management

Azure Local instances and the deployed workload resources, such as Azure Local VMs, need to be updated and patched regularly. By regularly applying updates, you ensure that your organization maintains a strong security posture. You also improve the overall reliability and supportability of your estate. We recommend that you use automatic and periodic manual assessments for early discovery and application of security patches and operating system updates.

#### Infrastructure updates

Azure Local is continuously updated to enhance the customer experience and introduce new features and functionality. Feature updates are delivered every six months through release trains, with new versions released in April (YY04) and October (YY10). In addition to regular feature updates, Azure Local receives monthly cumulative updates that include operating system security and reliability improvements, as well as updates to extensions and agents.

Update Manager is an Azure service that you can use to apply, view, and manage updates for Azure Local. This service provides a mechanism to view all Azure Local instances across your entire infrastructure and edge locations that use the Azure portal to provide a centralized management experience. For more information, see the following resources:

- [Azure Local release information](/azure/azure-local/release-information-23h2#about-azure-stack-hci-version-23h2-releases)
- [Azure Local life cycle cadence](/azure/azure-local/update/about-updates-23h2#lifecycle-cadence)
- [Review update phases of Azure Local](/azure/azure-local/update/update-phases-23h2)
- [Use Update Manager to update Azure Local](/azure/azure-local/update/azure-update-manager-23h2)

It's important to check for new driver and firmware updates regularly, such as every three to six months. If you use a Premier Solution category version for your Azure Local hardware, the [Solution Builder Extension (SBE) package updates](/azure/azure-local/update/solution-builder-extension) are integrated with Update Manager to provide a simplified update experience. If you use validated nodes or an integrated system category, there might be a requirement to download and run an OEM-specific update package that contains the firmware and driver updates for your hardware. To determine how updates are supplied for your hardware, contact your hardware OEM or SI partner.

#### Workload guest operating system patching

You can enroll Azure Local VMs that are deployed on Azure Local into [Update Manager][azure-update-management] to provide a unified patch management experience by using the same mechanism used to update the Azure Local instance physical machines. You can use Update Manager to create [guest maintenance configurations](/azure/virtual-machines/maintenance-configurations#guest). These configurations control settings such as the Reboot setting *reboot if necessary*, the schedule (dates, times, and repeat options), and either a dynamic (subscription) or static list of the Azure Local VMs for the scope. These settings control the configuration for when operating system security patches are installed inside your workload VM's guest operating system.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Identify the potential failure points

Every architecture is susceptible to failures. You can anticipate failures and be prepared with mitigations by using failure mode analysis (FMA). The following table describes four examples of potential points of failure in this architecture.

| Component | Risk | Likelihood | Impact and mitigation | Outage |
|-----------|------|------------|-----------------------|----|
| Azure Local instance outage | Power, network, hardware, or software failure | Medium | To prevent a prolonged application outage caused by the failure of an Azure Local instance for business-critical or mission-critical use cases, your workload should be architected by using HA and DR principles. For example, you can use industry-standard workload data replication technologies to maintain multiple copies of persistent state data that are deployed by using multiple Azure Local VMs or AKS instances that are deployed on separate Azure Local instances and in separate physical locations. | Potential outage |
| Azure Local single physical machine outage | Power, hardware, or software failure | Medium | To prevent a prolonged application outage caused by the failure of a single Azure Local machine, your Azure Local instance should have multiple physical machines. Your workload capacity requirements during the cluster design phase determine the number of physical machines. We recommend that you have three or more physical machines. We also recommended that you use three-way mirroring, which is the default storage resiliency mode for clusters with three or more physical machines. To prevent a SPoF and increase workload resiliency, deploy multiple instances of your workload by using two or more Azure Local VMs or container pods that run on multiple AKS worker nodes. If a single machine fails, the Azure Local VMs and workload or application services are restarted on the remaining online physical machines in the cluster. | Potential outage |
| Azure Local VM or AKS worker node (workload) | Misconfiguration | Medium | Application users are unable to sign in or access the application. Identify misconfigurations during deployment. If these errors occur during a configuration update, DevOps team must roll back changes. You can redeploy the VM if necessary. Redeployment takes less than 10 minutes to deploy but can take longer according to the type of deployment. | Potential outage |
| Connectivity to Azure | Network outage | Medium | Azure Local requires network connectivity to Azure for control plane operations to be available. For example, to provision new Azure Local VMs or AKS clusters, install solution updates by using Update Manager, or monitor health status of the instance by using Azure Monitor. If connectivity to Azure is unavailable, the instance operates in a degraded state, where these capabilities aren't available. However, existing workloads that already run on Azure Local continue to run. [If network connectivity to Azure isn't restored within 30 days](/azure/azure-local/faq#how-long-can-azure-local-run-with-the-connection-down), the instance enters an "Out Of Policy" status, which can limit functionality. The [Azure resource bridge appliance can't be offline for more than 45 days](/azure/azure-arc/resource-bridge/troubleshoot-resource-bridge#arc-resource-bridge-is-offline) because this inactivity can affect the validity of the security key used for authentication. | Management operations unavailable |

  For more information, see [Recommendations for performing FMA](/azure/well-architected/reliability/failure-mode-analysis).

#### Reliability targets

This section describes an example scenario. A fictitious customer known as *Contoso Manufacturing* uses this reference architecture to deploy Azure Local. They want to address their requirements and deploy and manage workloads on-premises. Contoso Manufacturing has an internal service-level objective (SLO) target of 99.8% that business and application stakeholders agree on for their services.

- An SLO of 99.8% uptime, or availability, results in the following periods of allowed downtime, or unavailability, for the applications that are deployed by using Azure Local VMs that run on Azure Local:

  - Weekly: 20 minutes and 10 seconds

  - Monthly: 1 hour, 26 minutes, and 56 seconds

  - Quarterly: 4 hours, 20 minutes, and 49 seconds

  - Yearly: 17 hours, 23 minutes, and 16 seconds

- **To help meet the SLO targets**, Contoso Manufacturing implements the principle of least privilege (PoLP) to restrict the number of Azure Local instance administrators to a small group of trusted and qualified individuals. This approach helps prevent downtime because of inadvertent or accidental actions performed on production resources. Furthermore, the security event logs for on-premises Active Directory Domain Services (AD DS) domain controllers are monitored to detect and report any user account group membership changes, known as *add* and *remove* actions, for the *Azure Local instance administrators* group that uses a SIEM solution. Monitoring increases reliability and improves the security of the solution.

  For more information, see [Recommendations for identity and access management](/azure/well-architected/security/identity-access).

- **Strict change control procedures** are in place for Contoso Manufacturing's production systems. This process requires that all changes are tested and validated in a representative test environment before implementation in production. All changes submitted to the weekly change advisory board process must include a detailed implementation plan (or link to source code), risk level score, a comprehensive rollback plan, post-release testing and verification, and clear success criteria for a change to be reviewed or approved.

  For more information, see [Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Monthly security patches and quarterly baseline updates** are applied to production Azure Local instances only after they're validated by the preproduction environment. Update Manager and the cluster-aware updating feature automate the process of using [VM live migration](/windows-server/virtualization/hyper-v/manage/live-migration-overview) to minimize downtime for business-critical workloads during the monthly servicing operations. Contoso Manufacturing standard operating procedures require that security, reliability, or baseline build updates are applied to all production systems within four weeks of their release date. Without this policy, production systems are perpetually unable to stay current with monthly operating system and security updates. Out-of-date systems negatively affect platform reliability and security.

  For more information, see [Recommendations for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Contoso Manufacturing implements daily, weekly, and monthly backups** to retain the last 6 x days of daily backups (Mondays to Saturdays), the last 3 x weekly (each Sunday) and 3 x monthly backups, with each *Sunday week 4* being retained to become the month 1, month 2, and month 3 backups by using a *rolling calendar based schedule* that's documented and auditable. This approach meets Contoso Manufacturing requirements for an adequate balance between the number of data recovery points available and reducing costs for the offsite or cloud backup storage service.

  For more information, see [Recommendations for designing a DR strategy](/azure/well-architected/reliability/disaster-recovery).

- **Data backup and recovery processes are tested** for each business system every six months. This strategy provides assurance that BCDR processes are valid and that the business is protected if a datacenter disaster or cyber incident occurs.

  For more information, see [Recommendations for designing a reliability testing strategy](/azure/well-architected/reliability/testing-strategy).

- **The operational processes and procedures** described previously in the article, and the recommendations in the [Well-Architected Framework service guide for Azure Local](/azure/well-architected/service-guides/azure-local), enable Contoso Manufacturing to meet their 99.8% SLO target and effectively scale and manage Azure Local and workload deployments across multiple manufacturing sites that are distributed around the world.

  For more information, see [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

#### Redundancy

Consider a workload that you deploy on a single Azure Local instance as a *locally redundant deployment*. The cluster provides HA at the platform level, but you must deploy the cluster in a single rack. For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Local instances, ideally in separate physical locations.

Use industry-standard, HA patterns for workloads that provide active/passive replication, synchronous replication, or asynchronous replication such as [SQL Server Always On](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server). You can also use an external network load balancing (NLB) technology that routes user requests across the multiple workload instances that run on Azure Local instances that you deploy in separate physical locations. Consider using a partner external NLB device. Or you can evaluate the [load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview) that support traffic routing for hybrid and on-premises services, such as an Azure Application Gateway instance that uses ExpressRoute or a VPN tunnel to connect to an on-premises service.

For more information, see [Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- **A secure foundation for the Azure Local platform:** [Azure Local][azure-local-basic-security] is a secure-by-default product that uses validated hardware components with a TPM, UEFI, and Secure Boot to build a secure foundation for the Azure Local platform and workload security. When deployed with the default security settings, Azure Local has Application Control, Credential Guard, and BitLocker enabled. To simplify delegating permissions by using the PoLP, use [Azure Local built-in role-based access control (RBAC) roles][azure-local-rbac] such as Azure Local Administrator for platform administrators and Azure Local VM Contributor or Azure Local VM Reader for workload operators.

- **Default security settings:** Azure Local applies [default security settings][azure-local-security-default] for your Azure Local instance during deployment and [enables drift control](/azure/azure-local/manage/manage-secure-baseline) to keep the physical machines in a known good state. You can use the security default settings to manage cluster security, drift control, and secured core server settings on your cluster.

- **Security event logs:** [Azure Local syslog forwarding][azure-local-security-syslog] integrates with security monitoring solutions by retrieving relevant security event logs to aggregate and store events for retention in your own SIEM platform.

- **Protection from threats and vulnerabilities:** [Defender for Cloud][azure-local-defender-for-cloud] protects your Azure Local instance from various threats and vulnerabilities. This service helps improve the security posture of your Azure Local environment and can protect against existing and evolving threats.

- **Threat detection and remediation:** [Microsoft Advanced Threat Analytics][ms-ata] detects and remediates threats, such as threats that target AD DS, that provide authentication services to Azure Local instance machines and their Windows Server VM workloads.

- **Network isolation:** Isolate networks if needed. For example, you can provision multiple logical networks that use separate VLANs and network address ranges. When you use this approach, ensure that the management network can reach each logical network and VLAN so that Azure Local instance physical machines can communicate with the VLAN networks through the ToR switches or gateways. This configuration is required for management of the workload, such as allowing infrastructure management agents to communicate with the workload guest operating system.

  For more information, see [Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- **Cloud-style billing model for licensing:** Azure Local pricing follows the [monthly subscription billing model][azure-local-billing] with a flat rate for each physical processor core in an Azure Local instance. Extra usage charges apply if you use other Azure services. If you own on-premises core licenses for Windows Server Datacenter edition with active Software Assurance, you might choose to exchange these licenses to activate Azure Local instance and Windows Server VM subscription fees.

- **Automatic VM guest patching for Azure Local VMs:** This feature helps reduce the overhead of manual patching and the associated maintenance costs. Not only does this action help make the system more secure, but it also optimizes resource allocation and contributes to overall cost efficiency.

- **Cost monitoring consolidation:** To consolidate monitoring costs, use [Azure Local Insights](/azure/azure-local/concepts/monitoring-overview#insights) and patch by using [Update Manager for Azure Local](/azure/azure-local/update/about-updates-23h2). Azure Local Insights uses Azure Monitor to provide rich metrics and alerting capabilities. The life cycle manager component of Azure Local integrates with Update Manager to simplify the task of keeping your clusters up-to-date by consolidating update workflows for various components into a single experience. Use Azure Monitor and Update Manager to optimize resource allocation and contribute to overall cost efficiency.

  For more information, see [Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

- **Initial workload capacity and growth:** When you plan your Azure Local deployment, consider your initial workload capacity, resiliency requirements, and future growth considerations. Consider if using a two, three, or four-node storage switchless architecture can reduce costs, such as removing the need to procure storage-class network switches. Procuring extra storage class network switches can be an expensive component of new Azure Local instance deployments. Instead, you can use existing switches for management and compute networks, which simplify the infrastructure. If your workload capacity and resiliency needs don't scale beyond a four-node configuration, consider using existing switches for the management and compute networks, and use the [storage switchless architecture](azure-local-switchless.yml) to deploy Azure Local.

  For more information, see [Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

> [!TIP]
> You can reduce costs through Azure Hybrid Benefit if you hold Windows Server Datacenter licenses that include active Software Assurance. For more information, see [Azure Hybrid Benefit for Azure Local][azs-hybrid-benefit].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- **Simplified provisioning and management experience integrated with Azure:** The [cloud-based deployment in Azure][azure-local-deploy-via-portal] provides a wizard-driven interface that shows you how to create an Azure Local instance. Similarly, Azure simplifies the process of [managing Azure Local instances][azure-local-manage-cluster-at-scale] and [Azure Local VMs](/azure/azure-local/manage/azure-arc-vm-management-overview). You can automate the portal-based deployment of the Azure Local instance by using [this ARM template][azure-local-deploy-via-template]. Using templates provides consistency and automation to deploy Azure Local at scale, specifically in edge scenarios such as retail stores or manufacturing sites that require an Azure Local instance to run business-critical workloads.

- **Automation capabilities for Azure Virtual Machines:** Azure Local provides a wide range of automation capabilities for managing workloads, such as Azure Local VMs. These capabilities include the automated deployment of Azure Local VMs by using the Azure CLI, ARM templates, or Bicep templates. VM operating system updates are delivered through the Azure Arc extension for updates and [Update Manager][azure-update-management], which applies updates to each Azure Local instance. Azure Local also provides support for [Azure Local VM management][azure-local-vm-automate-cli] by using the Azure CLI and [non-Azure Local VMs][azure-local-manage-non-arc-vms] by using Windows PowerShell. You can run the Azure CLI commands locally from one of the Azure Local machines or remotely from a management computer. Integration with [Azure Automation][az-auto-hybrid-worker] and Azure Arc facilitates a wide range of extra automation scenarios for [VM workloads][arc-vm-extensions] through Azure Arc extensions.

  For more information, see [Recommendations for using IaC](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- **Automation capabilities for containers on AKS:** Azure Local provides a wide range of automation capabilities for managing workloads, such as containers, on AKS. You can [automate the deployment of AKS clusters by using the Azure CLI][azure-local-automate-arc-aks]. Use the Azure Arc extension for [Kubernetes updates][azure-local-automate-aks-update] to update AKS workload clusters. You can also manage [Azure Arc-enabled AKS][azure-local-aks-automate-cli] by using the Azure CLI. You can run the Azure CLI commands locally from one of the Azure Local machines or remotely from a management computer. Integrate with Azure Arc for a wide range of extra automation scenarios for [containerized workloads][azure-local-k8s-gitops] through Azure Arc extensions.

  For more information, see the following resources:

  - [Recommendations for enabling automation](/azure/well-architected/operational-excellence/enable-automation)
  - [Compare management capabilities of VMs on Azure Local](/azure/azure-local/concepts/compare-vm-management-capabilities)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Workload storage performance:** Consider using the [DiskSpd](/previous-versions/azure/azure-local/manage/diskspd-overview) tool to test workload storage performance capabilities of an Azure Local instance. You can use the VMFleet tool to generate load and measure the performance of a storage subsystem. Determine whether you should use [VMFleet](https://github.com/microsoft/diskspd/wiki/VMFleet) to measure storage subsystem performance.

  We recommend that you establish a baseline for your Azure Local instances performance before you deploy production workloads. DiskSpd uses various command-line parameters that enable administrators to test the storage performance of the cluster. The main function of DiskSpd is to issue read and write operations and output performance metrics, such as latency, throughput, and IOPs.

  For more information, see [Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test).

- **Workload storage resiliency:** Consider the benefits of [storage resiliency][s2d-resiliency], usage (or capacity) efficiency, and performance. Planning for Azure Local volumes includes identifying the optimal balance between resiliency, usage efficiency, and performance. You might find it difficult to optimize this balance because maximizing one of these characteristics typically has a negative effect on one or more of the other characteristics. Increasing resiliency reduces the usable capacity. As a result, the performance might vary, depending on the chosen resiliency type. When resiliency and performance are the priority, and when you use three or more physical machines, the default storage configuration employs three-way mirroring for both infrastructure and user volumes.

  For more information, see [Recommendations for capacity planning](/azure/well-architected/performance-efficiency/capacity-planning).

- **Network performance optimization:** Consider network performance optimization. As part of your design, be sure to include projected [network traffic bandwidth allocation][azure-local-network-bandwidth-allocation] when you determine your [optimal network hardware configuration][azure-local-networking].

  To optimize compute performance in Azure Local, you can use GPU acceleration. GPU acceleration is beneficial for [high-performance AI or machine learning workloads][azure-local-gpu-acceleration] that involve data insights or inferencing. These workloads require deployment at edge locations because of considerations like data gravity or security requirements. In a hybrid deployment or on-premises deployment, it's important to take your workload performance requirements, including GPUs, into consideration. This approach helps you select the correct services when you design and procure your Azure Local instances.

  For more information, see [Recommendations for selecting the correct services](/azure/well-architected/performance-efficiency/select-services).

## Deploy this scenario

The following section provides an example list of the high-level tasks or typical workflow used to deploy Azure Local, including prerequisite tasks and considerations. This workflow list is intended as an example guide only. It isn't an exhaustive list of all required actions, which can vary based on organizational, geographic, or project-specific requirements.

In this scenario, a project or use case requires you to deploy a hybrid cloud solution in an on-premises or edge location to deliver local compute for data processing. There's also a need to maintain Azure-consistent management and billing experiences. More details are described in the **[Potential use cases](#potential-use-cases)** section of this article. The remaining steps assume that Azure Local is the chosen infrastructure platform solution for the project.

1. **Gather workload and use case requirements from relevant stakeholders.** This strategy enables the project to confirm that the features and capabilities of Azure Local meet the workload scale, performance, and functionality requirements. This review process should include understanding the workload scale, or size, and required features such as Azure Local VMs, AKS, Virtual Desktop, or Azure Arc-enabled data services or the Azure Arc-enabled Machine Learning service. The workload RTO and RPO (reliability) values and other nonfunctional requirements (performance and load scalability) should be documented as part of this step.

1. **Review the Azure Local sizer output for the recommended hardware partner solution.** This output includes details of the recommended physical server hardware make and model, number of physical machines, and the specifications for the CPU, memory, and storage configuration for each physical node to deploy and run your workloads.

1. **Use the [Azure Local sizing tool][azure-local-sizer-tool] to create a new project that models the workload type and scale.** This project includes the size and number of VMs and their storage requirements. These details are inputted together with choices for the system type, preferred CPU family, and your resiliency requirements for HA and storage fault tolerance, as explained in the **[Cluster design choices](#cluster-design-choices)** section.

1. **Review the Azure Local Sizer output for the recommended hardware partner solution.** This solution includes details of the recommended physical server hardware (make and model), number of physical machines, and the specifications for the CPU, memory, and storage configuration for each physical node to deploy and run your workloads.

1. **Contact the hardware OEM or SI partner to further qualify the suitability of the recommended hardware version versus your workload requirements.** If available, use OEM-specific sizing tools to determine OEM-specific hardware sizing requirements for the intended workloads. This step typically includes discussions with the hardware OEM or SI partner for the commercial aspects of the solution. These aspects include quotations, availability of the hardware, lead times, and any professional or value-add services that the partner provides to help accelerate your project or business outcomes.

1. **Deploy two ToR switches for network integration.** For HA solutions, Azure Local instances require two ToR switches to be deployed. Each physical machine requires four NICs, two of which must be RDMA-capable, which provides two links from each machine to the two ToR switches. Two NICs, one connected to each switch, are converged for outbound north-south connectivity for the compute and management networks. The other two RDMA-capable NICs are dedicated for the storage east-west traffic. If you plan to use existing network switches, ensure that the make and model of your switches are on the [approved list of network switches supported by Azure Local](/azure/azure-local/concepts/physical-network-requirements#network-switches-for-azure-local).

1. **Work with the hardware OEM or SI partner to arrange delivery of the hardware.** The SI partner or your employees are then required to integrate the hardware into your on-premises datacenter or edge location, such as racking and stacking the hardware, physical network, and power supply unit cabling for the physical machines.

1. **Perform the Azure Local instance deployment.** Depending on your chosen solution version (Premier Solution, Integrated System, or Validated Node), either the hardware partner, SI partner, or your employees can [deploy the Azure Local software](/azure/azure-local/deploy/deployment-introduction). This step starts by onboarding the physical machines Azure Stack HCI operating system into Azure Arc-enabled servers, then starting the Azure Local cloud deployment process. Customers and partners can raise a support request directly with Microsoft in the [Azure portal](https://portal.azure.com/) by selecting the *Support + Troubleshooting* icon or by contacting their hardware OEM or SI partner, depending on the nature of the request and the hardware solution category.

   > [!TIP]
   > ![GitHub logo](../_images/github.svg) The [Azure Stack HCI operating system, version 23H2 system reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip) demonstrates how to deploy a switched multi-node deployment of Azure Local by using an ARM template and parameter file. Alternatively, [the Bicep example](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/) demonstrates how to use a Bicep template to deploy an Azure Local instance, including its prerequisites resources.

1. **Deploy highly available workloads on Azure Local using Azure portal, CLI, or ARM + Azure Arc templates for automation.** Use the *custom location* resource of the new Azure Local instance as the target region when you [deploy workload resources such as Azure Local VMs, AKS, Virtual Desktop session hosts, or other Azure Arc-enabled services](#use-azure-arc-with-azure-local) that you can enable through AKS extensions and containerization on Azure Local.

1. **Install monthly updates to improve the security and reliability of the platform.** To keep your Azure Local instances up to date, it's important to install Microsoft software updates and hardware OEM driver and firmware updates. These updates improve the security and reliability of the platform. [Update Manager](/azure/azure-local/update/azure-update-manager-23h2) applies the updates and provides a centralized and scalable solution to install updates across a single cluster or multiple clusters. Check with your hardware OEM partner to determine the process for installing hardware driver and firmware updates because this process can vary depending on your chosen hardware solution category type (Premier Solution, Integrated System, or Validated Node). For more information, see [Infrastructure updates](#infrastructure-updates).

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)

## Next steps

Microsoft Learn product documentation:

- [Azure Local release information](/azure/azure-local/release-information-23h2)
- [AKS on Azure Local](/azure/aks/aksarc/aks-whats-new-local)
- [Virtual Desktop on Azure Local](/azure/virtual-desktop/azure-local-overview)
- [What is Azure Local monitoring?](/azure/azure-local/concepts/monitoring-overview)
- [Protect VM workloads by using Site Recovery on Azure Local](/azure/azure-local/manage/azure-site-recovery)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Change tracking and inventory overview](/azure/automation/change-tracking/overview-monitoring-agent)
- [Update Manager overview](/azure/update-manager/overview)
- [What are Azure Arc-enabled data services?](/azure/azure-arc/data/overview)
- [What are Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is the Backup service?](/azure/backup/backup-overview)
- [Azure Automation overview](/azure/automation/overview)
- [Azure Automation State Configuration](/azure/automation/automation-dsc-overview)
- [Introduction to Kubernetes compute target in Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere?view=azureml-api-2)

Azure product documentation:

- [Azure Local](https://azure.microsoft.com/products/local/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Azure Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

Microsoft Learn training:

- [Configure Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data)
- [Design a solution for backup and DR](/training/modules/design-solution-for-backup-disaster-recovery)
- [Introduction to Azure Arc](/training/modules/intro-to-azure-arc)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Keep your VMs updated](/training/modules/manage-azure-updates/)
- [Protect your VMs by using Backup](/training/modules/protect-virtual-machines-with-azure-backup)

Other resources:

- [Scale model deployment with Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/scale-model-deployment-with-azure-machine-learning-anywhere/2888753)
- [Realizing Machine Learning anywhere with AKS and Azure Arc-enabled Machine Learning - Tech Community Blog](https://techcommunity.microsoft.com/blog/azurearcblog/realizing-machine-learning-anywhere-with-azure-kubernetes-service-and-arc-enable/3470783)
- [Machine learning on AKS hybrid and Azure Local by using Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/blog/azurestackblog/machine-learning-on-aks-hybrid--stack-hci-using-azure-arc-enabled-ml/3816127)

[arc-azure-policy]: /azure/azure-arc/servers/security-controls-policy
[arc-enabled-aks]: /azure/aks/hybrid/cluster-architecture
[arc-enabled-data-services]: /azure/azure-arc/data/overview
[arc-enabled-vms]: /azure/azure-local/manage/azure-arc-vm-management-overview
[arc-vm-extensions]: /azure/azure-arc/servers/manage-vm-extensions
[azure-local]: /azure/well-architected/service-guides/azure-local
[az-auto-hybrid-worker]: /azure/automation/automation-hybrid-runbook-worker
[azure-local-aks-automate-cli]: /cli/azure/aksarc
[azure-local-automate-aks-update]: /azure/aks/hybrid/cluster-upgrade
[azure-local-automate-arc-aks]: /azure/aks/hybrid/aks-create-clusters-cli
[virtual-desktop]: /azure/well-architected/azure-virtual-desktop/
[azure-local-basic-security]: /azure/azure-local/concepts/security-features
[azure-local-billing]: /azure/azure-local/concepts/billing
[azure-local-csv-cache]: /azure/azure-local/manage/use-csv-cache#planning-considerations
[azure-local-defender-for-cloud]: /azure/azure-local/manage/manage-security-with-defender-for-cloud
[azure-local-deploy-via-portal]: /azure/azure-local/deploy/deploy-via-portal
[azure-local-deploy-via-template]: /azure/azure-local/deploy/deployment-azure-resource-manager-template
[azure-local-gpu-acceleration]: /windows-server/virtualization/hyper-v/deploy/use-gpu-with-clustered-vm?pivots=azure-stack-hci
[azure-local-k8s-gitops]: /azure/azure-arc/kubernetes/use-gitops-connected-cluster
[azure-local-manage-cluster-at-scale]: /azure/azure-local/manage/manage-at-scale-dashboard
[azure-local-manage-non-arc-vms]: /azure/azure-local/manage/vm-powershell
[azure-local-network-bandwidth-allocation]: /azure/azure-local/concepts/host-network-requirements#traffic-bandwidth-allocation
[azure-local-networking]: /azure/azure-local/concepts/host-network-requirements
[azure-local-rbac]: /azure/azure-local/manage/assign-vm-rbac-roles
[azure-local-security-default]: /azure/azure-local/manage/manage-secure-baseline
[azure-local-security-syslog]: /azure/azure-local/manage/manage-syslog-forwarding
[azure-local-sizer-tool]: https://azurestackhcisolutions.azure.microsoft.com/#catalog
[azure-local-vbs]: /windows-hardware/design/device-experiences/oem-vbs
[azure-local-vm-automate-cli]: /cli/azure/stack-hci-vm
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
