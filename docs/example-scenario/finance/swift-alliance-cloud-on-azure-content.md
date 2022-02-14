This article provides an overview of deploying Alliance Cloud connectivity stack in Azure. The solution requires two customer Azure subscriptions. One subscription contains the SIL (SWIFT Integration Layer) resources. The other subscription contains the resources to connect to SWIFT's network via Alliance Connect Virtual.

This approach can be used for:

* Migrating SWIFT connectivity from on-premises to Azure

* Establishing new SWIFT connectivity using Azure

## Potential use cases

This solution is targeted to:

* Existing SWIFT customers running SIL (SWIFT Integration Layer) on-premises who want to run Alliance Cloud footprint in Azure.
* New SWIFT customers can benefit by deploying directly to Azure.

## Architecture

[![Architecture for SWIFT Alliance Cloud](./media/swift-alliance-cloud.png)](./media/swift-alliance-cloud.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud.vsdx) that contains this architecture diagram._

A SWIFT deployment in Azure consists of two Azure customer subscriptions. The two subscription design separates the resources based on the primary responsibility for the resource. The customer is primarily responsible for the SWIFT Integration Layer (SIL) resources. SWIFT provides the Juniper vSRX as part of the Alliance Connect Virtual managed connectivity solution. In this context, SWIFT configures the Juniper vSRX and establishes the VPN tunnel from the vSRX to SWIFT. The customer has no access nor visibility into the vSRX configuration or operation, but does have visibility and operational responsibility for the underlying Azure infrastructure resources.

SWIFT's Alliance Cloud footprint is single tenant based. To increase resiliency and availability, it is recommended that each customer deploys a second similar configuration (in standby mode) in a different Azure region. For each customer there will be an instance of the SWIFT Integration Layer and Alliance Connect Virtual.

The SIL subscription contains resources managed by the customer. The resources for the SIL can be deployed with Resource Manager template to create the core infrastructure as described in this architecture. Customers can modify the SIL Resource Manager template to meet their specific needs as long as it adheres to SWIFT's Customer Security Programme Customer Security Controls Framework (CSP-CSCF). Customers are recommended to use the SWIFT CSP-CSCF Azure policies in this subscription.

The Alliance Connect Virtual subscription contains resources deployed by the customer. The resources are deployed through a Resource Manager template provided by SWIFT, also known as the Cloud Infrastructure Definition (CID) file. SWIFT manages the configuration and operation of the Juniper vSRX.

Once the SIL infrastructure is deployed, the customer follows SWIFT's instructions for installing the SIL software. These instructions include peering the VNETs in both subscriptions.

The SWIFT customer will establish secure connectivity to SIL subscription.

* ExpressRoute can be used to connect customer premises to Azure via private connectivity
* Site-to-site VPN can be used to connect customer premises to Azure via the Internet
* RDP over the Internet can be used to connect customers with Internet connectivity

[![SWIFT Alliance Cloud Customer Connectivity](./media/swift-alliance-cloud-customer-connectivity.png)](./media/swift-alliance-cloud-customer-connectivity.png#lightbox)

_Download a [Visio file](https://arch-center.azureedge.net/swift-alliance-cloud-customer-connectivity.vsdx) that contains this architecture diagram._

The SWIFT customer uses RDP, with one of the three connectivity approaches, to connect to the SIL software running on the SIL VM. The recommended Azure Firewall and Azure Network Security Group are configured to only allow appropriate traffic to pass to the SIL VM. The SIL software traffic to SWIFTNet flows via the VNET peering with the Juniper vSRX, which has an established VPN tunnel to SWIFTNet over the Internet.

### Components

The SIL subscription has a single resource group, which contains:

* An Azure Resource Group contains all the resources that follow
* An Azure VNET
* An Azure Subnet for the Azure Firewall, with an Azure Network Security Group
* An Azure Subnet for the SIL, with an Azure Network Security Group
* An Azure Firewall configured to allow appropriate traffic to SIL.
* Azure Policies for SWIFT.

## Considerations

A customer's account team at Microsoft can be engaged to help guide the Azure implementation.

***Segregating different environments***

SWIFT customer resources on Azure should comply with the SWIFT Customer Security Programme Customer Security Controls Framework (CSP-CSCF). CSP-CSCF control 1.1 mandates segregation between different environments (production, test, development). The recommended approach is to deploy each environment in a separate subscription. Separate subscriptions make it easier to segregate servers and other infrastructure, credentials, and so on.

Customers are recommended to deploy different environment in different subscriptions.

### Availability

This example scenario for SWIFT's Alliance Cloud footprint / SIL presented does not provide high availability features. Multiple SIL / Alliance Cloud footprint  deployments could be used with the customer redirecting users to a backup location.

### Operations

Customers have responsibility for operating both the SIL software and the underlying Azure resources in the SIL subscription.

In the SWIFT Alliance Connect Virtual subscription, SWIFT is responsible for the configuration of the vSRX and the operation of the VPN between the vSRX and SWIFTNet. The customer is responsible for operating and monitoring the underlying infrastructure resources.

Azure provides a comprehensive set of monitoring capabilities in Azure Monitor. These tools focus on the infrastructure deployed in Azure. Monitoring the SWIFT software falls outside these tools. You can use a monitoring agent to collect event logs, performance counters, and other logs, and have these logs and metrics sent to Azure Monitor. For more information, see [Overview of the Azure monitoring agents](/azure/azure-monitor/platform/agents-overview).

[Azure Alerts](/azure/azure-monitor/alerts/alerts-overview) proactively notify you when issues are found with your infrastructure or application using your monitoring data in Azure Monitor. They allow you to identify and address issues before the users of your system notice them.

[Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics/overview) allows you to edit run log queries with data in Azure Monitor Logs.

### Security

The traffic between the SIL and vSRX is limited to specific and known traffic. NSGs can be used with Azure packet capture capabilities available in Network Watcher, combined with Azure Security Center and Azure Sentinel. Network security group flow logs in Azure Network Watcher can be used to send flow data to Azure Storage accounts. [Azure Sentinel](/services/azure-sentinel/) can collect these logs, detect and investigate threats, and respond to incidents with built-in orchestration and automation of common tasks.

[Azure Bastion](/services/azure-bastion/) enables connectivity transparently from the Azure portal to a virtual machine via RDP or SSH. As Azure Bastion requires administrators to sign in to the Azure portal, Multi-Factor Authentication can be enforced and Conditional Access can be used to enforce other restrictions. For example: from which public IP-address administrators can sign in.

Azure Bastion requires a dedicated subnet to deploy to and requires a public IP-address. Access to this public IP-address is restricted by the Azure Bastion service through a managed Network Security Group. Deploying Azure Bastion also enables Just-In Time Access, which only opens required ports on-demand when remote access is required.

***Enforcing SWIFT CSP-CSCF policies***

[Azure Policy](/services/azure-policy) enables customers to set policies that need to be enforced within (part of) an Azure subscription to meet compliance or security requirements. For example, Azure Policy can be used to block administrators to deploy certain resources or enforce network configuration rules that block traffic to internet. Customers can use built-in policies or create policies themselves.

SWIFT has a policy framework that helps customers enforce a subset of SWIFT CSP-CSCF requirements using Azure policies within a the customer subscription. For simplicity, you can create a separate subscription in which you deploy SWIFT Secure Zone components and another subscription for other (potentially related) components. Separate subscriptions enable you to apply the SWIFT CSP-CSCF Azure policies to subscriptions only containing a SWIFT Secure Zone.

Customers are recommended to deploy SWIFT components in a separate subscription from any back-office applications. Separate subscriptions ensure SWIFT CSP-CSCF only applies to SWIFT components and not to customer-specific components.

* [Overview of the SWIFT CSP-CSCF v2020 blueprint sample](/azure/governance/blueprints/samples/swift-2020/)

## Next steps

Explore other SWIFT modules functionality and architecture in detail as provided below.

* [SWIFT Alliance Connect in Azure](swift-on-azure-srx.yml)
* [SWIFT Alliance Connect Virtual in Azure](swift-on-azure-vsrx.yml)
* [Alliance Access](swift-alliance-access-vsrx-on-azure.yml)
* [Alliance Access with Alliance Connect Virtual](swift-alliance-access-on-azure.yml)
* [Alliance Messaging Hub (AMH)](swift-alliance-messaging-hub.yml)
* [Alliance Messaging Hub (AMH) with Alliance Connect Virtual](swift-alliance-messaging-hub-vsrx.yml)
* [Alliance Lite2](swift-alliance-lite-2-on-azure.yml)

## Related resources

* [SWIFT's Alliance Cloud](https://www.swift.com/our-solutions/interfaces-and-integration/alliance-cloud)

<!-- links -->

[calculator]: https://azure.com/e/