This article is part of a series that builds on the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml). To effectively deploy Azure Stack HCI by using a **three-node storage switchless** design, it's important to understand the baseline architecture. This process includes familiarizing yourself with the cluster design choices for the physical nodes that deliver local compute, storage, and networking capabilities. This knowledge helps you identify the necessary changes for a successful deployment. The guidance in this article also applies to a **two-node storage switchless** deployment and makes necessary adjustments for cases where the number of physical nodes decreases from three to two.

The storage switchless network design removes the requirement for storage class network switches to connect the network adapter ports that are used for storage traffic. Instead, nodes are directly connected by using interlink ethernet cables. This configuration is commonly used in retail, manufacturing, or remote office scenarios. This configuration is also suitable for smaller edge use cases that don't have or require extensive datacenter network switches for storage replication traffic.

This reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Stack HCI as a resilient infrastructure platform to deploy and manage virtualized workloads. For more information about workload architecture patterns that are optimized to run on Azure Stack HCI, see the content located under the **Azure Stack HCI workloads** navigation menu.

This architecture is a starting point for a [three-node Azure Stack HCI cluster that uses a storage switchless networking design](/azure-stack/hci/plan/three-node-switchless-two-switches-two-links). Workload applications that are deployed on an Azure Stack HCI cluster should be well architected. This approach includes deploying multiple instances for high availability of any critical workload services and implementing appropriate business continuity and disaster recovery (BCDR) controls, such as regular backups and DR failover capabilities. To focus on the HCI infrastructure platform, these workload design aspects are intentionally excluded from this article. For more information about guidelines and recommendations for the five pillars of the Azure Well-Architected Framework, see the [Azure Stack HCI Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci).

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br>&#9642; [Networking](#network-design) <br>|&#9642; [Cost optimization](#cost-optimization)<br>&#9642; [Performance efficiency](#performance-efficiency)<br>|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Stack HCI solution** by using an ARM template and parameter file.

## Architecture

:::image type="complex" source="images/azure-stack-hci-switchless.png" lightbox="images/azure-stack-hci-switchless.png" alt-text="Diagram that shows a three-node Azure Stack HCI cluster that uses a switchless storage architecture and has dual ToR switches for external connectivity." border="false"::: 
   Diagram that illustrates a three-node Azure Stack HCI cluster that uses a switchless storage architecture and has dual Top-of-Rack (ToR) switches for external (north-south) connectivity. The cluster uses several Azure services, including Azure Arc, Key Vault, Azure Storage, Azure Update Manager, Azure Monitor, Azure Policy, Microsoft Defender, Azure Backup, Extended Security Updates, and Azure Site Recovery.
:::image-end:::

For more information about these resources, see [Related resources](#related-resources).

## Potential use cases

Use this design and the designs described in the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml) to address the following use case requirements:

- Deploy and manage highly available (HA) virtualized or container-based edge workloads that are deployed in a single location to enable business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- The storage switchless network design removes the requirement to deploy storage class network switches to connect the network adapter ports that are used for the storage traffic.

- You can use the storage switchless network design to help reduce the costs associated with the procurement and configuration of storage class network switches for storage traffic, but it does increase the number of network adapter ports required in the physical nodes.

## Architecture components

The architecture resources remain mostly unchanged from the baseline reference architecture. For more information, see the [platform resources and platform supporting resources](azure-stack-hci-baseline-content.md#components) used for Azure Stack HCI deployments.

## Cluster design choices

When you determine your cluster design options, refer to the [baseline reference architecture](azure-stack-hci-baseline.yml). Use these insights and the [Azure Stack HCI Sizer Tool][azs-hci-sizer-tool] to appropriately scale an Azure Stack HCI cluster according to the workload requirements.

When you use the storage switchless design, it's crucial to remember that a three-node cluster is the maximum supported size. This limitation is a key consideration for your cluster design choices because you must ensure that your workload's capacity requirements don't exceed the physical capacity capabilities of the three-node cluster specifications. Because you can't perform an add-node gesture to expand a storage switchless cluster beyond three nodes, it's **critically important** to understand your workload capacity requirements beforehand and plan for future growth. This way you can ensure that your workload doesn't exceed the storage and compute capacity over the expected lifespan of the Azure Stack HCI cluster hardware.

> [!CAUTION]
> The maximum supported cluster size for the storage switchless network architecture is three physical nodes. Be sure to consider this limit during the cluster design phase, such as including the present and future growth capacity requirements for your workload.

### Network design

Network design refers to the overall arrangement of physical and logical components within the network. In a three-node storage switchless configuration for Azure Stack HCI, three physical nodes are directly connected without using an external switch for storage traffic. These direct interlinked ethernet connections simplify network design by reducing complexity because there's no requirement to define or apply storage quality of service and prioritization configurations on the switches. The technologies that underpin lossless RDMA communication, such as explicit congestion notification (ECN), priority flow control (PFC), or quality of service (QoS) that are required for RoCE v2 and iWARP, aren't needed. However, this configuration supports a maximum of three nodes, which means you can't scale the cluster by adding more nodes after deployment.

> [!NOTE]
> This three-node storage switchless architecture requires **six network adapter ports** that provide redundant links for all network intents. Take this into consideration if you plan to use a _small form-factor hardware_ SKU, or if there is limited physical space in the server chassis for extra network cards. Consult your preferred hardware manufacturer partner for more information.

#### Physical network topology

The physical network topology shows the actual physical connections between nodes and networking components. The connections between nodes and networking components for a three-node storage switchless Azure Stack HCI deployment are:

- Three nodes (or servers):

  - Each node is a physical server that runs on Azure Stack HCI OS.
  
  - Each node requires six network adapter ports in total: four RDMA-capable ports for storage and two ports for management and compute.
  
- Storage traffic:

  - Each of the three nodes is interconnected through dual dedicated physical network adapter ports for storage. The following diagram illustrates this process.
  
  - The storage network adapter ports connect directly to each node by using ethernet cables to form a full mesh network architecture for the storage traffic.
  
  - This design provides link redundancy, dedicated low latency, high bandwidth, and high throughput.
  
  - Nodes within the HCI cluster communicate directly through these links to handle storage replication traffic, also known as east-west traffic.

  - This direct communication eliminates the need for extra network switch ports for storage and removes the requirement to apply QoS or PFC configuration for SMB Direct or RDMA traffic on the network switches.
  
  - Check with your hardware manufacturer partner or network interface card (NIC) vendor for any recommended OS drivers, firmware versions, or firmware settings for the switchless interconnect network configuration.
  
- Dual Top-of-Rack (ToR) switches:

  - This configuration is _switchless_ for storage traffic but still requires ToR switches for the external connectivity. This connectivity is called north-south traffic and includes the cluster _management_ intent and the workload _compute_ intents.
  
  - The uplinks to the switches from each node use two network adapter ports. Ethernet cables connect these ports, one to each ToR switch, to provide link redundancy.
  
  - We recommend that you use dual ToR switches to provide redundancy for servicing operations and load balancing for external communication.
  
- External connectivity:

  - The dual ToR switches connect to the external network, such as the internal corporate LAN, and use your edge border network device, such as a firewall or router, to provide access to the required outbound URLs.
  
  - The two ToR switches handle the north-south traffic for the Azure Stack HCI cluster, including traffic related to management and compute intents.

    :::image type="content" source="images/three-node-physical-network.png" alt-text="Diagram of a three-node Azure Stack HCI cluster with switchless storage architecture and dual ToR switches for external connectivity." lightbox="images/three-node-physical-network.png" border="false":::

#### Logical network topology

The logical network topology provides an overview for how the network data flows between devices, regardless of their physical connections. The following list summarizes the logical setup for a three-node storage switchless Azure Stack HCI cluster:

- Dual ToR switches:

  - Before cluster deployment, the two ToR network switches need to be configured with the required VLAN IDs and maximum transmission unit (MTU) settings for the management and compute ports. For more information, see the [physical network requirements](/azure-stack/hci/concepts/physical-network-requirements) or ask your switch hardware vendor or systems integrator (SI) partner for assistance.
  
- Azure Stack HCI applies network automation and _intent-based network configuration_ by using the [Network ATC service](/azure-stack/hci/deploy/network-atc).

  - Network ATC is designed to ensure optimal networking configuration and traffic flow by using network traffic _intents_. Network ATC defines which physical network adapter ports are used for the different network traffic intents (or types), such as for the cluster _management_, workload _compute_, and cluster _storage_ intents.
  
  - Intent-based policies simplify the network configuration requirements by automating the node network configuration based on parameter inputs that are specified as part of the Azure Stack HCI cloud deployment process.

- External communication:

  - When the nodes or workload need to communicate externally by accessing the corporate LAN, internet, or another service, they route using the dual ToR switches. This process is described in the previous **[Physical network topology](#physical-network-topology)** section.
  
  - When the two ToR switches act as Layer 3 devices, they handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  
  - Management network intent uses the Converged Switch Embedded Teaming (SET) virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - For the compute network intent, you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as virtual machines (VMs), use these IDs to give access to the physical network. The logical networks use the two physical network adapter ports that are converged by using SET for the compute and management intents.
  
- Storage traffic:

  - The nodes communicate with each other directly for storage traffic by using the four direct interconnect ethernet ports per node, which use six separate nonroutable (or Layer 2) networks for the storage traffic.
  
  - There's _no default gateway_ configured on the four storage intent network adapter ports within the Azure Stack HCI node OS.

  - Each node can access S2D capabilities of the cluster, such as remote physical disks that are used in the storage pool, virtual disks, and volumes. Access to these capabilities is facilitated through the SMB Direct RDMA protocol over the two dedicated storage network adapter ports that are available in each node. SMB Multichannel is used for resiliency.
  
  - This configuration ensures sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

    :::image type="complex" source="images/three-node-logical-network.png" lightbox="images/three-node-logical-network.png" alt-text="Diagram that shows the logical networking topology for a three-node Azure Stack HCI cluster."
    Diagram that shows the logical networking topology for a three-node Azure Stack HCI cluster. It uses a switchless storage architecture with dual ToR switches for external (or north-south) connectivity.
    :::image-end:::

#### IP address requirements

To deploy a three-node storage switchless configuration of Azure Stack HCI with dual links for the storage interconnects, the cluster infrastructure platform requires that you allocate a minimum of 20 x IP addresses. More IP addresses are required if you use a VM appliance supplied by your hardware manufacturer partner, or if you use microsegmentation or software defined networking (SDN). For more information, see [Review the three-node storage reference pattern IP requirements for Azure Stack HCI](/azure-stack/hci/plan/three-node-ip-requirements).

When you design and plan IP address requirements for Azure Stack HCI, remember to account for additional IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Stack HCI cluster and infrastructure components. If you plan to use Azure Kubernetes Services (AKS) on Azure Stack HCI, see [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

> [!IMPORTANT]
> Review the Well-Architected Framework considerations described in the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline-content.md#considerations).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Cost optimization considerations include:

- Switchless cluster interconnects versus switch-based cluster interconnects. The switchless interconnect topology consists of connections between dual port, or _redundant_, RDMA-capable network adapter ports in each node to form a full mesh. Each node has two direct connections to every other node. Although this implementation is straightforward, it's only supported in two-node or three-node clusters. An Azure Stack HCI cluster with four or more nodes requires the _storage switched_ network architecture. You can use this architecture to add more nodes after deployment, unlike the storage switchless design that doesn't support add-node operations.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Performance efficiency considerations include:

- You can't increase the scale (or perform an add-node operation) of an existing three-node storage switchless HCI cluster without redeploying the cluster and adding extra networking capabilities such as network switches, ports and cables for storage traffic, and the other required nodes. Three nodes are the maximum supported cluster size for the storage switchless network design. Factor this limitation into the cluster design phase to ensure that the hardware can support future workload capacity growth.

## Deploy this scenario

For more information about how to design, procure, and deploy an Azure Stack HCI solution, see the **Deploy this scenario** section of the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline-content.md#deploy-this-scenario).

Use the following deployment automation template as an example of how to deploy Azure Stack HCI by using the three-node storage switchless architecture.

> [!TIP]
> ![GitHub logo](../_images/github.svg) **Deployment automation**: This [reference template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Stack HCI solution** by using an ARM template and parameter file.

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Azure Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)

## Next steps

Product documentation:

- [Azure Stack HCI version 23H2 release information](/azure-stack/hci/release-information-23h2)
- [AKS on Azure Stack HCI](/azure/aks/hybrid/aks-whats-new-23h2)
- [Azure Virtual Desktop for Azure Stack HCI](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Stack HCI monitoring?](/azure-stack/hci/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Stack HCI](/azure-stack/hci/manage/azure-site-recovery)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Change Tracking and Inventory overview](/azure/automation/change-tracking/overview)
- [Azure Update Manager overview](/azure/update-manager/guidance-migration-automation-update-management-azure-update-manager)
- [What are Azure Arc-enabled data services?](/azure/azure-arc/data/overview)
- [What are Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is Azure Backup?](/azure/backup/backup-overview)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere)

Product documentation for specific Azure services:

- [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

Microsoft Learn modules:

- [Configure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc-enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Scale model deployment with Azure Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/scale-model-deployment-with-azure-machine-learning-anywhere/ba-p/2888753)
- [Realizing Machine Learning anywhere with AKS and Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-arc-blog/realizing-machine-learning-anywhere-with-azure-kubernetes/ba-p/3470783)
- [Machine learning on AKS hybrid and Stack HCI using Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-stack-blog/machine-learning-on-aks-hybrid-amp-stack-hci-using-azure-arc/ba-p/3816127)
- [Keep your virtual machines updated](/training/modules/keep-your-virtual-machines-updated)
- [Protect your virtual machine settings with Azure Automation State Configuration](/training/modules/protect-vm-settings-with-dsc)
- [Protect your VMs by using Backup](/training/modules/protect-virtual-machines-with-azure-backup)

[azure-well-architected-framework]: /azure/architecture/framework
[azs-hci-sizer-tool]: https://azurestackhcisolutions.azure.microsoft.com/#sizer
