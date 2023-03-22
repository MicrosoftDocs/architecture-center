---
title: Global routing redundancy for mission-critical web applications
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global web applications.
author: johndowns
ms.author: jodowns
ms.date: 03/10/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-traffic-manager
  - azure-front-door
categories:
  - networking

---

# Global routing redundancy for mission-critical web applications

> [!IMPORTANT]
> Designing redundancy implementations that deal with global platform outages for a mission-critical architecture can be complex and costly. Because of the potential problems that might arise with this design, carefully consider the [tradeoffs](#tradeoffs).
> In most situations, you won’t need the architecture described in this article.

Mission-critical systems strive to minimize single points of failure by building redundancy and self-healing capabilities in the solution as much as possible. Any unified entry point of the system can be considered a point of failure. If this component experiences an outage, the entire system will be offline to the user.  When choosing a routing service, it’s important to consider the reliability of the service itself.  In the [baseline architecture for mission-critical application](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro), Azure Front Door was chosen because of its 99.99% uptime SLA and a rich feature set:

-	Ability to route traffic to multiple regions in an active-active model
- Ability of transparent failover using TCP anycast
-	Ability to serve static content from edge nodes by using integrated content delivery networks (CDNs)
-	Ability to block unauthorized access with integrated web application firewall

Reliability and resiliency built into Azure Front Door is more than enough to meet most business requirements. However, with any distributed system, expect failure; even for Front Door. If the business requirements demand a higher composite SLA or zero-down time in case of an outage, you’ll need to rely on an alternate traffic ingress path. However, the pursuit of a higher composite SLA comes with significant costs, operational overhead, lower your overall reliability. Carefully consider the tradeoffs and potential issues that the alternate path might introduce in other components that are on the critical path. Even when the impact of unavailability is significant, complexity might outweigh the benefit.

One approach is to define a secondary path, with alternate service(s), which becomes active only when Azure Front Door is unavailable. Feature parity with Front Door shouldn’t be treated as a hard requirement. Prioritize features that you absolutely need for business continuity purposes, even potentially running in a limited capacity.

Another approach is using third-party technology for global routing. This approach will require a multi-cloud active-active deployment with stamps hosted across two or more cloud providers. Even though Azure can effectively be integrated with other cloud platforms, this approach is not recommended because of operational complexity across the different cloud platforms. 

This article describes some strategies for global routing using Azure Traffic Manager as the alternate router in situations where Azure Front Door isn’t available.

## Traffic ingress

When your clients send traffic to your application, it traverses a *path*. Typically, the path includes parts of the internet, before the requests are routed to the Microsoft global network.

In a simple application architecture, your client might connect directly to your application servers in Azure. Your application might even perform client-side load balancing, sending requests to a set of application servers. However, as you grow and your solution matures, it's a good practice to perform traffic routing within Azure Front Door. Azure Front Door provides many capabilities to support global application delivery, including anycast routing to a large network of global points of presence (PoPs), transparent failover between origins, a web application firewall to secure your solution, caching capabilities to improve application performance and reduce the load on your origin servers, and Private Link integration. For more information about Front Door's capabilities, see [Accelerate and secure your web application with Azure Front Door](/azure/frontdoor/scenarios).

Azure Front Door is a highly available service. It has an industry-leading SLA of 99.99% uptime, which is much higher than many other CDNs. Further, teams throughout Microsoft rely on Azure Front Door to accelerate the delivery of web traffic in a secure and reliable manner to customers. However, no cloud-based service is infallible. We take a great deal of care to avoid outages, and we fix them quickly and learn from them whenever they happen. For most customers, the reliability and resiliency built into the Azure Front Door platform is more than enough to meet their business requirements. Occasionally, some customers have mission-critical solutions that require them to minimize the risk and impact of any downtime.

You can switch between Azure Front Door and other CDNs or application delivery services during an outage or a disaster. However, you need to carefully consider these architectures. They introduce complexity, and bring significant costs and limitations. Further, they might limit your ability to use some important features of Azure Front Door.

## Approach

When you design a mission-critical global web application, consider having multiple redundant traffic paths. The following diagram shows a general approach to delivering mission-critical web application traffic:

:::image type="content" source="./media/overview/alternate-traffic-paths.png" alt-text="Diagram showing Traffic Manager directing requests to Azure Front Door or to another service, and then to the origin server." border="false":::

When you follow this approach, you introduce several components and make significant changes to other components in your solution:

1. **Azure Traffic Manager** directs traffic to Azure Front Door or to the alternative service that you've selected.

   [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a DNS-based global load balancer. Your domain's CNAME record points to Traffic Manager, and Traffic Manager determines where the traffic should go based on how you configure its [routing method](/azure/traffic-manager/traffic-manager-routing-methods). In most situations, consider using [priority routing](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method) so that traffic flows through Azure Front Door by default. Traffic Manager can automatically switch traffic to your alternate path if Azure Front Door is unavailable.
  
   You can also consider using a different global traffic routing system, such as a global load balancer. However, Traffic Manager works well for many situations.

1. You have two *paths* for traffic to ingress to your application:

   - **Azure Front Door** processes and routes most of your application traffic. Azure Front Door provides the *primary path* to your application.

   - **Another service** is used as a backup for Azure Front Door. Traffic only flows through this *secondary path* if Azure Front Door is unavailable.
  
     The specific service that you select for your secondary path depends on many factors, which are described in more detail later throughout this article. You might choose to use Azure-native services, or third-party services. In these articles we provide Azure-native options to avoid adding additional operational complexity to the solution.

1. **Your origin application servers** need to be ready to accept traffic from either service. You need to consider how you [secure traffic to your origin](#origin-security), and what responsibilities Azure Front Door and other upstream services provide. Ensure that your application can handle traffic from whichever path your traffic flows through.

## Consistency of ingress paths

Azure Front Door provides many capabilities to make your application more resilient, performant, and secure. It's important that you understand which capabilities and features you use and rely on. When you have an understanding of how you use Azure Front Door, you can determine which alternative services provide the minimum capabilities that you need, and you can decide on an architectural approach.

If you plan to send traffic through multiple paths to reach your application, you need to ensure that each path has equivalent capabilities. Or, you need to make an informed decision about which capabilities are essential and which capabilities can be omitted when your solution is in a degraded mode.

When planning an alternative traffic path, here are some key questions you should consider:

- Do you use Azure Front Door's caching features? If caching is unavailable, are your origin servers likely to struggle to keep up with your traffic?
- Do you do use the Azure Front Door rules engine to perform custom routing logic, or to rewrite requests?
- Do you use the Azure Front Door web application firewall (WAF) to secure your applications?
- Do you restrict traffic based on IP address or geography?
- Who issues and managed your TLS certificates?
- How do you restrict access to your origin application servers to ensure it comes through Azure Front Door? Do you use Private Link, or do you rely on public IP addresses with service tags and identifier headers?
- Do your application servers accept traffic from anywhere other than Azure Front Door? If they do, which protocols do they accept?
- Do your clients use Azure Front Door's HTTP/2 support?

### Web application firewall

If you use Azure Front Door's WAF to protect your application, consider what happens if the traffic doesn't go through Azure Front Door.

If your alternative path also provides a WAF, consider the following questions:

- Can it be configured in the same way as your Azure Front Door WAF?
- Does it need to be tuned and tested independently, to reduce the likelihood of false positive detections?

> [!WARNING]
> You might consider not using a WAF for your alternative ingress path, and consider accepting the increased risk of attacks when your traffic flows through the alternate path. However, this isn't a good practice.
> 
> When you deploy an architecture like the one described in this article, your alternate traffic path is always exposed to the internet and is ready to accept traffic at any moment. If an attacker discovers an unprotected secondary traffic path to your application, they might send malicious traffic through your secondary path even when the primary path includes a WAF.
> 
> Instead, it's best to secure *all* paths to your application servers.

## Domain names and DNS

Your application should use a custom domain name. In a mission-critical solution, it's even more important to use a custom domain name. By using a custom domain name, you have control over how traffic flows to your application, and you reduce the dependencies you take on a single provider.

It's also a good practice to use a high-quality and resilient DNS service for your domain name, such as [Azure DNS](/azure/dns/dns-overview). If your domain name's DNS servers are unavailable, clients can't reach your service.

In a mission-critical solution, it's also a good practice to use multiple DNS resolvers to increase the overall resiliency of your solution even further.

### CNAME chaining

Solutions that combine Traffic Manager, Azure Front Door, and other services use a multi-layer DNS CNAME resolution process, also called *CNAME chaining*. For example, when you resolve your own custom domain, you might see five or more CNAME records before an IP address is returned.

Adding additional links to a CNAME chain can affect DNS name resolution performance. However, DNS responses are usually cached, which reduces the performance impact.

## TLS certificates

Azure Front Door provides managed TLS certificates. However, in this kind of architecture it's a good idea to provision and use your own TLS certificates. This is a good practice for several reasons:

- To issue and renew managed TLS certificates, Azure Front Door verifies your ownership of the domain. The domain verification process generally assumes that your domain's CNAME records point directly to Azure Front Door. In a complex architecture like that described in this article, this assumption often isn't correct. Issuing and renewing managed TLS certificates on Azure Front Door might not work smoothly in these situations, and you increase the risk of outages due to TLS certificate problems.
- Similarly, even if your other services provide managed TLS certificates, they might not be able to verify domain ownership either.
- If each service that you use issues their own managed TLS certificates independently, you might cause problems for your clients. For example, clients might not expect to see different TLS certificates issued by different authorities, or with different expiry dates or thumbprints.

When you provision and use your own TLS certificates, you reduce the number of potential problems you might introduce in this kind of architecture. However, you also need to take care to renew and update your certificates before they expire.

## Origin security

When you [configure your origin](/azure/frontdoor/origin-security) to only accept traffic through Azure Front Door, you gain protection against layer 3 and layer 4 [DDoS attacks](/azure/frontdoor/front-door-ddos). Furthermore, because Azure Front Door only responds to valid HTTP traffic, it also helps to reduce your exposure to many protocol-based threats. If you change your architecture to allow alternative ingress paths, you need to evaluate whether you've accidentally increased your origin's exposure to threats.

If you use Private Link to connect from Azure Front Door to your origin server, how does traffic flow through your alternative path? Can you use private IP addresses to access your origins, or must you use public IP addresses?

If your origin uses the Azure Front Door service tag and the `X-Azure-FDID` header to validate that traffic has flowed through Azure Front Door, consider how your origins can be reconfigured to validate that traffic has flowed through either of your valid paths. Also, ensure that you test that you haven't accidentally opened your origin to traffic through other paths, including from other customers' Azure Front Door profiles.

When you plan your origin security, check whether your alternative traffic path relies on provisioning dedicated public IP addresses. If it does, consider whether you should implement [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) to reduce the risk of denial of service attacks against your origins. Also, consider whether you need to implement [Azure Firewall](/azure/firewall/overview) or another firewall capable of protecting you against a variety of network threats. You might also need more intrusion detection strategies. These controls often aren't required when your application is only exposed through Azure Front Door, but are often important elements in a more complex architecture.

## Monitor component health and trigger traffic failover

When planning a highly available mission-critical web application architecture, consider how you'll monitor the health of the overall solution and its components. The following questions help to plan how to monitor your traffic ingress:

- How do the different components of your solution monitor the health of downstream components?
- When should health monitors consider downstream components to be unhealthy?
- How long does it take for an outage to be detected?
- After an outage is detected, how long does it take for traffic to be routed through an alternative path?

There are multiple global load balancing solutions that enable you to monitor the health of Azure Front Door, and to trigger an automatic failover to a backup platform if an outage occurs. For most customers, a DNS based solution such as Azure Traffic Manager is suitable. With Azure Traffic Manager, you configure [endpoint monitoring](/azure/traffic-manager/traffic-manager-monitoring) to monitor downstream services. You can instruct Traffic Manager which URL to check, how frequently to check that URL, and when to consider the downstream service unhealthy based on probe responses. In general, the shorter the interval between checks, the less time it takes for Traffic Manager to direct traffic through an alternative path to reach your origin server.

If Azure Front Door is unavailable, then multiple factors influence the overall amount of time that the outage affects your traffic, including:

- The time to live (TTL) on your DNS records.
- How frequently Traffic Manager runs its health checks.
- How many failed probes Traffic Manager is configured to see before it reroutes traffic.
- How long clients and upstream DNS servers cache Traffic Manager's DNS responses for.

You also need to determine which of these elements are within your control, and whether upstream services beyond your control might affect your clients' experiences. For example, even if you use a low TTL on your DNS records, upstream DNS caches might disobey these instructions and serve stale responses for longer than they should. This behavior might exacerbate the effects of an outage or make it seem like your application is unavailable, even when Traffic Manager has already switched to sending requests to the alternative traffic path.

> [!TIP]
> Mission-critical solutions require automated failover approaches wherever possible. Manual failover processes are generally too slow for mission-critical solutions to remain responsive.

## Availability of Azure Traffic Manager

Azure Traffic Manager is a highly available service, but as with all DNS-based traffic managers, it also has a service level agreement that doesn't guarantee 100% availability. If Traffic Manager is unavailable, your users might not be able to access your application, even if Azure Front Door and your alternative service are both available. It's important to plan how your solution will continue to operate even if Traffic Manager isn't responding to requests.

Traffic Manager returns cacheable DNS responses. If your DNS records' TTLs allow for caching, short outages of Traffic Manager might not be a concern, because downstream DNS resolvers might have cached a previous response. However, you should consider whether you plan for prolonged outages. You might choose to manually reconfigure your DNS servers to direct users to Azure Front Door if Traffic Manager is unavailable.

## Deployment and configuration

When you're planning how to operate a mission-critical traffic ingress solution, you should also plan for how you deploy or configure your services when they're degraded. For most Azure services, SLAs apply to the uptime of the service itself, and not to management operations or deployments. Consider whether your deployment and configuration processes need to be made resilient to service outages.

You should also consider the number of independent control planes that you need to interact with to manage your solution. When you use Azure services, Azure Resource Manager provides a consistent control plane. If you use a third-party service to route your traffic, you might need to use a separate control plane to configure the service.

> [!WARNING]
> If you need to use multiple control planes, you introduce risk to your solution. Every point of difference increases the likelihood that somebody accidentally misses a configuration setting in the other, or applies different configuration to each component. Ensure that your operational procedures mitigate this risk.

## Development and testing

For a mission-critical solution, your testing practices need to verify that your solution meets your requirements regardless of the path that your application traffic flows through. Consider each part of the solution and how you test it for each type of outage.

Ensure that your testing processes include these elements:

- Can you verify that traffic is correctly redirected through the alternative path when the primary path is unavailable?
- Can both paths support the level of production traffic you expect to receive?
- Are both paths adequately secured, to avoid opening or exposing vulnerabilities when you're in a degraded state?

## Health modeling

In a mission-critical solution, a health model helps you to represent the overall health status. When you use multiple traffic ingress paths, you need to monitor the health of each path. If your traffic is rerouted to the secondary ingress path, your health model should reflect the fact that the system is still operational but that it's running in a degraded state. For more information about health modeling, see [Health modeling for mission-critical workloads](../../../reference-architectures/containers/aks-mission-critical/mission-critical-health-modeling.md)

## Tradeoffs

This type of architecture can increase your overall availability and resiliency to outages. However, there are some significant tradeoffs that you need to consider. When evaluating a complex architecture, you should weigh up the potential benefits against the known costs, and make an informed decision about whether the benefits are worth those costs.

The main costs associated with an architecture like the one described above are:

- **Financial cost:** When you deploy multiple redundant paths to your application, you need to consider the cost of deploying and running the resources. We provide two example scenarios for different use cases, each of which has a different cost profile.
- **Operational complexity:** Every time you add additional components to your solution, you increase your management overhead. Further, every time you make a change to one component, you need to consider whether other components might be affected.

  For example, suppose you decide to add some application features that require you to use new capabilities of Azure Front Door. You need to check whether your alternative traffic path also provides an equivalent capability, and if not, you need to decide how to handle the difference in behavior between the two traffic paths. In real-world applications, these complexities can have a high cost, and can present a major risk to your system's stability.
- **Performance:** As described above, this type of solution requires additional CNAME lookups during name resolution. In most applications, this isn't a significant concern, but you should evaluate whether your application performance is affected by introducing additional layers into your ingress path.

> [!WARNING]
> If you're not careful in how you design and implement a complex high-availability solution, you can actually make your availability worse. Increasing the number of components in your architecture increases the number of failure points. It also means you have a higher level of operational complexity. When you add extra components, every change that you make needs to be carefully reviewed to understand how it affects your overall solution.

## Common scenarios

Based on our experience working with customers, we've observed two common scenarios where mission-critical web traffic needs the kind of architecture described in this article. We provide more detailed guidance for each of these scenarios.

- [Global content delivery](./mission-critical-content-delivery.md) commonly applies to static content delivery, media, and high-scale eCommerce applications. In this scenario, caching is a critical part of the solution architecture, and failures to cache can result in significantly degraded performance or reliability.
- [Global HTTP ingress](./mission-critical-global-http-ingress.md) commonly applies to mission-critical dynamic applications and APIs. In this scenario, the core requirement is to route traffic to the origin server reliably and efficiently. Frequently, a WAF is an important security control used in these solutions.

Every customer's solution architecture and requirements are different, so it's important to consider how you design your own mission-critical web application.

## Next steps

Review the [global HTTP ingress](./mission-critical-global-http-ingress.md) and [global content delivery](./mission-critical-content-delivery.md) scenarios to understand whether they apply to your solution.
