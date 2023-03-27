---
title: Mission-critical global HTTP ingress
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global HTTP applications when your focus is on HTTP ingress.
author: johndowns
ms.author: jodowns
ms.date: 03/10/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - checklist
  - guide
---

# Mission-critical global HTTP ingress

Mission-critical applications need to maintain a high level of uptime, even when network components are unavailable or degraded. When you design web traffic ingress, routing, and security, you can consider combining multiple Azure services to achieve a higher level of availability and to avoid having a single point of failure.

If you decide to adopt this approach, you'll need to implement separate network path to your application servers, and each path needs to be configured and tested separately. You must carefully consider the full implications of this approach.  

This article describes an approach to support global HTTP traffic ingress through Azure Front Door and Azure Application Gateway. This approach might suit your needs if your solution needs:

- Azure Front Door for global traffic routing. This might mean that you have multiple instances of your application in separate Azure regions, or that you serve all global users from a single region.
- Web application firewall (WAF) to protect your application, regardless of the path your traffic follows to reach your origin servers.

Caching at the network edge isn't critical part of your application delivery. If caching is important, see [Mission-critical global content delivery](./mission-critical-content-delivery.md) for an alternative approach.

> [!NOTE]
>
> This use case is part of an overall design strategy that covers an alternate approach when Azure Front Door is unavailable. For information about the context and considerations, see [Mission-critical global web applications](./overview.md).

## Approach

This DNS-based load balancing solution uses multiple Azure Traffic Manager profiles to monitor Azure Front Door. In the very unlikely event of an availability issue, Traffic Manager redirects traffic through Application Gateway.

:::image type="content" source="./media/mission-critical-global-http-ingress/front-door-application-gateway.png" alt-text="Azure Traffic Manager with priority routing to Azure Front Door, and a nested Traffic Manager profile using performance routing to send to Application Gateway instances in two regions." border="false":::

The solution includes the following components:

- **Traffic Manager using priority routing mode** has two [endpoints](/azure/traffic-manager/traffic-manager-endpoint-types). By default, Traffic Manager sends requests through Azure Front Door. If Azure Front Door is unavailable, a second Traffic Manager profile determines where to direct the request. The second profile is described below.

- **Azure Front Door** processes and routes most of your application traffic. Azure Front Door routes traffic to the appropriate origin application server, and it provides the primary path to your application. Azure Front Door's WAF protects your application against common security threats. If Azure Front Door is unavailable, traffic is automatically redirected through the secondary path.

- **Traffic Manager using performance routing mode** has an endpoint for each Application Gateway instance. This Traffic Manager sends requests to the Application Gateway instance with the best performance from the client's location.

- **Application Gateway** is deployed into each region, and sends traffic to the origin servers within that region. Application Gateway's WAF protects any traffic that flows through the secondary path.

- **Your origin application servers** need to be ready to accept traffic from both Azure Front Door and Azure Application Gateway, at any time.

## Considerations

The following sections describe some important considerations for this type of architecture. You should also review [Mission-critical global web applications](./overview.md) for other important considerations and tradeoffs when you use Azure Front Door in a mission-critical solution.

#### Traffic Manager configuration

This approach uses [nested Traffic Manager profiles](/azure/traffic-manager/traffic-manager-nested-profiles) to achieve both priority-based and performance-based routing together for your application's alternative traffic path. In a simple scenario with an origin in a single region, you might only need a single Traffic Manager profile configured to use priority-based routing.

#### Regional distribution

Azure Front Door is a global service, while Application Gateway is a regional service.

Azure Front Door's points of presence are deployed globally, and TCP and TLS connections [terminate at the closest point of presence to the client](/azure/frontdoor/front-door-traffic-acceleration). This behavior improves the performance of your application. In contrast, when clients connect to Application Gateway, their TCP and TLS connections terminate at the Application Gateway that receives the request, regardless of where the traffic originated.

#### Connections from clients

As a global multitenant service, Azure Front Door provides inherent protection against a variety of threats. Azure Front Door only accepts valid HTTP and HTTPS traffic, and doesn't accept traffic on other protocols. Microsoft manages the public IP addresses that Azure Front Door uses for its inbound connections. Because of these characteristics, Azure Front Door can help to [protect your origin against a variety of attack types](/azure/frontdoor/front-door-ddos), and your origins can be [configured to use Private Link connectivity](#private-link-connections-to-origin-servers).

In contrast, Application Gateway is an internet-facing service with a dedicated public IP address. You must protect your network and origin servers against a variety of attack types. For more information, see [Origin security](./overview.md#origin-security).

#### Private Link connections to origin servers

Azure Front Door Premium provides [Private Link connectivity](/azure/frontdoor/origin-security?#private-link-origins) to your origins, which reduces the public internet-facing surface area of your solution.

If you use Private Link to connect to your origins, consider deploying a private endpoint into your virtual network, and configure Application Gateway to use the private endpoint as the backend for your application.

#### Scaling

When you deploy Application Gateway, you deploy dedicated compute resources for your solution. If large amounts of traffic arrive at your Application Gateway unexpectedly, you might observe performance or reliability issues.

To mitigate this risk, consider how you [scale your Application Gateway instance](/azure/application-gateway/application-gateway-autoscaling-zone-redundant). Either use autoscaling, or ensure that you've manually scaled it to handle the amount of traffic that you might receive after failing over.

### Caching

If you use Azure Front Door's caching features, then it's important to be aware that after your traffic switches to the alternative path and uses Application Gateway, content is no longer served from the Azure Front Door caches. 

If you depend on caching for your solution, see [Mission-critical global content delivery](./mission-critical-content-delivery.md) for an alternative approach that uses a partner CDN as a fallback to Azure Front Door.

Alternatively, if you use caching but it's not an essential part of your application delivery strategy, consider whether you can scale out or scale up your origins to cope with the increased load caused by the higher number of cache misses during a failover.

## Tradeoffs

This type of architecture is most useful if you want your alternative traffic path to use features like request processing rules, a WAF, and TLS offload. Both Azure Front Door and Application Gateway provide similar capabilities. 

However, there are tradeoffs:

- **Operational complexity**. When you use any of these features, you need to configure them on both Azure Front Door and Application Gateway. For example, if you make a configuration change to your Azure Front Door WAF, you need to apply the same configuration change to your Application Gateway WAF too. Your operational complexity becomes much higher when you need to reconfigure and test two separate systems.

- **Feature parity**. While there are similarities between the features that Azure Front Door and Application Gateway offer, many features don't have exact parity. Be mindful of these differences, because they could affect how the application is delivered based on the traffic path it follows.

  Application Gateway doesn't provide caching. For more information about this difference, see [Caching](#caching).

  Azure Front Door and Application Gateway are distinct products and have different use cases. In particular, [the two products are different in how they're deployed to Azure regions](#regional-distribution). Ensure you understand the details of each product and how you use them.

- **Cost**. You typically need to deploy an Application Gateway instance into each region where you have an origin. Because each Application Gateway instance is billed separately, the cost can become high when you have origins deployed into several regions.

  If cost is a significant factor for your solution, see [Mission-critical global content delivery](./mission-critical-content-delivery.md) for an alternative approach that uses a partner content delivery network (CDN) as a fallback to Azure Front Door. Some CDNs bill for traffic on a consumption basis, so this approach might be more cost-effective. However, you might lose some of the other advantages of using Application Gateway for your solution.

  Alternatively, you could consider deploying an alternative architecture where Traffic Manager can route traffic directly to platform as a service (PaaS) application services, avoiding the need for Application Gateway and reducing your costs. You could consider this approach if you use a service like Azure App Service or Azure Container Apps for your solution. However, if you follow this approach, there are several important tradeoffs to consider:

  - **WAF:** Azure Front Door and Application Gateway both provide WAF capabilities. If you expose your application services directly to the internet, you might not be able to protect your application with a WAF.
  - **TLS offload:** Azure Front Door and Application Gateway both terminate TLS connections. Your application services need to be configured to terminate TLS connections. 
  - **Routing:** Both Azure Front Door and Application Gateway perform routing across multiple origins or backends, including path-based routing, and they support complex routing rules. If your application services are exposed directly to the internet, you can't perform traffic routing.

> [!WARNING]
> If you consider exposing your application directly to the internet, create a thorough threat model and ensure that the architecture meets your security, performance, and resiliency requirements.
>
> If you use virtual machines to host your solution, you should not expose the virtual machines to the internet.

## Next steps

Review the [global content delivery](./mission-critical-content-delivery.md) scenario to understand whether it applies to your solution.
