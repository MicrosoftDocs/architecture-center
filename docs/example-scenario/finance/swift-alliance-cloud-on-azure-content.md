> [!NOTE]
> For general updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying the Alliance Cloud connectivity stack on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two Azure subscriptions: 
- One subscription contains the SWIFT Integration Layer (SIL) resources. 
- The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

## Architecture

:::image type="content" alt-text="Diagram that shows how to deploy Azure resources in a SWIFT Alliance Cloud solution." source="./media/swift-alliance-cloud-azure.png" lightbox="./media/swift-alliance-cloud-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-vSRX-GA-allModules.vsdx) of this architecture. See the **AC (All-GoldSilverBronze)** tab.*

### Workflow

In this example scenario, SWIFT Alliance Cloud is deployed into two Azure subscriptions. The two-subscription design separates resources based on the primary responsibility for each resource:

* You're primarily responsible for supplying the resources for the SIL in one Azure subscription.
* In a second Azure subscription, SWIFT provides the virtual firewall, Juniper vSRX. This component is part of the solution for managed connectivity of Alliance Connect Virtual.

SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the Juniper vSRX to SWIFT. You don't have access or visibility into the Juniper vSRX configuration or operation, but you do have visibility and operational responsibility for the underlying Azure infrastructure resources. High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution.

The connection between SWIFTNet and these customer-specific networking components can use the dedicated Azure ExpressRoute line or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option that's best suited to your message-traffic volumes and required level of resilience. For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

The footprint of SWIFT Alliance Cloud is based on a single tenant. To increase resiliency and availability, each customer deploys a second replicated configuration, in standby mode, in a different Azure region. For each customer, there's an instance of the SIL and Alliance Connect Virtual.

The SIL subscription contains resources that you manage. The SIL subscription has a single resource group, which contains:

* An Azure virtual network.
* An Azure subnet for Azure Firewall with an Azure network security group.
* An Azure subnet for the SIL with an Azure network security group.
* A configuration of Azure Firewall that allows appropriate traffic to the SIL.
* An Azure subnet for the additional virtual machines (depicted by HA-VM 1 and HA-VM 2 in the architecture diagram) for high availability monitoring and routing.
* Azure policies for compliance with SWIFT's Customer Security Programme (CSP) – Customer Security Controls Framework (CSCF).

You can deploy the resources for the SIL by using an Azure Resource Manager template (ARM template) to create the core infrastructure, as described in this architecture. You can modify the ARM template for the SIL to meet your specific needs. But your configuration needs to adhere to policies that CSP–CSCF requires. You can use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to apply the necessary policies to comply with CSP–CSCF.

The Alliance Connect Virtual subscription contains resources that you deploy. You deploy them by using an ARM template, also known as the Cloud Infrastructure Definition (CID) file, that's provided by SWIFT. SWIFT manages the configuration and operation of the Juniper vSRX.

You're responsible for establishing enhanced-security connectivity to the SIL. You can use one of these methods:

* Use ExpressRoute to connect on-premises resources to Azure via private connectivity.
* Use site-to-site VPN to connect your premises to Azure via the internet.
* Use Remote Desktop Protocol (RDP) over the internet, if you have internet connectivity. (Alternatively, you can use Azure Bastion for these connections. We recommended Azure Bastion for new SWIFT on Azure customers.)

:::image type="content" alt-text="Diagram that shows three ways to connect to the Azure accounts that support the SWIFT Integration Layer for SWIFT Alliance Cloud." source="./media/swift-alliance-cloud-connectivity.png" lightbox="./media/swift-alliance-cloud-connectivity.png" border="false":::

<!-- _Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-on-azure-connectivity.vsdx) that contains this architecture diagram._ -->

You use one of the three methods of connectivity to connect to the SIL software that runs on the SIL VM. The recommended configurations of Azure Firewall and network security groups allow only appropriate traffic to pass to the SIL VM. 

Alternatively, you can use Azure Bastion to restrict traffic. (The corresponding subnet can be part of the connectivity hub virtual network. As a general guideline, we recommend this option for new SWIFT on Azure customers.) Azure Bastion provides connectivity from the Azure portal to a virtual machine via RDP or SSH. Because Azure Bastion requires administrators to sign in to the Azure portal, you can enforce multifactor authentication. 

You can use Conditional Access to enforce other restrictions. For example, you can restrict the public IP address that administrators can use to sign in. Azure Bastion must be deployed to a dedicated subnet and requires a public IP address. It restricts access to this public IP address by using a managed network security group. Azure Bastion also provides just-in-time access, which opens required ports on demand only when remote access is required. The traffic from the SIL software to SWIFTNet flows via the virtual network peering with the Juniper vSRX. This component has an established VPN tunnel to SWIFTNet over the internet or the dedicated ExpressRoute connection (depending on the Alliance Connect Virtual connectivity option).

### Components

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) provides enhanced-security, seamless RDP and SSH access to VMs. This fully managed service doesn't expose public IP addresses.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into the Microsoft Cloud over a private connection that's facilitated by a connectivity provider. You can use ExpressRoute to establish connections to Microsoft Cloud services like Azure and Office 365.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy) helps you manage policies in a central location. By using this service, you can track compliance status, govern resources, and discover the changes that made a resource non-compliant. You can also enforce policies on your resources and ensure that future configurations are compliant with standards and regulations.
- [Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can communicate with each other, the internet, and on-premises networks, all with enhanced security.
- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure as a service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.

## Scenario details

This approach can be used for:

- Migrating SWIFT connectivity from on-premises to Azure.
- Establishing new SWIFT connectivity by using Azure.

## Considerations 

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following considerations apply to this solution. If you want more detailed information, your account team at Microsoft can help guide your Azure implementation for SWIFT.

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This example scenario provides high availability. Multiple instances of SIL and Alliance Cloud, together with Alliance Connect Virtual, are deployed to support higher availability by providing back-up locations. To increase resiliency and availability, we recommend that you deploy a second similar configuration in a different Azure zone, in the same Azure region. For Alliance Cloud on Azure and Alliance Connect Virtual instances, the systems (SIL VM, HA-VM 1, and VA vSRX) should be deployed in the same Azure zone (for example, AZ1) as shown in the preceding architecture diagram.

To increase resiliency beyond a single Azure region, we recommend that you deploy in multiple Azure regions by using [Azure paired regions](/azure/best-practices-availability-paired-regions). Each Azure region is paired with another region in the same geography. Azure serializes platform updates (planned maintenance) across region pairs so that only one paired region is updated at a time. If an outage affects multiple regions, at least one region in each pair is prioritized for recovery. 

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The traffic between the SIL and the Juniper vSRX is limited to specific and known traffic. To monitor the traffic, you can use network security groups and the packet capture capabilities that are provided by Azure Network Watcher, combined with Azure Security Center and Azure Sentinel. You can use network security group flow logs in Network Watcher to send flow data to Azure Storage accounts. [Azure Sentinel](/azure/sentinel/overview) provides built-in orchestration and automation of common tasks. This functionality can collect the flow logs, detect and investigate threats, and respond to incidents.

[Azure Bastion](/azure/bastion/bastion-overview) provides connectivity transparently from the Azure portal to a virtual machine via RDP or Secure Shell Protocol (SSH). Because Azure Bastion requires administrators to sign in to the Azure portal, you can use Conditional Access to enforce multifactor authentication and other access restrictions. For example, you can specify the public IP address that administrators can use to sign in.

Azure Bastion must be deployed to a dedicated subnet and requires a public IP address. Azure Bastion restricts access to this public IP address by using a managed network security group. Deploying Azure Bastion also enables just-in-time access, which opens required ports on demand, only when remote access is required.

#### Enforce SWIFT CSP–CSCF policies

You can use [Azure Policy](/azure/governance/policy/overview) to set policies that need to be enforced within an Azure subscription to meet compliance or security requirements. For example, you can use Azure Policy to block administrators from deploying certain resources or to enforce network configuration rules that block traffic to the internet. You can use built-in policies or create your own policies.

SWIFT has a policy framework that helps you enforce a subset of SWIFT CSP–CSCF requirements by using Azure policies within your subscription. For simplicity, you can create a separate subscription in which you deploy SWIFT secure zone components and another subscription for other potentially related components. If you use separate subscriptions, you can apply the SWIFT CSP–CSCF Azure policies only to subscriptions that contain a SWIFT secure zone.

We recommend that you deploy SWIFT components in a subscription that's separate from any back-office applications. Using separate subscriptions ensures that SWIFT CSP–CSCF applies only to SWIFT components and not to customer-specific components.

Consider using the latest implementation of SWIFT CSP controls, but first consult with the Microsoft team that you're working with.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

You're responsible for operating the SIL software and the underlying Azure resources in the SIL subscription.

In the Alliance Connect Virtual subscription, SWIFT is responsible for the configuration of Juniper vSRX. SWIFT also operates the VPN between the Juniper vSRX and SWIFTNet. You're responsible for operating and monitoring the underlying infrastructure resources.

Azure provides a comprehensive set of monitoring capabilities in Azure Monitor. These tools monitor the infrastructure that's deployed on Azure. They don't monitor the SWIFT software. You can use a monitoring agent to collect event logs, performance counters, and other logs and send these logs and metrics to Azure Monitor. For more information, see [Azure Monitor Agent overview](/azure/azure-monitor/agents/agents-overview). 

[Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) use data from Azure Monitor to proactively notify you when issues are found with your infrastructure or application. They allow you to identify and address problems before your users notice them. 

You can use [Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview) to edit and run queries against data in Azure Monitor Logs.

#### Segregate environments

SWIFT customer resources on Azure should comply with CSP–CSCF. CSP–CSCF control version 1.1 mandates segregation between different environments, like production, test, and development. We recommend that you deploy each environment in a separate subscription. Using separate subscriptions makes it easier to segregate servers and other infrastructure, credentials, and so on.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Gansu Adhinarayanan](https://www.linkedin.com/in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist 
- [Mahesh Kshirsagar](https://www.linkedin.com/in/mahesh-kshirsagar-msft/?originalSubdomain=uk) | Senior Cloud Solution Architect
- [Ravi Sharma](https://www.linkedin.com/in/ravisharma4sap) | Senior Cloud Solution Architect 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 

- [SWIFT Alliance Cloud](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-cloud)

## Related resources

Explore the functionality and architecture of other SWIFT modules in the following articles: 
* [SWIFT Alliance Connect on Azure](swift-on-azure-srx.yml)
* [SWIFT Alliance Connect Virtual on Azure](swift-on-azure-vsrx.yml)
* [SWIFT Alliance Access with Alliance Connect](swift-alliance-access-on-azure.yml)
* [SWIFT Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml)
* [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect](swift-alliance-messaging-hub.yml)
* [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
* [SWIFT Alliance Lite2 on Azure](swift-alliance-lite2-on-azure.yml)