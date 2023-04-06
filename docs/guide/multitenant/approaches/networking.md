---
title: Architectural approaches for networking in multitenant solutions
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for networking in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 03/24/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - azure-virtual-network
  - azure-private-link
  - azure-front-door
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for networking in multitenant solutions

All solutions deployed to Azure require networking of some kind. Depending on your solution design and the workload, the ways in which you interact with Azure's networking services might be different. In this article, we provide considerations and guidance for the networking aspects of multitenant solutions on Azure. We include information about the lower-level networking components, like virtual networks, through to higher-level and application-tier approaches.

> [!NOTE]
> Azure itself is a multitenant environment, and Azure's network components are designed for multitenancy. Although it's not required to understand the details in order to design your own solution, you can [learn more about how Azure isolates your virtual network traffic from other customers' traffic](/azure/security/fundamentals/isolation-choices#networking-isolation).

## Key considerations and requirements

### Infrastructure and platform services

The concerns you have for your networking components will differ, depending on the category of services you use.

#### Infrastructure services

Whenever you use infrastructure services, like virtual machines or Azure Kubernetes Service, you need to consider and design the virtual networks, or VNets, that underpin your services' connectivity. You also need to consider the other layers of security and isolation that you need to incorporate in your design. [Avoid relying exclusively on network-layer controls](#relying-only-on-network-layer-security-controls).

#### Platform services

If you use Azure's platform services, like App Service, Azure Cosmos DB, or Azure SQL Database, then the specific architecture you use will determine the networking services you require.

If you need to isolate your platform services from the internet, you need to use a VNet. Depending on the specific services you use, you might work with [private endpoints](/azure/private-link/private-endpoint-overview) or VNet-integrated resources, like [Application Gateway](/azure/application-gateway/overview). However, you might also choose to make your platform services available through their public IP addresses, and use the services' own protections like firewalls and identity controls. In these situations, you might not need a VNet.

The decision of whether to use VNets for platform services is based on many requirements, including the following factors:

- **Compliance requirements:** You might need to meet a specific compliance standard. Some standards require your Azure environment to be configured in specific ways.
- **Your tenants' requirements:** Even if your own organization doesn't have specific requirements for network-layer isolation or controls, your tenants might. Ensure you have a clear understanding of how your tenants will access your solution and whether they have any assumptions about its network design.
- **Complexity:** It can be more complex to understand and work with virtual networks. Ensure your team has a clear understanding of the principles involved, or you're likely to deploy an insecure environment.

Ensure that you understand the [implications of using private networking](#antipatterns-to-avoid).

### Sizing subnets

When you need to deploy a VNet, it's important to carefully consider the sizing and address space of the entire VNet and of the subnets within the VNet.

Ensure you have a clear understanding of how you will deploy your Azure resources into VNets, and the number of IP addresses each resource consumes. If you deploy tenant-specific compute nodes, database servers, or other resources, ensure you create subnets that are large enough for your expected tenant growth and [horizontal autoscaling of resources](/azure/architecture/framework/scalability/design-scale).

Similarly, when you work with managed services, it's important that you understand how IP addresses are consumed. For example, when you use Azure Kubernetes Service with [Azure Container Networking Interface (Azure CNI)](/azure/aks/configure-azure-cni), the number of IP addresses consumed from a subnet will be based on factors like the number of nodes, how you scale horizontally, and the service deployment process that you use. When you use Azure App Service and Azure Functions with VNet integration, [the number of IP addresses consumed is based on the number of plan instances](/azure/app-service/overview-vnet-integration#subnet-requirements).

[Review the subnet segmentation guidance](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) when planning your subnets.

### Public or private access

Consider whether your tenants will access your services through the internet or through private IP addresses.

For internet-based (public) access, you can use firewall rules, IP address allowlisting and denylisting, shared secrets and keys, and identity-based controls to secure your service.

If you need to enable connectivity to your service by using private IP addresses, consider using [Azure Private Link Service](#azure-private-link-service) or [cross-tenant virtual network peering](/azure/virtual-network/create-peering-different-subscriptions). For some limited scenarios, you might also consider using Azure ExpressRoute or Azure VPN Gateway to enable private access to your solution. We only advise that you use this approach when you have a small number of tenants, and deploy dedicated VNets for each tenant.

### Access to tenants' endpoints

Consider whether you need to send data to endpoints within the tenants' networks, either within or outside of Azure. For example, will you need to invoke a webhook that's provided by a customer, or do you need to send real-time messages to a tenant?

If you do need to send data to tenants' endpoints, consider the following common approaches:

- Initiate connections from your solution to tenants' endpoints through the internet. Consider whether the connections must originate from a [static IP address](#static-ip-addresses). Depending on the Azure services you use, you might need to deploy a [NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview), firewall, or load balancer.
- Deploy an [agent](#agents) to enable connectivity between your Azure-hosted services and your customers' networks, regardless of where they are located.
- For one-way messaging, consider using a service like [Azure Event Grid](/azure/event-grid/overview), with or without [event domains](/azure/event-grid/event-domains).

## Approaches and patterns to consider

In this section, we describe some of the key networking approaches that you can consider in a multitenant solution. We begin by describing the lower-level approaches for core networking components, and then follow with the approaches that you can consider for HTTP and other application-layer concerns.

### Tenant-specific VNets with service provider-selected IP addresses

In some situations, you need to run dedicated VNet-connected resources in Azure on a tenant's behalf. For example, you might run a virtual machine for each tenant, or you might need to use private endpoints to access tenant-specific databases.

Consider deploying a VNet for each tenant, by using an IP address space that you control. This approach enables you to peer the VNets together for your own purposes, such as if you need to establish a [hub and spoke topology](#hub-and-spoke-topology) to centrally control traffic ingress and egress.

However, service provider-selected IP addresses aren't appropriate if tenants need to connect directly to the VNet you created, such as by using VNet peering. It's likely that the address space you select will be incompatible with their own address spaces.

### Tenant-specific VNets with tenant-selected IP addresses

If tenants need to peer their own VNets with the VNet you manage on their behalf, consider deploying tenant-specific VNets with an IP address space that the tenant selects. This system enables each tenant to ensure that the IP address ranges in your system's VNet don't overlap with their own VNets. By using non-overlapping IP address ranges, they can ensure their networks are compatible for peering.

However, this approach means it's unlikely that you can peer your tenants' VNets together or adopt a [hub and spoke topology](#hub-and-spoke-topology), because there are likely to be overlapping IP address ranges among VNets of different tenants.

### Hub and spoke topology

The [hub and spoke VNet topology](../../../reference-architectures/hybrid-networking/hub-spoke.yml) enables you to peer a centralized *hub* VNet with multiple *spoke* VNets. You can centrally control the traffic ingress and egress for your VNets, and control whether the resources in each spoke's VNet can communicate with each other. Each spoke VNet can also access shared components, like Azure Firewall, and it might be able to use services like Azure DDoS Protection.

When you use a hub and spoke topology, ensure you plan around limits, [such as the maximum number of peered VNets](/azure/virtual-network/virtual-network-peering-overview), and ensure that you don't use overlapping address spaces for each tenant's VNet.

The hub and spoke topology can be useful when you deploy tenant-specific VNets with IP addresses that you select. Each tenant's VNet becomes a spoke, and can share your common resources in the hub VNet. You can also use the hub and spoke topology when you scale shared resources across multiple VNets for scale purposes, or when you use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml).

> [!TIP]
> If your solution runs across multiple geographic regions, it's usually a good practice to deploy separate hubs and hub resources in each region. While this practice incurs a higher resource cost, it avoids traffic going through multiple Azure regions unnecessarily, which can increase the latency of requests and incur global peering charges.

### Static IP addresses

Consider whether your tenants need your service to use static public IP addresses for inbound traffic, outbound traffic, or both. Different Azure services enable static IP addresses in different ways.

When you work with virtual machines and other infrastructure components, consider using a load balancer or firewall for both inbound and outbound static IP addressing. Consider using NAT Gateway to control the IP address of outbound traffic. For more information about using NAT Gateway in a multitenant solution, see [Azure NAT Gateway considerations for multitenancy](../service/nat-gateway.md).

When you work with platform services, the specific service you use determines whether and how you can control IP addresses. You might need to configure the resource in a specific way, such as by deploying the resource into a VNet and by using a NAT Gateway or firewall. Or, you can request the current set of IP addresses that the service uses for outbound traffic. For example, [App Service provides an API and web interface to obtain the current outbound IP addresses for your application](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors).

### Agents

If you need to enable your tenants to receive messages that are initiated by your solution, or if you need to access data that exists in tenants' own networks, then consider providing an agent (sometimes called an _on-premises gateway_) that they can deploy within their network. This approach can work whether your tenants' networks are in Azure, in another cloud provider, or on premises.

The agent initiates an outbound connection to an endpoint that you specify and control, and either keeps long-running connections alive or polls intermittently. Consider using [Azure Relay](/azure/azure-relay/relay-what-is-it) to establish and manage connections from your agent to your service. When the agent establishes the connection, it authenticates and includes some information about the tenant identifier so that your service can map the connection to the correct tenant.

Agents typically simplify the security configuration for your tenants. It can be complex and risky to open inbound ports, especially in an on-premises environment. An agent avoids the need for tenants to take this risk.

Examples of Microsoft services that provide agents for connectivity to tenants' networks include:
- [Azure Data Factory's self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime).
- [Azure App Service Hybrid Connection](/azure/app-service/app-service-hybrid-connections).
- Microsoft on-premises data gateway, which is used for [Azure Logic Apps](/azure/logic-apps/logic-apps-gateway-connection), [Power BI](/power-bi/connect-data/service-gateway-onprem), and other services.

### Azure Private Link service

[Azure Private Link service](/azure/private-link/private-link-service-overview) provides private connectivity from a tenant's Azure environment to your solution. Tenants can also use Private Link service with their own VNet, to access your service from an on-premises environment. Azure securely routes the traffic to the service using private IP addresses.

For more information about Private Link and multitenancy, see [Multitenancy and Azure Private Link](../service/private-link.md).

### Domain names, subdomains, and TLS

When you work with domain names and transport-layer security (TLS) in a multitenant solution, there are a number of considerations. [Review the considerations for multitenancy and domain names](../considerations/domain-names.yml).

### Gateway Routing and Gateway Offloading patterns

The [Gateway Routing pattern](../../../patterns/gateway-routing.yml) and the [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml) involve deploying a layer 7 reverse proxy or *gateway*. Gateways are useful to provide core services for a multitenant application, including the following capabilities:

- Routing requests to tenant-specific backends or deployment stamps.
- Handling tenant-specific domain names and TLS certificates.
- Inspecting requests for security threats, by using a [web application firewall (WAF)](https://azure.microsoft.com/services/web-application-firewall).
- Caching responses to improve performance.

Azure provides several services that can be used to achieve some or all of these goals, including Azure Front Door, Azure Application Gateway, and Azure API Management. You can also deploy your own custom solution, by using software like NGINX or HAProxy.

If you plan to deploy a gateway for your solution, a good practice is to first build a complete prototype that includes all of the features you need, and to verify that your application components continue to function as you expect. You should also understand how the gateway component will scale to support your traffic and tenant growth.

### Static Content Hosting pattern

The [Static Content Hosting pattern](../../../patterns/static-content-hosting.yml) involves serving web content from a cloud-native storage service, and using a content delivery network (CDN) to cache the content.

You can use [Azure Front Door](/azure/frontdoor/front-door-caching) or another CDN for your solution's static components, such as single-page JavaScript applications, and for static content like image files and documents.

Depending on how your solution is designed, you might also be able to cache tenant-specific files or data within a CDN, such as JSON-formatted API responses. This practice can help you improve the performance and scalability of your solution, but it's important to consider whether tenant-specific data is isolated sufficiently to avoid leaking data across tenants. Consider how you plan to purge tenant-specific content from your cache, such as when data is updated or a new application version is deployed. By including the tenant identifier in the URL path, you can control whether you purge a specific file, all the files that relate to a specific tenant, or all the files for all the tenants.

## Antipatterns to avoid

### Failing to plan for VNet connectivity

By deploying resources into VNets, you have a great deal of control over how traffic flows through your solution's components. However, VNet integration also introduces additional complexity, cost, and other factors that you need to consider. This effect is especially true with platform at a service (PaaS) components.

It's important to test and plan your network strategy, so that you uncover any issues before you implement it in a production environment.

### Not planning for limits

Azure enforces a number of limits that affect networking resources. These limits include [Azure resource limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits) and fundamental protocol and platform limits. For example, when you build a high-scale multitenant solution on platform services, such as Azure App Service and Azure Functions, you might need to consider the [number of TCP connections and SNAT ports](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors). When you work with virtual machines and load balancers, you also need to consider limitations for [outbound rules](/azure/load-balancer/outbound-rules) and for [SNAT ports](/azure/load-balancer/load-balancer-outbound-connections).

### Small subnets

It's important to consider the size of each subnet to allow for the number of resources or instances of resources that you will deploy, especially as you scale. When you work with platform as a service (PaaS) resources, ensure you understand how your resource's configuration and scale will affect the number of IP addresses that are required in its subnet.

### Improper network segmentation

If your solution requires virtual networks, consider how you configure [network segmentation](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) to enable you to control inbound and outbound (north-south) traffic flows and the flows within your solution (east-west). Decide whether tenants should have their own VNets, or if you will deploy shared resources in shared VNets. Changing the approach can be difficult, so ensure you consider all of your requirements, and then select an approach that will work for your future growth targets.

### Relying only on network-layer security controls

In modern solutions, it's important to combine network-layer security with other security controls, and you should not rely only on firewalls or network segmentation. This is sometimes called *zero-trust networking*. Use identity-based controls to verify the client, caller, or user, at every layer of your solution. Consider using services that enable you to add additional layers of protection. The options you have available depend on the Azure services that you use. In AKS, consider using a service mesh for mutual TLS authentication, and [network policies](/azure/aks/use-network-policies) to control east-west traffic. In App Service, consider using the [built-in support for authentication and authorization](/azure/app-service/overview-authentication-authorization) and [access restrictions](/azure/app-service/app-service-ip-restrictions).

### Rewriting host headers without testing

When you use the [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml), you might consider rewriting the `Host` header of HTTP requests. This practice can simplify the configuration of your backend web application service by offloading the custom domain and TLS management to the gateway.

However, `Host` header rewrites can cause problems for some backend services. If your application issues HTTP redirects or cookies, the mismatch in host names can break the application's functionality. In particular, this issue can arise when you use backend services that are themselves multitenant, like Azure App Service, Azure Functions, and Azure Spring Apps. For more information, see the [host name preservation best practice](../../../best-practices/host-name-preservation.yml).

Ensure you test your application's behavior with the gateway configuration that you plan to use.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 * [Joshua Waddell](https://www.linkedin.com/in/joshua-waddell) | Senior Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Review [considerations when using domain names in a multitenant solution](../considerations/domain-names.yml).
- Review service-specific guidance for your networking services:
  - [Use Azure Front Door in a multitenant solution](../service/front-door.md)
  - [Azure NAT Gateway considerations for multitenancy](../service/nat-gateway.md)
  - [Multitenancy and Azure Private Link](../service/private-link.md)