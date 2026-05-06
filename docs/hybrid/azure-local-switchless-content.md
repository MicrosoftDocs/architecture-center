This article is part of a series that builds on the [Azure Local baseline reference architecture](azure-local-baseline.yml). To effectively deploy Azure Local by using a **storage switchless** design, it's important to understand the baseline architecture. This process requires you to familiarize yourself with the cluster design choices for the physical nodes that deliver local compute, storage, and networking capabilities. This knowledge helps you identify the necessary changes for a successful deployment. The guidance in this article applies to **two-node**, **three-node**, and **four-node storage switchless** deployments. You need to adjust your configuration based on the number of physical nodes in your instance, which can range from [two nodes](/azure/azure-local/plan/two-node-switchless-two-switches) to [four nodes](/azure/azure-local/plan/four-node-switchless-two-switches-two-links).

The storage switchless network design removes the requirement for storage class network switches to connect the network adapter ports that are used for storage traffic. Instead, nodes are directly connected by using interlink Ethernet cables. This configuration is commonly used in retail, manufacturing, and remote office scenarios. This configuration is also suitable for smaller edge use cases that don't have or require extensive datacenter network switches for storage replication traffic.

This reference architecture provides workload-agnostic guidance and recommendations for configuring Azure Local as a resilient infrastructure platform to deploy and manage virtualized workloads. For more information about workload architecture patterns that are optimized to run on Azure Local, see the content located under the **Azure Local workloads** navigation menu.

This architecture is a starting point for an [Azure Local instance that uses a storage switchless networking design](/azure/azure-local/plan/three-node-switchless-two-switches-two-links). Workload applications that are deployed on an Azure Local instance should be well architected. This approach includes deploying multiple instances for high availability of any critical workload services and implementing appropriate business continuity and disaster recovery (BCDR) controls, such as regular backups and DR failover capabilities. To focus on the hyperconverged infrastructure (HCI) platform, these workload design aspects are intentionally excluded from this article. For more information about guidelines and recommendations for the five pillars of the Azure Well-Architected Framework, see [Architecture best practices for Azure Local](/azure/well-architected/service-guides/azure-local).

| Architecture | Design decisions | Well-Architected Framework approach |
|---|---|---|
| &#9642; [Architecture diagram](#architecture) <br> &#9642; [Components](#components) <br> &#9642; [Potential use cases](#potential-use-cases) <br> &#9642; [Deploy this scenario](#deploy-this-scenario) <br> | &#9642; [Cluster design choices](#cluster-design-choices) <br> &#9642; [Network design](#network-design) <br> &#9642; [Physical network topology](#physical-network-topology) <br> &#9642; [Logical network topology](#logical-network-topology) <br> &#9642; [IP address requirements](#ip-address-requirements) <br> &#9642; [Outbound network connectivity](#outbound-network-connectivity) <br> | &#9642; [Considerations](#considerations) <br> &#9642; [Cost Optimization](#cost-optimization) <br> &#9642; [Performance Efficiency](#performance-efficiency) <br> |

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [reference implementation](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Local instance** by using an Azure Resource Manager template (ARM template) and parameter file.

## Architecture

:::image type="complex" source="images/azure-local-switchless.png" lightbox="images/azure-local-switchless.png" alt-text="Diagram that shows a three-node Azure Local instance that uses a switchless storage architecture and has dual ToR switches for external connectivity." border="false":::
   Diagram that illustrates a three-node Azure Local instance that uses a switchless storage architecture and has dual ToR switches for external (north-south) connectivity. Azure Local uses several Azure services, including Azure Arc, Key Vault, Azure Storage, Azure Update Manager, Azure Monitor, Azure Policy, Microsoft Defender, Azure Backup, Extended Security Updates, and Azure Site Recovery.
:::image-end:::

For more information about these resources, see [Related resources](#related-resources).

## Components

The architecture resources remain mostly unchanged from the baseline reference architecture. For more information, see the [platform resources and platform supporting resources](/azure/architecture/hybrid/azure-local-baseline#components) used for Azure Local deployments.

## Potential use cases

Use this design and the designs described in the [Azure Local baseline reference architecture](azure-local-baseline.yml) to address the following use case requirements:

- Deploy and manage highly available (HA) virtualized or container-based edge workloads that are deployed in a single location to enable business-critical applications and services to operate in a resilient, cost-effective, and scalable manner.

- The storage switchless network design removes the requirement to deploy storage class network switches to connect the network adapter ports that are used for the storage traffic.

- You can use the storage switchless network design to help reduce the costs associated with the procurement and configuration of storage class network switches for storage traffic, but it does increase the number of network adapter ports required in the physical machines.

## Cluster design choices

For guidance and recommendations for your Azure Local instance design choices, refer to the [baseline reference architecture](azure-local-baseline.yml). Use these insights and the [Azure Local sizer tool](https://azurelocalsolutions.azure.microsoft.com/#sizer) to appropriately scale an Azure Local instance according to the workload requirements.

When you use the storage switchless design, it's crucial to remember that four nodes is the maximum instance size supported. This limitation is a key consideration for your instance design choices because you must ensure that your workload's capacity requirements don't exceed the physical capacity capabilities of the four-node instance specifications. Because you can't perform an add-node gesture to expand a storage switchless instance beyond four nodes, it's **critically important** to understand your workload capacity requirements beforehand and plan for future growth. This approach helps ensure that your workload doesn't exceed the storage and compute capacity over the expected lifespan of the Azure Local instance hardware.

> [!CAUTION]
> The maximum supported instance size for the storage switchless network architecture is four physical nodes (or *machines*). Be sure to consider this limit during the instance design phase, such as including the present and future growth capacity requirements for your workload.

### Network design

Network design refers to the overall arrangement of physical and logical components within the network. In a three-node storage switchless configuration for Azure Local, three physical nodes are directly connected without using an external switch for storage traffic. These direct interlinked Ethernet connections simplify network design by reducing complexity because there's no requirement to define or apply storage Quality of Service (QoS) and prioritization configurations on the switches. Technologies that underpin lossless Remote Direct Memory Access (RDMA) communication, such as Explicit Congestion Notification (ECN), Priority Flow Control (PFC), and QoS aren't required for RoCE v2 and iWARP. However, this configuration supports a maximum of four machines. For an existing four-node storage switchless instance, you can't scale the instance by adding more nodes after deployment.

> [!NOTE]
> This three-node storage switchless architecture requires **six network adapter ports** to provide redundant links for all network intents. Consider this factor if you plan to use a *small form-factor hardware* SKU or if there's limited physical space in the server chassis for extra network cards. For more information, consult your preferred hardware manufacturer partner.
>
> A [four-node storage switchless](/azure/azure-local/plan/four-node-switchless-two-switches-two-links) Azure Local instance with dual links requires **eight network adapter ports** for each node: six ports for the storage intent and two ports for the management and compute intent.

#### Physical network topology

The physical network topology shows the actual physical connections between nodes and networking components. The following configuration outlines the connections between nodes and networking components in a three-node storage switchless Azure Local deployment:

:::image type="complex" source="images/azure-local-3-node-physical-network.png" lightbox="images/azure-local-3-node-physical-network.png" alt-text="Diagram of a three-node Azure Local instance with switchless storage architecture and dual ToR switches for external connectivity." border="false":::
   The diagram shows the physical network topology for a three-node Azure Local instance that uses a storage switchless architecture. It highlights the direct connections between the nodes for storage traffic and the use of dual top-of-rack (ToR) switches for management and compute traffic. Each node has two network adapters for storage, which are cross-connected to the other nodes, and two network adapters for management and compute, which connect to the ToR switches.
:::image-end:::

- Three nodes (or machines):

  - Each node is a physical server that runs on Azure Stack HCI operating system.
  
  - Each node requires six network adapter ports in total: four RDMA-capable ports for storage and two ports for management and compute.
  
- Storage traffic:

  - Each of the three nodes is interconnected through dual dedicated physical network adapter ports for storage. The following diagram illustrates this process.
  
  - The storage network adapter ports connect directly to each node by using Ethernet cables to form a full mesh network architecture for the storage traffic.
  
  - This design provides link redundancy, dedicated low latency, high bandwidth, and high throughput.
  
  - Nodes within the Azure Local instance communicate directly through these links to handle storage replication traffic, also known as *east-west traffic*.

  - This direct communication eliminates the need for extra network switch ports for storage and removes the requirement to apply QoS or PFC configuration for SMB Direct or RDMA traffic on the network switches.
  
  - Check with your hardware manufacturer partner or network interface card (NIC) vendor for any recommended operating system drivers, firmware versions, or firmware settings for the switchless interconnect network configuration.
  
- Dual top-of-rack (ToR) switches:

  - This configuration is *switchless* for storage traffic but still requires ToR switches for the external connectivity. This connectivity is known as *north-south traffic* and includes the cluster *management* intent and the workload *compute* intents.
  
  - The uplinks to the switches from each node use two network adapter ports. Ethernet cables connect these ports, one to each ToR switch, to provide link redundancy.
  
  - We recommend that you use dual ToR switches to provide redundancy for servicing operations and load balancing for external communication.
  
- External connectivity:

  - The dual ToR switches connect to the external network, such as the internal corporate local area network (LAN), and use your edge border network device, such as a firewall or router, to provide access to the required outbound URLs.
  
  - The two ToR switches handle the north-south traffic for the Azure Local instance, including traffic related to management and compute intents.

#### Logical network topology

The logical network topology provides an overview for how the network data flows between devices, regardless of their physical connections. The following list summarizes the logical setup for a three-node storage switchless Azure Local instance:

:::image type="complex" source="images/azure-local-3-node-logical-network.png" lightbox="images/azure-local-3-node-logical-network.png" alt-text="Diagram that shows the logical networking topology for a three-node Azure Local instance." border="false":::
   The diagram shows the logical network topology for a three-node Azure Local instance that uses a storage switchless architecture. It illustrates the flow of network traffic between components. The diagram shows three physical nodes. Network ATC is used to define intents for management, compute, and storage traffic. The management and compute intents are converged onto a virtual switch that uses a Switch Embedded Team (SET). The storage intent uses dedicated RDMA-capable adapters that are directly connected between the nodes in a full mesh. The diagram also depicts logical networks for virtual machines and the connection to the external network via the ToR switches.
:::image-end:::

- Dual ToR switches:

  - Before cluster deployment, the two ToR network switches need to be configured with the required VLAN IDs and maximum transmission unit (MTU) settings for the management and compute ports. For more information, see the [physical network requirements](/azure/azure-local/concepts/physical-network-requirements) or ask your switch hardware vendor or systems integrator (SI) partner for assistance.
  
- [Network ATC](/azure/azure-local/deploy/network-atc):

  - Azure Local applies network automation and *intent-based network configuration* by using the [Network ATC service](/azure/azure-local/deploy/network-atc).
  
  - Network ATC is designed to ensure optimal networking configuration and traffic flow by using network traffic *intents*. Network ATC defines which physical network adapter ports are used for the different network traffic intents (or types), such as for the cluster *management*, workload *compute*, and cluster *storage* intents.
  
  - Intent-based policies simplify the network configuration requirements by automating the node network configuration based on parameter inputs that are specified as part of the Azure Local cloud deployment process.

- External communication:

  - When the nodes or workload need to communicate externally by accessing the corporate LAN, internet, or another service, they [route by using the dual ToR switches](#physical-network-topology).
  
  - When the two ToR switches act as Layer 3 devices, they handle routing and provide connectivity beyond the cluster to the edge border device, such as your firewall or router.
  
  - Management network intent uses the converged Switch Embedded Teaming (SET) virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - For the compute network intent, you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as virtual machines (VMs), use these IDs to give access to the physical network. The logical networks use the two physical network adapter ports that are converged by using SET for the compute and management intents.
  
- Storage traffic:

  - The nodes communicate with each other directly for storage traffic by using the four direct interconnect Ethernet ports for each node, which use six separate nonroutable (or layer 2) networks for the storage traffic.

  - There's *no default gateway* configured on the four storage intent network adapter ports within the Azure Stack HCI operating system.

  - Each node can access Storage Spaces Direct (S2D) capabilities of the cluster, such as remote physical disks that are used in the storage pool, virtual disks, and volumes. Access to these capabilities is facilitated through the Server Message Block (SMB) Direct RDMA protocol over the two dedicated storage network adapter ports that are available in each node. SMB Multichannel is used for resiliency.
  
  - This configuration ensures sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

#### IP address requirements

To deploy a three-node storage switchless configuration of Azure Local with dual links for the storage interconnects, the cluster infrastructure platform requires you to allocate a minimum of 20 x IP addresses. More IP addresses are required if you use a VM appliance supplied by your hardware manufacturer partner or if you use microsegmentation or software-defined networking (SDN). For more information, see [Review the three-node storage reference pattern IP address requirements for Azure Local](/azure/azure-local/plan/three-node-ip-requirements).

When you design and plan IP address requirements for Azure Local, remember to account for extra IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Local instance and infrastructure components. If you plan to use Azure Kubernetes Services (AKS) on Azure Local, see [AKS enabled by Azure Arc network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

#### Outbound network connectivity

Review the [outbound network connectivity section of the Azure Local baseline reference architecture](/azure/architecture/hybrid/azure-local-baseline#outbound-network-connectivity) because the guidance and recommendations are applicable for both the storage switched and storage switchless architectures.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

> [!IMPORTANT]
> Review the Well-Architected Framework considerations described in the [Azure Local baseline reference architecture](/azure/architecture/hybrid/azure-local-baseline#considerations).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Consider switchless cluster interconnects versus switch-based cluster interconnects. The switchless interconnect topology consists of connections between dual port RDMA-capable network adapters in each node to form a full mesh. Each node has two direct connections to every other node. Although this implementation is straightforward, it's only supported in two-node, three-node, or four-node instances. An Azure Local instance with five or more nodes requires the *storage switched* network architecture. You can use this architecture to add more nodes after deployment, unlike the storage switchless design that doesn't support add-node operations.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Review the [supported scenarios for add-node](/azure/azure-local/manage/add-server#supported-scenarios) operations for Azure Local, specifically the storage network architecture requirement when increasing the scale (add-node) of an existing Azure Local instance. The capacity planning aspect of your design phase is critically important when you use the storage switchless architecture because you can't add extra nodes after your cluster is deployed.

- You can't increase the scale (or perform an add-node operation) of an existing four-node storage switchless Azure Local instance without redeploying the instance and adding extra networking capabilities such as network switches, ports, and cables for storage traffic, and the other required machines. Four nodes is the maximum supported instance size for the storage switchless network design. Factor this limitation into the instance design phase to ensure that the hardware can support future workload capacity growth.

## Deploy this scenario

For more information about how to design, procure, and deploy an Azure Local solution, see the [**Deploy this scenario** section of the Azure Local baseline reference architecture](/azure/architecture/hybrid/azure-local-baseline#deploy-this-scenario).

Use the following deployment automation template as an example of how to deploy Azure Local by using the three-node storage switchless architecture.

> [!TIP]
> ![GitHub logo](../_images/github.svg) **Deployment automation:** This [reference template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs) describes how to deploy a **three-node storage switchless Azure Local solution** by using an ARM template and parameter file.

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)

## Next steps

Microsoft Learn product documentation:

- [Azure Stack HCI operating system, version 23H2 release information](/azure/azure-local/release-information-23h2)
- [AKS on Azure Local](/azure/aks/aksarc/aks-whats-new-local)
- [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-local-overview)
- [What is Azure Local monitoring?](/azure/azure-local/concepts/monitoring-overview)
- [Azure Automation overview](/azure/automation/overview)
- [Azure Automation overview](/azure/automation/overview)
- [Protect VM workloads by using Azure Site Recovery on Azure Local](/azure/azure-local/manage/azure-site-recovery)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Change tracking and inventory overview](/azure/automation/change-tracking/overview-monitoring-agent)
- [Azure Update Manager overview](/azure/update-manager)
- [What are Azure Arc-enabled data services?](/azure/azure-arc/data/overview)
- [What are Azure Arc-enabled servers?](/azure/azure-arc/servers/overview)
- [What is Azure Backup?](/azure/backup/backup-overview)
- [Introduction to Kubernetes compute target in Azure Machine Learning](/azure/machine-learning/how-to-attach-kubernetes-anywhere)
- [Protect your virtual machine settings by using Azure Automation State Configuration](/azure/automation/automation-dsc-onboarding)

Azure product documentation:

- [Azure Local](https://azure.microsoft.com/products/local)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Azure Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

Microsoft Learn training:

- [Configure Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data)
- [Design a solution for backup and disaster recovery](/training/modules/design-solution-for-backup-disaster-recovery)
- [Introduction to Azure Arc](/training/modules/intro-to-azure-arc)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Keep your VMs updated](/training/modules/manage-azure-updates)
- [Protect your VMs by using Backup](/training/modules/protect-virtual-machines-with-azure-backup)

Other resources:

- [Scale model deployment with Azure Machine Learning anywhere - Tech Community Blog](https://techcommunity.microsoft.com/blog/azure-ai-foundry-blog/scale-model-deployment-with-azure-machine-learning-anywhere/2888753)
- [Realizing Machine Learning anywhere with AKS and Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/blog/azurearcblog/realizing-machine-learning-anywhere-with-azure-kubernetes-service-and-arc-enable/3470783)
- [Machine learning on AKS hybrid and Azure Local by using Azure Arc-enabled machine learning - Tech Community Blog](https://techcommunity.microsoft.com/blog/azurestackblog/machine-learning-on-aks-hybrid--stack-hci-using-azure-arc-enabled-ml/3816127)
