Hybrid architecture can combine services in Azure with infrastructure and workloads in datacenters, at edge locations, and in other clouds. This article helps you evaluate requirements and select Azure services and operating models for a hybrid solution. For foundational concepts and a planning workflow, see [Get started with Azure hybrid and adaptive cloud architecture](../../hybrid/hybrid-start-here.md).

## Hybrid considerations

Start with workload and organizational requirements. Don't select a platform based only on current hardware location.

In general, use managed services hosted in Azure when workload requirements allow. Keep compute local only when latency, physical-system dependencies, data constraints, or operational independence justify it. Use Azure Arc to govern supported resources outside Azure. Use Azure Local when you need validated, Azure-consistent infrastructure in your locations. Use hybrid and multicloud guiding principles to document exceptions and portability requirements.

> [!NOTE]
> Azure Local runs on validated hardware that customers procure from Microsoft OEM partners. It supports several deployment types and two connectivity modes. For more information, see [Find your Azure Local deployment type](/azure/azure-local/plan/find-your-deployment-type).

### Workload and data placement

Identify where each workload and its data can run. Consider latency, data gravity, bandwidth, service availability, resiliency, and dependencies on local applications or systems. A workload might need to remain local because it controls physical equipment, processes large data volumes near their source, or must continue operating if it loses external connectivity. Other workloads might benefit from the elasticity and managed services available in Azure regions.

Data residency, privacy, confidentiality, and retention requirements can differ for each data type. Document where your application data, model inputs and outputs, logs, telemetry, identity data, configuration, and support data can be stored and processed, and whether each data type can cross location or jurisdictional boundaries. 

### Sovereignty and regulatory controls

Translate sovereignty controls into specific architectural requirements. These requirements can include jurisdictional control, operational autonomy, data residency, personnel access, encryption key ownership, supply-chain controls, and the ability to operate without a connection to a public cloud.

When requirements call for Microsoft cloud services in sovereign, regulated, or disconnected environments, evaluate [Microsoft Sovereign Private Cloud](/azure/azure-sovereign-clouds/private/overview/sovereign-private-cloud). Azure Local provides the infrastructure foundation, and individual solutions have different deployment and connectivity requirements.

Running a workload locally doesn't satisfy sovereignty, privacy, or regulatory requirements by itself. Evaluate the complete solution, including its control plane, identity system, update process, monitoring, support model, and administrative access. Confirm that evidence and controls meet the requirements that apply to your organization.

### Connectivity and operational independence

Classify each location as reliably connected, intermittently connected, or disconnected. Then identify which operations must continue during a connectivity outage, and for how long.

Azure Arc-enabled resources normally establish outbound connections to Azure. Individual Arc-enabled services have their own endpoints and connectivity requirements. Azure Local supports connected and disconnected operating models, but the disconnected operating model provides a subset of Azure capabilities and has distinct lifecycle and hardware requirements. Treat disconnected operations as an architecture choice, not only as a network configuration.

### Infrastructure and scale

Decide whether to reuse existing servers and virtualization platforms or deploy validated Azure Local infrastructure. Azure Arc supports several existing infrastructure types. Azure Local supports hyperconverged, disaggregated, multi-rack, and small form factor (preview) deployment types, with scale ranging from one to hundreds of machines. Use [Find your Azure Local deployment type](/azure/azure-local/plan/find-your-deployment-type) to compare connectivity modes, scale, and storage architectures.

Plan capacity for failures, maintenance, upgrades, and workload growth. AI inference, virtual desktops, and container platforms can have substantially different processor, graphics processing unit (GPU), memory, storage, and network requirements.

### Resiliency and recovery

Define availability and [recovery targets](/azure/well-architected/reliability/metrics) for each workload, including its recovery time objective (RTO) and recovery point objective (RPO). Evaluate local hardware, instance, site, connectivity, and dependent-service failures. Use the targets to compare replication, backup, failover, failback, and recovery automation for each candidate approach. Confirm that sovereignty and data residency requirements allow the locations that store replicas and backups.

Match failure domains to your workload recovery targets. If a business-critical or mission-critical workload must survive an instance or site outage, evaluate running multiple workload instances across separate Azure Local instances and physical locations.

For Azure Local, review [Infrastructure resiliency for Azure Local](/azure/azure-local/manage/disaster-recovery-infrastructure-resiliency) to design validated hardware, failover clustering, storage fault tolerance, and redundant networking. For rack-level failures within one instance, consider an [Azure Local rack-aware cluster](/azure/azure-local/concepts/rack-aware-cluster-overview). This architecture distributes nodes and data copies across two physical racks, but it requires high-bandwidth connectivity with round-trip latency of 1 millisecond or less.

Use backup and continuous replication to address failures that redundancy within one Azure Local instance can't mitigate. Align backup frequency with the workload RPO, retain recovery copies outside the failure domains that they protect, and regularly test VM and data restoration. For Azure Local VMs, review [Virtual machine resiliency for Azure Local](/azure/azure-local/manage/disaster-recovery-vm-resiliency), which compares backup options, replication to Azure by using Azure Site Recovery, and replication between Azure Local instances by using Hyper-V Replica.

Supplement VM-level protection with workload-native continuity mechanisms where application consistency or dependencies require them. Review [Workload resiliency for Azure Local](/azure/azure-local/manage/disaster-recovery-workloads-resiliency) for examples that apply to Arc-enabled SQL Server and Azure Virtual Desktop.

Document recovery sequencing and network changes. Conduct test failovers regularly to validate RTOs and maintain staff readiness. Set the cadence based on workload criticality, RTO and RPO targets, business continuity and compliance requirements, and material changes to the workload or recovery process. For broader recommendations, review the [Reliability pillar in architecture best practices for Azure Local](/azure/well-architected/service-guides/azure-local#reliability).

### Ownership and cost

Evaluate the total cost of ownership for each hosting option. For Azure Local, include capital expenditures such as hardware procurement and network integration. Include operating expenditures such as software and support, power, cooling, datacenter space, connectivity, backup and disaster recovery, hardware lifecycle, and ongoing platform and workload operations. Compare these costs with the consumption, data transfer, and operational costs of services hosted in Azure.

Azure Local runs on validated physical infrastructure in your locations, not on Microsoft-owned infrastructure in an Azure region. In connected deployments, Azure provides the control plane, but your organization and its partners operate the local facilities, hardware, and network integration. Select hardware from Microsoft hardware partners in the [Azure Local solutions catalog](https://azurelocalsolutions.azure.microsoft.com/#/catalog).

### Operations and governance

Define which team owns hardware, platform, workloads, identity, security, and network. Standardize resource organization, policy, role-based access control, monitoring, update management, and infrastructure as code where the selected services support them.

A common control plane can reduce differences between operating environments, but doesn't replace all platform-specific tasks. Account for local hardware lifecycle, service prerequisites, disconnected update processes, and the skills required to troubleshoot each location.

## Hybrid approach decision tree

The following decision tree shows four approaches based on workload location, connectivity, and operational requirements.

:::image type="complex" source="./images/hybrid-decision-tree.svg" lightbox="./images/hybrid-decision-tree.svg" alt-text="Decision tree that maps workload location, connectivity, and operational requirements to four hybrid approaches." border="false":::
   The decision tree shows arrows pointing from a box at the top labeled operating environments and connections to four hybrid solutions paths. The first Azure-hosted path shows Azure connected with ExpressRoute or encrypted site-to-site VPN. The second distributed resources path shows existing servers or multicloud resources with Azure Arc management. The third path labeled local with Azure connection uses an Azure control plane with on-premises or edge workloads and data. The fourth path labeled no persistent Azure connection uses Azure Local disconnected operations with a local control plane in an extended or permanent disconnected state.
:::image-end:::

- **Connectivity to Azure services.** Workloads can run in Azure, and users or systems in on-premises or edge networks connect privately to Azure services in Azure regions through ExpressRoute or an encrypted site-to-site VPN.

- **Manage existing distributed resources.** You can manage existing Windows and Linux servers, VMware vSphere, or System Center Virtual Machine Manager resources with Azure Arc-enabled services or use multicloud connectors enabled by Azure Arc.

- **Run workloads locally with connectivity to Azure.** With Azure Local connected mode, the control plane runs in Azure, while workloads and data run and are stored on validated hardware in on-premises or edge locations.

- **Operate without persistent connectivity to Azure.** With Azure Local disconnected operations, a local control plane supports operations during an extended or permanent disconnected state. Workloads run in on-premises or edge locations on validated hardware.

Use the following table to compare candidate approaches and their implications. A solution can combine multiple rows.

| Requirement | Approach | Key implications and recommendations |
| --- | --- | --- |
| The workload should run in an Azure region. | [Choose an Azure service](technology-choices-overview.md) that provides infrastructure as a service (IaaS), platform as a service (PaaS), or software as a service (SaaS). | Evaluate regional availability, data residency, network access, shared responsibility, and service dependencies. If the workload requires private-only access, verify that the service supports Azure Private Link through private endpoints and lets you disable public network access. |
| Users or systems in your locations need to connect to workloads and services that run in an Azure region. | Use [ExpressRoute](/azure/expressroute/expressroute-introduction) for a private provider connection or [VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) for an encrypted tunnel over the public internet. | Azure hosts the workloads. Design routing, name resolution, security inspection, bandwidth, and connection resiliency. |
| You want Azure inventory, governance, security, or operations for existing on-premises workloads. | Use [Azure Arc-enabled servers](/azure/azure-arc/servers/overview) to manage Windows and Linux machines. | Workloads remain on their current servers or hypervisor platform. Confirm agent connectivity, supported features, and data collection settings. |
| You want to manage existing Kubernetes or virtualization platforms through Azure. | Use [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview), [Azure Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview), or [Azure Arc-enabled System Center Virtual Machine Manager](/azure/azure-arc/system-center-virtual-machine-manager/overview). | Capabilities and prerequisites differ by resource type. Azure Arc doesn't convert the underlying platform into Azure Local. |
| You need validated local infrastructure for VMs, AKS, or supported Azure Arc-enabled services. | Use [Azure Local in connected mode](../../hybrid/azure-local-baseline.yml). | Azure is the control plane. During a connectivity loss, host infrastructure and existing VMs continue to run, but cloud-dependent features become unavailable, and information in the Azure portal might become outdated. Hyperconverged deployments must [sync with Azure at least once every 30 days](/azure/azure-local/faq#what-happens-if-my-network-connection-to-the-control-plane-temporarily-goes-down-how-long-can-azure-local-run-with-the-connection-down-what-happens-if-the-30-day-limit-is-exceeded), or they enter reduced functionality and can't create VMs. [AKS on Azure Local](/azure/aks/aksarc/connectivity-modes) can stop functioning if its certificates expire. Select a deployment type and validated hardware that meet workload and availability requirements. |
| Sovereignty, regulatory, or air-gap requirements prevent connectivity to Azure. | Evaluate [disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview). | Requires Azure Local 2602 or later. Eligibility requires a valid business need to operate disconnected, an eligible Microsoft agreement, an active Standard-or-higher support plan with Microsoft or a partner that has an active support plan, Premier Solutions hardware, a dedicated management cluster, and staff or a partner capable of deploying and operating the environment. Plan capacity and lifecycle processes for the local control plane. |
| AI inference must run near local applications and data or within a controlled local environment. | Evaluate [Foundry Local on Azure Local](/azure/azure-sovereign-clouds/private/foundry-local/overview). | The service is in preview and available by request. Plan Azure Local and Kubernetes capacity, supported models, application integration, security, and connected or disconnected operations. |
| Industrial or OT devices need local connectivity, messaging, and data processing. | Use [Azure IoT Operations](/azure/iot-operations/overview-iot-operations) on Azure Arc-enabled Kubernetes. | We recommend Azure IoT Operations for new edge-connected solutions. It can operate offline for a maximum of 72 hours and might degrade during that period. Plan Kubernetes infrastructure, supported protocols, Azure Arc connectivity, and reconnection within the supported offline window. |
| Software must run on device-oriented or constrained edge hardware. | Use [Azure IoT Edge](/azure/iot-edge/about-iot-edge) with Azure IoT Hub. | Plan device provisioning, IoT Hub dependencies, fleet management, intermittent connectivity, local storage, and software lifecycle management. Azure IoT Edge and Azure IoT Operations have different architectures and no direct migration path. |

## Evaluate services for specialized workloads

After you select workload placement, infrastructure, and connectivity mode, evaluate services for specialized workload requirements. Confirm that each service supports your target environment and operating model, because infrastructure, availability, and connectivity requirements differ.

AI requirements can change where you place compute and data. Local inference can reduce round-trip latency and help keep model inputs and outputs within a controlled environment. AI also requires sufficient compute capacity, model lifecycle controls, security controls, and an operating model for applications and data.

For an introduction to generative AI concepts, architecture patterns, model selection, and development platforms, see the [AI technology overview](/azure/architecture/ai-ml/ai-overview). Use the [Microsoft Foundry model catalog](https://ai.azure.com/explore/models) to explore available models. Model availability, capabilities, and deployment options differ between Azure-hosted and local environments, so confirm support for your target environment before you select a model.

The following services address AI, media analysis, development, and productivity workloads on Azure Local or other Azure Arc-enabled infrastructure:

- [Foundry Local on Azure Local](/azure/azure-sovereign-clouds/private/foundry-local/overview) is in preview and available by request. It runs AI inference on an Azure Arc-enabled Kubernetes cluster on Azure Local and supports connected and disconnected environments. OpenAI-compatible REST patterns and synchronization with the Foundry model catalog provide familiar application integration and model discovery patterns. Deployment, operations, and supported models differ from Microsoft Foundry in Azure.

- [Agentic Retrieval in Foundry Local](/azure/azure-arc/agents-tools-foundry-local/overview) is in preview. It provides local retrieval-augmented generation and agent capabilities on Azure Local. Support for disconnected operations is also in preview.

- [Azure AI Video Indexer enabled by Arc](/azure/azure-video-indexer/arc/azure-video-indexer-enabled-by-arc-overview) performs video and audio analysis on Azure Arc-enabled Kubernetes. Access is gated, and the service supports direct connection mode only. Media and insights remain at the edge, but control-plane information is sent to Azure for billing and monitoring.

- [GitHub Enterprise Local](/azure/azure-sovereign-clouds/private/github-local/github-local-overview) is in preview. It runs GitHub Enterprise Server on Azure Local for connected or disconnected development environments.

- [Microsoft 365 Local](/azure/azure-sovereign-clouds/private/m365-local/microsoft-365-local-overview) is generally available. It runs supported Exchange Server, SharePoint Server, and Skype for Business Server workloads on Azure Local and requires deployment through an authorized solution partner.

Don't use preview services in production environments. Review current support, regional availability, hardware, connectivity, licensing, and preview terms before you include them in an architecture.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Neil Bird](https://www.linkedin.com/in/neil-bird-/) | Principal Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Find your Azure Local deployment type](/azure/azure-local/plan/find-your-deployment-type)
- [Azure Arc and the adaptive cloud approach](/azure/azure-arc/overview#azure-arc-and-the-adaptive-cloud-approach)

## Related resources

- [Get started with Azure hybrid and adaptive cloud architecture](../../hybrid/hybrid-start-here.md)
- [Azure Local baseline reference architecture](../../hybrid/azure-local-baseline.yml)
- [AKS baseline architecture for AKS on Azure Local](../../example-scenario/hybrid/aks-baseline.yml)
- [Azure Virtual Desktop on Azure Local](../../hybrid/azure-local-workload-virtual-desktop.yml)
- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Azure AI technology overview](../../ai-ml/ai-overview.md)
