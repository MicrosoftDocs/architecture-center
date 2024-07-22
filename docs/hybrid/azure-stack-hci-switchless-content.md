This article is part of a series that builds on the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml). To effectively deploy Azure Stack HCI using a **three-node storage switchless** design, it's important to understand the baseline architecture. This process includes familiarizing yourself with the cluster design choices for the physical nodes that deliver local compute, storage, and networking capabilities. This knowledge helps you identify the necessary changes for a successful deployment. The guidance in this article also applies to a **two-node storage switchless** deployment and makes necessary adjustments for cases where the number of physical nodes decreases from three to two.

The _storage switchless_ network design removes the requirement for _storage class network switches_ to connect the network adapter ports used for storage traffic. Instead, nodes are directly connected using interlink Ethernet cables. This configuration is commonly used in retail, manufacturing, or remote office scenarios, but it's also suitable for any smaller edge use cases that don't have or require _extensive datacenter network switches_ for storage replication traffic.

This reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Stack HCI as a resilient infrastructure platform to deploy and manage virtualized workloads. For more information on workload architecture patterns that are optimized to run on Azure Stack HCI, see the content located under the **Azure Stack HCI workloads** navigation menu.

This architecture serves as a starting point for a [three-node Azure Stack HCI cluster using a storage switchless networking design](/azure-stack/hci/plan/three-node-switchless-two-switches-two-links). Workload applications that are deployed on an Azure Stack HCI cluster should be well-architected. This approach includes deploying multiple instances for high availability of any critical workload services and implementing appropriate business continuity and disaster recovery (BC/DR) controls, such as regular backups and DR failover capabilities. To focus on the HCI infrastructure platform, these workload design aspects are intentionally excluded from this article. For more information about guidelines and recommendations for the five pillars of the Azure Well-Architected Framework, see the [Azure Stack HCI Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci).

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Potential use cases](#potential-use-cases) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br>&#9642; [Networking](#network-design) <br>|&#9642; [Cost optimization](#cost-optimization)<br>&#9642; [Performance efficiency](#performance-efficiency)<br>|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Stack HCI solution** by using an ARM template and parameter file.

## Architecture

[![Diagram illustrating a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity. The cluster uses a number of Azure services, including Azure Arc, Key Vault, Azure Storage, Azure Update Management, Azure Monitor, Azure Policy, Microsoft Defender, Azure Backup, Extended Security Updates and Azure Site Recovery.](images/azure-stack-hci-switchless.png)](images/azure-stack-hci-switchless.png#lightbox)

For information about these resources, see Azure product documentation listed in [Related resources](#related-resources).

## Potential use cases

The following use case requirements can be addressed using this design and the designs detailed in the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml):

- Deploy and manage highly available (HA) virtualized or container-based edge workloads that are deployed in a single location to enable business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- The _storage switchless_ network design removes the requirement to deploy _storage class network switches_ to connect the network adapter ports that are used for the Storage traffic.

- The _storage switchless_ network design can help reduce the costs associated with the procurement and configuration of _storage class network switches_ for storage traffic, but it does increases the number of network adapter ports required in the physical nodes.

## Architecture components

The architecture resources remain mostly unchanged from the baseline reference architecture. For more information, see the [platform resources and platform supporting resources](azure-stack-hci-baseline.yml#architecture-components) used for Azure Stack HCI deployments.

## Cluster design choices

Refer to the [baseline reference architecture](azure-stack-hci-baseline.yml) when determining your cluster design options. Use these insights alongside the [Azure Stack HCI Sizer Tool][azs-hci-sizer-tool] to appropriately scale an Azure Stack HCI cluster according to the workload requirements.

When you use the _storage switchless_ design, it's crucial to remember that a three-node cluster is the maximum supported size. This limitation is a key consideration for your cluster design choices because you must ensure that your workload's capacity requirements do not exceed the physical capacity capabilities of the three-node cluster specification. Because you can't perform an add-node gesture to expand a storage switchless cluster beyond three nodes, it's **critically important** to understand your workload capacity requirements upfront and plan for future growth. This way you can ensure that your workload doesn't exceed the storage and compute capacity over the expected lifespan of the Azure Stack HCI cluster hardware.

> [!CAUTION]
> To increase the scale (or perform an add-node operation) for an existing three-node _storage switchless_ HCI cluster, you have to redeploy the cluster and add extra networking capabilities such as switches, ports, cables for storage traffic, and additional required nodes. <br><br> The maximum supported cluster size for the _storage switchless_ network design is three nodes. Be sure to consider this limit when sizing the hardware during the cluster design phase to accommodate future workload capacity growth requirements.

### Network design

Network design refers to the overall arrangement of components within the network, both physical and logical. In the case of a three node "storage switchless" configuration for Azure Stack HCI, we have three physical nodes (_servers_) that are directly connected to each other without the use of an external switch for the storage traffic. These "direct interlinked ethernet connections" between the nodes for the storage traffic simplifies the network design by reducing complexity, as there's no requirement to define or apply "storage quality of service and prioritization configuration" on the switches. For example the technologies that underpin lossless RDMA communication, such as ECN, PFC or QoS that are required for RoCE v2 and iWARP. However, the maximum number of supported nodes in this configuration is three nodes, which means it isn't possible to scale (_add additional nodes_) the cluster after deployment.

> [!NOTE]
> This "three-node storage switchless" architecture requires **six network adapter ports** which provide redundant links for all network intents. Take this into consideration if you are planning to use a "_small form-factor hardware_" SKU, if there is limited physical space in the server chassis for additional network cards. Consult with your preferred hardware OEM partner for more information.

#### Physical network topology

The physical network topology shows the actual physical connections between nodes and networking components. Below is what this looks like for a three-node storage switchless Azure Stack HCI deployment:

- Three nodes (_servers_):
  - Each node is a physical server running Azure Stack HCI OS.
  - Each node requires six network adapter ports in total: four RDMA capable ports for storage and two ports for management and compute.
- Storage Traffic:
  - All three nodes are interconnected using dual dedicated physical network adapter ports for storage, as shown in the diagram below.
  - The storage network adapter ports directly connected to each node using ethernet cables, forming a "full mesh network architecture" for the storage traffic.
  - This design provides link redundancy, and dedicated low latency, high bandwidth / through-put.
  - Within the HCI cluster, nodes communicate directly with each other using these links for the storage replication traffic (_east/west traffic_).
  - This direct communication avoids the requirement to use additional network switch ports for storage and removes the requirement to apply quality of service (QoS) or priority flow control (PFC) configuration for SMB-Direct (_RDMA_) traffic on the network switches.
  - _Note:_ Check with your hardware OEM partner and/or network interface card (NIC) vendor for any recommended OS drivers, firmware versions, or firmware settings for the switchless interconnect network configuration.
- Dual Top of Rack (ToR) Switches:
  - Although this configuration is "_switchless_" for storage traffic, it still requires ToR switches for the external connectivity (_north/south traffic_), such as the cluster "management" intent and the workload "compute" intent(s).
  - The uplinks to the switches from each node use two network adapter ports, which are connected using ethernet cables, one to each ToR switch to provide link redundancy.
  - Using dual ToR switches is recommended to provide redundancy for servicing operations and load balancing for external communication.
- External Connectivity:
  - The dual (_two_) ToR switches connect to the external network, such as the internal corporate LAN and provide access to the required outbound URLs using your edge border network device (_firewall or router_).
  - The two ToR switches handle traffic going in and out of the Azure Stack HCI cluster (_north/south traffic_), such as traffic that flows over the management and compute intents.

[![Diagram illustrating the physical networking topology for a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity.](images/azure-stack-hci-3node-physical-network.png)](images/azure-stack-hci-3node-physical-network.png#lightbox)

#### Logical network topology

The logical network topology provides an overview for how the network data flows between devices, regardless of their physical connections. The following is a summarization of the logical setup for a three-node storage switchless Azure Stack HCI cluster:

- Dual Top of Rack (ToR) Switches:
  - Prior to deployment of the cluster, the two ToR network switches need to be configured with the required VLAN IDs and MTU settings for the Management and Compute ports. For more information, see [physical network requirements](/azure-stack/hci/concepts/physical-network-requirements), or ask your switch hardware vendor or SI partner for assistance.
- Azure Stack HCI leverages network automation and _intent-based network configuration_ using the [NetworkATC service](/azure-stack/hci/deploy/network-atc).
  - NetworkATC is designed to ensure optimal networking configuration and traffic flow using network "_Intents_", such as defining which physical network adapter ports are used for the different network traffic intents (_types_), such as for the cluster "management", workload "compute", and cluster "storage" intents.
  - Intent-based policies simplify the network configuration requirements, by automating the node network configuration based on parameter inputs that are specified as part of the Azure Stack HCI cloud deployment process.
- External communication:
  - When the nodes or workload need to communicate externally by accessing the corporate LAN, internet, or another service, they route using the dual ToR switches. This process is outlined in the previous physical network topology section.
  - When acting as Layer 3 devices, the two ToR switches handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  - Management network intent: uses the Converged SET Team virtual interface, allowing the cluster management IP and control plane resources to communicate externally.
  - Compute network intent: one or more logical networks can be created in Azure with the specific VLAN IDs for your environment. These are used by the workload resources, such as virtual machines (VMs) to provide access to the physical network. The logical networks will use the two physical network adapter ports that are Converged using a SET Team for the Compute and Management intents.
- Storage traffic:
  - The nodes communicate with each other directly for storage traffic using the four direct interconnect Ethernet ports per node, which use **six separate non-routable (_layer 2_) networks** for the storage traffic.
  - There is "no default gateway" configured on the four storage intent network adapter ports within the Azure Stack HCI node OS.
  - Each node can access storage spaces direct (S2D) capabilities of the cluster, such as remote physical disks used in the storage pool, virtual disks, and volumes using the SMB-Direct (_RDMA_) protocol over the **four dedicated "switchless" storage network adapter ports** available in each node, SMB Multichannel is used for resiliency.
  - This configuration ensures sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

[![Diagram illustrating the logical networking topology for a three-node Azure Stack HCI cluster using a switchless storage architecture, with dual ToR switches for external (north/south) connectivity.](images/azure-stack-hci-3node-logical-network.png)](images/azure-stack-hci-3node-logical-network.png#lightbox)

#### IP address requirements

To deploy a three-node storage switchless configuration of Azure Stack HCI with dual links for the storage interconnects, the cluster infrastructure platform requires that you allocate a minimum of 20 x IP addresses. Additional IP addresses are required if you use a VM appliance supplied by your hardware OEM partner, or if you use microsegmentation or software defined networking (SDN). For more information, see [Review the three-node storage reference pattern IP requirements for Azure Stack HCI](/azure-stack/hci/plan/three-node-ip-requirements).

When you design and plan IP address requirements for Azure Stack HCI, remember to account for additional IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Stack HCI cluster and infrastructure components. If you plan to use Azure Kubernetes Services (AKS) on Azure Stack HCI, see [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

## Well-Architected Framework considerations

The Microsoft [Azure Well-Architected Framework (WAF)][azure-well-architected-framerwork] is a set of guiding tenets that are followed in this reference architecture. The following considerations are framed in the context of these tenets.

> [!IMPORTANT]
> Review the Well-Architected Framework considerations described in the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml#well-architected-framework-considerations).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, the [Cost optimization pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#cost-optimization).

Cost optimization considerations include:

- Switchless cluster interconnects versus switch-based cluster interconnects. The switchless interconnect topology consists of connections between dual port, or _redundant_, Remote Direct Memory Access (RDMA)-capable network adapter ports in each node to form a full mesh. Each node has two direct connections to every other node. Though this implementation is straightforward, it's only supported in two-node or three-node clusters. An Azure Stack HCI cluster with four or more nodes requires the _storage switched_ network architecture. You can use this architecture to add additional nodes after deployment, unlike the storage switchless design that doesn't support add-node operations.

### Performance efficiency

Performance efficiency defines the controls put in place to enable the workload to meet the demands placed on it by users in an efficient manner. For more information, see the [Performance efficiency pillar of the Azure Stack HCI WAF Service Guide](/azure/well-architected/service-guides/azure-stack-hci#performance-efficiency).

Performance efficiency considerations include:

- It isn't supported to increase the scale (_perform an add-ode operation_) of an existing three-node "storage switchless" HCI cluster, without redeploying the cluster and adding additional networking capabilities (_network switches, ports and cables_) for storage traffic, and the additional required nodes. Three nodes is the maximum supported cluster size for the "storage switchless" network design. It's important to factor this into the cluster design phase when sizing the hardware, in terms of allowing for future workload capacity growth requirements.

## Deploy this scenario

For more information about how to design, procure, and deploy an Azure Stack HCI solution, see the **Deploy this scenario** section of the [Azure Stack HCI baseline reference architecture](azure-stack-hci-baseline.yml#deploy-this-scenario).

Use the following deployment automation template as an example of how to deploy Azure Stack HCI by using the three-node storage switchless architecture.

> [!TIP]
> ![GitHub logo](../_images/github.svg) **Deployment automation**: This [reference template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Stack HCI solution** by using an ARM template and parameter file.

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
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)

## Next steps

Product documentation:

- [Azure Stack HCI, version 23H2 release information](/azure-stack/hci/release-information-23h2)
- [AKS on Azure Stack HCI](/azure/aks/hybrid/aks-whats-new-23h2)
- [Azure Virtual Desktop for Azure Stack HCI](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Stack HCI monitoring?](/azure-stack/hci/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Stack HCI](/azure-stack/hci/manage/azure-site-recovery)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Change Tracking and Inventory overview](/azure/automation/change-tracking/overview)
- [Update Management overview](/azure/automation/update-management/overview)
- [What are Azure Arc-enabled Data Services?](/azure/azure-arc/data/overview)
- [What is Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is the Azure Backup service?](/azure/backup/backup-overview)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere)

Microsoft Learn modules:

- [Configure Azure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Scale model deployment with Azure Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/t5/ai-machine-learning-blog/scale-model-deployment-with-azure-machine-learning-anywhere/ba-p/2888753)
- [Realizing Machine Learning anywhere with AKS and Arc-enabled Machine Learning - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-arc-blog/realizing-machine-learning-anywhere-with-azure-kubernetes/ba-p/3470783)
- [Machine learning on AKS hybrid & Stack HCI using Azure Arc-enabled ML - Tech Community Blog](https://techcommunity.microsoft.com/t5/azure-stack-blog/machine-learning-on-aks-hybrid-amp-stack-hci-using-azure-arc/ba-p/3816127)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere?view=azureml-api-2)
- [Keep your virtual machines updated](/training/modules/keep-your-virtual-machines-updated)
- [Protect your virtual machine settings with Azure Automation State Configuration](/training/modules/protect-vm-settings-with-dsc)
- [Protect your virtual machines by using Azure Backup](/training/modules/protect-virtual-machines-with-azure-backup)

[azure-well-architected-framerwork]: /azure/architecture/framework
[azs-hci-sizer-tool]: https://aka.ms/hci-catalog#sizer
