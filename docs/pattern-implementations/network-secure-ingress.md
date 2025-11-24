---
title: Network secure ingress pattern implementation with Azure Front Door Premium tier
description: The pattern implementation for network secure ingress illustrates global routing, low-latency failover for unhealthy workloads, and mitigating attacks at the edge.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/18/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: sfi-image-nochange
ai-usage: ai-assisted
---

# Pattern implementation for network secure ingress

Network secure ingress encapsulates several design patterns, including the patterns for global routing, global offloading, and health endpoint monitoring. You can use the pattern implementation in this article as a gateway for any HTTP or HTTPS workload that requires high availability or reliability by providing secure global routing to workloads in differing regions with low-latency failover.

## Video: Network secure ingress implementation

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=163c161c-0f7e-4fea-b126-c8f540fc84e0&embedUrl=/azure/architecture/pattern-implementations/network-secure-ingress]

## Pattern requirements

This article describes three requirements that the pattern implementation for network secure ingress focuses on: global routing, low-latency failover, and mitigating attacks at the edge.

### Global routing

The network secure ingress pattern encapsulates the global routing pattern. As such, the implementation can route requests to workloads in different regions.

:::image type="content" source="_images/secure-ingress-use-case-one.png" alt-text="Diagram that shows an HTTPS request being routed to two workloads in different regions.":::

### Low-latency failover

The implementation must be able to identify healthy and unhealthy workloads and adjust the routing accordingly in a time-sensitive way. The latency should be able to support adjusting the routing in a matter of minutes.

:::image type="content" source="_images/secure-ingress-use-case-two.png" alt-text="Diagram that shows an HTTPS request not being routed to an unhealthy workload.":::

### Mitigating attacks at the edge

Mitigating attacks at the edge necessitates the "network secure" part of the implementation. The workloads or platform as a service (PaaS) services shouldn't be accessible via the internet. Internet traffic should only be able to route through the gateway. The gateway should have the ability to mitigate exploits.

:::image type="content" source="_images/secure-ingress-use-case-three.png" alt-text="Diagram that shows an HTTPS request with a SQL statement in the query string of a request not being stopped at the edge.":::

## Patterns

This solution implements the following design patterns:

- [Gateway routing pattern](/azure/architecture/patterns/gateway-routing): Route requests to multiple services or service instances that can reside in different regions.
- [Gateway offloading pattern](/azure/architecture/patterns/gateway-offloading): Offload functionality, such as mitigating attacks, to a gateway proxy.
- [Health endpoint monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring): Expose endpoints that validate the health of the workload.

## Design

:::image type="complex" source="_images/network-diagram-ingress.png" alt-text="Diagram that shows a request flowing through Azure Front Door Premium to regional stamps.":::
The diagram shows an HTTPS request flowing to an Azure Front Door Premium box, which has a web application firewall in it. This illustrates the integration between Azure Front Door Premium and Azure Web Application Firewall. The diagram then shows the request flowing through Private Link to two stamps in different regions. Each stamp has a static website and an internal load balancer. The requests flow through Private Link to the static websites and the load balancers in both stamps.
:::image-end:::

This implementation includes the following details:

- It uses Azure Blob Storage accounts to simulate static web workloads running in two regions. This implementation doesn't include any workloads running behind an internal load balancer (ILB). The diagram shows an ILB to illustrate that this implementation would work for private workloads running behind an ILB.
- It uses Azure Front Door Premium tier as the global gateway.
- The Azure Front Door instance has a global web application firewall (WAF) policy configured with managed rules that help protect against common exploits.
- The storage accounts aren't exposed over the internet.
- The Azure Front Door Premium tier accesses the storage accounts via Azure Private Link.
- The Azure Front Door instance has the following high-level configuration:
  - An endpoint with a single route that points to a single origin group. An origin group is a collection of origins or back ends.
  - The origin group has an origin configured to point to each storage account.
  - Each origin requests Private Link access to the storage account.
  - The origin group has health probes configured to access an HTML page in the storage accounts. The HTML page is acting as the health endpoint for the static workloads. If the probes can successfully access the origin in three out of the last four attempts, the origin is deemed healthy.
  
## Components

### Web request

- [Azure Web Application Firewall](/azure/web-application-firewall/overview) is a security service that protects web applications from common threats and vulnerabilities by using Microsoft-managed rule sets. In this architecture, the Premium tier integrates with Azure Front Door Premium to inspect and block malicious HTTP and HTTPS traffic before it reaches back-end services.
- [Azure Private Link](/azure/private-link/private-link-overview) is a service that enables private connectivity to Azure PaaS services over the Microsoft backbone network. In this architecture, it allows Azure Front Door to securely access storage accounts without exposing them to the public internet.
- [Azure Front Door Premium](/azure/frontdoor/front-door-overview) is a global application delivery network that provides layer-7 load balancing, routing, and security features. In this architecture, it serves as the secure global gateway. It routes traffic to regional workloads and enforces Web Application Firewall policies while communicating privately via Private Link. The Premium tier supports the following components:
  - [Private Link](/azure/frontdoor/private-link) enables Azure Front Door to connect to PaaS services or workloads in a private virtual network over the Microsoft backbone network.
  - [Microsoft-managed rule sets](/azure/frontdoor/standard-premium/tier-comparison) are available only in the Premium tier of Azure Front Door, which integrates with the Premium tier of Web Application Firewall for protection against common exploits.
- [Azure Storage](/azure/storage/common/storage-account-overview) is a scalable cloud storage service for structured and unstructured data. In this architecture, Blob Storage accounts for static web assets and serve as the origin targets for Azure Front Door routing.
- An [ILB](/azure/load-balancer/load-balancer-overview) distributes private IP traffic within a virtual network or across connected networks. This implementation doesn't directly use an ILB, but it's represented in the architecture to show how private workloads behind an ILB can be routed similarly to storage accounts.

### Operations

Securing resources from a network perspective helps protect against exploits, but it also isolates the resources from processes or administrators who might need to access those resources. For example, a build agent in a DevOps pipeline might need to access the storage account in order to deploy an update to the web application. Also, an administrator might need to access the resource for troubleshooting purposes.

To illustrate providing access to network secure access for operational purposes, this implementation deploys a virtual machine (VM) in a virtual network that has Private Link access to the storage accounts. This implementation deploys Azure Bastion, which the administrator can use to connect to the VM. For the deployment scenario, a private build agent could be deployed to the virtual network, similar to how the VM was.

Here are details about the components for operations:

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is a networking service that enables secure communication between resources. In this architecture, the virtual network contains the components required for an administrator to securely communicate with the storage account over the private Microsoft backbone network.
- [Azure Virtual Machines](/azure/virtual-machines/overview) is an infrastructure-as-a-service (IaaS) offering that provides scalable compute resources. In this architecture, a VM serves as a jump box for administrators to securely access network-secured resources.
- [Azure Bastion](/azure/bastion/bastion-overview) is a managed PaaS that provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to VMs without exposing public IP addresses. In this architecture, it enables administrators to connect to the jump box VM over SSH for secure operations.
- A [Private Link endpoint](/azure/private-link/private-endpoint-overview) is a network interface that connects to Azure services via Private Link and assigns a private IP address from the virtual network. In this architecture, the private endpoint connects to the storage account PaaS service. This connection allows resources in the private virtual network to communicate with the storage account over the private IP address.
- A [private Azure DNS zone](/azure/dns/private-dns-privatednszone) is a Domain Name System (DNS) service that resolves domain names to private IP addresses within a virtual network. In this architecture, it resolves the storage account's Private Link host name to its private IP address, which enables secure access from the VM.

## Web request flow

:::image type="complex" source="_images/network-diagram-ingress-user-flow.png" alt-text="Diagram that shows the flow for a web request.":::
The diagram shows a user making a web request to Azure Front Door. In the Azure Front Door box, the diagram shows each of the steps of the Azure Front Door routing flow. Highlighted in the flow is the step where WAF rules are evaluated, where the Azure Front Door route is matched and an origin group is selected, and where the origin is selected from the origin group. The last highlighted piece is where Azure Front Door connects to the Azure Blob Storage account via Private Link.
:::image-end:::

1. The user issues an HTTP or HTTPS request to an Azure Front Door endpoint.
2. The WAF rules are evaluated. Rules that match are always logged. If the Azure Front Door WAF policy mode is set to *prevention* and the matching rule has an action set to *block on anomaly*, the request is blocked. Otherwise, the request continues or is redirected, or the subsequent rules are evaluated.
3. The route configured in Azure Front Door is matched and the correct origin group is selected. In this example, the path was to the static content in the website.
4. The origin is selected from the origin group.

   a. In this example, the health probes deemed the website unhealthy, so it's eliminated from the possible origins.  
   b. This website is selected.
5. The request is routed to the Azure storage account via Private Link over the Microsoft backbone network.

For more information about the Azure Front Door routing architecture, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture?pivots=front-door-standard-premium).

## Operational flow

:::image type="complex" source="_images/network-diagram-ingress-with-vnet.png" alt-text="Diagram that shows the flow that an administrator would use to connect to a protected resource.":::
The diagram has three parts. The first part shows Azure Blob Storage acting as a static website. Azure Front Door connects through Private Link to the storage account. The second part is a box that represents a virtual network. The virtual network has subnets and their contents. These subnets include a private endpoint subnet that contains a Private Link endpoint with an IP address of 10.0.2.5, a jump box subnet with a jump box virtual machine, and an Azure Bastion subnet with Azure Bastion in it. The third part is an administrative user who is using SSH to access the jump box VM in the virtual network via Azure Bastion. An arrow goes from the VM to the private Azure DNS zone. The last arrow goes from the VM to the Private link endpoint and then to the storage account.
:::image-end:::

1. An administrator connects to the Azure Bastion instance that's deployed in the virtual network.

2. Azure Bastion provides SSH connectivity to the jump box VM.

3. The administrator on the jump box tries to access the storage account via the Azure CLI. The jump box queries DNS for the public Azure Blob Storage account endpoint: `storageaccountname.blob.core.windows.net`.

   Private DNS ultimately resolves to `storageaccountname.privatelink.blob.core.windows.net`. It returns the private IP address of the Private Link endpoint, which is 10.0.2.5 in this example.

4. A private connection to the storage account is established through the Private Link endpoint.

## Considerations

Keep the following points in mind when you use this solution.

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This scenario addresses the following key points about reliability:

- Global routing with low latency, through the use of health probes, enables reliability by insulating the application against regional outages.
- [Web Application Firewall on Azure Front Door](/azure/frontdoor/web-application-firewall) provides centralized protection for HTTP and HTTPS requests.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario addresses the following key points about security:

- [Private Link support in Azure Front Door Premium](/azure/frontdoor/private-link) eliminates the need to expose your internal or PaaS services over the internet. Private Link allows Azure Front Door to communicate to your private services or PaaS services over the Microsoft backbone network.
- [Web Application Firewall on Azure Front Door](/azure/frontdoor/web-application-firewall) provides centralized protection for HTTP and HTTPS requests.
- [Managed rules in Web Application Firewall Premium](/azure/web-application-firewall/afds/waf-front-door-drs) are Microsoft-managed rules that help protect you against a common set of security threats.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Although both Azure Front Door Premium and Web Application Firewall Premium provide advanced security features over the Standard tier, there's additional cost to both. Review the following resources to learn more about pricing for Azure Front Door and Web Application Firewall:

- [Azure Front Door pricing](https://azure.microsoft.com/pricing/details/frontdoor/)
- [Web Application Firewall pricing](https://azure.microsoft.com/pricing/details/web-application-firewall/)
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator)

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Implementing network security boundaries adds complexity to operations and deployment. Keep these points in mind:

- The [IP ranges for Microsoft-hosted agents vary over time](/azure/devops/pipelines/agents/hosted?tabs=yaml#networking). Consider implementing self-hosted agents in your virtual network.
- Implement [Azure Bastion](/azure/bastion/bastion-overview) for scenarios where operations teams need to access network secure resources.
- The use of [Web Application Firewall on Azure Front Door](/azure/frontdoor/web-application-firewall) to provide centralized protection for HTTP and HTTPS requests is an example of the gateway offloading pattern. The responsibility of examining requests for exploits is offloaded to Web Application Firewall in Azure Front Door. The benefit from an operational excellence perspective is that you need to manage the rules in only one place.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands that users place on it. For more information, see [Overview of the performance efficiency pillar](/azure/architecture/framework/scalability/overview).

Global routing enables horizontal scaling through the deployment of more resources in the same region or different regions.
