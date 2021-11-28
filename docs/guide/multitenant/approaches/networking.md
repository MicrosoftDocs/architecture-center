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

The hub and spoke topology can be useful in several types of multitenant solutions, as illustrated in the following examples.

#### Example 1: Tenant-specific spoke VNets

When every tenant needs their own VNet, you can consider configuring each tenant-specific VNet as a spoke. You can create a single hub VNet for network resources that every tenant should share.

TODO diagram

#### Example 2: Large numbers of shared spoke VNets

When you create shared components to enable high levels of scale, such as when you use the [Deployment Stamps pattern](../../../patterns/deployment-stamp.md), or need to scale out to support high levels of traffic, you can create separate spoke VNets for each set of resources. Your central hub VNet can then contain resources that should be accessible throughout your entire environment.

TODO diagram

### Static IP addresses

Consider whether your tenants need your service to use static public IP addresses for inbound traffic, outbound traffic, or both. Different Azure services enable static IP addresses in different ways.

When you work with virtual machines and other infrastructure components, consider using a load balancer or firewall for both inbound and outbound static IP addressing. You can also consider using NAT Gateway to control the IP address of outbound traffic.

When you work with platform services, the specific service you use determines whether and how you can control IP addresses. You might need to configure the resource in a specific way, such as by deploying the resource into a VNet and using a NAT Gateway or firewall, or by requesting the current set of IP addresses that the service uses for outbound traffic (for example, [App Service provides such an API](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors)).

### On-premises gateways

If you need to enable your tenants to receive data from your solution by using the internet, or if you need to access data that exists in tenants' on networks, then consider providing an on-premises gateway or agent that they can deploy within their network. The agent initiates an outbound connection to an endpoint that you specify and control, and either keeps long-running connections alive or polls intermittently. When the agent establishes the connection, it authenticates and includes some information about the tenant identifier so that your service can map the connection to the correct tenant.

Gateways typically simplify the security configuration for your tenants. It can be complex and risky to open inbound ports, especially in an on-premises environment. A data gateway avoids the need for tenants to take this risk.

<!-- TODO here down -->

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
