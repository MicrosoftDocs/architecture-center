#

This article provides an overview of deploying SWIFT's Alliance Lite2 connectivity stack/footprint in Azure. The solution requires two customer Azure subscriptions. One subscription contains the Alliance Lite2 AutoClient resources. The other subscription contains the resources to connect to SWIFT's network.

This approach can be used by customers who

* want to migrate their Alliance Lite2 footprint from on-premises to Azure OR
* want to establish a new connectivity to SWIFT via Alliance Lite2 in Azure

## Potential use cases

This solution is targeted to:

* Existing SWIFT customers running Alliance Lite2 footprint on-premises who want to run Alliance Lite2 footprint (SIL/Directlink/Autoclient) in Azure, including connectivity to SWIFT's network.
* New SWIFT customers can benefit by deploying directly in Azure.

## Architecture

[![Architecture for SWIFT Alliance Lite2](./media/swift-alliance-lite-2.png)](./media/swift-alliance-lite-2.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-lite-2.vsdx) that contains this architecture diagram._

A SWIFT deployment in Azure consists of two Azure customer subscriptions. The two subscription design separates the resources based on the primary responsibility for the resource. The customer is primarily responsible for the Alliance Lite2 AutoClient resources. SWIFT provides the Juniper vSRX as part of the Alliance Connect Virtual managed connectivity service. In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the vSRX to SWIFT. The customer has no access nor visibility into the vSRX configuration or operation, but does have visibility and operational responsibility for the underlying Azure infrastructure resources.

Alliance Lite2 connectivity stack is single tenant solution. For each customer there will be an instance of Lite2 AutoClient and Alliance Connect Virtual. To increase resiliency and availability, it is recommended that customer deploys a second similar configuration in standby mode in a different Azure region.

The Alliance Lite2 AutoClient subscription contains resources managed by the customer. The resources for the Alliance Lite2 AutoClient can be deployed with Resource Manager template to create the core infrastructure as described in this architecture. Customers can modify the Alliance Lite2 AutoClient Resource Manager template to meet their specific needs as long as it adheres to SWIFT's Customer Security Programme Customer Security Controls Framework (CSP-CSCF). Customers are recommended to use the SWIFT CSP-CSCF Azure policies in this subscription.

The SWIFT Alliance Connect Virtual customer subscription contains resources deployed by the customer. The resources are deployed through a Resource Manager template provided by SWIFT, also known as the Cloud Infrastructure Definition (CID) file. SWIFT manages the configuration and operation of the Juniper vSRX.

Once the SWIFT Alliance Connect Virtual and Alliance Lite2 AutoClient infrastructure is deployed, the customer follows SWIFT's instructions for installing the Alliance Lite2 AutoClient software. These instructions include peering the VNETs in both subscriptions.

The SWIFT customer will establish secure connectivity to Alliance Lite2 AutoClient subscription.

* Azure ExpressRoute can be used to connect customer premises to Azure via private connectivity
* Azure Site to Site VPN can be used to connect customer premises to Azure via the Internet
* RDP direct over the Internet can be used to connect customers with Internet connectivity

[![SWIFT Alliance Lite2 Customer Connectivity](./media/swift-alliance-lite-2-customer-connectivity.png)](./media/swift-alliance-lite-2-customer-connectivity.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-lite-2-customer-connectivity.vsdx) that contains this architecture diagram._

The SWIFT customer uses RDP, with one of the three connectivity approaches, to connect to Alliance Lite2 AutoClient software running on the Alliance Lite2 AutoClient VM. The recommended Azure Firewall and Azure Network Security Group are configured to only allow RDP traffic to pass to Alliance Lite2 AutoClient VM. The Alliance Lite2 AutoClient software traffic to SWIFTNet flows via the VNET peer via the Juniper vSRX, which has an established VPN tunnel to SWIFTNet over the Internet.

### Components

The Alliance Lite2 AutoClient subscription has a single resource group, which contains:

* An Azure VNET
* An Azure Subnet for the Azure Firewall, with an Azure Network Security Group
* An Azure Subnet for the Alliance Lite2 AutoClient, with an Azure Network Security Group
* An Azure Firewall configured to allow RDP traffic to Alliance Lite2 AutoClient.
* Azure Policies for SWIFT.

## Considerations

A customer's account team at Microsoft can be engaged to help guide the Azure implementation.

***Segregating different environments***

SWIFT customer resources on Azure should comply with the SWIFT Customer Security Programme Customer Security Controls Framework (CSP-CSCF). CSP-CSCF control 1.1 mandates segregation between different environments (production, test, development). The recommended approach is to deploy each environment in a separate subscription. Separate subscriptions make it easier to segregate servers and other infrastructure, credentials, and so on.

Customers are recommended to deploy different environment in different subscriptions.

### Availability

This example scenario for SWIFT Alliance Lite2 presented does not provide high availability features. Multiple SWIFT Alliance Lite2 AutoClient deployments could be used with the customer redirecting users to a backup location.

### Operations

Customers have responsibility for operating both the Alliance Lite2 AutoClient software and the underlying Azure resources in the Alliance Lite2 AutoClient subscription.

In the SWIFT Alliance Connect Virtual subscription, SWIFT is responsible for the configuration of the Alliance Connect Virtual and network connectivity between the Alliance Connect Virtual and SWIFT. The customer is responsible for operating and monitoring the underlying infrastructure resources.

Azure provides a comprehensive set of monitoring capabilities in Azure Monitor. These tools focus on the infrastructure deployed in Azure. Monitoring the SWIFT software falls outside these tools. You can use a monitoring agent to collect event logs, performance counters, and other logs, and have these logs and metrics sent to Azure Monitor. For more information, see [Overview of the Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).

[Azure Alerts](/azure/azure-monitor/alerts/alerts-overview) proactively notify you when issues are found with your infrastructure or application using your monitoring data in Azure Monitor. They allow you to identify and address issues before the users of your system notice them.

[Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics/overview) allows you to edit run log queries with data in Azure Monitor Logs.

### Security

The traffic between Alliance Lite2 AutoClient and Alliance Connect Virtual is limited to specific and known traffic. NSGs can be used with Azure packet capture capabilities available in Network Watcher, combined with Azure Security Center and Azure Sentinel. Network security group flow logs in Azure Network Watcher can be used to send flow data to Azure Storage accounts. [Azure Sentinel](/services/azure-sentinel/) can collect these logs, detect and investigate threats, and respond to incidents with built-in orchestration and automation of common tasks.

[Azure Bastion](/services/azure-bastion/) enables connectivity transparently from the Azure portal to a virtual machine via RDP or SSH. As Azure Bastion requires administrators to sign in to the Azure portal, Multi-Factor Authentication can be enforced and Conditional Access can be used to enforce other restrictions. For example: from which public IP-address administrators can sign in.

Azure Bastion requires a dedicated subnet to deploy to and requires a public IP-address. Access to this public IP-address is restricted by the Azure Bastion service through a managed Network Security Group. Deploying Azure Bastion also enables Just-In Time Access, which only opens required ports on-demand when remote access is required.

***Enforcing SWIFT CSP-CSCF policies***

[Azure Policy](/services/azure-policy) enables customers to set policies that need to be enforced within (part of) an Azure subscription to meet compliance or security requirements. For example, Azure Policy can be used to block administrators to deploy certain resources or enforce network configuration rules that block traffic to internet. Customers can use built-in policies or create policies themselves.

SWIFT has a policy framework that helps customers enforce a subset of SWIFT CSP-CSCF requirements using Azure policies within a the customer subscription. For simplicity, you can create a separate subscription in which you deploy SWIFT Secure Zone components and another subscription for other (potentially related) components. Separate subscriptions enable you to apply the SWIFT CSP-CSCF Azure policies to subscriptions only containing a SWIFT Secure Zone.

Customers are recommended to deploy SWIFT components in a separate subscription from any back-office applications. Separate subscriptions ensure SWIFT CSP-CSCF only applies to SWIFT components and not to customer-specific components.

Consider using the latest implementation of SWIFT CSP controls in Azure after consulting Microsoft team working with you.

## Next steps

Explore other SWIFT modules functionality and architecture in detail as provided below.

* [SWIFT Alliance Connect in Azure](swift-on-azure-srx.yml)
* [SWIFT Alliance Connect Virtual in Azure](swift-on-azure-vsrx.yml)
* [Alliance Access](swift-alliance-access-vsrx-on-azure.yml)
* [Alliance Access with Alliance Connect Virtual](swift-alliance-access-on-azure.yml)
* [Alliance Messaging Hub (AMH)](swift-alliance-messaging-hub.yml)
* [Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
* [Alliance Cloud](swift-alliance-cloud-on-azure.yml)

## Related resources

* [SWIFT's Alliance Lite2](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-lite2)

<!-- links -->

[calculator]: https://azure.com/e/