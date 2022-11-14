---
title: Network secure ingress pattern implementation with Azure Front Door Premium tier
description: The network secure ingress pattern implementation illustrates global routing, low latency failover for unhealthy workloads, and mitigating attacks at the edge.
author: robbagby
ms.author: robbag
ms.date: 10/18/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
- azure-front-door
- azure-bastion
- azure-virtual-network
- azure-web-application-firewall
categories:
- azure
azure.category:
- networking
- web
---

# Network secure ingress implementation

Network secure ingress encapsulates several design patterns, including the global routing, global offloading, and health endpoint monitoring patterns. This pattern implementation can be used as a gateway for any HTTP(S) workload that requires high availability or reliability by providing secure global routing to workloads in differing regions with low latency failover.

> [!IMPORTANT]
> The [Network Secure Ingress Sample](https://aka.ms/networksecureingresssample) provides a sample that allows you to deploy the solution described in this article.

## Video: Network secure ingress implementation

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=163c161c-0f7e-4fea-b126-c8f540fc84e0&embedUrl=/azure/architecture/pattern-implementations/network-secure-ingress]

## Pattern requirements

This article focuses on three requirements that the network secure ingress pattern implementation focuses on: global routing, low latency failover, and mitigating attacks at the edge.

### Global routing

The network secure ingress pattern encapsulates the global routing pattern. As such, the implementation is able to route requests to workloads in different regions.

:::image type="content" source="_images/secure-ingress-use-case-one.png" alt-text="Diagram showing an HTTPS request being routed to two workloads in different regions.":::
<br/>*Figure 1: Global routing*

### Low latency failover

The implementation must be able to identify healthy and unhealthy workloads and adjust the routing accordingly in a time sensitive manner. The latency should be able to support adjusting the routing in a manner of minutes.

:::image type="content" source="_images/secure-ingress-use-case-two.png" alt-text="Diagram showing an HTTPS request not being routed to an unhealthy workload.":::
<br/>*Figure 2: Low latency failover*

### Mitigating attacks at the edge

Mitigating the attacks at the edge necessitates the "network secure" part of the implementation. The workloads or PaaS services shouldn't be accessible via the internet. Internet traffic should only be able to route through the gateway. The gateway should have the ability to mitigate exploits.

:::image type="content" source="_images/secure-ingress-use-case-three.png" alt-text="Diagram showing an HTTPS request with a SQL statement in the querystring of a request not being stopped at the edge.":::
<br/>*Figure 3: Mitigating attacks at the edge*

## Patterns

This solution implements the following design patterns.

- [Gateway routing pattern](/azure/architecture/patterns/gateway-routing) - route requests to multiple services or service instances that can reside in different regions.
- [Gateway offloading pattern](/azure/architecture/patterns/gateway-offloading) - offloads functionality, such as mitigating against attacks, to a gateway proxy.
- [Health endpoint monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring) - workloads expose endpoints that validate the health of the workload.

## Design

:::image type="complex" source="_images/network-diagram-ingress.png" alt-text="Diagram showing a request flowing through Azure Front Door (AFD) Premium to regional stamps.":::
The diagram shows an HTTPS request flowing to an Azure Front Door Premium box, which has Web Application Firewall (WAF) in it. This illustrates the integration between Azure Front Door Premium and WAF. The diagram then shows the request flowing through Private Link to two different stamps in different regions. Each stamp has a static web site and an internal load balancer. The requests flow through private link to the static web sites and the load balancers in both stamps.
:::image-end:::
*Figure 4: Azure Front Door Premium design*

This following are details about this implementation:

- Azure Blob Storage Accounts are used to simulate static web workloads running in two regions. This implementation doesn't implement any workloads running behind an internal load balancer (ILB). The ILB is shown in the diagram to illustrate that this implementation would work for private workloads running behind an ILB.
- Azure Front Door Premium tier is used as the global gateway.
- The Front Door instance has a global Web Application Firewall (WAF) policy configured with Managed Rules that protect against common exploits.
- The Storage Accounts aren't exposed over the internet.
- Azure Front Door Premium tier accesses the Storage Accounts via Azure Private Link.
- The Front Door instance has the following high-level configuration:
  - An endpoint with a single route pointing to a single origin group. An origin group is a collection of origins or back ends.
  - The origin group has an origin configured that points to each Storage Account.
  - Each origin is requesting Private Link access to the Storage Account.
  - The origin group has health probes configured to access an HTML page in the Storage Accounts. The HTML page is acting as the health endpoint for the static workloads. If the probes are able to successfully access the origin three out of the last four attempts, the origin is deemed healthy.
  
## Components

### Web request

- [Web Application Firewall (WAF)](/azure/web-application-firewall/overview) - Web Application Firewall protects web applications from exploits. The premium tier supports managed rules which Microsoft manages that protect against common exploits.
- [Azure Private Link](/azure/private-link/private-link-overview) - Private endpoints in Azure Private Link expose an Azure PaaS service to a private IP address in a virtual network. This allows the communication to flow across the Microsoft Backbone network and not on the public internet.
- [Azure Front Door Premium tier](/azure/frontdoor/front-door-overview) - Azure Front Door provides layer 7 global load balancing. Azure Front Door has integration with WAF. The premium tier supports:
  - [Azure Private Link support in Azure Front Door](/azure/frontdoor/private-link) - Private Link support allows Azure Front Door to communicate with PaaS services or workloads running in a private Virtual Network over the Microsoft Backbone network.
  - [Microsoft managed rule set support](/azure/frontdoor/standard-premium/tier-comparison) - The premium tier of Azure Front Door supports the premium tier of Web Application Firewall, which supports the managed rule set in WAF.
- [Azure Storage Account](/azure/storage/common/storage-account-overview) - Blob Storage Accounts are used in this implementation to represent a static website or workload.
- [Internal Load Balancer](/azure/load-balancer/load-balancer-overview) - While pictured, the internal load balancer isn't used in this implementation. It's pictured to represent a private workload running behind that load balancer. The routing to the Storage Account will be the same as it would to load balancers.

### Operations

Securing resources from a network perspective protects against exploits, but also isolates the resources from processes or administrators who might need to access those resources. For example, a build agent in a DevOps pipeline might need to access the Storage Account in order to deploy an update to the web application. Also, an administrator might need to access the resource for troubleshooting purposes.

To illustrate providing access to network secure access for operational purposes, this implementation deploys a virtual machine in a virtual network that has Private Link access to the Storage Accounts. This implementation deploys Azure Bastion that the administrator can use to connect to the virtual machine. For the deployment scenario, a private build agent could be deployed to virtual network similar to how the virtual machine was.

- [Azure Virtual Network (VNet)](/azure/virtual-network/virtual-networks-overview) - The virtual network in this implementation is used to contain the components required for an administrator to securely communicate with the Storage Account over the private Microsoft Backbone network.
- [Azure Virtual Machine (VM)](/azure/virtual-machines/overview) - This VM is used as a jumpbox for administrators to connect to. The VM is deployed in the private VNet.
- [Azure Bastion](/azure/bastion/bastion-overview) - Azure Bastion allows the administrator to securely connect to the jumpbox VM over SSH without requiring the VM to have a public IP address.
- [Private Link Endpoint](/azure/private-link/private-endpoint-overview) - The private endpoint is assigned a private IP address from the VNet and connects to the Storage Account PaaS service. This allows resources in the private VNet to communicate to the Storage Account over the private IP address.
- [Private DNS Zone](/azure/dns/private-dns-privatednszone) - The Private DNS zone is a DNS service that is used to resolve the Azure Storage Account private link hostname to the private endpoint private IP address.

## Web request flow

:::image type="complex" source="_images/network-diagram-ingress-user-flow.png" alt-text="Diagram showing the flow for a web request.":::
   The diagram shows a user making a web request to Azure Front Door. In the AFD box, the diagram shows each of the steps of the AFD routing flow. Highlighted in the flow is the step where WAF rules are evaluated, where the AFD route is matched and an origin group is selected and where the origin is selected from the origin group. The last highlighted piece is where AFD connects to the Azure Storage Blob account via Private Link.
:::image-end:::
*Figure 5: The design of the request routing flow*

1. The user issues an HTTP(S) request to an Azure Front Door endpoint.
2. The WAF rules are evaluated. Rules that match are always logged. If the Front Door WAF policy mode is set to prevention and the matching rule has an action set to 'block on anomaly', the request is blocked. Otherwise the request continues, is redirected, or the subsequent rules are evaluated.
3. The route configured in Azure Front Door is matched and the correct origin group is selected. In this example, the path was to the static content in the web site.
4. The origin is selected from the origin group.
<br />&nbsp;4a. In this example, the web site was deemed unhealthy by the health probes, so it was eliminated from the possible origins.  
&nbsp;4b. This web site was selected.
5. The request is routed to the Azure Storage Account via private link over the Microsoft backbone network.

For more information about the Azure Front Door routing architecture, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture?pivots=front-door-standard-premium).

## Operational flow

:::image type="complex" source="_images/network-diagram-ingress-with-vnet.png" alt-text="Diagram showing the flow an administrator would use to connect to a protected resource.":::
   The diagram has three parts. The first part shows Azure Blob Storage acting as a static web site. Azure Front Door is pictured connecting through private link to the storage account. The second part is a box that represents a Virtual Network (VNet). The VNet has the following subnets and their contents: 1) a private endpoint subnet that contains a private link endpoint with an IP of 10.0.2.5, 2) A jumpbox subnet with a jumpbox virtual machine, and 3) An Azure Bastion Subnet with Azure Bastion in it. The third part is an administrative user that is SSHing into to the Jumpbox VM  in the VNet via Azure Bastion. There is then an arrow from the VM to the Private DNS Zone. The last arrow is from the VM to the Private link endpoint and then to the Storage Account.
:::image-end:::
*Figure 6: The design of the administrator flow*

1. An administrator connects to Azure Bastion that is deployed in the Virtual Network.
2. Azure Bastion provides SSH connectivity to the jumpbox virtual machine.
3. The administrator on the jumpbox tries to access the storage account via the Azure CLI. The jumpbox queries DNS for the public Azure Blob Storage Account endpoint: storageaccountname.blob.core.windows.net. Private DNS ultimately resolves to storageaccountname.privatelink.blob.core.windows.net, returning the private IP address of the private link endpoint, which is 10.0.2.5 in this example.
4. A private connection to the storage account is established through the private link endpoint.

## Considerations

Keep these points in mind when you use this solution.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This scenario addresses the following key points regarding reliability:

- Global routing with low latency, through the use of health probes, enables reliability by insulating the application against regional outages.
- [Web Application Firewall (WAF) on Azure Front Door](/azure/frontdoor/web-application-firewall) provides centralized protection for HTTP(S) requests.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario addresses the following key points regarding security:

- [Azure Front Door Premium Private Link support](/azure/frontdoor/private-link) eliminates the need to expose your internal or PaaS services over the internet. Private Link allows Azure Front Door to communicate to your private services or PaaS services over the Microsoft backbone network.
- [Web Application Firewall (WAF) on Azure Front Door](/azure/frontdoor/web-application-firewall) provides centralized protection for HTTP(S) requests. 
- [Managed rules in Web Application Firewall Premium](/azure/web-application-firewall/afds/waf-front-door-drs) are Microsoft managed rules that protect you against a common set of security threats.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

While both Azure Front Door Premium and Web Application Firewall Premium provide advanced security features over the standard tier, there's additional cost to both. Review the following resources to learn more about pricing for Azure Front Door and Web Application Firewall:

- [Azure Front Door pricing](https://azure.microsoft.com/pricing/details/frontdoor/)
- [Web Application Firewall pricing](https://azure.microsoft.com/pricing/details/web-application-firewall/)
- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator)

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Implementing network security boundaries adds complexity regarding operations and deployment.

- The [IP ranges for Microsoft-hosted agents vary over time](/azure/devops/pipelines/agents/hosted?tabs=yaml#networking). You should consider implementing self-hosted agents in your virtual network.
- Implement [Azure Bastion](/azure/bastion/bastion-overview) for scenarios where operations teams need to access network secured resources.
- The use of [Web Application Firewall (WAF) on Azure Front Door](/azure/frontdoor/web-application-firewall) provides centralized protection for HTTP(S) requests is an example of the gateway offloading pattern. The responsibility of examining requests for exploits was offloaded to WAF in Azure Front Door. The benefit from an operational excellence perspective is that there is only one place where the rules need to be managed.

> [!IMPORTANT]
> The [Network Secure Ingress Sample](https://aka.ms/networksecureingresssample) provides a sample that allows you to deploy all of the resources required for you to connect to a jumpbox through Azure Bastion and connect to a network secured virtual machine.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Global routing enables horizontal scaling through the deployment of additional resources in the same or different regions.

## Deploy this implementation

Follow the steps outlined in the [Network Secure Ingress Sample](https://aka.ms/networksecureingresssample).
