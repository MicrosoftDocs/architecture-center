This article provides best practices deploying multiple SAP systems and environments. It focuses on the connections between systems and the optimal placement of SAP in Azure without going into detail on individual SAP system.

[Visio file]:https://arch-center.azureedge.net/sap-whole-landscape.vsdx

## Architecture

[![Diagram that shows a sample overall SAP landscape in Azure](media/sap-whole-landscape.png)](media/sap-whole-landscape.png#lightbox)

_Download a [Visio file] of the architectures in this article._

This solution illustrates the SAP landscape of a typical large enterprise. You can reduce the size and scope of the configuration to fit your requirements. This reduction might apply to the SAP landscape: fewer subscriptions, fewer virtual machines (VMs), no high availability. Business policies might also necessitate adaptations to the architecture, particularly to the network design. When possible, we've included alternatives. Choose an approach that's right for your business.

This article about a whole SAP landscape is intentionally high-level on some details such as compute, storage, network components and others. This article intentionally doesn'tprovide architecture on a single SAP system in detail. Many existing guides and designs are focused precisely on these details, however omit the bigger picture. For individual guides and more targeted single SAP system view, follow the links at the end of this document.

### Azure subscriptions

This architecture uses three subscriptions:

- An Azure virtual hub subscription where the hub virtual network (VNet) exists for the primary and secondary regions. This subscription is for all central services and not just SAP.
- An Azure SAP production subscription where the production and disaster recovery systems are configured.
- An Azure SAP non-production subscription where non-production systems, including sandbox, development, quality assurance, or pre-production systems, reside.

This configuration is optional and depends on size of your SAP landscape. You can use a subscription for each environment / tier / workload zone. You can use a dedicated subscription for sandbox or project SAP environment only, isolating on network and Azure level the resources to limit blast radius of such crash-and-burn environment. One recommendation is to not use too many subscriptions, such as one per SAP system or all SAP BW systems. The overhead of multiple subscriptions and implicit different spoke networks becomes too difficult to manage.

For more information on resource management, see:

- [Limits for each subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits)
- [Azure policies](/azure/governance/policy/overview)
- [Management groups](/azure/governance/management-groups/overview)

### Network design

The architecture uses a hub-spoke topology. The hub VNet acts as a central point of connectivity. It connects to the on-premises network and the various spoke VNets, enabling user and application access to the SAP workload.

**On-premises connection** For SAP workloads we recommend using ExpressRoute to connect the hub on-premises network. You could use [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about) topology if you have global locations. Consider setting up a site-to-site (S2S) VPN as a backup to Azure ExpressRoute or any third-party route requirements. As on-premises connection is assumed already in place for SAP use in this architecture, see any details and decision help between available options in the following documents:

- [Network topology and connectivity for an SAP migration](/azure/cloud-adoption-framework/scenarios/sap/eslz-network-topology-and-connectivity)
- [Hub and spoke architecture](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about)
- [S2S VPN as a backup for ExpressRoute private peering](/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering)

**Virtual network use** We recommend using one VNet per environment, often called SAP deployment tier. The architecture uses a different VNet for production, development, quality assurance, and sandbox. However, depending on the size of your SAP landscape, you can combine the SAP spoke virtual networks into fewer or even only one SAP spoke VNet. Each SAP environment's VNet would then be subnets inside such combined virtual network - SAP development subnets, SAP pre-production subnets, etc. For small SAP landscapes with few VMs and SAP systems, we recommend keeping at minimum a production and non-production division of subnets.

Any simplification and change of the network and subscription design needs to reevaluate the security impact on network routing, access to and from public networks, access of shared services like NFS / SMB file shares and other Azure services.

**Direct traffic outside the VNet to firewall** All network traffic to spoke VNets should traverse a firewall, including remote function call (RFC) connections. We've configured communication between the spoke VNets and communication between the spoke VNets and on-premises network to pass through the hub VNet firewall in the Azure Firewall subnet. We used VNet peering to connect the various spoke VNets to the hub VNet. All spoke-to-spoke VNet communication traverses the hub VNet firewall. You could also use a network virtual appliance instead of a firewall. For more information, see [network virtual appliance](https://azure.microsoft.com/solutions/network-appliances/).

Network traffic inside an SAP spoke VNet shouldn't pass through firewall. This applies especially for the communication path between SAP application and SAP system's database. Placement of any firewall or network virtual appliances in the communication path between the SAP application and the DBMS layer of SAP systems running the SAP kernel isn't supported.

**Limit spoke-to-spoke virtual network peering** VNet peering between the spoke VNets should be avoided if possible. Spoke-to-spoke VNet peering allows spoke-to-spoke communication to bypass the hub VNet firewall. You should only configure spoke-to-spoke VNet peering when you have high-bandwidth requirements. Examples include database replication between SAP environments. All other network traffic should run through the hub VNet and firewall.

Spoke-to-spoke VNet peering allows spoke-to-spoke communication to bypass the hub VNet firewall. You should only configure spoke-to-spoke VNet peering when you have high-bandwidth requirements. Examples include database replication between SAP environments or production to disaster recovery virtual network. All other network traffic should run through the hub VNet and firewall.

**Internet in- and outbound traffic** For details on internet ingress and egress network traffic, follow a dedicated architecture on this topic at [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml)

#### Subnets

It's a best practice to divide each SAP environment's own VNet (production, pre-production, development, sandbox) into subnets and use subnets to group related services. The production virtual network in the architecture has five subnets. The network design you should use depends on the resources in the virtual network, but use the architecture and the following points to implement the right principles.

- **Application subnet**: The application subnet contains virtual machines running SAP application servers, (ABAP) SAP Central Services (A)SCS, SAP enqueue replication services ERS and SAP Web Dispatcher instances. The subnet also contains a private endpoint to Azure Files. In the diagram the VMs are grouped by role showing a typical, highly available, single SAP system using either availability sets or zones for resilient deployment. See individual SAP architecture guides linked at end for more details on individual SAP system.

- **Database subnet**: The database subnet holds virtual machines running databases. In the diagram a pair of VMs for a highly available setup in synchronous replication are a representation for all database VMs of one SAP environment.

- **SAP perimeter subnet**: This subnet is a demilitarized zone (DMZ) that contains internet-facing applications such as SAProuter, SAP Cloud Connector, SAP Analytics Cloud Agent, and Application Gateway. These services have dependencies on SAP systems that an SAP team should deploy, manage, and configure, not a central IT team. For this reason, you should place these services in the SAP spoke VNet and not the Hub VNet.

The architecture doesn't show a non-production SAP perimeter subnet. Non-production SAP workload uses SAP production perimeter services and network. The decision to create a non-production environment for shared SAP services (SAProuter, Cloud Connector) depends on your company policies and the size of your SAP landscape. One major driver to use a dedicated non-production SAP perimeter is the business criticality of processes depending on this connectivity path and the degree of change you foresee for these applications. A dedicated non-production SAP perimeter will be helpful during testing and new feature deployment. Should the applications be mostly served for less critical and secondary business processes with little change, the need for such extra non-production SAP perimeter is likely low.

- **Application Gateway subnet**: Azure Application Gateway requires its own subnet. Use it to allow traffic from the Internet that SAP services, such as SAP Fiori, can use. An Azure Application Gateway requires at least a /29 size subnet. We recommend size /27 or larger. You can't use both versions of Application Gateway (v1 and v2) in the same subnet. For more information, see [subnet for Azure Application Gateway](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet).

- **Azure NetApp Files subnet**: [A delegated subnet](/azure/azure-netapp-files/azure-netapp-files-delegate-subnet) if using NetApp Files to provide NFS / SMB file shares for different SAP on Azure scenarios. A /24 subnet is the default. Use your requirements to determine the proper sizing.

We have a few more notes on subnet design. Ensure sufficient network address space is provided for the subnets.  If you use SAP virtual host names, you need more address space in your SAP subnets, including the SAP perimeter. Often 2-3 IPs are required for each SAP instance including the physical VM hostname. Other Azure services might require their own dedicated subnet, when deployed in the SAP workload VNets.

#### Network security groups (NSG)

Using subnets to divide makes it easier to implement and manage the security. It allows you to implement network security groups at the subnet level. Grouping resources in the same subnet when they require different security rules makes it difficult to implement and manage security rules. It requires network security groups at the subnet level and network-interface level. With these two levels, security rules easily conflict and can cause unexpected communication problems that are difficult to troubleshoot.

 NSG rules in place affect network traffic in- and out of the subnet, and also [within the subnet](/azure/virtual-network/network-security-group-how-it-works#intra-subnet-traffic). For more information on NSGs, see [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli).

**Application security groups (ASG)**: We recommend using application security groups to group VM network interfaces and reference the ASGs in NSG rules. This allows easier rule creation and management, instead of IP ranges only, and are recommended for SAP deployments. Each network interface can belong to multiple application security groups, with different NSG rules. For more information, see [application security groups](/azure/virtual-network/application-security-groups).

#### Azure Private Link

We recommend using Azure Private Link to improve the security of network communications. Azure Private Link uses private endpoints with private IP addresses to communicate with Azure services. It lets you avoid sending network communication using public internet endpoints. For more information, see [private endpoints on Azure services](/azure/private-link/private-endpoint-overview).

**Private endpoints**: Azure Files is the connected service but the same concept can be extended to any supported Azure service.

**Azure Private Link SAP BTP connectivity**: Azure Private Link for SAP Business Technology Platform (BTP) is now generally available. SAP Private Link Service supports connections from SAP BTP, the Cloud Foundry runtime, and other services. Example scenarios include SAP S/4HANA or SAP ERP running on the virtual machine and connecting to Azure native services such as Azure Database for MariaDB and Azure Database for MySQL.

The architecture depicts an SAP Private Link Service connection from SAP BTP environments. SAP Private Link Service establishes a private connection between specific SAP BTP services and specific services in each network as service provider accounts. Private link allows BTP services to access your SAP environment through private network connections. It improves security by not using the public internet to communicate.

For more information, see:

- [Azure Private Link resources](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/e8bc0c6440834a47a0ff57cb4efc0dc2.html?locale=en-US)
- [Azure Database for MariaDB](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/862fa2958c574c3cbfa12a927ce1d5fe.html?locale=en-US)
- [Azure Database for MySQL](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/5c70499ee70b415d954145a795e43355.html?locale=en-US)
- [Internet connection for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)

### NFS / SMB file shares

SAP systems often depend on NFS volumes or SMB shares to share files between VMs of same or other SAP systems, or to act as file interface with other applications. We recommend using native Azure services for network file system (NFS) / server message block (SMB) file shares. They have better availability and resilience with service level agreements (SLAs) than operating-system-based tools.

For more information, see:

- [Azure Premium Files](/azure/virtual-machines/workloads/sap/planning-guide-storage#azure-premium-files)
- [Azure NetApp Files](/azure/virtual-machines/workloads/sap/planning-guide-storage#azure-netapp-files-anf)
- [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) lists requirements for storage services in Azure for SAP workloads

Your architecture needs to contain plans and sizing for individual volumes and to which SAP system each is connected to. Keep scalability and performance targets of the Azure service in mind during detail planning. The following table outlines common SAP file shares and gives a brief description and recommended use in a whole SAP environment.

| File share name | Usage | Recommendation |
|:----------------|:------| :--------------|
| sapmnt          | Distributed SAP system, profile and global directories | Dedicated share for each SAP system, no reuse               |
| cluster         | HA shares for ASCS, ERS, DB, as per respective design  | Dedicated share for each SAP system, no reuse               |
| saptrans        | SAP transport directory                                | One share for one or few SAP landscapes (ERP, BW) |
| interface       | File exchange with non-SAP applications                | Customer specific requirements, separate file shares per environment (prod, non-prod) |

As noted in the table, only transport can be shared between different SAP environments. This means determining the placement of such central share. Avoid consolidating too many SAP systems into one saptrans share for scalability and performance reasons. See guidance in service specific documentation linked in this chapter.

The corporate security policies will drive the architecture and possible separation of volumes between environments. A transport directory with separation per environment / tier will still need RFC communication between SAP environments to allow SAP transport groups or transport domain links. For more information, see:

- [SAP transport groups](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/44b4a0ce7acc11d1899e0000e829fbbd.html)
- [Transport domain links](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/14c795388d62e450e10000009b38f889.html)

### Data services

The architecture contains Azure data services that help you extend and improve your SAP data platform. We recommend you use services, such as Azure Synapse Analytics, Azure Data Factory, and Azure Data Lake Storage, to unlock business insights. These data services help you analyze and visualize SAP data and non-SAP data.

For many data integration scenarios, an integration runtime is required. The Azure integration runtime is the compute infrastructure that Azure Data Factory and Azure Synapse Analytics pipelines use to provide data integration capabilities. We recommend the deployment of runtime virtual machines for these services for each environment separately. Following examples show you how to connect SAP systems and deploy the Azure integration runtime.

- [Azure integration runtime](/azure/data-factory/concepts-integration-runtime)
- [Set up a self-hosted integration runtime to use in the SAP CDC solution](/azure/data-factory/sap-change-data-capture-shir-preparation)
- [Copy data from SAP HANA](/azure/data-factory/connector-sap-hana?tabs=data-factory)
- [Copy data from SAP Business Warehouse via Open Hub](/azure/data-factory/connector-sap-business-warehouse-open-hub)

## Reuse of services between SAP systems

A topic already touched upon with NFS / SMB file shares, when looking at the overall SAP landscape, the diagram shows several Azure services used by multiple SAP systems. While no single guidance is possible and many approaches are valid, a set of recommendations and design decisions are shared below. This document won't provide guidance on central IT services. Applications such as firewalls, network gateways, DNS or OS patch repositories, such central services are out of scope for this article.

Services that typically serve an SAP system are best separated as described here:

- **Load balancers**: Load balancers should be dedicated to individual services. For each SAP system with clustered high-availibility (HA) architecture, we recommend one load balancer for ASCS/SCS and Enqueue Replication Service (ERS). For database of the same SAP system, if running SAP HANA with high-availability architecture, a second load balancer should be used. Other databases than SAP HANA might not require load balancers at all even for HA deployment. See database specific documents for details of such load balancer design.  

Using one set of load balancers for a single SAP system helps to ensure that troubleshooting doesn't get complex, with many front- and back-end pools and load balancing rules all on a single load balancer. This configuration also ensures resource naming and placement in resource groups aligns with the SAP system and subnet used by load balancer frontend matches the SAP layer of database or application.

Alternatively to one load balancer for (A)SCS and ERS and second for SAP HANA, a single load balancer for all three services (A)SCS, ERS and DB clusters of one SAP system can also be considered.

- **Application Gateway**: We recommend at least one application gateway per SAP environment (production, non-production, and sandbox) unless the complexity and number of connected systems is too high. You could use an application gateway for multiple SAP systems to reduce complexity since not all SAP systems in the environment require public access. A single application gateway could serve multiple web dispatcher ports for a single SAP S/4HANA system or across different SAP environments.

- **SAP Web Dispatcher VMs:** This architecture in the sample, highly available SAP system within production environment shows a pool of 2 or more SAP Web Dispatcher VMs. First decision should be made to use standalone VMs for SAP Web Dispatcher or to embed the Web Dispatcher service with the (A)SCS VM for one individual SAP system. If standalone VMs are used for Web Dispatcher, we recommend to not reuse them between different SAP systems. Such design allows you to size the Web Dispatcher VMs individually for each SAP system. For smaller SAP systems where Web Dispatcher service is required, consider embedding them with the (A)SCS instance.

- **SAP services**: SAP services like SAProuter, Cloud Connector, and Analytics Cloud Agent, are deployed based on application requirements, either centrally or split up. No recommendation on reuse between SAP systems due to diverse customer requirements. Main decision to make is mentioned in networking section, if and when SAP perimeter subnet for non-production should be used. Otherwise with just production perimeter subnet for SAP, the SAP perimeter services are consumed by entire SAP landscape.

## Disaster recovery considerations

Disaster recovery addresses the requirement for business continuity in case the primary Azure region is unavailable or compromised. From an overall SAP landscape perspective, the main decisions to make are:

- **Use different IP address ranges** A virtual network doesn'tspan beyond a single Azure region, a different virtual network is required in secondary region. The virtual network in the DR environment needs different IP address range to enable database synchronization through database native technology.
- **Ensure file share availability**: SAP important aspects are availability of the SMB or NFS service and data replication, together with backup infrastructure and backup data.
- **Central services and connectivity from on-premises**: With SAP depending on key central services like DNS, availability and change configuration on SAP side during DR failover needs to be established.

For detailed disaster recovery guidance for SAP, see details in article [Disaster recovery overview and infrastructure guidelines for SAP workload](/azure/virtual-machines/workloads/sap/disaster-recovery-overview-guide).

## Consolidating SAP subnets and virtual networks

To address any requirement to decrease the number of required virtual networks and subnets for smaller SAP deployments, some changes to the main architecture design are possible. Ensure any modification to simplify and flatten the architecture are done only after careful consideration. These would be:

- **Combine the SAP application and database subnets into one**
  By combining the two subnets you simplify the overall network design and mirror what is often deployed in many SAP landscapes on-premises, one large network for SAP. By combining the subnets, an even higher attention needs to be placed on subnet security and your NSG rules. NSG rules in place affect network traffic in- and out of the subnet, and also [within the subnet](/azure/virtual-network/network-security-group-how-it-works#intra-subnet-traffic). Use of ASGs is recommended always, but particularly when using a single subnet for SAP application and database subnets.
- **Combine SAP perimeter subnet into application subnet**
  Another simplification possible on network level, is to place VMs from the perimeter subnet into SAP application subnet, eliminating the SAP perimeter subnet. Similarly to the point above with joint SAP app and DB subnet, a heightened attention must be placed on NSG rules and ASG use. Due to the typically small SAP perimeter subnet or virtual network, we only recommend this simplification approach for small SAP estates.
- **Combine SAP spoke VNets between different SAP environments / tiers**
  The architecture shown uses different virtual networks for each SAP environment / tier - production, development, etc. Depending on the size of your SAP landscape, you can combine the SAP spoke virtual networks into fewer or even only one SAP spoke. Each SAP environment's VNet would then be a subnet inside such combined virtual network - SAP development application subnet, SAP development database subnet, SAP pre-production application subnet, etc. Recommendation even for SAP landscapes with few VMs and SAP systems is to keep at least a production and non-production division of subnets. This alternative design goes together with having more or fewer Azure subscriptions for SAP workloads, from chapter [subscriptions](#azure-subscriptions) within this document.

## Example SAP landscape of three SAP environments

The following diagram is the same architecture, but with as an example of a three SAP environments -  SAP S/4HANA, SAP BW and SAP PI/PO. Its aim is to show this architecture with simplified view for VM and other details, and to ensure placement of different SAP systems is understood on a whole landscape level. It shows a 4-tier S/4HANA environment, including sandbox workload zone, a 3-tier BW and SAP PI/PO is a 2-tier deployment with production and development only.

[![Diagram that shows a sample overall SAP landscape in Azure with a dedicated perimeter VNet](media/sap-whole-landscape-three-sap-example.png)](media/sap-whole-landscape-three-sap-example.png#lightbox)

## Contributors
  
_This article is maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:**

 * [Robert Biro](https://www.linkedin.com/in/robert-biro-38991927) | Senior Architect  
 * [Pankaj Meshram](https://ww.linkedin.com/in/pankaj-meshram-6922981a) | Principal Program Manager

## Next steps

- [SAP S/4HANA in Linux on Azure](./sap-s4hana.yml)
- [Run SAP NetWeaver in Windows on Azure](./sap-netweaver.yml)
- [Run SAP HANA in a scale-up architecture on Azure](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)
- [Cloud Adoption Framework - SAP scenario](/azure/cloud-adoption-framework/scenarios/sap/)
- [In- and Outbound internet connections for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)
- [SAP on Azure documentation](/azure/virtual-machines/workloads/sap/get-started).
- [Azure planning and implementation guide for SAP workloads](/azure/virtual-machines/workloads/sap/planning-guide)
- [SAP workloads on Azure: planning and deployment checklist](/azure/virtual-machines/workloads/sap/sap-deployment-checklist)
