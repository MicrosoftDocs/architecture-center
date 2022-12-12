This article provides best practices deploying multiple SAP systems and environments. It focuses on the connections between systems and the optimal placement of SAP in Azure without going into detail on individual SAP system. The architecture illustrates the SAP environment for a large enterprise and the design decisions needed. For individual guides and more targeted single SAP system view, follow the links at the end of this document.

**I RECOMMEND ONE ARCHITECTURE. WE SHOULD REPLACE THIS DIAGRAM ONE WITH THE MORE SECURE ARCHITECTURE BELOW. AND JUST DESCRIBE THE DIFFERENCE OR GIVE READERS SHOT CLOSE UP OF THE SAP PRODUCTION SUBSCRIPTION, NOT THE FULL ARCHITECTURE.**

[Visio file]:https://arch-center.azureedge.net/sap-whole-landscape.vsdx

## Architecture

[![Diagram that shows a sample overall SAP landscape in Azure](media/sap-whole-landscape.png)](media/sap-whole-landscape.png#lightbox)

_Download a [Visio file] of the architectures in this article._

### Azure subscriptions

**TAKE A RECOMMENDATION APPROACH. WHAT IS YOUR SUBSCRIPTION RECOMMENDATION IN GENERAL? HAVE A SUBSCRIPTION FOR EACH ENVIRONMENT(PROD, DEV, TEST, DR)?**

This architecture uses three subscriptions:

- An Azure virtual hub subscription where the hub virtual network (VNet) exists for the primary and secondary regions.
- An Azure SAP production subscription where the production and disaster recovery systems are configured.
- An Azure SAP non-production subscription where non-production systems, including sandbox, development, quality assurance, or pre-production systems, reside.

This configuration is optional and depends on size of your SAP landscape. You can use a subscription for each environment / tier / workload zone. You can use a dedicated subscription for sandbox or project SAP environment only, isolating on network and Azure level the resources to limit blast radius of such crash-and-burn environment. One recommendation is to not use too many subscriptions, such as one per SAP system or all SAP BW systems. The overhead of multiple subscriptions and implicit different spoke networks becomes too difficult to manage.

For more information on resource management, see:

- [Limits for each subscription](/azure/azure-resource-manager/management/azure-subscription-service-limits)
- [Azure policies](/azure/governance/policy/overview)
- [Management groups](/azure/governance/management-groups/overview)

### Network design

The architecture uses a [hub-spoke topology](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). The hub VNet acts as a central point of connectivity. It connects to the on-premises network and the various spoke VNets.

**On-premises connection** We've used ExpressRoute to connect the hub on-premises network, but you could use [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about). **WHY OR WHY NOT WOULD YOU USE VIRTUAL WAN?** Consider setting up a site-to-site (S2S) VPN as a backup to Azure ExpressRoute or any third-party route requirements. For more information, see:

- [Azure virtual WAN](/azure/virtual-wan/virtual-wan-about)
- [S2S VPN as a backup for ExpressRoute private peering](/azure/expressroute/use-s2s-vpn-as-backup-for-expressroute-privatepeering).

**Virtual network use** We recommend using one VNet per workload or environment. The architecture uses a different VNet for production, development, quality assurance, and sandbox. However, depending on the size of your SAP landscape, you can combine the SAP spoke virtual networks into fewer or even only one SAP spoke. Each SAP environment's vnet would then be a subnet inside such combined virtual network - SAP development application subnet, SAP development database subnet, SAP pre-production application subnet, etc. For SAP landscapes with few VMs and SAP systems, we recommend keeping at least a production and non-production division of subnets. **<---SUBNETS OR VNETS?**

Any simplification and change of the network and subscription design needs to re-evaluate the security impact on network routing, access to and from public networks, access of shared services like NFS / SMB file shares and other Azure services.

**Direct all traffic to firewall** All network traffic should traverse a firewall, including remote function call (RFC) connections. We've configure communication between the spoke VNets and communication between the spoke VNets and on-premises network to pass through the hub VNet firewall in the Azure Firewall Subnet. We used VNet peering to connect the various spoke VNets to the hub VNet. All spoke-to-spoke VNet communication traverses the hub VNet firewall. You could also use a network virtual appliance instead of a firewall. For more information, see [network virtual appliance](https://azure.microsoft.com/solutions/network-appliances/).

**Limit spoke-to-spoke virtual network peering** VNet peering between the spoke VNets should be avoided if possible. Spoke-to-spoke VNet peering allows spoke-to-spoke communication to bypass the hub VNet firewall. You should only configure spoke-to-spoke VNet peering when you have high-bandwidth requirements. Examples include database replication between SAP environments. Any spoke-to-spoke communication should only allow high-bandwidth traffic. All other network traffic should run through the hub VNet.

#### Subnets

It's a best practice to divide each SAP environment (production, pre-production, development, sandbox) into subnets and use subnets to group related services.  The production virtual network in the architecture has five subnets. The network design you should use depends on the resources in the virtual network, but use the architecture and the following points to implement the right principles.

**CAN WE DESCRIBE WHAT THE COMPONENTs in the app subnet do in the architecture?What are the boxes around the layers? resource groups? NSGs? if you're not careful, they look like subnet.**<br>
**Application subnet**: The application subnet contains a private endpoint to Azure Files, SAP Web Dispatcher pool, Advanced Business Application Programming (ABAP) Central Services (ASCS)/SAP central services (SCS), SAP application servers, and SAP enqueue replication services instances **<---the SAP enqueue is not in the architecture. can you address this?**

**Database subnet**: The database subnet holds virtual machines running databases. **what do they do in the architecture? asynch replication to DR?**

The architecture does not show a non-production SAP perimeter subnet/network. The decision to create a non-production environment for shared SAP services (SAProuter or Cloud Connector) depends on your company strategy and the size of your SAP landscape. **<---CAN YOU AT LEAST GIVE A GENERAL PRINCIPLE? FOR USING OR NOT USING A NON-PRODUCTION PERIMETER SUBNET/NETWORK?** A dedicated non-production SAP perimeter will be helpful during testing and new feature deployment.

**Application Gateway subnet**: Azure Application Gateway requires its own subnet. Use it to allow traffic from the Internet that SAP services, such as SAP Fiori, can use. An Azure Application Gateway requires at least a /29 size subnet. We recommend size /27 or larger. You can't use both versions of Application Gateway (v1 and v2) in the same subnet. For more information, see [subnet for Azure Application Gateway](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet).

**Azure NetApp Files subnet**: We recommend using Azure NetApp to host your SAP network file shares (NFSs) and server message block (SBM) shares. You can use Azure NetApp Files for database storage, though it's not in the architecture. **<--CAN YOU BE MORE SPECIFIC ABOUT DATABASE STORAGE? WHAT ABOUT APPLICATION VOLUME GROUP?** Azure NetApp Files requires a designated subnet. A /24 subnet is the default, but you should determine the right size for your system. For more information, see [delegated Azure NetApp Files subnet](/azure/azure-netapp-files/azure-netapp-files-delegate-subnet)

**Central security services**: Azure requires some central security services, such as Azure Bastion or Azure Firewall, have their own dedicated subnets.

We have a few more notes on subnet design. You cannot place an Azure network virtual appliances in the communication path between the SAP application and the DBMS layer of SAP systems running the SAP kernel. It isn't supported in Azure. **WHY DO YOU NEED MORE SUBNET SPACE? HOW MUCH MORE SPACE?-->** If you use SAP virtual host names, you need to have larger subnets more address space in your SAP subnets, including the SAP perimeter.

#### Security groups

Using subnets to divide makes it easier to implement and manage the security. It allows you implement network security groups at the subnet level. Grouping resources in the same subnet when they require different security rules makes it difficult to implement and manage security rules. It requires network security groups at the subnet level and network-interface level. With these two levels, security rules easily conflict and can cause unexpected communication problems that are difficult to troubleshoot. For more information, see [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli).

**Application security groups**: We recommend using application security groups allow you to group VM network interfaces and reference the ASGs in NSG rules. This allows easier rule creation and management, instead of IP ranges only, and are recommended for SAP deployments. For more information, see [application security groups](/azure/virtual-network/application-security-groups).

#### Azure Private Link

We recommend using Azure Private Link to improve the security of network communications. Azure Private Link uses private endpoints with private IP addresses to communicate with Azure services. It lets you avoid sending network communication through the public internet. For more information, see [private endpoints on Azure services](/azure/private-link/private-endpoint-overview).

**Azure Private Link SAP BTP connectivity**: Azure Private Link for SAP BTP is now generally available. SAP Private Link Service supports connections from SAP BTP, the Cloud Foundry runtime, and other services. Example scenarios include SAP S/4HANA or SAP ERP running on the virtual machine and connecting to Azure native services such as Azure Database for MariaDB and Azure Database for MySQL.

The architecture depicts an SAP Private Link Service connection to BTP environments. SAP Private Link Service establishes a private connection between specific SAP BTP services and specific services in each network as service provider accounts. Private link allows BTP services to access your SAP environment through private network connections. It improves security by not using the public internet to communicate.

For more information, see:

- [Internet connection for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)
- [Azure Private Link resources](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/e8bc0c6440834a47a0ff57cb4efc0dc2.html?locale=en-US)
- [Azure Database for MariaDB](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/862fa2958c574c3cbfa12a927ce1d5fe.html?locale=en-US)
- [Azure Database for MySQL](https://help.sap.com/docs/PRIVATE_LINK/42acd88cb4134ba2a7d3e0e62c9fe6cf/5c70499ee70b415d954145a795e43355.html?locale=en-US)

**Private endpoints**: Azure Files is the connected service but the same concept can be extended to any supported Azure service.

### Data services

The architecture contains Azure data services that help you extend and improve your SAP data platform. We recommend you use services, such as Azure Synapse Analytics, Azure Data Factory, and Azure Data Lake Storage, to unlock business insights. These data services help you analyze and visualize SAP data and non-SAP data.

**THE PURPOSE OF THE FOLLOWING PARAGRAPH ISN'T CLEAR TO ME. WHAT IS THE RECOMMENDATION? -->**
The Azure integration runtime is the compute infrastructure that Azure Data Factory and Azure Synapse Analytics pipelines use to provide data integration capabilities. Consider the deployment of runtime virtual machines for these services per tier. We have examples showing you how to connect SAP systems and deploy the Azure integration runtime.

- [Azure integration runtime](/azure/data-factory/concepts-integration-runtime)
- [Set up a self-hosted integration runtime to use in the SAP CDC solution](/azure/data-factory/sap-change-data-capture-shir-preparation)
- [Copy data from SAP HANA](/azure/data-factory/connector-sap-hana?tabs=data-factory)
- [Copy data from SAP Business Warehouse via Open Hub](/azure/data-factory/connector-sap-business-warehouse-open-hub)

### NFS / SMB file shares

We recommend using native Azure services for network file system (NFS) / server message block (SMB) file shares. They have better availability and resilience service level agreements (SLAs) than operating-system-based tools. **I'M NOT SURE WHAT YOU MEAN BY APPLICATIONS? -->** Applications should be checked against support requirements in [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553).

SAP systems often depend on NFS volumes or SMB shares to share files between VMs of same or other SAP systems, or to act as file interface with other applications. These file shares are best provided by native Azure services.

For more information, see:

- [Azure Files](/azure/virtual-machines/workloads/sap/disaster-recovery-overview-guide)
- [Azure NetApp Files](/azure/virtual-machines/workloads/sap/planning-guide-storage#azure-netapp-files-anf)

Your architecture needs to contain plans and sizing for individual volumes and to which SAP system each is connected to. The following table outlines common SAP file shares and gives a brief description. **MAKE IT MORE CLEAR WHY THE TABLE IS USEFUL. CAN WE USE THE TABLE TO MAP AN AZURE SOLUTION TO A TYPE OF FILE SHARE?vv**

| File share name | Description |
|:----------------|:------------|
| sapmnt          | Each individual SAP system with own file share, no reuse between SAP systems or environments                                    |
| Cluster shares  | (A)SCS, ERS, Database high availability shares, as per respective design. No reuse between any SAP system or environment        |
| SAP Transports  | Often one file share for one or more SAP landscapes (ERP, BW) with possible separation between environments (prod, non-prod)      |
| File interfaces | Depends on connected applications, often separate file shares for each environment (prod, non-prod), with no access between them |

**WHY DO WE ONLY TALK ABOUT SAP TRANSPORT AFTER THE TABLE?-->** For SAP transport, the simple architecture is to provide one file share in production environment and allowing access from other SAP environments virtual networks. The corporate security policies will drive the architecture and possible separation of volumes between environments. A transport directory with separation per environment / tier will need RFC communication between SAP environments to allow SAP transport groups or transport domain links. For more information, see:

- [SAP transport groups](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/44b4a0ce7acc11d1899e0000e829fbbd.html)
- [Transport domain links](https://help.sap.com/docs/SAP_NETWEAVER_750/4a368c163b08418890a406d413933ba7/14c795388d62e450e10000009b38f889.html).

## Reuse of services between SAP systems

Services that typically serve an SAP system are best separated as described here:

**Load balancers**: Load balancers should be dedicated to individual services. We recommend one load balancer for ASCS/SCS and Evaluated Receipt Settlement (ERS) and another for database separated for each SAP System Identifier (SID). **<---PLEASE CLARIFY - Does ASCS/SCS, ERS, and a database represent three different SAP SIDs? Or are there multiple SAP SIDs in ASCS/SCS, ERS, and the database. In other words is the recommendation for 3 load balancers or more than 3 load balancers?**

Alternatively, a single load balancer for both (A)SCS, ERS and DB clusters of one SAP system is also good design. **WHICH CONFIGURATION ARE YOU REFERRING TO? As it currently reads it looks like you're promoting the alternative solution over the recommended solution in the first paragraph--->** This configuration helps to ensure that troubleshooting doesn't get complex, with many front-end and back-end pools and load balancing rules all on a single load balancer.

**Can you clarify what this means? Are you saying it encourages you to group components that share a lifecycle?** A single load balancer per SAP SID also ensures that placement in resource groups matches that of other infrastructure components.

**Application Gateway**: We recommend at least one application gateway per SAP environment (production, non-production, and sandbox) unless the complexity and number of connected systems is too high. You could use an application gateway for multiple SAP systems to reduce complexity since not all SAP systems in the environment require public access. A single application gateway could serve multiple web dispatcher ports for a single SAP S/4HANA system or across different SAP environments.

**This is the first time the article focuses on web dispatcher. Let's give some general recommendations-->**
**SAP Web Dispatcher VMs:** SAP Web Dispatcher VMs can be re-used by having multiple services configured. **<--Let's clarify if you're referring to web tier services, app tier services, or database tier services.** The configuration allows multiple SAP clients and/or SAP systems connected.

**I've clarified this sentence. The architecture doesn't embed web dispatchers, right? Why or why not embed? Why does not embedding force you to rely on a naming strategy for sharing?-->**
You can install an SAP Web Dispatcher on the ASCS virtual machine or keep them separate. Separating the SAP Web Dispatcher from the ASCS VMs allows you to share the SAP Web Dispatcher across multiple SAP systems.  should be decided based on your company's strategy about naming, resource group design and ease of troubleshooting.

**Provide a recommendation or a decision guide for this paragraph. It's just information right now-->**
**SAP services**: SAP services like SAProuter, Cloud Connector, and Analytics Cloud Agent, are deployed based on application requirements, either centrally or split up. Production and non-production separation is often desired.

## Disaster recovery considerations

**WE NEED TO DESCRIBE THE ARCHITECTURE AND PROVIDE RECOMMENDATIONS AROUND THAT. FOR EXAMPLE:**
- **USE ASR TO REPLICATE AND FAILOVER YOUR PERIMETER AND APP SUBNETS: [TELL THEM WHY AND HOW]**
- **REPLICATE YOUR FILE SHARE- [WHY? AND HOW?]**
- **REPLICATE YOUR DATABASE - [WHY? AND HOW?]**

***PROVIDE A RECOMMENDATION or a decision guide for this paragraph. It's just information right now-->***
Disaster recovery addresses the requirement for business continuity in case the primary Azure region is unavailable or compromised. From an overall SAP landscape perspective, the main decisions to make are:

***PROVIDE A RECOMMENDATION or a decision guide for this paragraph. It's just information right now-->***

**Use different IP address ranges**: The virtual network in the DR environment needs different IP address range to enable database synchronization through database native technology.

**Ensure file share availability**: For SAP particularly important is availability of the SMB or NFS service and data replication, together with backup infrastructure and backup data.

**Central services and connectivity from on-premises**: With SAP depending on key central services like DNS, availability and change configuration on SAP side during DR failover needs to be established. (**WHY AND HOW? SHOULD WE SHOW DNS IN THE ARCHITECTURE?)**

For detailed disaster recovery guidance for SAP, see details in article [Disaster recovery overview and infrastructure guidelines for SAP workload](/azure/virtual-machines/workloads/sap/disaster-recovery-overview-guide)

### Secured perimeter architecture

**I THINK MORE SECURE ARCHITECTURE SHOULD BE THE DEFAULT ABOVE AND NOT THE ALTERNATIVE, UNLESS YOU DON'T RECOMMEND THIS TO CUSTOMERS. COMPLEXITY IS NOT A GOOD REASON TO AVOID BETTER SECURITY AND THAT'S THE STATED DRAWBACK HERE.**
The alternative architecture uses two discrete virtual networks in the production subscription, both spoke virtual networks that are peered to the central hub virtual network. There's no spoke-to-spoke peering. Communication between the "SAP production" VNet and the "SAP perimeter" VNet passes through the hub. The separation of networks helps to protect the applications from security threats.

**CAN WE SHOW THE NETWORK CONNECTIONS FOR THE SAP PERIMETER NETWORK APPLICATION SUBNET? THERE'S INTERNET TRAFFIC TO THE APP?**

[![Diagram that shows a sample overall SAP landscape in Azure with a dedicated perimeter vnet](media/sap-whole-landscape-secured-perimeter.png)](media/sap-whole-landscape-secured-perimeter.png#lightbox)

_You might be able to zoom multiple time to see full resolution and details. Same [Visio file] contains all the architecture, including the alternatives._

The "SAP perimeter" VNet is a demilitarized zone (DMZ) that contains internet-facing applications such as SAProuter, SAP Cloud Connector, SAP Analytics Cloud Agent, and Application Gateway. These services have dependencies on SAP systems that an SAP team should deploy, manage, and configure, not a central IT team. For this reason, you should place these service in the "SAP perimeter" VNet and not the Hub VNet.

**Better incident response**: Quick and immediate isolation of compromised services if a breach is detected. Removing virtual network peering from the SAP perimeter to the hub immediately isolates the SAP perimeter workloads and SAP application virtual network applications from the internet. Changing or removing an NSG rule that permits access only affects new connections and doesn't cut existing connections.

**Fine-grained network access control**: The "SAP Perimeter" VNet provides more stringent network access control to and from the "SAP production" network.

**Increased complexity, latency, and cost**: The architecture increases management complexity, cost, and latency. Internet-bound communication from the SAP production virtual network is peered twice, once to the Hub virtual network and again to the SAP perimeter virtual network out to the internet. The firewall in the Hub virtual network has the greatest affect on latency. We recommend measure the latency to see if your use case can support it.

**SAP perimeter network application subnet** As an alternative, The SAP perimeter network application subnet contains VMs running SAP applications, such as SAProuter or Cloud Connector, where direct connectivity to the internet is needed. **CAN WE SHOW INTERNET AND NETWORK CONNECTIONS IN THE DIAGRAM? THIS SUBNET CURRENT ONLY CONNECTS TO ASR.**

**WHY OR WHY NOT DO THIS-->?**
The concept of own perimeter vnet can be extended with own non-production vnet and thus having a validation environment for any changes. The non-production SAP workloads could connect through the separate non-production SAP perimeter environment instead of using the production environment only.

For more information, see [perimeter network best practices](/azure/cloud-adoption-framework/ready/azure-best-practices/perimeter-networks).

**I DELETED THE OTHER ARCHITECTURE. THERE WASN'T ENOUGH CONTENT AROUND IT AND IT SHOULD BE A SEPARATE ARTICLE**
## Contributors
  
_This article is maintained by Microsoft. It was originally written by the following contributors._

**Principal authors:** 

 * [Robert Biro](https://www.linkedin.com/in/robert-biro-38991927) | Senior Architect  
 * [Pankaj Meshram](https://ww.linkedin.com/in/pankaj-meshram-6922981a) | Principal Program Manager

Other contributors: ...

## Next steps

- [SAP S/4HANA in Linux on Azure](./sap-s4hana.yml)
- [Run SAP NetWeaver in Windows on Azure](./sap-netweaver.yml)
- [Run SAP HANA in a scale-up architecture on Azure](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)
- [Cloud Adoption Framework - SAP scenario](/azure/cloud-adoption-framework/scenarios/sap/)
- [In- and Outbound internet connections for SAP on Azure](/azure/architecture/guide/sap/sap-internet-inbound-outbound)
- [SAP on Azure documentation](/azure/virtual-machines/workloads/sap/get-started).
- [Azure planning and implementation guide for SAP workloads](/azure/virtual-machines/workloads/sap/planning-guide)
- [SAP workloads on Azure: planning and deployment checklist](/azure/virtual-machines/workloads/sap/sap-deployment-checklist)

