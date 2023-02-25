> [!NOTE]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying the Alliance Cloud connectivity stack on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the SWIFT Integration Layer (SIL) resources. 
- The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

## Architecture

:::image type="content" alt-text="Diagram that shows how to deploy Azure resources in a SWIFT Alliance Cloud solution." source="./media/swift-alliance-cloud-on-azure-architecture.png" lightbox="./media/swift-alliance-cloud-on-azure-architecture.png" border="false":::

replace diagram. update link 

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-on-azure.vsdx) that contains this architecture diagram. This diagram is on page AC (All-GoldSilverBronze)._

### Workflow

In this example scenario, deployment of SWIFT's Alliance Cloud in Azure involves using two Azure subscriptions. The two-subscription design separates resources based on the primary responsibility for each resource:

* SWIFT customers are primarily responsible for supplying the resources for the SIL in one Azure subscription.
* In a second Azure subscription, SWIFT provides the virtual firewall, Juniper vSRX. This component is part of the solution for managed connectivity of Alliance Connect Virtual.

In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the Juniper vSRX to SWIFT. Customers have no access or visibility into the Juniper vSRX configuration or operation, but customers do have visibility and operational responsibility for the underlying Azure infrastructure resources. High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution.

The connection between SWIFTNet and these customer-specific networking components can use the dedicated Azure ExpressRoute connection or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. Customers can choose the option best suited to message-traffic volumes and the required level of resilience. For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

The footprint of SWIFT's Alliance Cloud is based on a single tenant. To increase resiliency and availability, each customer deploys a second replicated configuration, in standby mode, in a different Azure region. For each customer, there's an instance of the SIL and Alliance Connect Virtual.

The SIL subscription contains resources that are managed by the customer. The SIL subscription has a single resource group, which contains:

* An Azure virtual network.
* An Azure subnet for Azure Firewall with an Azure network security group.
* An Azure subnet for the SIL with an Azure network security group.
* A configuration of Azure Firewall that allows appropriate traffic to SIL.
* An Azure subnet for the additional virtual machines (depicted by HA-VM 1 and HA-VM 2 in the architecture diagram) for high availability monitoring and routing.
* Azure policies for compliance with SWIFT's Customer Security Programme (CSP) – Customer Security Controls Framework (CSCF).

The resources for the SIL can be deployed by using an Azure Resource Manager template (ARM template) to create the core infrastructure, as described in this architecture. You can modify the ARM template for the SIL to meet your specific needs. But your configuration needs to adhere to policies that CSP–CSCF requires. You can use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to apply the necessary policies to comply with CSP–CSCF.

The Alliance Connect Virtual subscription contains resources that you deploy. You deploy them by using an ARM template, also known as the Cloud Infrastructure Definition (CID) file, that's provided by SWIFT. SWIFT manages the configuration and operation of the Juniper vSRX.

SWIFT customers establish improved-security connectivity to the SIL subscription by:

* Using ExpressRoute to connect on-premises resources to Azure via private connectivity.
* Using site-to-site VPN to connect customer premises to Azure via the internet.
* Using Remote Desktop Protocol (RDP) over the internet to connect customers that have internet connectivity. (You can alternatively use Azure Bastion for these connections.  We recommended this option for new SWIFT on Azure customers.)

:::image type="content" alt-text="Diagram that shows three ways to connect to the Azure accounts that support the SWIFT Integration Layer for SWIFT Alliance Cloud." source="./media/swift-alliance-cloud-on-azure-connectivity.png" lightbox="./media/swift-alliance-cloud-on-azure-connectivity.png" border="false":::

replace diagram 

<!-- _Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-on-azure-connectivity.vsdx) that contains this architecture diagram._ -->

The SWIFT customer uses one of the three methods of connectivity to connect to the SIL software that runs on the SIL VM. The recommended configurations of Azure Firewall and network security groups allow only appropriate traffic to pass to the SIL VM. 

Alternatively, you can use Azure Bastion to restrict traffic. (The corresponding subnet can be part of the connectivity hub virtual network. As a general guideline, we recommend this option for new SWIFT on Azure customers.) Azure Bastion provides connectivity from the Azure portal to a virtual machine via RDP or SSH. Because Azure Bastion requires administrators to sign in to the Azure portal, you can enforce multifactor authentication. 

You can use Conditional Access to enforce other restrictions. For example, you can restrict the public IP address that administrators can use to sign in. Azure Bastion must be deployed to a dedicated subnet and requires a public IP address. It restricts access to this public IP address by using a managed network security group. Azure Bastion also provides just-in-time access, which opens required ports on demand only when remote access is required. The traffic from the SIL software to SWIFTNet flows via the virtual network peering with the Juniper vSRX. This component has an established VPN tunnel to SWIFTNet over the internet or the dedicated ExpressRoute connection (depending on the Alliance Connect Virtual connectivity option).

### Components

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) provides secure and seamless RDP and SSH access to VMs. This fully managed service doesn't expose public IP addresses.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into the Microsoft cloud over a private connection that's facilitated by a connectivity provider. You can use ExpressRoute to establish connections to Microsoft cloud services like Azure and Office 365.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy) helps you to manage policies in a central location. By using this service, you can track compliance status, govern resources, and discover the changes that made a resource non-compliant. You can also enforce policies on your resources and ensure that future configurations are compliant with standards and regulations.
- [Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks.
- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure-as-a-service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.

## Scenario details

This approach can be used for:
•	Migrating SWIFT connectivity from on-premises to Azure.
•	Establishing new SWIFT connectivity by using Azure.
Potential use cases
This solution is targeted to:
•	Existing SWIFT customers who run SIL on premises and want to run Alliance Cloud in Azure.
•	New SWIFT customers who can benefit by deploying directly to Azure.
