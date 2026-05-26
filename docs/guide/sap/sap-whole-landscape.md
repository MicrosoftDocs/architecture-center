---
title: SAP Landscape Architecture
description: Best practices and recommendations for architecting an entire SAP landscape on Azure.
author: msftrobiro
ms.author: robiro
ms.date: 03/03/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# SAP landscape architecture

This article provides best practices for architecting an entire SAP landscape in Azure. The SAP landscape includes multiple SAP systems across hub, production, nonproduction, and disaster recovery (DR) environments. The article provides recommendations that focus on network design and not specific SAP systems. The goal is to provide recommendations for architecting a secure, high-performing, and resilient SAP landscape.

## Architecture

:::image type="complex" source="media/sap-whole-landscape.svg" border="false" lightbox="media/sap-whole-landscape.svg" alt-text="Diagram that shows a sample SAP landscape in Azure.":::
This diagram presents an end-to-end SAP landscape that crosses two Azure regions: a primary region and a disaster recovery (DR) region. It uses numbered callouts to indicate the workflow. Callout 1 marks the on-premises network, which connects to callout 2, the Azure subscription for regional hubs. The connection uses ExpressRoute for the primary region, and ExpressRoute or VPN for the DR region. Callout 3 is a hub virtual network in the primary region, and callout 4 is a hub virtual network in the DR region. Each hub network contains subnets for a gateway, Azure Firewall, shared services, and Application Gateway. Shared services include Active Directory and DNS. Callout 5 identifies the SAP nonproduction subscription, which contains separate spoke virtual networks for development, pre-production/QA, and sandbox environments, each labeled with callout 6. Each nonproduction spoke contains application and database subnets and a private endpoint and connects to either Azure Files or Azure NetApp Files with SMB/NFS shares. In the pre-production spoke, Azure NetApp Files is in its own subnet. Callout 7 identifies the SAP production subscription, which contains the primary SAP production spoke, labeled 8, and a mirrored SAP production DR spoke labeled 9. These production spokes contain application, database, perimeter, and Azure NetApp Files subnets. Each one contains tiers for the SAP Web Dispatcher pool, SAP ASCS and application servers, databases, and SAProuter. Each one also contains a private endpoint. Hub-to-spoke connectivity is provided by virtual network peering. The diagram shows asynchronous database replication, asynchronous Site Recovery replication, and NFS/SMB file replication between the primary and DR production environments. The nonproduction environment and both production environments all contain callouts labeled 10. Each of these callouts is associated with a cloud witness, Data Factory, Data Lake Storage, and Recovery Services vaults. The primary production environment also contains Site Recovery. The Recovery Services vaults icon in the DR environment is labeled G(Z)RS. Callout 11 depicts SAP BTP access through Private Link service via DEV, QAS, and PRD subaccounts.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sap-whole-landscape.vsdx) of the architecture.*

### Workflow

1. *On-premises network*. An Azure ExpressRoute connection from the on-premises network to connected Azure regions.
1. *Azure subscription: regional hubs*. An Azure subscription that contains central services for the whole enterprise, not just SAP. The hub subscription provides central services and connectivity by peering to spoke virtual networks that contain SAP workloads.
1. *Hub virtual network*. A virtual network spoke for the central hub in the primary region.
1. *Hub virtual network in DR region*. A virtual network spoke for the central hub in the DR region. It mirrors the subnet design of the production virtual network in the primary region.
1. *Azure subscription: SAP nonproduction*. An Azure subscription for all nonproduction SAP workloads. It includes pre-production, quality assurance, development, and sandbox environments.
1. *SAP nonproduction spoke virtual networks*. Separate virtual networks for SAP nonproduction workloads in the primary region. Each SAP environment has its own virtual network and subnets.
1. *Azure subscription: SAP production*. An Azure subscription for all production SAP workloads.
1. *SAP production spoke virtual network*. A virtual network for the SAP production environment. It contains multiple subnets. This virtual network is in the primary region.
1. *SAP production DR spoke virtual network*. A virtual network for SAP production in the secondary, DR region. It mirrors the subnet design of the production virtual network in the primary region.
1. *Azure services*. Example Azure services that you can connect to the SAP landscape.
1. *SAP Business Technology Platform (BTP)*. The SAP BTP. The SAP environment accesses the BTP through Azure Private Link.

### Azure subscriptions

We recommend a hub-spoke network design. In a hub-spoke design, you need at least three subscriptions to divide your SAP environments:

- One for the regional hub virtual networks
- One for nonproduction virtual networks
- One for production virtual networks

Subscriptions provide billing, policy, and security boundaries. The number of subscriptions that you use depends on your billing, policy, and security needs. In general, avoid using too many subscriptions. Too many subscriptions can add unneeded management overhead and networking complexity. For example, you don't need a subscription for each SAP system. This architecture uses three subscriptions:

- *Regional hubs*. A virtual hub subscription where the hub virtual network is located for the primary and secondary regions. This subscription is for all central services, not just SAP.

- *SAP nonproduction*. An SAP nonproduction subscription where nonproduction systems reside, including sandbox, development, quality assurance, or pre-production systems.

- *SAP production*. An SAP production subscription that contains the production and DR systems.

For more information, see:

- [Limits for each subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits)
- [Azure policies](/azure/governance/policy/overview)
- [Management groups](/azure/governance/management-groups/overview)

### Network design

A hub-spoke topology is the recommended network design for an SAP landscape. In this topology, the production hub virtual network acts as a central point of connectivity. It connects to the on-premises network and the various spoke virtual networks and enables users and applications to access the SAP workload. This section provides recommendations for SAP network design in this hub-spoke topology.

**Use ExpressRoute for on-premises connection.** For SAP workloads, we recommend that you use ExpressRoute to connect the on-premises network to the hub virtual network and hub DR virtual network. You can use Azure Virtual WAN topology if you have global locations. Consider setting up a site-to-site (S2S) VPN as a backup to ExpressRoute or any third-party route requirements.

For more information, see:

- [Network topology and connectivity for an SAP migration](/azure/cloud-adoption-framework/scenarios/sap/eslz-network-topology-and-connectivity)
- [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke)
- [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about)
- [S2S VPN as a backup for ExpressRoute private peering](/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering)

**Use one virtual network per environment.** We recommend using one virtual network per SAP environment (deployment tier). The architecture uses a different virtual network for production, development, quality assurance, and sandbox. This network design is ideal for large enterprise architectures.

**Use a central firewall.** All network traffic to the spoke virtual networks, including remote function call (RFC) connections, should pass through a central firewall in the hub virtual network. All communication between the spoke virtual networks passes through the hub virtual network firewall. Network communication between the spoke virtual networks (spoke-to-spoke communication) passes through the hub virtual network firewall in the Azure Firewall subnet of the hub virtual network. Similarly, network communication between the spoke virtual networks and the on-premises network also passes through the hub virtual network firewall. The architecture uses virtual network peering to connect the various spoke virtual networks to the hub virtual network. You could also use a network virtual appliance (NVA) instead of a firewall. For more information, see [Create an NVA in the hub](/azure/virtual-wan/how-to-nva-hub).

Network traffic that stays within a virtual network shouldn't pass through a firewall. For example, don't put a firewall between the SAP application subnet and the SAP database subnet. Placing a firewall or NVAs between the SAP application and the database management system (DBMS) layer of SAP systems that runs the SAP kernel isn't supported. This configuration negatively affects network latency for all database access and negatively affects SAP performance.

**Avoid peering spoke virtual networks.** Virtual network peering between the spoke virtual networks should be avoided if possible. Spoke-to-spoke virtual network peering allows spoke-to-spoke communication to bypass the hub virtual network firewall. You should configure spoke-to-spoke virtual network peering only when you have high-bandwidth requirements, for example, for database replication between SAP environments. All other network traffic should run through the hub virtual network and firewall. For more information, see [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml).

#### Subnets

It's a best practice to divide each SAP environment (production, pre-production, development, sandbox) into subnets and to use subnets to group related services. This section provides recommendations for subnetting an SAP landscape.

##### Number of subnets

The production virtual network in the architecture has five subnets. This design is ideal for large enterprise solutions. The number of subnets can be less or more. The number of resources in the virtual network should determine the number of subnets in the virtual network.

##### Subnet sizing

Ensure that the subnets have sufficient network address space. If you use SAP virtual host names, you need more address space in your SAP subnets. Often each SAP instance requires two, three, or more IP addresses and includes one IP address for the virtual machine (VM) host name. Other Azure services might require a dedicated subnet when deployed in the SAP workload virtual networks.

##### Application subnet

The application subnet contains VMs that run SAP application servers, SAP Central Services (ASCS), SAP Enqueue Replication Server (ERS), and SAP Web Dispatcher instances. The subnet also contains a private endpoint for Azure Files. In the diagram, the VMs are grouped by role. We recommend that you use Azure Virtual Machine Scale Sets with flexible orchestration together with availability zones for resilient deployment. For more information, see the [Next steps](#next-steps) section of this article.

##### Database subnet

The database subnet contains VMs that run databases. In the diagram, a pair of VMs with synchronous replication represents all the database VMs of one SAP environment.

##### Perimeter subnets

Perimeter subnets are internet facing and include an SAP perimeter subnet and an Azure Application Gateway subnet. This section provides recommendations for designing these two subnets.

**SAP perimeter subnet:** The SAP perimeter subnet is a perimeter network that contains internet-facing applications like SAProuter, SAP Cloud Connector, SAP Analytics Cloud Agent, and Application Gateway. These services have dependencies on SAP systems that an SAP team should deploy, manage, and configure. A central IT team shouldn't manage the services in the SAP perimeter subnet. For this reason, you should place these services in the SAP spoke virtual network and not the hub virtual network. The architecture diagram shows only a production SAP perimeter network. It doesn't show an SAP perimeter subnet in the nonproduction virtual networks. The workloads in the nonproduction SAP subscription use the services in the SAP perimeter subnet.

You can create a separate SAP perimeter subnet in the nonproduction subscription. We recommend this approach only for critical workloads or workloads that change frequently. A dedicated nonproduction SAP perimeter is helpful for testing and new feature deployment. Less critical applications or applications that will have few modifications over time don't need a separate nonproduction SAP perimeter subnet.

**Application Gateway subnet:** Application Gateway requires its own subnet. Use Application Gateway to allow traffic from the internet that SAP services, such as SAP Fiori, can use. The recommended architecture places Application Gateway together with its front-end public IP address in the hub virtual network. Application Gateway requires at least a size /29 subnet. We recommend /27 or larger. You can't use both versions of Application Gateway (V1 and V2) in the same subnet. For more information, see [subnet for Azure Application Gateway](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet).

**Perimeter subnets in a separate virtual network:** For increased security, you can put the SAP perimeter subnet and Application Gateway subnet in a separate virtual network within the SAP production subscription. The SAP perimeter spoke virtual network is peered with the hub virtual network, and all network traffic to public networks flows through the perimeter virtual network. This alternative approach places Application Gateway with its public IP address for inbound connections in a spoke virtual network for SAP use exclusively.

:::image type="complex" source="media/sap-whole-landscape-secured-perimeter-peering.svg" border="false" lightbox="media/sap-whole-landscape-secured-perimeter-peering.svg" alt-text="Diagram that shows network flow between virtual network spokes through the hub virtual network.":::
This diagram shows an architecture that places perimeter subnets in a separate virtual network. On the far left, an on-premises network that contains a gateway connects through ExpressRoute to an Azure subscription for regional hubs. Inside that subscription, a hub virtual network contains a gateway subnet containing a zone-redundant gateway, an Azure Firewall subnet, a shared services subnet containing Active Directory and DNS, and an Azure Bastion subnet. The hub also exposes a public IP endpoint. The hub connects to an Azure subscription for SAP production via virtual network peering. This subscription is split into two spoke virtual networks: the SAP perimeter spoke and the SAP production spoke. In the perimeter spoke, one subnet hosts Application Gateway with Web Application Firewall, and another subnet hosts SAProuter and Cloud Connector. There's a public IP at the perimeter edge. Inbound internet traffic for web services and Fiori enters through this perimeter path. In the production spoke, one subnet hosts an SAP Web Dispatcher pool, SAP ASCS, and application servers. Another production subnet hosts databases. A separate storage area in this subnet includes Azure Files or Azure NetApp Files with SMB/NFS shares. Azure NetApp Files in its own subnet. Azure Files connects to the application subnet via a private endpoint. Directional arrows labeled spoke-hub-spoke traffic flow show that communication from the production spoke to the perimeter spoke is forced through the hub. On the far right is a group of connected platform services: cloud witness, Data Factory, Data Lake Storage, Recovery Services vaults, and Site Recovery. At the top-right, a Private Link label indicates private connectivity for SAP BTP.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sap-whole-landscape-secured.vsdx) that includes this alternative architecture.*

This network design provides better incident response capabilities and fine-grained network access control. However, it also increases the management complexity, network latency, and cost of the deployment. The following sections discuss each point.

*Better incident response:* The SAP perimeter spoke virtual network allows you to quickly isolate compromised services if you detect a breach. You can remove virtual network peering from the SAP perimeter spoke virtual network to the hub and immediately isolate the SAP perimeter workloads and SAP application virtual network applications from the internet. You shouldn't rely on network security group (NSG) rule changes for incident response. Changing or removing an NSG rule affects only new connections and doesn't remove existing malicious connections.

*Fine-grained network access control:* The SAP perimeter virtual network provides more stringent network access control to and from the SAP production spoke virtual network.

*Increased complexity, latency, and cost:* The architecture increases management complexity, cost, and latency. Internet-bound communication from the SAP production virtual network is peered twice, once to the hub virtual network and again to the SAP perimeter virtual network out to the internet. The firewall in the hub virtual network has the biggest effect on latency. We recommend that you measure the latency to see if your use case can support it.

For more information, see [perimeter network best practices](/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks).

##### Azure NetApp Files subnet

If you're using Azure NetApp Files, you should have a delegated subnet to provide network file system (NFS) or server message block (SMB) file shares for different SAP-on-Azure scenarios. A /24 subnet is the default size for an Azure NetApp Files subnet, but you can change the size to meet your needs. Use your own requirements to determine the proper size. For more information, see [Delegate a subnet to Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-delegate-subnet).

##### Subnet security

Using subnets to group SAP resources that have the same security rule requirements makes it easier to manage security.

**NSGs:** Subnets allow you to implement network security groups at the subnet level. Grouping resources in the same subnet that require different security rules requires NSGs at the subnet level and network-interface level. In this two-level configuration, security rules easily conflict and can cause unexpected communication problems that are difficult to troubleshoot. NSG rules also affect traffic [within the subnet](/azure/virtual-network/network-security-group-how-it-works#intra-subnet-traffic). For more information, see [NSGs](/azure/virtual-network/tutorial-filter-network-traffic-cli).

**Application security groups (ASGs):** We recommend that you use ASGs to group VM network interfaces and reference the ASGs in the NSG rules. This configuration enables easier rule creation and management for SAP deployments. Each network interface can belong to multiple ASGs with different NSG rules. For more information, see [ASGs](/azure/virtual-network/application-security-groups).

#### Private Link

We recommend that you use Private Link to improve the security of network communications. Private Link uses private endpoints with private IP addresses to communicate with Azure services. Using Private Link enables you to avoid sending network communication over the internet to public endpoints. For more information, see [What is a private endpoint?](/azure/private-link/private-endpoint-overview).

**Use private endpoints in the application subnet:** We recommend that you use private endpoints to connect the application subnet to supported Azure services. In the architecture, there's a private endpoint for Azure Files in the application subnet of each virtual network. You can use this configuration for any supported Azure service.

**Use Private Link for SAP BTP:** You can use Private Link for SAP BTP. SAP Private Link Service supports connections from SAP BTP, the Cloud Foundry Runtime, and other services. Example scenarios include SAP S/4HANA or SAP ERP running on a VM. SAP services can connect to Azure native services like Azure Database for MySQL.

The architecture uses an SAP Private Link Service connection from SAP BTP environments. SAP Private Link Service establishes a private connection between specific SAP BTP services and specific services in each network as service provider accounts. Private Link allows BTP services to access your SAP environment through private network connections. It improves security because it enables you to avoid using the public internet to communicate.

For more information, see:

- [Azure Private Link resources](https://help.sap.com/docs/private-link/private-link1/azure-private-link-service-generic-lb-scenario-for-vms-and-others)
- [Azure Database for MySQL](https://help.sap.com/docs/private-link/private-link1/azure-database-for-mysql)
- [Internet connection for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)

### NFS and SMB file shares

SAP systems often depend on NFS or SMB shares. These file shares move files between VMs or function as a file interface with other applications. We recommend that you use native Azure services, like Azure Premium Files and Azure NetApp Files, as your NFS and SMB file shares. Azure services have better combined availability, resilience, and service-level agreements (SLAs) than operating-system-based tools.

For more information, see:

- [Azure Premium Files](/azure/sap/workloads/planning-guide-storage#azure-premium-files)
- [Azure NetApp Files](/azure/sap/workloads/planning-guide-storage)
- [SAP note 2015553 (requirements for storage services)](https://launchpad.support.sap.com/#/notes/2015553)

When you architect your SAP solution, you need to properly size the individual file share volumes and know which SAP system file share connects to. Keep scalability and performance targets of the Azure service in mind during planning. The following table outlines common SAP file shares and gives a brief description and recommended use in a whole-SAP environment.

| File share name | Usage | Recommendation |
|:----------------|:------| :--------------|
| `sapmnt` | Distributed SAP system, profile, and global directories | Dedicated share for each SAP system, no reuse               |
| `cluster`         | High-availability shares for ASCS, ERS, and database per respective design  | Dedicated share for each SAP system, no reuse               |
| `saptrans`        | SAP transport directory                                | One share for one or a few SAP landscapes (ERP, Business Warehouse) |
| `interface`       | File exchange with non-SAP applications                | Customer-specific requirements, separate file shares per environment (production, nonproduction) |

You can only share `saptrans` between different SAP environments, so carefully consider its placement. For scalability and performance reasons, avoid consolidating too many SAP systems into one `saptrans` share.

Corporate security policies dictate the architecture and separation of volumes between environments. A transport directory with separation per environment or tier needs RFC communication between SAP environments to allow SAP transport groups or transport domain links. For more information, see:

- [SAP transport groups](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/44b4a0ce7acc11d1899e0000e829fbbd.html)
- [Transport domain links](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/14c795388d62e450e10000009b38f889.html)

### Data services

The architecture contains Azure data services that help you extend and improve your SAP data platform. We recommend that you use services like Microsoft Fabric, Azure Data Factory, and Azure Data Lake Storage to obtain business insights. These data services help you analyze and visualize SAP data and non-SAP data.

For many data integration scenarios, an integration runtime or an on-premises data gateway is required. The Azure integration runtime is the compute infrastructure that Data Factory uses to provide data integration capabilities. Conversely, an on-premises data gateway provides data integration capabilities for Fabric data pipelines, shortcuts, and other Fabric integration and reporting tools. We recommend that you deploy runtime VMs for these services, for each environment separately. For more information, see:

- [On-premises data gateway](/data-integration/gateway/service-gateway-onprem)
- [Azure integration runtime](/azure/data-factory/concepts-integration-runtime)
- [Set up a self-hosted integration runtime for the SAP CDC connector](/azure/data-factory/sap-change-data-capture-shir-preparation)
- [Copy data from SAP HANA](/azure/data-factory/connector-sap-hana?tabs=data-factory)
- [Copy data from SAP Business Warehouse via Open Hub](/azure/data-factory/connector-sap-business-warehouse-open-hub)

### Shared services

SAP solutions rely on shared services. Load balancers and application gateways are examples of services that multiple SAP systems use. Your organizational needs should determine how you architect your shared services. The following sections provide general guidance.

**Load balancers:** We recommend one load balancer per SAP system. This configuration helps minimize complexity. Avoid having too many pools and rules on a single load balancer. The recommended configuration also ensures that naming and placement align with the SAP system and resource group. Each SAP system with a clustered high-availability (HA) architecture should have at least one internal load balancer. The architecture uses one load balancer for the ASCS VMs and a second load balancer for the database VMs. Some databases might not need load balancers to enable an HA deployment. SAP HANA does. For more information, see database-specific documentation.

**Application Gateway:** We recommend at least one application gateway per SAP environment (production, nonproduction, and sandbox) unless the complexity and number of connected systems is too high. You could use an application gateway for multiple SAP systems to reduce complexity, because not all SAP systems in the environment require inbound access from the internet. A single application gateway could serve multiple web dispatcher ports for a single SAP S/4HANA system or be used by different SAP systems.

**SAP Web Dispatcher VMs:** The architecture shows a pool of two or more SAP Web Dispatcher VMs. We don't recommend the reuse of SAP Web Dispatcher VMs between different SAP systems. Keeping them separate allows you to size the Web Dispatcher VMs to meet the needs of each SAP system. For smaller SAP solutions, we recommend that you embed the Web Dispatcher services in the ASCS instance.

**SAP services:** When you deploy SAP services like SAProuter, Cloud Connector, and Analytics Cloud Agent, use application requirements to determine whether to deploy them centrally or split them up. The main consideration to take into account, if and when you should use an SAP perimeter subnet for nonproduction, is mentioned in the [networking section](#perimeter-subnets). If you use only a production perimeter subnet for SAP, the SAP perimeter services are consumed by the entire SAP landscape.

### Disaster recovery

Disaster recovery (DR) addresses the requirement for business continuity in case the primary Azure region is unavailable or compromised. From an overall SAP landscape perspective, the following sections provide recommendations for DR design. These recommendations are depicted in the diagram.

**Use different IP address ranges:** Virtual networks only span a single Azure region. DR solutions should use a different region. You need to create a different virtual network in the secondary region. The virtual network in the DR environment needs to use a different IP address range to enable database synchronization through database-native technology.

**Ensure connectivity to central services and on-premises:** Connectivity to on-premises and key central services (DNS or firewalls) must be available in the DR region. Make availability and change configuration of the central IT services a part your DR plan. Central IT services are key components for a functioning SAP environment.

**Use Azure Site Recovery:** Site Recovery replicates managed disks and VM configurations for application servers to the DR region.

**Ensure file share availability:** SAP depends on the availability of key file shares. Backup or continuous file share replication is necessary to provide data on these file shares, with minimal data loss in a DR scenario.

**Database replication:** Site Recovery can't protect SAP database servers because of the high change rate and lack of database support by the service. You need to configure continuous and asynchronous database replication to the DR region.

For more information, see [Disaster recovery overview and infrastructure guidelines for SAP workload](/azure/sap/workloads/disaster-recovery-overview-guide).

### Smaller SAP architecture

For smaller SAP solutions, it might be beneficial to simplify the network design. In this design, each SAP environment's virtual network is a subnet in a combined virtual network. Any simplification of the network and subscription design can affect security. Reevaluate the network routing, access to and from public networks, access to shared services (file shares), and access to other Azure services. Here are some options for reducing the architecture to better meet organizational needs:

**Combine the SAP application and database subnets into one.** You can combine the application and database subnets to create one large SAP network. This network design mirrors many on-premises SAP networks. If you combine these two subnets, you need to pay closer attention to subnet security and NSG rules. ASGs are important when you use a single subnet for SAP application and database subnets.

**Combine the SAP perimeter subnet and application subnet.** You can combine the perimeter subnet and SAP application subnet. If you do, you need to pay closer attention to NSG rules and ASG use. We recommend this simplified approach only for small SAP estates.

**Combine SAP spoke virtual networks between different SAP environments.** The architecture uses different virtual networks for each SAP environment (hub, production, nonproduction, and DR). Depending on the size of your SAP landscape, you might be able to combine the SAP spoke virtual networks into fewer spokes or even only one SAP spoke. You still need to separate production and nonproduction environments. In this simplified scenario, each SAP production environment becomes a subnet in one SAP production virtual network. Each SAP nonproduction environment becomes a subnet in one SAP nonproduction virtual network.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Robert Biro](https://www.linkedin.com/in/robert-biro-38991927) | Senior Architect
- [Pankaj Meshram](https://www.linkedin.com/in/pankaj-meshram-6922981a) | Principal Program Manager

Other author:

- [Daniel Crawford](https://www.linkedin.com/in/daniel-crawford-b661373) | Senior Program Manager

## Next steps

- [The strategic impact of SAP in the cloud](/azure/cloud-adoption-framework/scenarios/sap/strategy)
- [SAP on Azure documentation](/azure/sap/workloads/get-started)
- [Azure planning and implementation guide for SAP workloads](/azure/sap/workloads/planning-guide)
- [SAP workloads on Azure: planning and deployment checklist](/azure/sap/workloads/deployment-checklist)

## Related resources

- [SAP S/4HANA in Linux on Azure](./sap-s4hana.md)
- [Run SAP NetWeaver in Windows on Azure](./sap-netweaver.md)
- [Run SAP HANA in a scale-up architecture on Azure](../../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.md)
- [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml)