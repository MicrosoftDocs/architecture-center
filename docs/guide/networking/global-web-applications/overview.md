---
title: Mission-critical global web applications
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global web applications.
author: johndowns
ms.author: jodowns
ms.date: 02/15/2023
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

# Mission-critical global web applications

Most modern applications rely on web protocols, HTTP and HTTPS, for application delivery. Global applications frequently use Azure Front Door to accelerate their performance, route traffic between regions, and secure their workloads.

Azure Front Door is a highly available service, with an industry-leading SLA. Further, teams throughout Microsoft rely on Azure Front Door to accelerate the delivery of web traffic in a secure and reliable manner to customers. However, like all cloud-based services, Azure Front Door is not immune to occasional outages. We take a great deal of care to avoid these issues, and we fix them quickly and learn from them whenever they happen. For most customers, the reliability and resiliency built into the Azure Front Door platform is more than enough to meet their business requirements. However, some customers have mission-critical solutions that require them to minimize the risk and impact of any downtime.

You can switch between Azure Front Door and other application delivery services during an outage or a disaster. However, these architectures need to be carefully considered. They introduce complexity, and bring significant costs and limitations. Further, they might limit your ability to use some important features of Azure Front Door.

In this article, we describe the factors that you need to consider when planning a mission-critical global HTTP application architecture with Azure Front Door.

## Approach

When you design a mission-critical global web application, consider having multiple redundant traffic paths. The following diagram shows a general approach to delivering mission-critical web application traffic:

:::image type="content" source="./media/overview/alternate-traffic-paths.png" alt-text="Diagram showing traffic being directed by Traffic Manager to Azure Front Door or to another service, and then to the origin server." border="false":::

In this approach, you introduce several components and make significant changes to other components in your solution:

- **Azure Traffic Manager** is used to direct traffic to Azure Front Door or to the alternative service that you've selected. [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a DNS-based global load balancer.

  Your domain's CNAME record points to Traffic Manager, and Traffic Manager determines where the traffic should go based on how you configure its [routing method](/azure/traffic-manager/traffic-manager-routing-methods). In most situations, consider using [priority routing](/azure/traffic-manager/traffic-manager-routing-methods#priority-traffic-routing-method) so that traffic flows through Azure Front Door most of the time. Traffic Manager can automatically fail over to your alternate traffic path if Azure Front Door is unavailable.
  
  You can also consider using a different global traffic routing system, but Traffic Manager works well for most situations.
- **Azure Front Door** processes and routes most of your application traffic. If Azure Front Door is unavailable, traffic is automatically redirected through another path.
- **Another service** is used as a backup for Azure Front Door. Traffic flows through this service if Azure Front Door is unavailable. The specific service you choose depends on many factors, which are described in more detail below.
- **Your origin application servers** need to be ready to accept traffic from either service. You need to consider how you [secure traffic to your origin](#origin-security), and what responsibilities Azure Front Door and other upstream services provide. Ensure that your application can handle traffic from whichever path your traffic flows through.

## Key considerations

When you architect your solution to use multiple ingress paths, you need to carefully consider the responsibilities of each layer of the solution.

### Understand your use of Azure Front Door

Azure Front Door provides many capabilities to make your application more resilient, performant, and secure. It's important that you understand which capabilities and features you use and rely on. When you have an understanding of how you use Azure Front Door, you can determine which alternative services provide the minimum capabilities that you need, and you can decide on an architectural approach. If you plan to send traffic through multiple paths to reach your application, you need to ensure that each path has equivalent capabilities. Or, you need to make an informed decision about which capabilities are essential and which aren't.

Some key questions you should consider are:

- Do you use Azure Front Door's caching features? If caching is unavailable, are your origin servers likely to struggle to keep up with your traffic?
- Do you do use the Azure Front Door rules engine to perform custom routing logic, or to rewrite requests?
- Do you use the Azure Front Door web application firewall (WAF) to secure your applications?
- Do you restrict traffic based on IP address or geography?
- Do you use Azure Front Door's managed TLS certificates?
- How do you restrict access to your origin application servers to ensure it comes through Azure Front Door? Do you use Private Link, or do you rely on public IP addresses with service tags and identifier headers?
- Do your application servers accept traffic from anywhere other than Azure Front Door? If they do, which protocols do they accept?
- Do your clients use HTTP/2 to access your application?

### Domain names and DNS

Your application should use a custom domain name. In a mission-critical solution, it's even more important to use a custom domain name. By using a custom domain name, you have control over how traffic flows to your application, and you reduce the dependencies you take on a single provider.

It's also a good practice to use a high-quality and resilient DNS service for your domain name, such as [Azure DNS](TODO). If your domain name's DNS servers are unavailable, clients can't reach your service.

### TLS certificates

Azure Front Door provides managed TLS certificates. However, in this kind of architecture it's a good idea to provision and use your own TLS certificates. This is a good practice for several reasons:

- To issue and renews managed TLS certificates, Azure Front Door verifies your ownership of the domain. The domain verification process generally assumes that your domain's CNAME records point directly to Azure Front Door. In a complex architecture like that described in this article, this assumption often isn't correct. Issuing and renewing managed TLS certificates on Azure Front Door might not work smoothly in these situations, and you increase the risk of outages due to TLS certificate problems.
- Similarly, even if your other services provide managed TLS certificates, they might not be able to verify domain ownership either.
- If each service that you use issues their own managed TLS certificates independently, you might cause problems for your clients. For example, clients might not expect to see different TLS certificates issued by different authorities, or with different expiry dates or thumbprints.

When you provision and use your own TLS certificates, you reduce the number of potential problems you might introduce in this kind of architecture. However, you also need to take care to renew and update your certificates before they expire.

### Web application firewall

If you use Azure Front Door's WAF to protect your application, consider what happens if the traffic doesn't go through Azure Front Door.

If you alternative path also provides a WAF, consider the following questions:

- Can it be configured in the same way as your Azure Front Door WAF?
- Does it need to be tuned and tested independently, to reduce the likelihood of false positive detections?

> [!WARNING]
> You might consider not using a WAF for your alternative ingress path, and accept the increaed risk of attacks when your traffic flows through the alternate path. However, this isn't a good practice. When you deploy an architecture like that described in this article, your alternate traffic path is always live and ready to accept traffic. If an attacker discovers the secondary traffic path to your application, they might exploit this information and send malicious trafic through your secondary path even when the primary path includes a WAF.
> 
> Instead, it's best to secure *all* paths to your application servers.

### Origin security

- DDoS protection and other layer 3/4 prevention
- Do you use X-Azure-FDID header? If so, how will this work when traffic follows a different path in?
- Do you use Private Link to connect from AFD to your origin? If so, how will this work when the traffic doesn't go through AFD?


### Monitoring health and triggering failover

- Traffic Manager needs to detect a failure in Front Door and then serve new records
- Your DNS TTL and TM probe config affects this
- Can't control all downstream DNS caches either

### Internet security

- When you use AFD, you get a lot of benefits by virtue of it being a multitenant service that only accepts valid HTTP traffic. Layer 3/4 traffic and non-HTTP protocols just don't get to you. So equally, attacks that rely on these protocols don't reach your application. If you've restricted your origin to only accept traffic from AFD, you significantly limit your exposure to internet threats.
- But if you use a secondary path into your application, this can be a significant shift in your exposure.
  - Consider whether you need to expose your applications to the internet. This might require dedicated public IP address. Consider whether you need to then start to use DDoS protection, intrusion detection, layer 3/4 firewalls, etc.

### DNS

Because DNS is a key element with serving web application traffic, it is also an industry best practice to utilize multiple DNS resolvers to ensure the utmost availability.

## Common scenarios

- [Global traffic ingress](./mission-critical-global-http-ingress.md)
- [Caching](./mission-critical-content-delivery.md)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Dave Burkhardt](https://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](https://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Harikrishnan M B](https://linkedin.com/in/harikrishnanmb/) | Product Manager 2, Azure Networking

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
