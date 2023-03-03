> [!NOTE]
> For updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

SWIFT Alliance Messaging Hub (AMH) is one of the key messaging solutions in the SWIFT product portfolio. AMH is customizable and meets the messaging needs of financial institutions. [AMH](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-messaging-hub) can help financial institutions introduce new services and products to the market quickly and efficiently. AMH can also help you meet the security and compliance standards that financial messaging requires.

This article describes a recommended solution for deploying AMH on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the AMH components. 
- The other subscription contains the resources for connecting to SWIFT's network via Alliance Connect Virtual.

## Architecture

:::image type="content" source="./media/alliance-messaging-hub-alliance-connect-virtual.png" alt-text="Diagram that shows how to host a SWIFT Alliance Messaging Hub on Azure." border="false" lightbox="./media/alliance-messaging-hub-alliance-connect-virtual.png":::

*Download a [Visio file](https://arch-center.azureedge.net/digrams-swift-alliance-messaging-hub-with-alliance-connect-virtual.vsdx) of this architecture.*

This Azure solution uses the same topology as the on-premises environment. On-premises environments fall into two categories:

- On-premises site (Business users). The location that business users and business applications use to access AMH.
- On-premises site (Hardware Security Module). The location that hosts the Hardware Security Module (HSM) appliance that SWIFT provides.

### Workflow

- A business user or an application at the organization's on-premises site (Business users) connects to AMH by using network connectivity. 
- AMH processes the user request by coordinating with SWIFT Alliance Gateway (SAG) with SWIFTNet Link (SNL). 
- The SAG and SNL components connect with the organization's on-premises site (HSM) to sign the message. 
- The Alliance Connect Virtual subscription contains the additional components that are required to enable connectivity with SWIFTNet. 
- High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly into two Azure availability zones. 
- HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution.
- The Alliance Connect Virtual networking solution forwards the message to SWIFTNet.
- The connection between SWIFTNet and customer-specific networking components can use the dedicated Azure ExpressRoute line or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option best suited to message-traffic volumes and the required level of resiliency. For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).
- Azure services that run in your optional shared Azure services subscription provide additional management and operational services.

AMH needs network connectivity with SAG and SNL.

- SAG provides multiple integration points and message concentration between SWIFT modules and SWIFTNet.
- SNL provides an API interface between SWIFT modules and SWIFTNet.

We recommend that you place the SWIFT modules, SAG, and SNL components in the same Azure virtual network. You can deploy them across separate subnets in the virtual network or in resource groups.

A key component of AMH is the AMH node, which runs a user interface, a database, and a messaging system. The AMH node provides the web front end that runs the user interface and Signal Transfer Point (STP) message processing.

- The AMH node runs on [JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux (RHEL)](https://techcommunity.microsoft.com/t5/marketplace-blog/announcing-red-hat-jboss-eap-on-azure-virtual-machines-and-vm/ba-p/2374068). 
- The database runs on Oracle. 
- The messaging system typically runs on WebSphere MQ, but you can use any JMS–compliant messaging service.
- Additional virtual machines (HA-VM 1 and HA-VM 2) monitor and maintain the route tables of  SAG, NSL, and other components.

The following Azure infrastructure services are also part of this solution:

- You need ab Azure subscription is needed to deploy AMH. We recommend that you use a new Azure subscription to manage and scale AMH.
- The solution deploys AMH in an Azure region by using an Azure resource group. We recommend that you set up a separate resource group for AMH, SAG, and SNL.
- Azure Virtual Network forms a private network boundary around the AMH deployment. The solution uses a network address space that doesn't conflict with the on-premises Business users site, the on-premises HSM site, or the Alliance Connect Virtual networking solution.
- The solution deploys AMH core components, that is, the front end, the database, and the messaging system, in separate Virtual Network subnets. If you use this configuration, you can control the traffic between them by using network security groups.
- Azure route tables provide a way to:
  - Control network connectivity between AMH and the on-premises site (HSM).
  - Configure the connectivity to SWIFTNet.
- Azure Load Balancer acts as a gateway to AMH. Business users and applications from an on-premises site connect to Load Balancer, which routes requests to a pool of back-end virtual machines (VMs) that run the AMH front end.
- Outbound connectivity from AMH VMs to the internet is routed through Azure Firewall. Typical examples of such connectivity include time syncs and antivirus definition updates.
- ExpressRoute or Azure VPN Gateway connects AMH components with the Business users on-premises site and the HSM on-premises site. ExpressRoute provides dedicated private network connectivity. VPN Gateway uses an internet-based connection.
- Azure Virtual Machines provides compute services for running AMH:
   - A compute-optimized SKU runs the AMH node.
   - A memory-optimized SKU with ample storage runs the database. 
   - A compute-optimized SKU runs the messaging component.
- Premium SSD managed disks ensure that AMH components achieve high-throughput and low-latency disk performance. Azure Disk Storage also provides backup and restore capabilities for disks that are attached to VMs.
- To reduce the network latency between SWIFT's AMH components, the solution uses Azure proximity placement groups, which place the SWIFT AMH VMs as close as possible to each other.

## Components

## Contributors 

## Next steps

- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [Availability zones](/azure/availability-zones/az-overview)
- [Azure virtual machine extensions](/azure/virtual-machines/extensions/overview)

## Related resources

- [SWIFT Alliance Connect on Azure](swift-on-azure-srx.yml)
- [SWIFT Alliance Connect Virtual on Azure](swift-on-azure-vsrx.yml)
- [SWIFT Alliance Access with Alliance Connect](swift-alliance-access-on-azure.yml)
- [SWIFT Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml)
- [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect](swift-alliance-messaging-hub.yml)
- [SWIFT Alliance Cloud on Azure](swift-alliance-cloud-on-azure.yml)
- [SWIFT Alliance Lite2 on Azure](swift-alliance-lite2-on-azure.yml)
