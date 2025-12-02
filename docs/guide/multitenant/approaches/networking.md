---
title: Architectural Approaches for Networking in Multitenant Solutions
description: This article describes approaches to consider for networking in a multitenant solution.
author: johndowns
ms.author: pnp
ms.date: 07/17/2025
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for networking in multitenant solutions

All solutions deployed to Azure require some form of networking. How you interact with Azure networking services depends on your solution's design and workload. This article provides considerations and guidance for the networking aspects of multitenant solutions on Azure. It includes information about lower-level networking components, such as virtual networks, and extends to higher-level and application-tier approaches.

> [!NOTE]
> Azure is a multitenant environment, as are many of its network components. You don't need to understand the details to design your own solution, but you can [learn more about how Azure isolates your virtual network traffic from other customers' traffic](/azure/security/fundamentals/isolation-choices#networking-isolation).

## Key considerations and requirements

### Infrastructure and platform services

Your networking component considerations depend on the category of services that you use.

#### Infrastructure services

When you use infrastructure services, like virtual machines (VMs) or Azure Kubernetes Service (AKS), consider and design the virtual networks that underpin your services' connectivity. Also consider the other layers of security and isolation that you need to incorporate into your design. [Avoid relying exclusively on network-layer controls](#relying-only-on-network-layer-security-controls).

#### Platform services

When you use Azure platform services, like Azure App Service, Azure Cosmos DB, or Azure SQL Database, your architecture determines the networking services that you require.

To isolate your platform services from the internet, use a virtual network. Depending on the services that you use, you might work with [private endpoints](/azure/private-link/private-endpoint-overview) or virtual network-integrated resources, like [Azure Application Gateway](/azure/application-gateway/overview). You might also make your platform services available through their public IP addresses and use the services' own protections like firewalls and identity controls. In these situations, you might not need to deploy and configure your own virtual network.

Decide whether to use virtual networks for platform services based on the following factors:

- **Compliance requirements:** You might need to meet a specific compliance standard. Some standards require you to configure your Azure environment in specific ways, such as using particular network controls. For more information, see [Architectural approaches for governance and compliance in multitenant solutions](./governance-compliance.md).

- **Your tenants' requirements:** Even if your organization doesn't have defined requirements for network-layer isolation or controls, your tenants might. Clearly understand how your tenants plan to access your solution and whether they have any assumptions about its network design.
- **Complexity:** Virtual networks introduce complexity. Ensure that your team clearly understands the principles involved to avoid deploying an insecure environment.

Ensure that you understand the [implications of using private networking](#antipatterns-to-avoid).

### Size your subnets

When you need to deploy a virtual network, carefully consider the sizing and address space of the entire virtual network, including the subnets.

Understand how you plan to deploy your Azure resources into virtual networks and the number of IP addresses that each resource consumes. If you deploy tenant-specific compute nodes, database servers, or other resources, create subnets large enough for your expected tenant growth and [horizontal autoscaling of resources](/azure/architecture/framework/scalability/design-scale).

Similarly, when you work with managed services, understand how they consume IP addresses. For example, when you use AKS with [Azure Container Networking Interface (CNI)](/azure/aks/configure-azure-cni), the number of IP addresses consumed from a subnet are based on factors like the number of nodes, how you scale horizontally, and your service deployment process. When you use App Service and Azure Functions with virtual network integration, [the number of IP addresses consumed is based on the number of plan instances](/azure/app-service/overview-vnet-integration#subnet-requirements).

[Review the subnet segmentation guidance](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) when you plan your subnets.

### Public or private access

Consider whether your tenants need to access your services through the internet or through private IP addresses.

To secure your service for internet-based (public) access, use firewall rules, IP address allowlisting and denylisting, shared secrets and keys, and identity-based controls.

To enable tenants to connect to your service by using private IP addresses, consider using [Azure Private Link service](#private-link-service) or [cross-tenant virtual network peering](/azure/virtual-network/create-peering-different-subscriptions). For some limited scenarios, you might also consider using Azure ExpressRoute or Azure VPN Gateway to enable private access to your solution. Typically, this approach only makes sense when you have a few tenants and when you deploy dedicated virtual networks for each tenant.

### Access to tenants' endpoints

Consider whether you need to send data to endpoints within the tenants' networks, either inside or outside Azure. For example, you might invoke a customer-provided webhook or send real-time messages to a tenant's systems.

If you need to send data to tenants' endpoints, consider the following common approaches:

- Initiate connections from your solution to tenants' endpoints through the internet. Consider whether the connections must originate from a [static IP address](#static-ip-addresses). Depending on the Azure services that you use, you might need to use network address translation (NAT) by deploying [Azure NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview), a firewall, or a load balancer.

- Deploy an [agent](#agents) to enable connectivity between your Azure-hosted services and your customers' networks, regardless of their location.
- Consider using a service like [Azure Event Grid](/azure/event-grid/overview), potentially with [event domains](/azure/event-grid/event-domains), for one-way messaging.

## Approaches and patterns to consider

This section describes some key networking approaches to consider in a multitenant solution. It starts with lower-level approaches for core networking components and then describes approaches for HTTP and other application-layer concerns.

### Tenant-specific virtual networks with service provider-selected IP addresses

In some scenarios, you need to run dedicated virtual network-connected resources in Azure on a tenant's behalf. For example, you might run a VM for each tenant, or you might need to use private endpoints to access tenant-specific databases.

Consider deploying a virtual network for each tenant by using an IP address space that you control. This approach enables you to peer the virtual networks together for your own purposes, such as establishing a [hub-and-spoke topology](#hub-and-spoke-topology) to centrally control traffic ingress and egress.

Avoid using service provider-selected IP addresses if tenants need to connect directly to the virtual network that you create, such as by using virtual network peering. The address space that you select likely conflicts with their existing address spaces.

### Tenant-specific virtual networks with tenant-selected IP addresses

If tenants need to peer their own virtual networks with the virtual network that you manage on their behalf, consider deploying tenant-specific virtual networks by using an IP address space that the tenant selects. This setup enables each tenant to ensure that the IP address ranges in your system's virtual network don't overlap with their own virtual networks, which enables compatibility for peering.

But this approach likely prevents you from peering your tenants' virtual networks together or adopting a [hub-and-spoke topology](#hub-and-spoke-topology). Peered virtual networks can't use overlapping IP address ranges, and when tenants select their own IP address ranges they're likely to select ranges that overlap with each other.

### Hub-and-spoke topology

The [hub-and-spoke virtual network topology](../../../networking/architecture/hub-spoke.yml) enables you to peer a centralized *hub* virtual network with multiple *spoke* virtual networks. You can centrally control the traffic ingress and egress for your virtual networks and control whether the resources in each spoke's virtual network can communicate with each other. Each spoke virtual network can also access shared components, like Azure Firewall, and might use services like Azure DDoS Protection.

When you use a hub-and-spoke topology, plan for limits [such as the maximum number of peered virtual networks](/azure/virtual-network/virtual-network-peering-overview). Don't use overlapping address spaces for each tenant's virtual network.

Consider using the hub-and-spoke topology when you deploy tenant-specific virtual networks that use IP addresses that you select. Each tenant's virtual network becomes a spoke and can share common resources in the hub virtual network. You can also use the hub-and-spoke topology when you scale shared resources across multiple virtual networks or when you use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml).

> [!TIP]
> If your solution spans multiple geographic regions, deploy separate hubs and hub resources in each region to prevent traffic from crossing multiple Azure regions. This practice incurs a higher resource cost but reduces request latency and reduces global peering charges.

### Static IP addresses

Consider whether your tenants need your service to use static public IP addresses for inbound traffic, outbound traffic, or both. Different Azure services enable static IP addresses in different ways.

When you work with VMs and other infrastructure components, consider using a load balancer or firewall for both inbound and outbound static IP addressing. Consider using Azure NAT Gateway to control the IP address of outbound traffic. For more information, see [Azure NAT Gateway considerations for multitenancy](../service/nat-gateway.md).

When you work with platform services, the specific service that you use determines how you can control IP addresses. You might need to configure the resource in a specific way, such as by deploying a resource like a VM into a virtual network and then using a NAT gateway or firewall. Or you can request the current set of IP addresses that the service uses for outbound traffic. For example, [App Service provides an API and web interface to obtain the current outbound IP addresses for your application](/azure/app-service/overview-inbound-outbound-ips#find-outbound-ips).

### Agents

To enable your tenants to receive messages initiated by your solution or to access data in your tenants' networks, consider providing an agent, sometimes called an *on-premises gateway*, that they deploy within their network. This approach can work whether your tenants' networks are in Azure, in another cloud provider, or on-premises.

The agent initiates an outbound connection to an endpoint that you specify and control. It either keeps long-running connections alive or polls intermittently. Consider using [Azure Relay](/azure/azure-relay/relay-what-is-it) to establish and manage connections from your agent to your service. When the agent establishes the connection, it authenticates and includes some information about the tenant identifier so that your service can map the connection to the correct tenant.

Agents typically simplify the security configuration for your tenants. It can be complex and risky to open inbound ports, especially in an on-premises environment. An agent eliminates the need for tenants to take this risk.

Microsoft services that provide agents for connectivity to tenants' networks include the following examples:

- [Azure Data Factory self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime)
- [App Service hybrid connections](/azure/app-service/app-service-hybrid-connections)
- Microsoft on-premises data gateway, which is used for [Azure Logic Apps](/azure/logic-apps/logic-apps-gateway-connection), [Power BI](/power-bi/connect-data/service-gateway-onprem), and other services

### Private Link service

[Private Link service](/azure/private-link/private-link-service-overview) provides private connectivity from a tenant's Azure environment to your solution. Tenants can also use Private Link service with their own virtual network to access your service from an on-premises environment. Azure securely routes the traffic to the service by using private IP addresses.

For more information, see [Multitenancy and Private Link](../service/private-link.md).

### Domain names, subdomains, and TLS

When you work with domain names and Transport Layer Security (TLS) in a multitenant solution, [review the key considerations](../considerations/domain-names.md).

### Gateway Routing and Gateway Offloading patterns

The [Gateway Routing pattern](../../../patterns/gateway-routing.yml) and the [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml) involve deploying a Layer-7 reverse proxy or *gateway*. Gateways provide core services for a multitenant application, including the following capabilities:

- Routing requests to tenant-specific back ends or deployment stamps
- Handling tenant-specific domain names and TLS certificates
- Inspecting requests for security threats by using a [web application firewall (WAF)](https://azure.microsoft.com/services/web-application-firewall)
- Caching responses to improve performance

Azure provides several services that can achieve some or all of these goals, including Azure Front Door, Application Gateway, and Azure API Management. You can also deploy your own custom solution by using software like NGINX or HAProxy.

If you plan to deploy a gateway for your solution, a good practice is to first build a complete prototype. Include all required features and verify that your application components function as expected. You should also understand how the gateway component scales to support your traffic and tenant growth.

### Static Content Hosting pattern

The [Static Content Hosting pattern](../../../patterns/static-content-hosting.yml) serves web content from a cloud-native storage service and uses a content delivery network to cache the content.

You can use [Azure Front Door](/azure/frontdoor/front-door-caching) or another content delivery network for your solution's static components such as single-page JavaScript applications and for static content such as image files and documents.

Depending on your solution's design, you might also be able to cache tenant-specific files or data within a content delivery network, such as JSON-formatted API responses. This practice can help you improve the performance and scalability of your solution. Ensure that tenant-specific data remains isolated sufficiently to prevent data leakage across tenants. Consider how you plan to purge tenant-specific content from your cache, such as when data is updated or a new application version is deployed. By including the tenant identifier in the URL path, you can control whether you purge a specific file, all files that relate to a specific tenant, or all files for all tenants.

## Antipatterns to avoid

### Failing to plan for virtual network connectivity

Deploying resources into virtual networks gives you significant control over how traffic flows through your solution's components. But virtual network integration also introduces more complexity, cost, and other factors that you need to consider, especially for platform as a service (PaaS) components.

Test and plan your network strategy to identify any problems before you implement it in a production environment.

### Not planning for limits

Azure enforces many limits that affect networking resources. These limits include [Azure resource limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits) and fundamental protocol and platform limits. For example, when you build a high-scale multitenant solution on platform services, such as App Service and Azure Functions, you might need to consider the [number of Transmission Control Protocol (TCP) connections and Source Network Address Translation (SNAT) ports](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors). When you work with VMs and load balancers, you also need to consider limitations for [outbound rules](/azure/load-balancer/outbound-rules) and [SNAT ports](/azure/load-balancer/load-balancer-outbound-connections).

### Small subnets

Size each subnet to support the number of resources or instances of resources that you plan to deploy, especially as you scale. When you work with PaaS resources, understand how your resource's configuration and scale affect the number of IP addresses that are required in its subnet.

### Improper network segmentation

If your solution requires virtual networks, consider how you configure [network segmentation](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) to control inbound and outbound traffic (known as *north-south traffic*), as well as traffic within your solution (known as *east-west traffic*). Decide whether tenants should have their own virtual networks or if you should deploy shared resources in shared virtual networks. Changing the approach can be difficult, so carefully consider all requirements before you select an approach that works for your future growth targets.

### Relying only on network-layer security controls

In modern solutions, you should combine network-layer security with other security controls. Don't rely only on firewalls or network segmentation. This approach is sometimes called *Zero Trust networking*. Use identity-based controls to verify the client, caller, or user at every layer of your solution. Consider using services that enable you to add extra layers of protection. Your options depend on the Azure services that you use. In AKS, consider using a service mesh for mutual TLS authentication and apply [network policies](/azure/aks/use-network-policies) to control east-west traffic. In App Service, consider using the [built-in support for authentication and authorization](/azure/app-service/overview-authentication-authorization) and [access restrictions](/azure/app-service/app-service-ip-restrictions).

### Rewriting host headers without testing

When you use the [Gateway Offloading pattern](../../../patterns/gateway-offloading.yml), you might consider rewriting the `Host` header of HTTP requests. This practice can simplify the configuration of your back-end web application service by offloading the custom domain and TLS management to the gateway.

But `Host` header rewrites can cause problems for some back-end services. If your application issues HTTP redirects or cookies, the mismatch in host names can break the application's functionality. In particular, this problem can occur when you use back-end services that run on multitenant infrastructure, like App Service and Azure Functions. For more information, see [Host name preservation best practices](../../../best-practices/host-name-preservation.yml).

Test your application's behavior with the gateway configuration that you plan to use.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Joshua Waddell](https://www.linkedin.com/in/joshua-waddell) | Senior Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Domain name considerations in multitenant solutions](../considerations/domain-names.md).
- Review service-specific guidance for your networking services:
  - [Use Azure Front Door in a multitenant solution](../service/front-door.md)
  - [Azure NAT Gateway considerations for multitenancy](../service/nat-gateway.md)
  - [Multitenancy and Private Link](../service/private-link.md)
