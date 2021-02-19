---
title: Best practices for endpoint security on Azure
description: Best practices for protecting application endpoints.
author: PageWriter-MSFT
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
azureCategories:
  - networking
products:
  - azure-firewall
  - azure-application-gateway
  - azure-ddos-protection
ms.custom:
  - article
---

# Best practices for endpoint security on Azure

An _endpoint_ is an address exposed by a web application so that external entities can communicate with it. A malicious or an inadvertent interaction with the endpoint can compromise the security of the application and even the entire system. One way to protect the endpoint is by placing filter controls on the network traffic that it receives, such as defining rule sets. A defense-in-depth approach can further mitigate risks. Include supplemental controls that protect the endpoint if the primary traffic controls fail. 

This article describes way in which you can protect web applications with Azure services and features. For product documentation, see Related links.

## Key points
- Protect all public endpoints with Azure Front Door, Application Gateway, Azure Firewall, Azure DDoS Protection.
- Use web application firewall (WAF) to protect web workloads.
- Protect workload publishing methods and restrict ways that are not in use.
- Implement an automated and gated CD/CD deployment process.
- Mitigate DDoS attacks. Use Standard protection for critical workloads where outage would have business impact. Also consider CDN as another layer of protection.
- Develop processes and procedures to prevent direct internet access of virtual machines (such as proxy or firewall) with logging and monitoring to enforce policies.
- Implement an automated and gated CI/CD deployment process.

## Public endpoints
A public endpoint receives traffic over the internet. The endpoints make the service easily accessible to attackers. 

**Are all public endpoints of this workload protected?**
***

An initial design decision is to assess whether you need a public endpoint at all. If you do, protect it with using these mechanisms.

### Web application firewalls (WAFs) 

WAFs provide a basic level of security for web applications.  WAFs are appropriate if the organizations that have invested in application security as WAFs provide additional defense-in-depth mitigation. 

WAFs mitigate the risk of an attacker to exploit commonly seen security vulnerabilities for applications. WAFs provide a basic level of security for web applications. This mechanism is an important mitigation because attackers target web applications for an ingress point into an organization (similar to a client endpoint).

Azure Application Gateway has WAF capabilities to inspect web traffic and detect attacks at the HTTP layer. It's a load balancer and HTTP(S) full reverse proxy that can do secure socket layer (SSL) encryption and decryption. 
  
For example, your workload is hosted in Application Service Environments(ILB ASE). The APIs are consolidated internally and exposed to external users. This external exposure could be achieved using an Application Gateway. This service is a load balancer. It forwards request to the internal API Management service, which in turn consumes the APIs deployed in the ASE. Application Gateway is also configured over port 443 for secured and reliable outbound calls.

> [!TIP]
>
> The design considerations for the preceding example are described in [Publishing internal APIs to external users](../../example-scenario/apps/publish-internal-apis-externally.yml).
  
Azure Front Door and Azure Content Delivery Network (CDN) also have WAF capabilities. 

### Azure Firewall

Protect the entire virtual network against potentially malicious traffic from the internet and other external locations. It inspects incoming traffic and only passes the allowed requests to pass through.  

A common design is to implement a DMZ or a perimeter network in front of the application. The DMZ is a separate subnet with the firewall. 

> [!TIP]
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: DMZ between Azure and your on-premises datacenter](https://github.com/mspnp/reference-architectures/tree/master/dmz/secure-vnet-hybrid).
>
> The design considerations are described in [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml).

### Combination approach

When you want higher security and there's a mix of web and non-web workloads in the virtual network use both Azure Firewall and Application Gateway. There are several ways in which those two services can work together. 
 
For example, you want to filter egress traffic. You want to allow connectivity to a specific Azure Storage Account but not others. You'll need fully qualified domain name (FQDN)-based filters. In this case run Firewall and Application Gateway in parallel.

Another popular design is when you want Azure Firewall to inspect all traffic and WAF to protect web traffic, and the application needs to know the client's source IP address. In this case, place Application Gateway in front of Firewall. Conversely, you can place Firewall in front of WAF if you want to inspect and filter traffic before it reaches the Application Gateway.

For more information, see [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml).

It’s challenging to write concise firewall rules for networks where different cloud resources dynamically spin up and down. Use [Azure Security Center](/azure/security-center/) to detect misconfiguration risks.

### Authentication
Disable insecure legacy protocols for internet-facing services. 
Legacy authentication methods are among the top attack vectors for cloud-hosted services. Those methods don’t support other factors beyond passwords and are prime targets for password spraying, dictionary, or brute force attacks.  

## Mitigate DDoS attacks

In a distributed denial-of-service (DDoS) attack, the server is overloaded with fake traffic. DDoS attacks are common and can be debilitating. An attack can completely block access or take down the services. Enable DDoS mitigation for all business-critical web application and services.

Azure provides DDoS protection in two tiers: **Basic** and **Standard**. 

**Basic** is integrated with Azure services and is available at no additional cost. The tier protects through always-on traffic monitoring and real-time mitigation. 

**Standard** has advanced features over **Basic** including logging, alerting, and telemetry.	

**How do you implement DDoS protection?**	
***	

Here are some common options:	

- DDoS protection at virtual network level. The protection usually focuses on the network (layer 3) level. Azure Virtual Network resources offer both **Basic** and **Standard**. 	

  The [Windows N-tier application on Azure with SQL Server](../../reference-architectures/n-tier/n-tier-sql-server.yml) reference architecture uses DDoS Protection Standard because this option:	
  - Uses adaptive tuning, based on the application's network traffic patterns, to detect threats. 	
  - Guarantees 100% SLA. 	
  - Can be cost effective. For example, during a DDoS attack, the first set of attacks cause  the provisioned resources to scale out. For a resource such as a virtual machine scale set, 10 machines can grow to 100, increasing overall costs. With Standard protection, you don't have to worry about the cost of the scaled resources because Azure will provide the cost credit. 	

  For information about Standard DDoS Protection, see [Azure DDoS Protection Service](/azure/virtual-network/ddos-protection-overview).	

- DDoS protection with caching. Consider content delivery network (CDN) as another layer of protection. With CDN, infrequently changing content is copied from the backend server and cached on servers in various locations. A request doesn't need to communicate with the backend server and request times are significantly reduced. In a DDoS attack, a CDN intercepts the traffic and stops it from reaching the backend server. That way, the application doesn't experience downtime that can  negatively impact business. 	

  Azure CDN has integrated DDoS protection through the **Basic** DDoS tier. For more information, see [Azure CDN DDoS Protection](/azure/cdn/cdn-ddos).	

- DDoS protection at higher levels that profile your services. This option provides a baseline for your deployments and then uses machine learning techniques to detect anomalous traffic. Also, proactively protects based on the set protection level before service degradation. Adopt the advance protection for any services where downtime will negatively impact the business.

For a list of reference architectures that demonstrate the use of DDoS protection, see [Azure DDoS Protection reference architectures](/azure/ddos-protection/ddos-protection-reference-architectures).
## Adopt DevOps

Developers shouldn't publish their code directly to app servers. 

**Does the organization have an CI/CD process for publishing code in this workload?**
***

Implement lifecycle of continuous integration, continuous delivery (CI/CD) for applications. Have processes and tools in place that aid in an automated and gated CI/CD deployment process.

**How are the publishing methods secured?**
***
Application resources allowing multiple methods to publish app content, such as FTP, Web Deploy should have the unused endpoints disabled. For Azure Web Apps, SCM is the recommended endpoint. It can be protected separately with network restrictions for sensitive use cases.


## Next step
> [!div class="nextstepaction"]
> [Data flow](design-network-flow.md)

### Related links
- [Azure Firewall](/azure/firewall/overview)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)
- [Azure DDoS Protection Standard](/azure/ddos-protection/)


> Go back to the main article: [Network security](design-network.md)