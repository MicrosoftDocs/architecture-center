This reference architecture extends the [Azure Local hyperconverged baseline](azure-local-baseline.yml) to cover connected, hyperconverged deployments of three to four machines that use direct links for storage traffic. The machines connect to dual top-of-rack (ToR) switches for the converged management and compute intents, but they don't use storage switches.

Use this architecture when avoiding storage switches justifies the extra network adapter ports, direct cabling, and fixed switchless machine count. *Switchless* applies only to storage traffic. Resilient management and workload connectivity still use external switches. To add a machine to an existing two- or three-machine deployment, the supported [add-node workflow](/azure/azure-local/manage/add-server#supported-scenarios) requires switched storage for the target topology. Plan the storage-switch procurement, recabling, network reconfiguration, capacity, and maintenance window before scale-out. Redeploy when the required target topology isn't supported by the add-node workflow.

> [!IMPORTANT]
> Azure Local also supports one- and two-machine storage-switchless deployments, but they're outside this reference architecture's scope. A single-machine deployment has no destination for live migration or failover, so platform updates and other host maintenance interrupt its workloads. For a two-machine deployment, use the [two-machine network reference pattern](/azure/azure-local/plan/two-node-switchless-two-switches) and separately evaluate its capacity, quorum, and storage-resiliency tradeoffs.

Apply the baseline's connected-management, external-dependency, security, workload-availability, backup, and recovery guidance. This article covers the design differences introduced by storage-switchless networking. Its diagrams illustrate a three-machine dual-link reference pattern. Use the validated reference pattern for your selected machine count.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach |
| --- | --- | --- |
| &#9642; [Architecture](#architecture) <br> &#9642; [Components](#components) <br> &#9642; [Potential use cases](#potential-use-cases) <br> &#9642; [Alternatives](#alternatives) <br> &#9642; [Deploy this scenario](#deploy-this-scenario) | &#9642; [Instance design choices](#instance-design-choices) <br> &#9642; [Network design](#network-design) <br> &#9642; [Physical network topology](#physical-network-topology) <br> &#9642; [Logical network topology](#logical-network-topology) <br> &#9642; [IP address requirements](#ip-address-requirements) | &#9642; [Reliability](#reliability) <br> &#9642; [Cost&nbsp;Optimization](#cost-optimization) <br> &#9642; [Operational&nbsp;Excellence](#operational-excellence) <br> &#9642; [Performance&nbsp;Efficiency](#performance-efficiency) |

## Architecture

:::image type="complex" source="images/azure-local-switchless.svg" lightbox="images/azure-local-switchless.svg" alt-text="Diagram that shows a three-machine Azure Local instance that uses a switchless storage architecture and has dual ToR switches for external connectivity." border="false":::
  The diagram shows three Azure Local machines below two network switches and a central switch, router, or firewall. Each machine has two 1-Gbps-or-faster Ethernet ports for the converged management and compute intent. One port connects to each switch through a trunk port. SET provides resiliency and load balancing. The management network uses one VLAN, and compute networks can use separate VLANs. Each machine also has four dedicated 10-Gbps-or-faster RDMA-capable storage ports. The storage ports don't connect to the switches. Instead, each pair of machines connects through two direct links for redundancy. The six links form six separate Layer 2 storage networks: 10.0.1.0/24 through 10.0.6.0/24. Storage adapters have no default gateway, and the Network ATC storage intent uses VLAN 711 with automatic IP addressing disabled.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-local-baseline-and-switchless.pptx) that contains the baseline and storage-switchless architectures.*

For other supported machine counts and link arrangements, see [Related resources](#related-resources).

## Components

This architecture uses the [platform and supporting resources from the baseline architecture](/azure/architecture/hybrid/azure-local-baseline#components). The illustrated three-machine dual-link pattern adds the following networking components:

- **Dedicated storage adapters.** Each machine has four dedicated 10-Gbps-or-faster RDMA-capable adapters for storage traffic.
- **Direct storage links.** Six Ethernet links connect the storage adapters in a full mesh. Two redundant links connect each pair of machines without passing through a storage switch.
- **Dual ToR switches.** The ToR switches remain part of the architecture for management and workload traffic. Each machine connects one converged management and compute adapter to each switch.

Component counts and link arrangements differ for other machine counts. Use the validated reference pattern for your selected topology.

## Potential use cases

Use this design when:

- Workloads need a highly available Azure Local platform of three to four machines at one location, and their forecast compute and storage demand fits the selected fixed machine count for the deployment's expected lifetime.

- Direct storage links provide an acceptable operational and cost tradeoff compared with procuring, configuring, and maintaining storage switches.

## Alternatives

| Requirement | Deployment model |
| --- | --- |
| Ability to add machines after deployment or deploy more than four machines | Use the [storage-switched hyperconverged baseline](azure-local-baseline.yml). |
| A three-machine deployment with fewer storage adapters and cables when storage path redundancy isn't required | Use the [three-machine single-link switchless pattern](/azure/azure-local/plan/three-node-switchless-two-switches-single-link). This pattern uses one direct storage link between each pair of machines, so a cable, port, or adapter failure can interrupt the affected storage path. |
| Local rack fault domains | Evaluate a [rack-aware cluster deployment](/azure/azure-local/concepts/rack-aware-cluster-overview). |
| SAN storage and independent compute and storage scaling | Evaluate an [Azure Local disaggregated deployment](/azure/azure-local/overview/disaggregated-overview). |
| Operation without Azure-connected management | Evaluate an [Azure Local disconnected operations deployment](/azure/azure-local/manage/disconnected-operations-overview). |

## Instance design choices

For guidance and recommendations for your Azure Local instance design choices, refer to the [baseline reference architecture](azure-local-baseline.yml). Size the selected three- or four-machine instance for workload demand, growth, maintenance, storage resiliency, and failure-state requirements.

Storage-switchless deployments support a maximum of four machines. Select the machine count and validated network reference pattern before deployment. Size each machine so the instance can meet forecast demand, storage-resiliency overhead, and *N*+1 capacity requirements for its expected hardware lifetime. For workload availability through two machine failures, use the [four-machine switchless pattern](/azure/azure-local/plan/four-node-switchless-two-switches-two-links), configure a cluster witness, use a symmetrical storage layout with three-way mirror or dual parity, and reserve *N*+2 compute capacity. For more information, see [Understanding cluster and pool quorum](/windows-server/storage/storage-spaces/quorum) and [Plan volumes on Azure Local and Windows Server clusters](/windows-server/storage/storage-spaces/plan-volumes). Scaling out an existing two- or three-machine deployment changes the storage architecture to switched because the supported target scenarios require switched storage.

For production deployments, we recommend three machines as the default storage-switchless topology. Three machines are the minimum required for Storage Spaces Direct three-way mirror volumes. Three-way mirror is appropriate for performance-sensitive workloads and keeps data accessible during two simultaneous hardware problems when no more than one is a machine failure. If two of the three machines become unavailable, the storage pool loses quorum and its virtual disks become inaccessible. Three-way mirror stores three copies, so usable capacity is approximately 33.3% of raw capacity. This storage resiliency doesn't replace sufficient compute capacity, workload redundancy, backups, or disaster recovery. Use four machines when requirements include workload availability through two machine failures, more aggregate compute or storage capacity, or dual parity or mixed resiliency.

> [!CAUTION]
> A storage-switchless target doesn't support add-node scale-out. To expand an existing deployment through the supported add-node workflow, change the target design to storage-switched networking and follow your hardware provider's cabling and configuration guidance. Redeploy when the required target topology isn't a supported add-node scenario. Plan workload migration or maintenance and recovery capacity before the current deployment reaches its limits.

### Network design

In a storage-switchless design, the machines connect directly for storage traffic. Direct links eliminate the need to configure storage switches, including priority flow control (PFC) and explicit congestion notification (ECN). Network ATC still configures the host storage intent, and the adapters, drivers, firmware, cabling, and RDMA protocol must match the validated solution and hardware-provider guidance.

> [!NOTE]
> Storage adapter, cable, network, and IP requirements vary by machine count and link redundancy. The illustrated three-machine dual-link pattern requires six network adapter ports per machine: four for storage and two for management and compute. Validate your selected reference pattern with your hardware manufacturer.

A [four-machine switchless pattern with dual storage links](/azure/azure-local/plan/four-node-switchless-two-switches-two-links) requires eight network adapter ports per machine: six for storage and two for management and compute.

The following physical, logical, and IP address sections describe the illustrated three-machine dual-link pattern. Don't apply its counts or cable map to a four-machine deployment.

#### Physical network topology

The physical network topology shows the connections between machines and networking components. The following configuration outlines the connections in a three-machine storage-switchless Azure Local deployment:

:::image type="complex" source="images/azure-local-3-node-physical-network.svg" lightbox="images/azure-local-3-node-physical-network.svg" alt-text="Diagram of a three-machine Azure Local instance with switchless storage architecture and dual ToR switches for external connectivity." border="false":::
  The diagram shows three Azure Local machines below two network switches. A switch, router, or firewall connects to both switches, which connect to each other via link aggregation. Each machine has two 1-Gbps-or-faster management and compute ports that use SET. One port is connected to each switch. Each machine also has four dedicated 10-Gbps-or-faster RDMA ports labeled SMB1 through SMB4. The storage ports bypass the switches. Two color-matched direct links connect every pair of machines, creating six redundant point-to-point storage paths across the three-machine instance.
:::image-end:::

The three-machine physical topology includes the following components and connections:

- Three machines:

  - Each machine is a physical server that runs the Azure Local operating system.
  
  - Each machine requires six network adapter ports in total: four RDMA-capable ports for storage and two ports for management and compute.
  
- Storage traffic:

  - Each machine has four dedicated storage ports. Two redundant links connect it directly to each of the other two machines.
  
  - The storage network adapter ports connect the machines directly by using Ethernet cables to form a full-mesh network architecture for storage traffic.
  
  - This design provides link redundancy, dedicated low latency, high bandwidth, and high throughput.
  
  - Machines within the Azure Local instance communicate directly through these links to handle storage replication traffic, also known as *east-west traffic*.

  - This direct communication eliminates storage-switch ports and the associated switch QoS, PFC, and ECN configuration for the direct links.
  
  - Check with your hardware manufacturer partner or network interface card (NIC) vendor for any recommended operating system drivers, firmware versions, or firmware settings for the switchless interconnect network configuration.
  
- Dual ToR switches:

  - This configuration is switchless for storage traffic but still requires ToR switches for external connectivity. This connectivity is known as *north-south traffic* and includes the management intent and workload compute intents.
  
  - The uplinks to the switches from each machine use two network adapter ports. Ethernet cables connect these ports, one to each ToR switch, to provide link redundancy.
  
  - We recommend that you use dual ToR switches to provide redundancy for servicing operations and load balancing for external communication.
  
- External connectivity:

  - The dual ToR switches connect to the external network, such as the internal corporate local area network (LAN), and use your edge border network device, such as a firewall or router, to provide access to the required outbound URLs.
  
  - The two ToR switches handle the north-south traffic for the Azure Local instance, including traffic related to management and compute intents.

#### Logical network topology

The logical network topology provides an overview of how network data flows between devices, regardless of their physical connections.

:::image type="complex" source="images/azure-local-3-node-logical-network.svg" lightbox="images/azure-local-3-node-logical-network.svg" alt-text="Diagram that shows the logical networking topology for a three-machine Azure Local instance." border="false":::
  The diagram shows the logical network topology for a three-machine Azure Local instance that uses a storage-switchless architecture. It illustrates the flow of network traffic between components. The diagram shows three physical machines. Network ATC defines intents for management, compute, and storage traffic. The management and compute intents converge onto a virtual switch that uses Switch Embedded Teaming (SET). The storage intent uses dedicated RDMA-capable adapters that connect the machines directly in a full mesh. The diagram also depicts logical networks for virtual machines and the connection to the external network through the ToR switches.
:::image-end:::

The following list summarizes the logical setup for a three-machine storage-switchless Azure Local instance.

- Dual ToR switches:

  - Before you deploy the instance, configure the two ToR network switches with the required VLAN IDs and maximum transmission unit (MTU) settings for the management and compute ports. For more information, see the [physical network requirements](/azure/azure-local/concepts/physical-network-requirements) or ask your switch hardware vendor or systems integrator partner for assistance.
  
- [Network ATC](/windows-server/networking/network-atc/network-atc):

  - Azure Local applies network automation and intent-based network configuration by using the [Network ATC service](/windows-server/networking/network-atc/network-atc).
  
  - Network ATC is designed to ensure optimal networking configuration and traffic flow by using network traffic *intents*. Network ATC defines which physical network adapter ports are used for the different network traffic intents (or types), such as for the management, workload compute, and storage intents.
  
  - Intent-based policies simplify the network configuration requirements by automating the machine network configuration based on parameters that you specify as part of the Azure Local cloud deployment process.

- External communication:

  - When the machines or workloads need to communicate externally by accessing the corporate LAN, internet, or another service, they [route by using the dual ToR switches](#physical-network-topology).
  
  - When the two ToR switches act as Layer 3 devices, they handle routing and provide connectivity beyond the instance to the edge border device, such as a firewall or router.
  
  - Management network intent uses the converged Switch Embedded Teaming (SET) virtual interface, which enables the cluster management IP address and control plane resources to communicate externally.
  
  - For the compute network intent, you can create one or more logical networks in Azure with the specific VLAN IDs for your environment. The workload resources, such as virtual machines (VMs), use these IDs to provide access to the physical network. The logical networks use the two physical network adapter ports that are converged by using SET for the compute and management intents.
  
- Storage traffic:

  - The machines communicate with each other directly for storage traffic by using four direct-interconnect Ethernet ports per machine. The links use six separate nonroutable, or Layer 2, storage networks.

  - There's no default gateway configured on the four storage intent network adapter ports within the Azure Local operating system.

  - Each machine accesses remote Storage Spaces Direct capacity through SMB Direct over its four dedicated RDMA-capable storage ports. SMB Multichannel uses the redundant paths.
  
  - This configuration ensures sufficient data transfer speed for storage-related operations, such as maintaining consistent copies of data for mirrored volumes.

#### IP address requirements

To deploy the illustrated three-machine dual-link storage-switchless configuration, allocate at least 20 IP addresses: 12 storage addresses, one for each of the four storage adapters on each machine, and eight management addresses for the three machines and five infrastructure roles. You need more IP addresses if you use a VM appliance supplied by your hardware manufacturer partner or if you use microsegmentation or software-defined networking (SDN). For the six-subnet storage layout, see the [three-machine dual-link network reference pattern](/azure/azure-local/plan/three-node-switchless-two-switches-two-links).

When you design and plan IP address requirements for Azure Local, remember to account for extra IP addresses or network ranges needed for your workload beyond the ones that are required for the Azure Local instance and infrastructure components. If you plan to use Azure Kubernetes Service (AKS) on Azure Local, see [AKS on Azure Local network requirements](/azure/aks-hybrid-edge/local/hyperconverged/network-system-requirements).

#### Outbound network connectivity

Review the [outbound network connectivity section of the Azure Local baseline reference architecture](/azure/architecture/hybrid/azure-local-baseline#outbound-network-connectivity). The guidance and recommendations apply to both the storage-switched and storage-switchless architectures.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

> [!IMPORTANT]
> Review the Well-Architected Framework considerations described in the [Azure Local baseline reference architecture](/azure/architecture/hybrid/azure-local-baseline#considerations).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Before deployment, size and procure enough CPU and memory capacity so the remaining available machines can meet current and forecast workload demand within performance targets while one machine is in maintenance or unavailable. Account for CPU and memory overcommit when you validate this failure state. For workload availability through two machine failures, use the four-machine topology described in [Instance design choices](#instance-design-choices), configure a cluster witness, use the specified storage layout, and reserve *N*+2 compute capacity. *N*+2 compute capacity alone doesn't provide failure tolerance.

- Use two storage links between each pair of machines. Test a failed cable, port, or adapter path and verify that SMB Multichannel continues to use the remaining path without exhausting its bandwidth.

- Use dual ToR switches for management and compute, as described in the baseline architecture. Storage-switchless networking doesn't remove north-south network failure domains.

- Choose volume resiliency for the required failure scenarios and usable capacity. Monitor storage repair state and capacity after a machine, adapter, or link failure.

- Prefer three-way mirror for performance-sensitive workloads on the recommended three-machine topology. Validate that the remaining compute and storage capacity can run workloads and complete storage repair during overlapping maintenance and failure conditions.

- Treat the deployment as one local failure domain. Use workload-level replication and recovery across independent failure domains when workloads must survive instance, rack, or site loss.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Compare the avoided storage-switch, optic, support, and configuration costs with the selected pattern's RDMA-capable storage adapters, direct cables, replacement inventory, and troubleshooting labor.

- Include the cost of capacity headroom and a later topology change. Add-node scale-out from an existing switchless deployment requires switched storage for the target topology, which adds switch, optics, cabling, configuration, and maintenance costs. Redeployment might be required when the target isn't a supported add-node scenario.

- Confirm that the existing ToR switches have enough ports and supported capabilities for redundant management and compute connectivity. Switchless deployment doesn't eliminate these switches.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use the validated cable map for the selected machine count and link pattern. Label both ends of every direct link, record adapter names and MAC addresses, and keep the same adapter, driver, firmware, and VLAN configuration on every machine.

- Run the Azure Local Environment Checker after cabling changes and before deployment. Validate all storage networks, RDMA operation, redundant paths, management and compute connectivity, and required outbound access.

- Monitor physical-link state, SMB Multichannel paths, RDMA counters, storage health, repair jobs, and remaining capacity. Include cable and adapter replacement in operational procedures and spare-parts planning.

- Document a scale-out or migration plan before the hardware approaches capacity. For supported add-node scenarios, plan how to introduce switched storage, and validate the target network before adding a machine. Include a redeployment and workload-migration plan for unsupported target scenarios.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Size direct-link bandwidth for storage replication, repair, live migration, and workload demand during normal and degraded operation. A surviving link must carry the traffic when its redundant link fails.

- Use three-way mirror when workload requirements prioritize storage performance and data protection from two simultaneous hardware problems over storage efficiency. On a three-machine instance, continuous volume access still requires cluster and storage-pool quorum. Two unavailable machines make the virtual disks inaccessible. Test the selected volume layout with production-representative I/O because machine count and resiliency type alone don't determine workload performance.

- Establish performance baselines before production and after firmware, driver, or cabling changes. Test steady-state load, a failed storage link, a machine in maintenance, and storage repair activity.

- Forecast compute, memory, and usable storage growth for the hardware lifetime. A switchless target can't scale out in place. Supported expansion requires a storage-switched target topology. Unsupported target scenarios require workload migration and redeployment.

## Deploy this scenario

Use the [baseline deployment workflow](/azure/architecture/hybrid/azure-local-baseline#deploy-this-scenario) for requirements, sizing, dependencies, environment validation, and operations. For the illustrated three-machine dual-link pattern, replace the baseline's portal deployment step with an [Azure Resource Manager template deployment](/azure/azure-local/deploy/deployment-azure-resource-manager-template) because the Azure portal doesn't support deploying this topology. Before deployment, validate the cable map, adapter symmetry, storage networks, RDMA operation, IP allocation, and ToR connectivity against the [three-machine dual-link network reference pattern](/azure/azure-local/plan/three-node-switchless-two-switches-two-links).

## Next steps

- [Architecture best practices for Azure Local](/azure/well-architected/service-guides/azure-local)
- [Azure Local network reference patterns](/azure/azure-local/plan/network-patterns-overview)
- [Two-machine switchless with two ToR switches](/azure/azure-local/plan/two-node-switchless-two-switches)
- [Three-machine switchless with two ToR switches and dual storage links](/azure/azure-local/plan/three-node-switchless-two-switches-two-links)
- [Four-machine switchless with two ToR switches and dual storage links](/azure/azure-local/plan/four-node-switchless-two-switches-two-links)
- [Physical network requirements for Azure Local](/azure/azure-local/concepts/physical-network-requirements)
- [Host network requirements for Azure Local](/azure/azure-local/concepts/host-network-requirements)

## Related resources

- [Azure Local hyperconverged baseline reference architecture](azure-local-baseline.yml)