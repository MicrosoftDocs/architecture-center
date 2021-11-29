---
title: Architectural approaches for networking
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for networking in a multitenant solution.
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

If you do need to send data to tenants' networks, you need to decide whether connections will be made through the internet or privately. For internet-based connections from your solution to tenants' networks, consider whether the connections must originate from a [static IP address](#static-ip-addresses). Depending on the Azure services you use, you might need to deploy a [NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview), firewall, or load balancer.

You can also consider deploying an [on-premises gateway](#on-premises-gateways) to enable connectivity between your Azure-hosted services and your customers' networks, regardless of where they are located.

## Approaches and patterns to consider

In this section, we describe some of the key networking approaches you can consider in a multitenant solution. We begin by describing the lower-level approaches for core networking components, and then follow with the approaches you can consider for HTTP and other application-layer concerns.

### Tenant-specific VNets

In some situations, you need to run dedicated resources in Azure on a tenant's behalf. Those resources might need to be VNet-connected because the resources requires network connectivity. For example, you might run a virtual machine for each tenant, or you might need to use private endpoints to access tenant-specific databases.

Consider deploying a VNet for each tenant, using an IP address space that you control. This enables you to peer the VNets together, such as if you need to establish a [hub and spoke topology](#hub-and-spoke-topology).

If you allow tenants to connect their own Azure VNets or on-premises environments to the VNet you host on their behalf, this provides a level of isolation to ensure they can't access other tenants' data. You can deploy virtual network gateways to enable connectivity and perform network address translation (NAT).

However, this isn't a good model if tenants need peer their own Azure VNets with the VNet you created. It's likely that the address space you select will be incompatible with their own address spaces.

### Tenant-specific VNets and tenant-selected IP addresses

If tenants need to peer their own VNets with the VNet you manage on their behalf, consider deploying tenant-specific VNets with an IP address space that the tenant selects. This enables each tenant to ensure that the IP address ranges are compatible for peering.

However, this approach means it's unlikely that you can peer your tenants' VNets together or adopt a [hub and spoke topology](#hub-and-spoke-topology), because there are likely to be overlapping IP address ranges.

### Hub and spoke topology

The [hub and spoke VNet topology](../../../reference-architectures/hybrid-networking/hub-spoke.yml) enables you to peer a centralized *hub* VNet with multiple *spoke* VNets. You can centrally control the traffic ingress and egress for your VNets, and control whether the resources in each spoke's VNet can communicate with each other. Each spoke VNet can also access shared components like Azure Firewall and might be able to use services like Azure DDoS Protection.

When you use a hub and spoke topology, ensure you plan around [limits such as the maximum number of peered VNets](/azure/virtual-network/virtual-network-peering-overview), and ensure that you don't use overlapping address spaces for each tenant's VNet.

The hub and spoke topology can be useful when you deploy tenant-specific VNets. Each tenant's VNet becomes a spoke, and can share your common resources in the hub VNet. You can also use the hub and spoke topology when you scale shared resources across multiple VNets for scale purposes, or when you use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.md).

> [!TIP]
> If your solution runs across multiple geographic regions, it's usually a good practice to deploy separate hubs and hub resources in each region. While this incurs a higher resource cost, it avoids traffic going through multiple Azure regions unnecessarily, which can increase the latency of requests and incur global peering charges.

### Static IP addresses

Consider whether your tenants need your service to use static public IP addresses for inbound traffic, outbound traffic, or both. Different Azure services enable static IP addresses in different ways.

When you work with virtual machines and other infrastructure components, consider using a load balancer or firewall for both inbound and outbound static IP addressing. You can also consider using NAT Gateway to control the IP address of outbound traffic.

When you work with platform services, the specific service you use determines whether and how you can control IP addresses. You might need to configure the resource in a specific way, such as by deploying the resource into a VNet and using a NAT Gateway or firewall, or by requesting the current set of IP addresses that the service uses for outbound traffic (for example, [App Service provides an API and web interface to obtain the current outbound IP addresses for your application](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors)).

### On-premises gateways

If you need to enable your tenants to receive data from your solution by using the internet, or if you need to access data that exists in tenants' on networks, then consider providing an on-premises gateway or agent that they can deploy within their network. The agent initiates an outbound connection to an endpoint that you specify and control, and either keeps long-running connections alive or polls intermittently. When the agent establishes the connection, it authenticates and includes some information about the tenant identifier so that your service can map the connection to the correct tenant.

Gateways typically simplify the security configuration for your tenants. It can be complex and risky to open inbound ports, especially in an on-premises environment. A data gateway avoids the need for tenants to take this risk.

### Azure Private Link service

[Azure Private Link Service](/azure/private-link/private-link-service-overview) provides private inbound connectivity from an end customer's Azure environment to your solution.

Tenants can deploy a private endpoint within their VNet and configure it to your Private Link service instance. Azure securely routes the traffic to the service. Azure Private Link service is used by many large SaaS providers, including [Snowflake](/shows/Azure-Videos/Azure-Private-Link--Snowflake).

[Private endpoints typically require approval](/azure/private-link/private-endpoint-overview#access-to-a-private-link-resource-using-approval-workflow) when the source and destination subscriptions are different. You can [automate the approval process](/azure/private-link/manage-private-endpoint#manage-private-endpoint-connections-on-a-customerpartner-owned-private-link-service) within your solution by using Azure Powershell, the Azure CLI, and the Azure Resource Manager API.

### Domain names, subdomains, and TLS

When you work with domain names and transport-layer security (TLS) in a multitenant solution, there are a number of considerations. [Review the considerations for multitenancy and domain names](../considerations/domain-names.md).

### Gateway Routing and Gateway Offloading patterns

The [Gateway Routing pattern](../../../patterns/gateway-routing.md) and the [Gateway Offloading pattern](../../../patterns/gateway-offloading.md) involve deploying a layer 7 reverse proxy. Gateways are useful to provide core services for a multitenant application, including:

- Routing requests to tenant-specific backends or deployment stamps.
- Handling tenant-specific domain names and TLS certificates.
- Inspecting requests for security threats by using a web application firewall (WAF).
- Caching responses to improve performance.

Azure provides several services that can be used to achieve some or all of these goals, including Azure Front Door, Azure Application Gateway, and Azure API Management. You can also deploy your own custom solution by using software like NGINX or HAProxy.

If you plan to deploy a gateway for your solution, it's a good practice to build a complete prototype that includes all of the features you need. You should also understand how the gateway component will scale to support your traffic and tenant growth.

### Static Content Hosting pattern

The [Static Content Hosting pattern](../../../patterns/static-content-hosting.md) involves serving web content from a cloud-native storage service, and using a content delivery network (CDN) to cache the content.

You can use Front Door or another CDN for your solution's static components, such as single-page JavaScript applications, and for static content like image files and documents.

Depending on how your solution is designed, you might also be able to cache tenant-specific files or data within a CDN, such as JSON API responses. This can help to improve the performance and scalability of your solution, but it's important to consider whether tenant-specific data is isolated sufficiently to avoid leaking data across tenants. You should also consider how you plan to purge tenant-specific content from your cache, such as when data is updated or a new application version is deployed. By including the tenant identifier in the URL path, you can control whether you purge a specific file, all files that relate to a specific tenant, or all files for all tenants.

## Antipatterns to avoid

* **Deploying everything as VNet-integrated without understanding the implications.** Deploying resources into VNets provides you with a great deal of control over how traffic flows through your solution. However, VNet integration also introduces additional complexity, cost, and other factors that you need to consider. It's important to test and plan your network strategy so that you uncover any issues before you implement it in a production environment.
* **Not planning for limits.** Azure enforces a number of limits that affect networking resources. These include [Azure resource limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits) as well as fundamental protocol and platform limits. For example, when you build a high-scale multitenant solution on platform services like Azure App Service and Azure Functions, you might need to consider the [number of TCP connections and SNAT ports](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors). When you work with virtual machines and load balancers, you also need to consider limitations for [outbound rules](/azure/load-balancer/outbound-rules) and for [SNAT ports](/azure/load-balancer/load-balancer-outbound-connections).
* **Not sizing subnets correctly.** It's important to consider the size of each subnet to allow for the number of resources or instances of resources that you will deploy. It's also important to consider how you [logically segment](/azure/security/fundamentals/network-best-practices#logically-segment-subnets) your subnets.
* **Not segmenting networks correctly.** If your solution requires virtual networks, consider how you configure network segmentation to enable you to control inbound and outbound (north-south) traffic flows as well as flows within your solution (east-west). Decide whether tenants should have their own VNets, or if you will deploy shared resources in shared VNets. It can be difficult to change the approach, so ensure you consider all of your requirements and select an approach that will work for your future growth targets.
* **Relying only on network-layer security controls.** In modern networks, it's important to combine network-layer security with other security controls, and not rely on firewalls or network segmentation. This is sometimes called *zero-trust networking*. Use identity-based controls to verify the client, caller, or user at every layer of your solution. Consider using services that enable you to add additional layers of protection. The options you have available depend on the Azure services you use. In AKS, consider using a service mesh for mutual TLS authentication, and [network policies](/azure/aks/use-network-policies) to control east-west traffic. In App Service, consider using the [built-in support for authentication and authorization](/azure/app-service/overview-authentication-authorization) and [access restrictions](/azure/app-service/app-service-ip-restrictions).
* **Using a reverse proxy to rewrite the HTTP `Host` header when the backend isn't aware.** When you use the [Gateway Offloading pattern](../../../patterns/gateway-offloading.md), you might consider rewriting the `Host` header of HTTP requests. This can simplify the configuration of your backend web application service by offloading the custom domain and TLS management to the gateway. However, `Host` header rewrites can cause problems for some backend services. If your application issues HTTP redirects or cookies, the mismatch in host names can break application functionality. This is a particular issue when you work with services like Azure App Service, Azure Functions, and Azure Spring Cloud. Ensure you test your application's behavior with the gateway configuration you plan to use.

## Next steps

Review [considerations when using domain names in a multitenant solution](../considerations/domain-names.md).

## Related resources

- [SaaS Private Connectivity Pattern](https://github.com/Azure/SaaS-Private-Connectivity)
