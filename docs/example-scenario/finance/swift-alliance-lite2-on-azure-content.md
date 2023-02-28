> [!NOTE]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying SWIFT's Alliance Lite2 connectivity stack on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the Alliance Lite2 AutoClient resources. 
- The other subscription contains the Alliance Connect Virtual resources to connect to SWIFT's network.

## Architecture

diagram

*Download a [Visio file]() of this architecture diagram (Page-Lite 2 (All-GoldSilverBronze) in the Visio file).*

update link. check note. 

### Workflow

In this example scenario, SWIFT Alliance Lite2 is deployed into two Azure subscriptions. The two-subscription design separates resources based on the primary responsibility for each resource:

- SWIFT customers are primarily responsible for supplying the resources for the SIL in one Azure subscription.

- In a second Azure subscription, SWIFT provides the virtual firewall, Juniper vSRX. This component is part of the solution for managed connectivity of Alliance Connect Virtual.

In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the Juniper vSRX to SWIFT. Customers have no access or visibility into the Juniper vSRX configuration or operation, but customers do have visibility and operational responsibility for the underlying Azure infrastructure resources. High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution.

The connection between SWIFTNet and these customer-specific networking components can use the dedicated Azure ExpressRoute or the internet. For information about SWIFT connectivity options, see [Two-subscription design](#two-subscription-design) in this article.

The two-subscription design separates the resources based on who's responsible for them. For more information, see [Two-subscription design](#two-subscription-design) and [Operations]() in this article.

The Lite2 AutoClient subscription has a single resource group. It contains:

- An Azure virtual network.
- An Azure subnet for the Azure firewall, with an Azure network security group.
- An Azure subnet for Alliance Lite2 AutoClient, with an Azure network security group.
- An Azure subnet for the additional virtual machines (depicted by HA-VM 1 and HA-VM 2 in the architecture diagram) for high availability monitoring and routing.
- A configuration of Azure Firewall that allows appropriate traffic to Alliance Lite2 AutoClient.
- Azure policies for SWIFT.
- Azure policies for compliance with SWIFT's Customer Security Programme (CSP) – Customer Security Controls Framework (CSCF).

You're responsible for establishing secured connectivity to the Alliance Lite2 AutoClient subscription. You can use one of these methods:

- Use ExpressRoute to connect your premises to Azure via private connectivity.
- Use Azure site-to-site VPN to connect your premises to Azure via the internet.
- Use direct RDP over the internet for internet connectivity. (You can alternatively use Azure Bastion for these connections. We recommended Azure Bastion for new SWIFT on Azure customers.)

image 

You use RDP, with one of the preceding three connectivity approaches, to connect to Alliance Lite2 AutoClient software running on the Lite2 AutoClient VM. You also configure the recommended Azure firewall and Azure network security group to allow only RDP traffic to pass to the Lite2 AutoClient VM. 

Alternatively, you can use Azure Bastion to restrict traffic. (The corresponding subnet can be part of the connectivity hub virtual network. As a general guideline, we recommend this option for new SWIFT on Azure customers.) Azure Bastion provides connectivity from the Azure portal to a virtual machine via RDP or SSH. Because Azure Bastion requires administrators to sign in to the Azure portal, you can enforce multifactor authentication. 

You can use Conditional Access to enforce other restrictions. For example, you can restrict the public IP address that administrators can use to sign in. Azure Bastion must be deployed to a dedicated subnet and requires a public IP address. It restricts access to this public IP address by using a managed network security group. Azure Bastion also provides just-in-time access, which opens required ports on demand only when remote access is required. Traffic from Lite2 AutoClient to SWIFTNet flows through the virtual network peer via Juniper vSRX. This component has an established VPN tunnel to SWIFTNet over the internet or the dedicated ExpressRoute connection (depending upon the Alliance Connect Virtual Connectivity option).

### Components

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for your private network on Azure. 
- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) provides cloud-native, intelligent network firewall security. 
- [ExpressRoute](https://azure.microsoft.com/products/expressroute) provides fast, reliable, and private connections to Azure.

## Scenario details

This approach can be used for:

- Migrating SWIFT connectivity from on-premises to Azure.
- Establishing new SWIFT connectivity by using Azure. 

### Potential use cases

This solution applies to:

- Organizations that plan to migrate Alliance Lite2 (SIL, Direct Link, AutoClient) from on-premises to Azure, including connectivity to SWIFT's network.
- New SWIFT customers who want to deploy directly to Azure.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following considerations apply to this solution. If you want more detailed information, your account team at Microsoft can help guide your Azure implementation for SWIFT.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Two-subscription design

The two-subscription design separates the resources based on who's responsible for them. You're primarily responsible for the Alliance Lite2 AutoClient resources. SWIFT provides Juniper vSRX as part of Alliance Connect Virtual, a managed connectivity service. In this context, SWIFT configures Juniper vSRX and establishes the VPN tunnel from the vSRX to SWIFT. You don't have access or visibility into the vSRX configuration or operation. You do have visibility and operational responsibility for the underlying Azure infrastructure resources. For more information, see [Deploy this scenario]() in this article. In some special cases, you can deploy these resources into two separate resource groups in a single subscription.

High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution. The connection between SWIFTNet and these customer-specific networking components can use the dedicated ExpressRoute connection or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option that's best suited to message-traffic volumes and the required level of resilience.  For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

The Alliance Lite2 connectivity stack is a single-tenant solution. For each SWIFT customer, there's an instance of Alliance Lite2 AutoClient and Alliance Connect Virtual. To increase resiliency and availability, we recommend that you deploy a second similar configuration in a different Azure zone, in the same Azure region. For Alliance Lite2 AutoClient and Alliance Connect Virtual instances, the systems (AutoClient VM, HA-VM 1, and VA vSRX) should be deployed in the same Azure zone (for example, AZ1) as shown in the preceding architecture diagram.