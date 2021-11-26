---
title: Architectural approaches for networking
titleSuffix: Azure Architecture Center
description: TODO
author: johndowns
ms.author: jodowns
ms.date: 11/25/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
  - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for networking

All solutions deployed to Azure require networking of some kind. Depending on your solution design and the workload, the ways in which you interact with Azure's networking services might be very different. On this page, we provide considerations and guidance for the networking aspects of multitenant solutions on Azure. We include information about the lower-level networking components, like virtual networks, through to higher-level and application-tier approaches.

> [!NOTE]
> Azure itself is a multitenant environment, and Azure's network components are designed for multitenancy. Although it's not required to understand the details in order to design your own solution, you can [learn more about how Azure isolates your virtual network traffic from other customers' traffic.](/azure/security/fundamentals/isolation-choices#networking-isolation)

## Key considerations and requirements

### Infrastructure and platform services

The concerns you have for your networking components will differ depending on the category of services you use.

#### Infrastructure services

Whenever you use infrastructure services, like virtual machines or Azure Kubernetes Service, you need to be consider and design the virtual networks, or VNets, underpinning your services' connectivity. You also need to consider the other layers of security and isolation that you need to incorporate in your design. Avoid relying exclusively on network-layer controls.

#### Platform services

If you are using Azure's platform services, like App Service, Azure Cosmos DB, or Azure SQL Database, then the specific architecture you use will dictate the networking services you require.

If you need to isolate your platform services from the internet, you will need to use a VNet. Depending on the specific services you use, you might work with [private endpoints](/azure/private-link/private-endpoint-overview) or VNet-integrated resources like [Application Gateway](/azure/application-gateway/overview). However, you might also choose to make your platform services available through their public IP addresses, and use the services' own protections like firewalls and identity controls. In these situations, you might not need a VNet.

The decision of whether to use VNets for platform services is based on many factors, including:

- **Compliance requirements:** You might need to meet a specific compliance standard. Some standards require your Azure environment to be configured in specific ways.
- **Your tenants' requirements:** Even if your own organization doesn't have specific requirements to require network-layer isolation or controls, your tenants might. Ensure you have a clear understanding of how your tenants will access your solution and whether they have any assumptions about its network design.
- **Complexity:** It can be more complex to understand and work with virtual networks. Ensure your team has a clear understanding of the principles involved, or you're likely to deploy an insecure environment.

Ensure that you understand the [implications of using private networking](#antipatterns-to-avoid).

### Sizing subnets

When you need to deploy a VNet, it's important to carefully consider the sizing and address space of the entire VNet and of the subnets within the VNet.

Ensure you have a clear understanding of how you will deploy your Azure resources into VNets, and the number of IP addresses each resource consumes. If you deploy tenant-specific compute nodes, database servers, or other resources, ensure you create subnets that are large enough for your expected tenant growth.

Similarly, when you work with managed services, it's important that you understand how IP addresses are consumed. For example, when you use Azure Kubernetes Service in conjunction with [Azure Container Networking Interface (Azure CNI)](/azure/aks/configure-azure-cni), the number of IP addresses consumed from a subnet will be based on factors including the number of nodes, how you scale horizontally, and the service deployment process you use. When you use Azure App Service and Azure Functions with VNet integration, [the number of IP addresses consumed is based on the number of plan instances](/azure/app-service/overview-vnet-integration#subnet-requirements).

[Review the subnet segmentation guidance](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) when planning your subnets.

### Public or private access

Consider whether your tenants will access your services through the internet or through private IP addresses. You can use services like [Azure Private Link Service](#azure-private-link-service), Azure ExpressRoute, and Azure VPN Gateway to enable private access to your solution.

### Access to on-premises or external networks

Consider whether you need to send data to tenants' networks, either within or outside of Azure. For example, will you need to invoke a webhook provided by a customer, or send real-time messages to a tenant?

If you do need to send data to tenants' networks, you need to decide whether connections will be made through the internet or privately. For internet-based connections from your solution to tenants' networks, consider whether the connections must originate from a static IP address. Depending on the Azure services you use, you might need to deploy a [NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview), firewall, or load balancer.

You can also consider deploying an [on-premises gateway](#on-premises-gateways) to enable connectivity between your Azure-hosted services and your customers' networks, regardless of where they are located.

## Approaches and patterns to consider

In this section, we describe some of the key networking approaches you can consider in a multitenant solution. We begin by describing the lower-level approaches for core networking components, and then follow with the approaches you can consider for HTTP and other application-layer concerns.

<!-- TODO here down -->

### Tenant-specific VNets

* Situation: You need to run dedicated resources in Azure on a tenant's behalf, and the tenant needs to be able to access those resources directly (e.g. from their own Azure VNet, or on-prem via a VPN).
* Consider deploying a VNet for each tenant, using an IP address space that the tenant chooses.
* The tenant can then peer their own network(s) with that VNet.
* However, because you'll have overlapping IP addresses, you can't peer the networks together.

### Hub and spoke topology

* When you need to use tenant-specific VNets, or deploy lots of VNets to scale your shared components out (e.g. for global distribution, multiple solutions that need to talk to each other, or high scale)
* Can deploy a spoke VNet per tenant and then peer to a central hub VNet.
* This topology provides the service provider the ability to control ingress and egress traffic in a centralized manner.
  * But watch for maximum VNet peerings (/azure/virtual-network/virtual-network-peering-overview)
  * And watch for overlapping address spaces.
* https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli
* By using a Hub and Spoke topology, you can share components like Azure Firewall and DDoS Protection rather than deploying them for every customer.

### Static IP addressing

* Outbound load balancer, firewall, or NAT Gateway
 * When working with PaaS services, you might be able to request the current set of IP addresses for outbound traffic (e.g. [App Service](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors)).

### On-premises gateways

For some solutions, consider tenants can deploy an agent within their own network. The agent initiates an outbound connection to an endpoint that you control. This can simplify the security model of your solution and helps your tenants avoid opening inbound ports.

### Azure Private Link Service

* [Azure Private Link Service](/azure/private-link/private-link-service-overview) provides private inbound connectivity from an end customer's Azure environment to a multitenant solution of the provider.
* Enables SaaS providers to expose their service on a private endpoint within the end customer's Azure subscription.
  * e.g. [Snowflake](/shows/Azure-Videos/Azure-Private-Link--Snowflake)
* Your customers can deploy a private endpoint and point it to your Private Link Service resource.
* Cross-subscription endpoints need approval, but you can automate this within your solution by using an ARM API call

### Domain names, subdomains, and TLS

* [Link to considerations](../considerations/domain-names.md)
* [Global DNS load balancing approach with shared Traffic Manager](/azure/traffic-manager/traffic-manager-faqs#how-can-i-assign-http-headers-to-the-traffic-manager-health-checks-to-my-endpoints)

### Gateway Routing and Gateway Offloading patterns
* [See pattern](/patterns/gateway-routing). [See pattern](/patterns/gateway-offloading).
* Layer 7 reverse proxy.
* Front Door, AppGW, APIM, or build your own (e.g. nginx or HAProxy cluster)
* Useful for TLS termination, handlign custom domain names, WAF, caching, routing (implements Gateway Routing pattern)
* Prototype everything and plan how you will scale

### Static Content Hosting pattern
* [See pattern](/patterns/static-content-hosting).
* If your solution is architected to enable it, you can use Front Door or another CDN for the static components - e.g. SPAs - and for static content like image files, documents, etc.
* If CDN is used for a multitenant solution, consider how to do purging so that it's scoped to the things you want to purge - e.g. URLs/query strings with tenant IDs in them. Then you can control whether you purge everything or just a specific tenant's files.

## Antipatterns to avoid

* Deploying everything as VNet-integrated without understanding the implications
  * Limits, complexity, cost
* Not being aware of limits, or planning for them
  * Subnet sizes - consider how you [segment your subnets](/azure/security/fundamentals/network-best-practices#logically-segment-subnets).
  * SNAT port, TCP connection limits
    * For more detail see these links: For VM and Load Balancer https://docs.microsoft.com/en-us/azure/load-balancer/outbound-rules or this https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections or this for web apps (since it can happen frequently with multiple separate tenant system connecting to different endpoints) https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-intermittent-outbound-connection-errors
  * Azure resource quotas and limits
* Not segmenting networks properly, if required
  * Consider how you segment your network and control east-west traffic
  * e.g. do tenants need their own isolated VNets? Or will you use a shared VNet with separate subnets for each role and have tenants share the subnets?
  * Generally not a good idea to deploy subnets per tenant because you'll run into limits quickly. Scale within a subnet or across VNets.
* Relying only on network segmentation.
  * Use identity-based controls/zero trust models too.
  * In AKS, use Network Policies as a way to control east-west traffic on the network layer and Service Mesh for mTLS.
* Using L7 reverse proxy to rewrite HTTP Host header when backend isn't aware
  * Causes problems with redirects and cookies
  * This is an issue with App Service, Azure Functions, Spring Cloud, among others

## Next steps

Links to other relevant pages within our section.

## Related resources

- https://github.com/Azure/SaaS-Private-Connectivity
