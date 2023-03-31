> [!NOTE]
> For updates on SWIFT product availability in the cloud, see the [SWIFT website](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).

This article provides an overview of deploying SWIFT's Alliance Lite2 connectivity stack on Azure. You can deploy the solution in a single Azure subscription. For better management and governance of the solution, however, we recommend that you use two subscriptions: 
- One subscription contains the Alliance Lite2 AutoClient resources. 
- The other subscription contains the Alliance Connect Virtual resources to connect to SWIFT's network.

## Architecture

:::image type="content" source="media/diagrams-swift-alliance-lite2-azure.png" alt-text="Diagram that shows an architecture for SWIFT Alliance Lite2." lightbox="media/diagrams-swift-alliance-lite2-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-vSRX-GA-allModules.vsdx) of this architecture. See the **Lite2 (All-GoldSilverBronze)** tab.*

### Workflow

In this example scenario, SWIFT Alliance Lite2 is deployed into two Azure subscriptions. The two-subscription design separates resources based on the primary responsibility for each resource:

- You're primarily responsible for supplying the resources for the Alliance Lite2 AutoClient in one Azure subscription.

- In a second Azure subscription, SWIFT provides the virtual firewall, Juniper vSRX. This component is part of the solution for managed connectivity of Alliance Connect Virtual.

In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the Juniper vSRX to SWIFT.

The connection between SWIFTNet and these customer-specific networking components can use the dedicated Azure ExpressRoute connection or the internet. For information about SWIFT connectivity options, see [Two-subscription design](#two-subscription-design) in this article.

The two-subscription design separates the resources based on who's responsible for them. For more information, see [Two-subscription design](#two-subscription-design) and [Operational excellence](#operational-excellence) in this article.

The Lite2 AutoClient subscription has a single resource group. It contains:

- An Azure virtual network.
- An Azure subnet for the Azure firewall, with an Azure network security group.
- An Azure subnet for Alliance Lite2 AutoClient, with an Azure network security group.
- An Azure subnet for the additional virtual machines (depicted by HA-VM 1 and HA-VM 2 in the architecture diagram) for high availability monitoring and routing.
- A configuration of Azure Firewall that allows appropriate traffic to Alliance Lite2 AutoClient.
- Azure policies for SWIFT.
- Azure policies for compliance with SWIFT's Customer Security Programme (CSP) – Customer Security Controls Framework (CSCF).

You're responsible for establishing enhanced-security connectivity to the Alliance Lite2 AutoClient subscription. You can use one of these methods:

- Use ExpressRoute to connect your premises to Azure via private connectivity.
- Use Azure site-to-site VPN to connect your premises to Azure via the internet.
- Use direct RDP over the internet for internet connectivity. (You can alternatively use Azure Bastion for these connections. We recommend Azure Bastion for new SWIFT on Azure customers.)

:::image type="content" source="media/lite2-access-secure-zone.png" alt-text="Diagram that shows SWIFT Alliance Lite2 connectivity." lightbox="media/lite2-access-secure-zone.png" border="false":::


You use RDP, with one of the preceding three connectivity approaches, to connect to Alliance Lite2 AutoClient software running on the Lite2 AutoClient VM. You also configure the recommended Azure firewall and Azure network security group to allow only RDP traffic to pass to the Lite2 AutoClient VM. 

Alternatively, you can use Azure Bastion to restrict traffic. (The corresponding subnet can be part of the connectivity hub virtual network. As a general guideline, we recommend this option for new SWIFT on Azure customers.) For more information, see the [Security](#security) section of this article. 

Traffic from Lite2 AutoClient to SWIFTNet flows through the virtual network peer via Juniper vSRX. This component has an established VPN tunnel to SWIFTNet over the internet or the dedicated ExpressRoute connection (depending upon the Alliance Connect Virtual Connectivity option).

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

The following considerations apply to this solution. If you want more detailed information, your account team at Microsoft can help guide your Azure implementation of SWIFT.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Two-subscription design

The two-subscription design separates the resources based on who's responsible for them. You're primarily responsible for the Alliance Lite2 AutoClient resources. SWIFT provides Juniper vSRX as part of Alliance Connect Virtual, a managed connectivity service. In this context, SWIFT configures Juniper vSRX and establishes the VPN tunnel from the vSRX to SWIFT. You don't have access or visibility into the vSRX configuration or operation. You do have visibility into and operational responsibility for the underlying Azure infrastructure resources. For more information, see [Deploy this scenario](#deploy-this-scenario) in this article. In some special cases, you can deploy these resources into two separate resource groups in a single subscription.

High availability is enabled because the vSRX components depicted in the preceding diagram are deployed redundantly in two Azure availability zones. Additionally, HA-VM 1 and HA-VM 2 monitor and maintain the route tables to provide higher resiliency and improve the availability of the solution. The connection between SWIFTNet and these customer-specific networking components can use the dedicated ExpressRoute connection or the internet. SWIFT offers three connectivity options: Bronze, Silver, and Gold. You can choose the option that's best suited to message-traffic volumes and the required level of resiliency.  For more information about these options, see [Alliance Connect: Bronze, Silver and Gold packages](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect/alliance-connect-bronze-silver-and-gold-packages).

The Alliance Lite2 connectivity stack is a single-tenant solution. For each SWIFT customer, there's an instance of Alliance Lite2 AutoClient and Alliance Connect Virtual. To increase resiliency and availability, we recommend that you deploy a second similar configuration in a different Azure zone, in the same Azure region. For Alliance Lite2 AutoClient and Alliance Connect Virtual instances, the systems (AutoClient VM, HA-VM 1, and VA vSRX) should be deployed in the same Azure zone (for example, AZ1) as shown in the preceding architecture diagram.

To increase resiliency beyond a single Azure region, we recommend that you deploy in multiple Azure regions by using [Azure paired regions](/azure/reliability/cross-region-replication-azure). Each Azure region is paired with another region in the same geography. Azure serializes platform updates (planned maintenance) across region pairs so that only one paired region is updated at a time. If an outage affects multiple regions, at least one region in each pair is prioritized for recovery.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The traffic between Alliance Lite2 AutoClient and Alliance Connect Virtual is limited to specific and known traffic. To monitor the traffic, you can use network security groups and the packet capture capabilities that are available in Azure Network Watcher, combined with Microsoft Defender for Cloud and [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel). You can use Network Watcher to send the flow logs from the network security group to Azure Storage accounts. Doing so allows Microsoft Sentinel to collect the logs, detect and investigate threats, and respond to incidents with built-in orchestration and automation of common tasks. 

[Azure Bastion](https://azure.microsoft.com/products/azure-bastion) provides connectivity from the Azure portal to a virtual machine via RDP or SSH. Because Azure Bastion requires administrators to sign in to the Azure portal, you can enforce multifactor authentication. You can use Conditional Access to enforce other restrictions. For example, you can restrict the public IP address that administrators can use to sign in.

Azure Bastion must be deployed to a dedicated subnet and requires a public IP address. It restricts access to this public IP address by using a managed network security group. Azure Bastion also provides just-in-time access, which opens required ports on demand only when remote access is required.

#### Segregate environments

SWIFT customer resources on Azure should comply with SWIFT CSP-CSCF. CSP-CSCF control 1.1 requires segregation of environments (production, test, development). We recommend that you deploy each environment in a separate subscription. Doing so makes it easier to segregate servers and other infrastructure, credentials, and so on.

#### Enforce SWIFT CSP-CSCF policies

You can use [Azure Policy](https://azure.microsoft.com/products/azure-policy) to set policies that need to be enforced within an Azure subscription to meet compliance or security requirements. For example, you can use Azure Policy to block administrators from deploying certain resources or to enforce network configuration rules that block traffic to the internet. You can use built-in policies or create your own policies.

SWIFT has a policy framework that can help you enforce a subset of SWIFT CSP-CSCF requirements by using Azure policies in your subscription. For simplicity, you can create one subscription in which you deploy SWIFT secure zone components and another subscription for other potentially related components. If you use separate subscriptions, you can apply the SWIFT CSP-CSCF Azure policies only to subscriptions that contain a SWIFT secure zone.

We recommend that you deploy SWIFT components in a subscription that doesn't contain any back-office applications. Separate subscriptions ensure that SWIFT CSP-CSCF applies only to SWIFT components and not to your own components.

Consider using the latest implementation of SWIFT CSP controls, but first consult with the Microsoft team that you're working with.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

You're responsible for operating the Alliance Lite2 AutoClient software and the underlying Azure resources in the Alliance Lite2 AutoClient subscription.

In the SWIFT Alliance Connect Virtual subscription, SWIFT is responsible for configuration of Alliance Connect Virtual and network connectivity between Alliance Connect Virtual and SWIFT. You're responsible for operating and monitoring the underlying infrastructure resources.

Azure provides a comprehensive set of monitoring capabilities in Azure Monitor. These tools monitor the infrastructure that's deployed on Azure. They don't monitor the SWIFT software. You can use a monitoring agent to collect event logs, performance counters, and other logs and send these logs and metrics to Azure Monitor. For more information, see [Azure Monitor Agent overview](/azure/azure-monitor/agents/agents-overview). 

[Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) use your data in Azure Monitor to notify you when problems are found with your infrastructure or application. They allow you to identify and address problems before your users notice them. 

You can use [Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview) to edit and run log queries against data in Azure Monitor Logs.

## Deploy this scenario

The Lite2 AutoClient subscription contains resources that you manage. You can deploy the resources for the Alliance Lite2 AutoClient by using an Azure Resource Manager template (ARM template) to create the core infrastructure, as described in this architecture. You can modify the template to meet your needs as long as it adheres to SWIFT's CSP-CSCF. We recommend that you use the SWIFT CSP-CSCF Azure policies in this subscription.

The SWIFT Alliance Connect Virtual subscription contains resources that you deploy. You can deploy the resources by using an ARM template that's provided by SWIFT. It's known as the Cloud Infrastructure Definition (CID) file. SWIFT manages the configuration and operation of the Juniper vSRX.

After the SWIFT Alliance Connect Virtual and Alliance Lite2 AutoClient infrastructure is deployed, follow SWIFT's instructions for installing the Alliance Lite2 AutoClient software. These instructions include peering the virtual networks in both subscriptions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Gansu Adhinarayanan](https://www.linkedin.com/in/ganapathi-gansu-adhinarayanan-a328b121) | Director - Partner Technology Strategist 
- [Ethan Haslett](https://www.linkedin.com/in/ethan-haslett-1502841) | Senior Cloud Solution Architect
- [Ravi Sharma](https://www.linkedin.com/in/ravisharma4sap) | Senior Cloud Solution Architect 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 

- [SWIFT Alliance Lite2](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-lite2) 
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview) 
- [What is Azure Firewall?](/azure/firewall/overview) 
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)

## Related resources 

- [SWIFT Alliance Connect on Azure](swift-on-azure-srx.yml)
- [SWIFT Alliance Connect Virtual on Azure](swift-on-azure-vsrx.yml) 
- [SWIFT Alliance Access with Alliance Connect](swift-alliance-access-on-azure.yml) 
- [SWIFT Alliance Access with Alliance Connect Virtual](swift-alliance-access-vsrx-on-azure.yml) 
- [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect](swift-alliance-messaging-hub.yml) 
- [SWIFT Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml) 
- [SWIFT Alliance Cloud on Azure](swift-alliance-cloud-on-azure.yml)