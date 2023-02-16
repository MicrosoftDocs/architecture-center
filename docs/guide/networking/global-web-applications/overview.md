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

Most modern applications rely on web protocols, HTTP and HTTPS, for application delivery. <!-- TODO more intro -->

Global applications frequently use Azure Front Door. Azure Front Door is a highly available service, with an industry-leading SLA. Further, teams throughout Microsoft rely on Front Door to accelerate the delivery of HTTP traffic in a secure and reliable manner to customers. However, like all cloud-based services, Azure Front Door is not immune to occasional outages. We spend a great deal of effort to avoid these issues, and to fix them and learn from them whenever they happen. For most customers, the reliability and resiliency built into the Front Door platform is more than enough to meet their business requirements. Nonetheless, a subset of customers might have mission-critical solutions that require them to minimize the risk and impact of downtime.

You can switch between Azure Front Door and other application delivery services during an outage or a disaster. However, these architectures need to be carefully considered. They introduce complexity, and bring significant costs and limitations. Further, they might inhibit your ability to use some important features of Azure Front Door.

In this article, we describe the factors that you need to consider when planning a mission-critical global HTTP application architecture with Azure Front Door.

## Alternate traffic paths

- Need to send traffic to Front Door when it's available, and automatically fail over when it's not
- What is Traffic Manager
- Diagram: TM -> { FD, generic other path } -> generic applications
- Your application needs to be ready to accept traffic from either pathway (AFD or otherwise)
  - Origin security
    - Do you use X-Azure-FDID header? If so, how will this work when traffic follows a different path in?
    - Do you use Private Link to connect from AFD to your origin? If so, how will this work when the traffic doesn't go through AFD?

## Key considerations

### Understand your use of Azure Front Door

- Front Door has many features
- It's important to understand which features you use and rely on
- The exact set of features that you use might dictate the approach you follow, and which alternate paths might be appropriate
- To you send traffic to another path, you need to ensure that you have equivalent features in the other service

### Domain names and TLS certificates

- Very important to use your own domain - don't rely on or use the provider-generated domains
- Azure Front Door provides managed TLS certificates. However, in this kind of architecture you should use your own certificate, for a couple of reasons:
  - Front Door's domain verification process for certificate generation and renewal assumes that your domain points directly to Front Door, which isn't true in this kind of approach.
  - Also, your other CDNs might not be able to generate and renew managed certificates, probably for similar reasons.
  - If you have multiple providers all issuing certificates independently you could cause problems for your clients.

### Web application firewall

- If you use the Front Door WAF to protect your application, consider what happens if the traffic isn't going through Front Door anymore
- Do your alternative paths also have WAFs? If so, can you configure them the same way as your Front Door WAF?
  - Do they need to be tested and tuned independently to avoid false positive detections?
  - If you choose not to use a WAF for your alternative path, are you making yourself more vulnerable to threats?
  - If somebody discovers your secondary path, could they send malicious traffic through your secondary path even when your primary path is live?

### Rules engine

- Do you do custom routing logic by using the Front Door rules engine? If so, how will you handle this when traffic traverses the alternate path?

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

Principal author:

 * [Dave Burkhardt](http://linkedin.com/in/david-burkhardt-13b79b3) | Principal Product Manager, Azure Networking
 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

 * TODO

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
