This article provides an overview of deploying Alliance Cloud connectivity stack in Azure. The solution requires two Azure subscriptions. One subscription contains the SWIFT Integration Layer (SIL) resources. The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

This approach can be used for:

* Migrating SWIFT connectivity from on-premises to Azure

* Establishing new SWIFT connectivity by using Azure

> [!NOTE]
> This article provides an overview with reference architecture for deploying SWIFT's Alliance Connect Virtual solution on Azure. Please note that the new Alliance Connect Virtual solution is not yet available for SWIFT production traffic. The solution is currently being tested with SWIFT customers and will become generally available throughout 2022 as part of a phased launch. For more information about the general availability of the product, see [SWIFT.com](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-connect-virtual).


## Potential use cases

This solution is targeted to:

* Existing SWIFT customers who run SIL on-premises and want to run Alliance Cloud in Azure.
* New SWIFT customers who can benefit by deploying directly to Azure.

## Architecture

:::image type="content" alt-text="Diagram of the architecture in this example scenario for deploying Azure resources for SWIFT Alliance Cloud." source="./media/swift-alliance-cloud-on-azure-architecture.png" lightbox="./media/swift-alliance-cloud-on-azure-architecture.png":::

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-on-azure.vsdx) that contains this architecture diagram._

### Workflow

In this example scenario, deployment of SWIFT's Alliance Cloud in Azure consists of two Azure subscriptions. The two-subscription design separates resources based on the primary responsibility for each resource. As the customer, you're primarily responsible for supplying the resources for the SWIFT Integration Layer (SIL). SWIFT provides the virtual firewall, Juniper vSRX, as part of the solution for managed connectivity of Alliance Connect Virtual. In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the Juniper vSRX to SWIFT. You have no access nor visibility into the Juniper vSRX configuration or operation, but you do have visibility and operational responsibility for the underlying infrastructure resources on Azure.

The footprint of SWIFT's Alliance Cloud is based on a single tenant. To increase resiliency and availability, each customer deploys a second similar configuration (in standby mode) in a different Azure region. For each customer, there's an instance of the SIL and Alliance Connect Virtual.

The SIL subscription contains resources that are managed by the customer. The resources for the SIL can be deployed by using an Azure Resource Manager template to create the core infrastructure, as described in this architecture. You can modify the template for the SIL to meet your specific needs as long as the configuration adheres to policies that are required by SWIFT's Customer Security Programme (CSP) – Customer Security Controls Framework (CSCF). You can use [Azure Policy](https://azure.microsoft.com/services/azure-policy) to apply the necessary policies to comply with CSP-CSCF.

The Alliance Connect Virtual subscription contains resources that you deploy. You deploy them by using an Azure Resource Manager template, also known as the Cloud Infrastructure Definition (CID) file, that's provided by SWIFT. SWIFT manages the configuration and operation of the Juniper vSRX.

After the SIL infrastructure is deployed, follow SWIFT's instructions for installing the SIL software. These instructions include peering the virtual networks in both subscriptions.

The SIL subscription has a single resource group, which contains:

* An Azure virtual network.
* An Azure subnet for the Azure firewall with an Azure network security group.
* An Azure subnet for the SIL with an Azure network security group
* An Azure firewall configured to allow appropriate traffic to SIL.
* Azure policies for compliance with CSP-CSCF.

You establish secure connectivity to the SIL subscription:

* You can use ExpressRoute to connect on-premises resources to Azure via private connectivity.
* You can use site-to-site VPN to connect customer premises to Azure via the internet.
* You can use Remote Desktop Protocol (RDP) over the Internet to connect customers that have Internet connectivity.

:::image type="content" alt-text="Diagram of connectivity in this example of the Azure accounts that support the SWIFT Integration Layer for SWIFT Alliance Cloud." source="./media/swift-alliance-cloud-on-azure-connectivity.png" lightbox="./media/swift-alliance-cloud-on-azure-connectivity.png":::

<!-- _Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-on-azure-connectivity.vsdx) that contains this architecture diagram._ -->

The SWIFT customer uses RDP, with one of the three connectivity approaches, to connect to the SIL software that runs on the SIL VM. The recommended configurations of Azure Firewall and network security groups allow only appropriate traffic to pass to the SIL VM. The traffic from the SIL software to SWIFTNet flows via the virtual network peering with the Juniper vSRX, which has an established VPN tunnel to SWIFTNet over the Internet.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) provides fast, reliable, and private connections to Azure.

- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) enforces application and network connectivity policies. This network security service centrally manages the policies across multiple virtual networks and subscriptions.

- [Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks.

- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is an infrastructure-as-a-service (IaaS) offering. You can use Virtual Machines to deploy on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.


## Considerations

You can engage your account team at Microsoft to help guide your Azure implementation for SWIFT.

#### Segregating different environments

SWIFT customer resources on Azure should comply with the CSP-CSCF. CSP-CSCF control version 1.1 mandates segregation between different environments (production, test, development). We recommend that you deploy each environment in a separate subscription. Separate subscriptions make it easier to segregate servers and other infrastructure, credentials, and so on.

### Availability

This example scenario for SWIFT's Alliance Cloud and SIL doesn't provide high availability. However, you can deploy multiple instances of SIL and Alliance Cloud to support higher availability by providing back up locations for SWIFT users.

### Operations

Customers have responsibility for operating both the SIL software and the underlying Azure resources in the SIL subscription.

In the Alliance Connect Virtual subscription, SWIFT is responsible for the configuration of the Juniper vSRX and the operation of the VPN between the vSRX and SWIFTNet. The customer is responsible for operating and monitoring the underlying infrastructure resources.

Azure provides a comprehensive set of monitoring capabilities in Azure Monitor. These tools focus on the infrastructure deployed in Azure. Monitoring the SWIFT software falls outside these tools. You can use a monitoring agent to collect event logs, performance counters, and other logs, and have these logs and metrics sent to Azure Monitor. For more information, see [Overview of the Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).

[Azure Alerts](/azure/azure-monitor/alerts/alerts-overview) proactively notify you when issues are found with your infrastructure or application using your monitoring data in Azure Monitor. They allow you to identify and address issues before the users of your system notice them.

[Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview) allows you to edit run log queries with data in Azure Monitor Logs.

### Security

The traffic between the SIL and the Juniper vSRX is limited to specific and known traffic. You can use network security groups and the packet capture capabilities that are provided by  Network Watcher, and combined with Azure Security Center and Azure Sentinel. Network security group flow logs in Azure Network Watcher can be used to send flow data to Azure Storage accounts. [Azure Sentinel](/azure/sentinel/overview) can collect these logs, detect and investigate threats, and respond to incidents with built-in orchestration and automation of common tasks.

[Azure Bastion](/azure/bastion/bastion-overview) enables connectivity transparently from the Azure portal to a virtual machine via RDP or SSH. Because Azure Bastion requires administrators to sign in to the Azure portal, you can use Conditional Access to enforce multi-factor authentication and other access restrictions. For example, you can specify from the public IP address from which administrators can sign in.

Azure Bastion requires a dedicated subnet to deploy to and requires a public IP address. Access to this public IP address is restricted by Azure Bastion through a network security group that's managed. Deploying Azure Bastion also enables just-in-time access, which only opens required ports on demand when remote access is required.

#### Enforcing SWIFT CSP-CSCF policies

[Azure Policy](/services/azure-policy) enables customers to set policies that need to be enforced within (part of) an Azure subscription to meet compliance or security requirements. For example, Azure Policy can be used to block administrators to deploy certain resources or enforce network configuration rules that block traffic to internet. Customers can use built-in policies or create policies themselves.

SWIFT has a policy framework that helps you enforce a subset of SWIFT CSP-CSCF requirements by using Azure policies within your subscription. For simplicity, you can create a separate subscription in which you deploy SWIFT Secure Zone components and another subscription for other (potentially related) components. Separate subscriptions enable you to apply the SWIFT CSP-CSCF Azure policies to subscriptions only containing a SWIFT Secure Zone.

We recommend deploying SWIFT components in a subscription that's separate from any back-office applications. Separate subscriptions ensure that SWIFT CSP-CSCF only applies to SWIFT components and not to customer-specific components.

Consider using the latest implementation of SWIFT CSP controls in Azure after consulting with the Microsoft team that's working with you.

## Pricing

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator), which preconfigures all Azure services.

## Next steps

Explore the functionality and architecture of other SWIFT modules in the following articles:

<!-- * [SWIFT Alliance Connect in Azure](swift-on-azure-srx.yml) -->
<!-- * [SWIFT Alliance Connect Virtual in Azure](swift-on-azure-vsrx.yml) -->
* [Alliance Access](swift-alliance-access-vsrx-on-azure.yml)
* [Alliance Access with Alliance Connect Virtual](swift-alliance-access-on-azure.yml)
* [Alliance Messaging Hub (AMH)](swift-alliance-messaging-hub.yml)
* [Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
<!-- * [Alliance Lite2](swift-alliance-lite-2-on-azure.yml) -->

## Related resources

* [SWIFT's Alliance Cloud](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-cloud)

<!-- links -->
