> [!NOTE]
> For updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article describes a recommended solution for deploying SWIFT Alliance Messaging Hub (AMH) on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the AMH components. 
- The other subscription contains the resources for connecting to SWIFT's network via Alliance Connect Virtual.

## Architecture

:::image type="content" source="./media/alliance-messaging-hub-alliance-connect-virtual.png" alt-text="Diagram that shows how to host a SWIFT Alliance Messaging Hub on Azure." border="false" lightbox="./media/alliance-messaging-hub-alliance-connect-virtual.png":::

*Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-vSRX-GA-allModules.vsdx) of this architecture. See the **AMH (All-GoldSilverBronze)** tab.*

This Azure solution uses the same topology as the on-premises environment. On-premises environments fall into two categories:

- Business users. The location that business users and business applications use to access AMH.
- Hardware Security Module. The location that hosts the Hardware Security Module (HSM) appliance that SWIFT provides.

### Workflow

- A business user or an application at the organization's on-premises site (Business users) connects to AMH by using network connectivity. 
- AMH processes the user request by coordinating with SWIFT Alliance Gateway (SAG) and SWIFTNet Link (SNL). 
- The SAG and SNL components connect to the organization's on-premises site (HSM) to sign the message. 
- The Alliance Connect Virtual subscription contains the additional components that are required to enable connectivity with SWIFTNet. 
- High availability is enabled because the vSRX components in the architecture are deployed redundantly into two Azure availability zones. 
- HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution.
- The Alliance Connect Virtual networking solution forwards the message to SWIFTNet.
- The connection between SWIFTNet and customer-specific networking components can use the dedicated Azure ExpressRoute line or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option best suited to your message-traffic volumes and required level of resiliency. For more information about these options, see [Alliance Connect: Bronze, Silver, and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).
- Azure services that run in your optional shared Azure services subscription provide additional management and operational services.

AMH needs network connectivity with SAG and SNL.

- SAG provides multiple integration points and message concentration between SWIFT modules and SWIFTNet.
- SNL provides an API interface between SWIFT modules and SWIFTNet.

We recommend that you place the SWIFT modules, SAG, and SNL components in the same Azure virtual network. You can deploy them across separate subnets in the virtual network or in resource groups.

A key component of AMH is the AMH node, which runs a user interface, a database, and a messaging system. The AMH node provides the web front end that runs the user interface and Signal Transfer Point (STP) message processing.

- The AMH node runs on [JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux (RHEL)](https://techcommunity.microsoft.com/t5/marketplace-blog/announcing-red-hat-jboss-eap-on-azure-virtual-machines-and-vm/ba-p/2374068). 
- The database runs on [Oracle](/azure/virtual-machines/workloads/oracle/oracle-overview). 
- The messaging system typically runs on [WebSphere MQ](https://azure.microsoft.com/updates/general-availability-enabling-ibm-websphere-application-server-on-azure-virtual-machines), but you can use any JMS–compliant messaging service.
- Additional virtual machines (HA-VM 1 and HA-VM 2) monitor and maintain the route tables of  SAG, NSL, and other components.

The following Azure infrastructure services are also part of this solution:

- You need an Azure subscription to deploy AMH. We recommend that you use a new Azure subscription to manage and scale AMH.
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
- Premium SSD managed disks ensure that AMH components achieve high-throughput and low-latency disk performance. Azure Disk Storage provides backup and restore capabilities for disks that are attached to VMs.
- To reduce the network latency between AMH components, the solution uses Azure proximity placement groups, which place the AMH VMs as close as possible to each other.

## Components

- [Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks on Azure. Virtual Network enables Azure resources like VMs to communicate with each other, the internet, and on-premises networks, all with enhanced-security connections.
- [Load Balancer](https://azure.microsoft.com/products/load-balancer) distributes inbound traffic to back-end pool instances. Load Balancer directs traffic according to configured load-balancing rules and health probes. 
- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions. 
- [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends on-premises networks into the Microsoft Cloud. By using a connectivity provider, ExpressRoute establishes private connections to cloud components like Azure services and Microsoft 365. 
- [Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is an infrastructure as a service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. 
- [Azure Disk Storage](https://azure.microsoft.com/products/storage/disks) provides high-performance, highly durable block storage. You can use these managed storage volumes with Virtual Machines.

## Scenario details 

AMH is one of the key messaging solutions in the SWIFT product portfolio. AMH is customizable and meets the messaging needs of financial institutions. [AMH](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-messaging-hub) can help financial institutions introduce new services and products to the market quickly and efficiently. AMH can also help organizations meet the security and compliance standards that financial messaging requires.

### Potential use cases

This solution is optimal for the finance sector.

It can provide benefits for existing and new SWIFT customers. You can use it for these scenarios:

- Migrating AMH from on-premises systems to Azure
- Establishing a new AMH environment on Azure

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

If you want more information about the following considerations, contact your account team at Microsoft, which can help guide your Azure implementation of SWIFT.

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Deploy AMH across Azure paired regions so that a regional outage doesn't affect workload availability.
- Use Azure availability zones inside an Azure region. Solution components like Azure Virtual Machine Scale Sets and Load Balancer support availability zones. When you use availability zones, your solution is available even if an Azure datacenter in the region experiences an outage.
- Use Azure Alerts to monitor the metrics and activity logs of key components like web components, the database, and messaging components.
- Use Azure managed disks with Premium SSD to achieve up to 20,000 IOPS and 900 Mbps of throughput.
- If you use a single Azure availability zone, use Oracle Active Data Guard to provide database reliability during zone failures.
- Identify the single points of failure in AMH, like regional outages that affect components. Plan for remediation.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Use the latest implementation of SWIFT Customer Security Programme (CSP) controls in Azure. You should, however, consult your Microsoft team first.
- Use Defender for Cloud to help protect against threats that exploit server and application vulnerabilities. Defender for Cloud can help you quickly identify threats, streamline threat investigation, and automate remediation.
- Use Azure Active Directory (Azure AD) and role-based access control (RBAC) to limit access to application components.
- Use Microsoft Sentinel to analyze security events and other events that solution components report. This service can help you respond quickly to anomalies and potential threats.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). 

To estimate the cost of the Azure resources that you need to run AMH, see [this estimate in the Azure pricing calculator](https://azure.com/e/d2e12d232edb49db85cf330f70ffd636).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Use Azure Monitor to monitor the solution infrastructure. Configure alerts and dashboards by using Log Analytics to detect and respond to critical events.
- Use Application Insights for application-level monitoring.
- Use declarative definitions in Azure Policy to enforce governance and compliance requirements.
- For zero-touch deployment, use the continuous integration and continuous delivery (CI/CD) workflow that Azure DevOps provides.
- Use an Azure Resource Manager template (ARM template) to provision Azure infrastructure components.
- Use virtual machine extensions to configure any other solution components in the Azure infrastructure.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Deploy an Azure virtual machine scale set that runs web server VM instances in a proximity placement group. This approach colocates VM instances and reduces latency between VMs.
- Use Azure VMs with accelerated networking to achieve up to 30 Gbps of network throughput.
- Configure Azure disk host caching as read-only to increase disk throughput.
- Configure Azure autoscale to scale up VM instances based on metrics like CPU or memory usage.
- Use Load Balancer in a zone-redundant configuration. If you use this configuration, you can route user requests so that they aren't affected by a zone failure in an Azure region.

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Gansu Adhinarayanan](https://www.linkedin.com/in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist 
- [Mahesh Kshirsagar](https://www.linkedin.com/in/mahesh-kshirsagar-msft/?originalSubdomain=uk) | Senior Cloud Solution Architect
- [Ravi Sharma](https://www.linkedin.com/in/ravisharma4sap) | Senior Cloud Solution Architect 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [Availability zones](/azure/availability-zones/az-overview)
- [Azure virtual machine extensions](/azure/virtual-machines/extensions/overview)

## Related resources

- [SWIFT Alliance Connect Virtual on Azure](swift-on-azure-vsrx.yml)
- [SWIFT Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml)
- [SWIFT Alliance Cloud on Azure](swift-alliance-cloud-on-azure.yml)
- [SWIFT Alliance Lite2 on Azure](swift-alliance-lite2-on-azure.yml)
