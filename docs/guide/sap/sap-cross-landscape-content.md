This article provides an architecture of a sample SAP deployment, showing the best practices when it comes to multiple SAP systems and environments. It does not go into detail on individual SAP system, instead the focus is showing the interconnected requirements and deployment placement of a whole SAP landscape in Azure.

[Visio file]:https://arch-center.azureedge.net/sap-cross-landscape.vsdx

## Architecture

[![Diagram that shows a sample overall SAP landscape in Azure](media/sap-cross-landscape.png)](media/sap-cross-landscape.png#lightbox)

_Download a [Visio file] of the architectures in this article._

This solution illustrates the SAP landscape of a typical large enterprise. You can reduce the size and scope of the configuration to fit your requirements. This reduction might apply to the SAP landscape: fewer subscriptions, fewer virtual machines (VMs), no high availability. It can also apply to alternatives to the network design, as described later in this article.

Customer requirements, driven by business policies, will necessitate adaptations to the architecture, particularly to the network design. When possible, we've included alternatives. Many solutions are viable. Choose an approach that's right for your business. The final design needs to help you secure your Azure resources but still provide a performant and scalable solution.

An alternative secured perimeter architecture, addressing heightened network security requirements, is shown later in this document in [chapter network design alternatives](#network-design-alternatives). Unless noted otherwise, details in this document cover the architecture shown above.

### Basic architectural principles

Main principles driving this architecture are

> [!div class="checklist"]
> * Azure subscription for each SAP environment, for example production, non-production and sandbox, only containing SAP workload
> * Using existing hub-spoke network model
> * Network segmentation on several layers and where appropriate

As mentioned in the introduction of this article this overall, or in other words cross-landscape, this article is intentionally high-level on some details such as compute, storage, network components and others. This article intentionally does not focus Many existing guides and designs are focused precisely on these details, however omit the bigger picture. This architecture presents the proven design for an enterprise-wide SAP deployment in Azure and the decisions needed for own design.

For individual guides and more targeted single SAP system view, please follow the links at the end of this document.

## Components

### Azure subscription

An Azure subscription in technical terms is an organizational grouping of Azure resources. Azure defines [limits for each subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits) and many Azure services have subscription dependencies. Most Azure resources belong to a single subscription. For example, a virtual network by itself cannot contain VM network interfaces from different subscriptions, it is limited to resources in one subscription only. Using multiple subscriptions allows you to leverage a company-wide [Azure policies](/azure/governance/policy/overview) and governance principles, organizing Azure subscriptions into [management groups](/azure/governance/management-groups/overview).

This architecture uses three subscriptions:
- An Azure virtual hub subscription where the hub virtual network exists for the primary and secondary regions.
- An Azure SAP production subscription where the production and disaster recovery systems are configured.
- An Azure SAP non-production subscription where a non-production systems, including sandbox, development, quality assurance, or pre-production systems, reside. 

This configuration is optional and depends on size of your SAP landscape. You can use a subscription for each environment / workload zone. You can use a dedicated subscription for sandbox or project SAP environment only, isolating on network and Azure level the resources to limit blast radius of such crash-and-burn environment. One recommendation is to not use too many subscriptions, such as one per SAP system or all SAP BW systems. The overhead of multiple subscriptions and implicit different spoke networks becomes too difficult to manage.

### Network design

The shown SAP architecture uses a [hub-spoke topology](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). The hub virtual network acts as a central point of connectivity to an on-premises network. The spoke virtual networks with SAP workload in them are peered with the hub virtual network(vnet). [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about) can be used instead the hub-spoke topology with same design principals for the SAP workload.

The architecture uses one SAP virtual network per workload zone or environment. It uses a different SAP virtual network for production, development, quality assurance, and the sandbox. In the architecture, you peer the Azure hub virtual network with the production, development, quality assurance, and sandbox virtual networks. Traffic from each SAP spoke vnet flows between the on-premises network and the hub vnet through a gateway connection.

> [!NOTE]
> Consider setting up a site-to-site (S2S) VPN as a backup of Azure ExpressRoute or for any third-party route requirements. For more information, see [Use S2S VPN as a backup for ExpressRoute private peering](/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering).

Traffic between each individual SAP spoke vnet flows also through the hub vnet and a central firewall or [network virtual appliance](https://azure.microsoft.com/solutions/network-appliances/). For example, a production S/4HANA system in production vnet connecting to development S/4HANA system through RFC connection to obtain some SAP transport information, would traverse the hub and firewall through the individual spoke vnet peering of the two - development and production - spoke vnets. Spoke to spoke vnet peering is recommended to be only used on exception cases, for example when required for high-bandwidth requirements, such as database replication between SAP environments. Any spoke to spoke peering when employed should be configured to allow only such high-bandwidth traffic, with other network traffic between SAP environments' vnets should still use the vnet hub.

#### Subnets and network security groups

The architecture subdivides the virtual network address space into subnets. You can associate each subnet with a network security group that defines the access policies for the subnet. Place application servers on a separate subnet to secure them more easily. You can manage the subnet security policies instead of managing individual servers. 

This architecture has between three and five subnets depending on the tier. For example, a production system might have the following five subnets:

- **SAP applications**: This subnet contains SAP application servers, SAP Central Services, SAP enqueue replication services instances and web dispatchers.
- **Database**: This subnet contains only virtual machines running databases.
- **SAP perimeter network**: This subnet contains VMs running SAP applications where direct connectivity to- or from the internet is needed, for example SAProuter or Cloud Connector.
- **Azure Application Gateway**: A delegated [subnet for Azure Application Gateway](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet), allowing traffic from the Internet, for example for SAP Fiori use.
- **Azure NetApp Files**: [A delegated subnet](/azure/azure-netapp-files/azure-netapp-files-delegate-subnet) for using NetApp Files for different SAP on Azure scenarios.

By using dedicated subnets for SAP databases and applications, you can set network security groups ([NSGs](/azure/virtual-network/tutorial-filter-network-traffic-cli)) to be more strict, which helps to protect both application types with their own sets of rules. You can then limit database access to SAP applications more easily, without needing to resort to application security groups for granular control. Separating your SAP application and database subnets also makes it easier to manage your security rules in NSGs. NSGs should be applied only on subnet level. Assigning NSGs to individual VM network interfaces, in addition to existing subnet NSGs, should be done in very rare and exceptional cases only.

Application security groups ([ASGs](/azure/virtual-network/application-security-groups)) allow you to group VM network interfaces and reference the ASGs in NSG rules. This allows easier rule creation and management, instead of IP ranges only.

#### Subnet sizing and design

When you design subnets for your SAP landscape, be sure to follow sizing and design principles:
- Placement of Azure network virtual appliances in the communication path between the SAP application and the DBMS layer of SAP systems running the SAP kernel isn't supported.
- Several Azure platform as a service (PaaS) services require their own designated subnets.
- Application Gateway requires at least a /29 subnet. We recommend /27 or larger. You can't use both versions of Application Gateway (v1 and v2) in the same subnet.
- If you use Azure NetApp Files for your NFS/SMB shares or database storage, a designated subnet is required. A /24 subnet is the default. Use your requirements to determine the proper sizing.
- If you use SAP virtual host names, you need more address space in your SAP subnets, including the SAP perimeter.
Central services like Azure Bastion or Azure Firewall, typically managed by a central IT team, require their own dedicated subnets of sufficient size.

#### SAP BTP connectivity

Azure Private Link for SAP BTP is now generally available. SAP Private Link Service currently supports connections from SAP BTP, the Cloud Foundry runtime, and other services on top of [Azure Private Link resources](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/e8bc0c6440834a47a0ff57cb4efc0dc2.html?locale=en-US) for the most common load balancer plus virtual machine scenarios. Example scenarios include SAP S/4HANA or SAP ERP running on the virtual machine and connecting to Azure native services like [Azure Database for MariaDB](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/862fa2958c574c3cbfa12a927ce1d5fe.html?locale=en-US) or [Azure Database for MySQL](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/5c70499ee70b415d954145a795e43355.html?locale=en-US).

The example architecture depicts an SAP Private Link Service connection to BTP environments. SAP Private Link Service establishes a private connection between specific SAP BTP services and specific services in your infrastructure as service provider accounts. If you reuse the private link functionality, BTP services can access your S/4 HANA environment through private network connections, which avoids data transfer via the public internet.

For more information about scenarios to connect to BTP services, see the SAP Community blog post about the [architecture effect of Private Link Service](https://blogs.sap.com/2021/07/27/btp-private-linky-swear-with-azure-how-many-pinkies-do-i-need/).  
For architecture with connectivity to SAP BTP through the public endpoint and Internet, see [In- and outbound internet connection for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound).

#### Private endpoints

This architecture uses private endpoints to bring the Azure service inside the virtual network. [Private endpoints on Azure services](/azure/private-link/private-endpoint-overview) deploy a network interface inside the private virtual network and you access the service through the private IP. Depending on service, access is possible from peered - locally and globally - virtual networks as well. In the diagram Azure Files is the connected service but the same concept can be extended to any supported Azure service.

### SAP with Azure services

The architecture contains components you can use for day two operations. The components include an Azure Recovery Services vault to back up SAP systems and others that help you extend and improve your SAP data platform with cloud-native Azure data services.

Services like Azure Synapse Analytics, Azure Data Factory, and Azure Data Lake Storage help unlock business insights by combining SAP data with non-SAP data and creating the analytics platform. To evaluate solution development environment design, review [best practices](/azure/synapse-analytics/guidance/implementation-success-evaluate-solution-development-environment-design). You can use different instances of Azure Data Factory and Azure Data Lake Storage based on the SAP tier and best practices for your environment design.

The Azure [integration runtime](/azure/data-factory/concepts-integration-runtime) is the compute infrastructure that Azure Data Factory and Azure Synapse Analytics pipelines use to provide data integration capabilities. Consider the deployment of runtime virtual machines for these services per tier. For examples of ways to connect with SAP systems and deploy the Azure integration runtime, see these articles:

- [Set up a self-hosted integration runtime to use in the SAP CDC solution](/azure/data-factory/sap-change-data-capture-shir-preparation)
- [Copy data from SAP HANA](/azure/data-factory/connector-sap-hana?tabs=data-factory)
- [Copy data from SAP Business Warehouse via Open Hub](/azure/data-factory/connector-sap-business-warehouse-open-hub)

For more information about all architecture components, see [SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana).

### NFS / SMB file shares

SAP systems very often require NFS volumes or SMB shares to share files either between VMs of same or other SAP systems, or to act as file interface with other applications. These file shares are best provided by native Azure services, [Azure Files](/azure/virtual-machines/workloads/sap/disaster-recovery-overview-guide) and [Azure NetApp Files](/azure/virtual-machines/workloads/sap/planning-guide-storage#azure-netapp-files-anf). See the linked documentation about details, including sizing guidance for performance. This article focuses on overall deployment across the entire SAP landscape with recommendations for each usage:

| File share name | Description |
|:----------------|:------------|
| sapmnt          | Each individual SAP system with own file share, no re-use between SAP systems or environments                                    |
| Cluster shares  | (A)SCS, ERS, Database high availability shares, as per respective design. No re-use between any SAP system or environment        |
| SAP Transports  | Often one file share for one or more SAP landscapes (ERP,BW) with possible separation between environments (prod, non-prod)      |
| File interfaces | Depends on connected applications, often separate file shares for each environment (prod, non-prod), with no access between them |

Your overall architecture needs to contain plans and sizing for individual volumes and to which SAP system each is connected to. For SAP transport, the simple architecture is to provide one file share in production environment and allowing access from other SAP environments virtual networks. The corporate security policies will drive the architecture and possible separation of volumes between environments. A transport directory with separation per environment / tier, will need RFC communication between SAP environments to allow [SAP transport groups](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/44b4a0ce7acc11d1899e0000e829fbbd.html) or [transport domain links](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/14c795388d62e450e10000009b38f889.html). See SAP documentation on details with such setup.

> [!TIP]
> Use native Azure services for NFS / SMB file shares, with their SLAs for availability and resilience. The use of OS based tools to provide file shares on your VMs, or third party services and applications should be checked against support requirements in [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553).

## Re-use of services between SAP systems

A topic already touched upon with NFS / SMB file shares, when looking at the overall SAP landscape, the opportunity shows to use several Azure services by multiple SAP systems. While no single guidance is possible and many approaches are valid, a set of recommendations and design decisions are shared below. Whether this applies on overall SAP landscape or within one SAP environment (production or development) or a smaller group of systems, depends on the Azure service, your overall enterprise architecture and security policies.

This document will not provide guidance on central IT services. Whether firewalls, network gateways, DNS or OS patch repositories, such central services are out of scope for this article.

The architecture does not show a non-production SAP perimeter subnet/network. The decision to create and manage a non-production environment for shared SAP services like SAProuter or Cloud Connector depends on your company strategy and size of SAP landscape. A dedicated non-production SAP perimeter will be helpful during testing and new feature deployment.

Services that typically serve an SAP system are best separated as described here:

- **Load balancers** should be dedicated to individual SAP systems. The degree of separation is best dictated by company policy on naming and grouping. We recommend to not use a single load balancer for multiple SAP systems. One load balancer can be used for both (A)SCS/ERS and DB clusters of one SAP SID, with dedicated backend pools, multiple frontends, health probes and balancing rules. Alternatively one separate load balancer for (A)SCS/ERS and a separate load balancer for DB cluster is also a very good design. This configuration helps to ensure that troubleshooting doesn't get complex, with multiple front-end and back-end pools and load balancing rules all on a single load balancer. A single load balancer per SAP SID also ensures that placement in resource groups matches that of other infrastructure components.
- **Application Gateway**, like a load balancer, allows multiple back ends, front ends, HTTP settings, and rules. The decision to use one application gateway for multiple uses is more common here because not all SAP systems in the environment require public access. Multiple uses in this context include different web dispatcher ports for same SAP S/4HANA systems or different SAP environments. We recommend at least one application gateway per tier (production, non-production, and sandbox) unless the complexity and number of connected systems becomes too high.
- **SAP Web Dispatcher VMs** can be re-used by having multiple services configured, thus allowing multiple SAP clients and/or SAP systems connected. If no embedded web dispatcher on ASCS VMs are used, dedicated web dispatchers sharing between SAP systems should be decided based on your company's strategy about naming, resource group design and ease of troubleshooting.
- **SAP services**, like SAProuter, Cloud Connector, and Analytics Cloud Agent, are deployed based on application requirements, either centrally or split up. Production and non-production separation is often desired.

## Network design alternatives

This article shows a typical large SAP landscape and best practices. There are many alternatives to a successful deployment in Azure and depending on corporate requirement and size, we want to show alternatives, which can extend or simplify the design. Consider these optional and use the recommendations from the entire article to shape your own overall SAP architecture.

### Secured perimeter architecture

[![Diagram that shows a sample overall SAP landscape in Azure with a dedicated perimeter vnet](media/sap-cross-landscape-secured-perimeter.png)](media/sap-cross-landscape-secured-perimeter.png#lightbox)

_Same [Visio file] contains all the architecture, including the alternatives._

The architecture uses two discrete virtual networks in the production subscription, both spoke virtual networks that are peered to the central hub virtual network. There's no spoke-to-spoke peering. A star topology is used, in which communication passes through the hub. The separation of networks helps to protect the applications from breaches.

An application-specific [perimeter network](/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks) (also known as a DMZ) contains the internet-facing applications, like SAProuter, SAP Cloud Connector, SAP Analytics Cloud Agent, and Application Gateway. In the architecture diagram, the perimeter network is named _SAP perimeter spoke virtual network_. Because of dependencies on SAP systems, the SAP team typically does the deployment, configuration, and management of these services. That's why these SAP perimeter services frequently aren't located in a central hub subscription and network, where they would need to be managed by the central IT team. This constraint causes organizational challenges. Application Gateway always requires its own designated subnet, which is best placed in the SAP perimeter virtual network. Application Gateway uses public IP addresses for its front end and HTTPS listener.

These are some of the benefits of using a separate SAP perimeter virtual network:

- Quick and immediate isolation of compromised services if a breach is detected. Removing virtual network peering from the SAP perimeter to the hub immediately isolates the SAP perimeter workloads and SAP application virtual network applications from the internet. Changing or removing an NSG rule that permits access affects only new connections and doesn't cut existing connections.
- More stringent controls on the virtual network and subnet, with a tight lockdown on communication partners in and out of the SAP perimeter network and SAP application networks. You can extend increased control to authorized users and access methods on SAP perimeter applications, with different authorization back ends, privileged access, or sign-in credentials for SAP perimeter applications.

The drawbacks are increased complexity and extra virtual network peering costs for internet-bound SAP traffic (because communication needs to pass through virtual network peering twice). The latency impact on spoke-hub-spoke peering traffic depends on any firewall that's in place and needs to be measured.

The concept of own perimeter vnet can be extended with own non-production vnet and thus having a validation environment for any changes. The non-production SAP workloads could connect through the separate non-production SAP perimeter environment instead of using the production environment only.

### Consolidating SAP subnets and virtual networks

To address any requirement to increase or decrease the amount of required virtual networks and subnets, some changes to the main architecture design are possible. These would be:

- **Combine the SAP application and database subnets into one**
  By combining the two subnets you simplify the overall network design and mirror what is often deployed in many SAP landscapes on-premises, one large network for SAP. By combining the subnets, an even higher attention needs to be placed on subnet security and your NSG rules. NSG rules in place affect network traffic in- and out of the subnet, and also [within the subnet](/azure/virtual-network/network-security-group-how-it-works#intra-subnet-traffic). Use of ASGs is recommended always, but particularly when using a single subnet for SAP application and database subnets.
- **Combine SAP perimeter subnet into application subnet**
  Another simplification possible on network level, is to place VMs from the perimeter subnet into SAP application subnet, eliminating the SAP perimeter subnet. Similarly to the point above with joint SAP app and DB subnet, a heightened attention must be placed on NSG rules and ASG use. Due to the typically small SAP perimeter subnet or virtual network, we only recommend this simplification approach for very small SAP estates.
- **Combine SAP spoke vnets between different SAP environments / tiers**
  The architecture shown uses different virtual networks for each SAP environment / tier - production, development, etc. Depending on the size of your SAP landscape, you can combine the SAP spoke virtual networks into fewer or even only one SAP spoke. Each SAP environment's vnet would then be a subnet inside such combined virtual network - SAP development application subnet, SAP development database subnet, SAP pre-production application subnet, etc. Recommendation even for SAP landscapes with few VMs and SAP systems is to keep at least a production and non-production division of subnets. This alternative design goes together with having more or fewer Azure subscriptions for SAP workloads, from chapter [subscriptions](#azure-subscription) within this document.

Any simplification and change of the network and subscription design needs to re-evaluate the security impact on network routing, access to and from public networks, access of shared services like NFS / SMB file shares and other Azure services.

Consolidation on SAP application level is not in scope for this overall SAP architecture and left to other, more detailed guides focused on single SAP system architecture. Example of this are no high availability, two-tier deployment with SAP application server and database on same VM or use of embedded web dispatchers running on up-sized SAP ASCS virtual machines.

## Example SAP landscape of three SAP environments

The following diagram is an example reference architecture that's an extension of the main architecture shown at start of this article. The diagram describes an example use case of three SAP environment - SAP S/4HANA, SAP BW and SAP PI/PO. While S/4HANA environment is 4-tier, including sandbox workload zone, SAP PI/PO is only a 2-tier environment with production and development only. The diagram shows visually how different SAP environments run together in an overall Azure architecture.

[![Diagram that shows a sample overall SAP landscape in Azure with a dedicated perimeter vnet](media/sap-cross-landscape-three-sap-example.png)](media/sap-cross-landscape-three-sap-example.png#lightbox)

## Contributors
  
_This article is maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:** 

 * [Robert Biro](https://www.linkedin.com/in/robert-biro-38991927) | Senior Architect  
 * [Pankaj Meshram](https://ww.linkedin.com/in/pankaj-meshram-6922981a) | Principal Program Manager

Other contributors: ...

## Next steps

- [SAP S/4HANA in Linux on Azure](./sap-s4hana)
- [Run SAP NetWeaver in Windows on Azure](./sap-netweaver)
- [Run SAP HANA in a scale-up architecture on Azure](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)
- [Cloud Adoption Framework - SAP scenario](/azure/cloud-adoption-framework/scenarios/sap/)
- [In- and Outbound intennet connections for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)
- [SAP on Azure documentation](/azure/virtual-machines/workloads/sap/get-started).
- [Azure planning and implementation guide for SAP workloads](/azure/virtual-machines/workloads/sap/planning-guide)
- [SAP workloads on Azure: planning and deployment checklist](/azure/virtual-machines/workloads/sap/sap-deployment-checklist)