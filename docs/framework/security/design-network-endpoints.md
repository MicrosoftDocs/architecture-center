---
title: Endpoint security
description: Best practices for securing access to internet, PaaS services, and on-premises networks.
author: PageWriter-MSFT
ms.date: 09/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
azureCategories:
  - hybrid
  - networking
products:
  - azure-firewall
  - azure-virtual-network  
---

# Endpoint security

An _endpoint_ is an address exposed by a web application so that external entities can communicate with it. A malicious or an inadvertant interaction with the endpoint can compromise the security of the application and even the entire system. One way to protect the endpoint is by placing filter controls on the network traffic that it receives, such as defining rule sets. A defense in depth approach can further mitigate risks. Include supplemental controls that protect the endpoint if the primary traffic controls fail. 

This article describes way in which you can protect web applications with Azure services and features. The links to the service documentation is given in Related links.

## Key points
- Protect all public endpoints with Azure Front Door, Application Gateway, Azure Firewall, Azure DDoS Protection.
- Use web application firewall (WAF) to protect web workloads.
- Protect workload publishing methods and restrict those not in use.
- Implement an automated and gated CD/CD deployment process.
- Mitigate DDoS attacks. Use Standard protection for critical workloads where outage would have business impact. Also consider CDN as another layer of protection.
- Develop process and procedures to prevent direct Internet access of virtual machines (such as proxy or firewall) with logging and monitoring to enforce policies.
- Implement an automated and gated CI/CD deployment process.

## Public endpoints
A public endpoint receives traffic over the internet. This makes the service easily accessble to attackers. 

**Are all public endpoints of this workload protected?**
***

An initial design decision is to assess whether you need a public endpoint at all. If you do, protect it with using these mechanisms.

### Web application firewalls (WAFs) 

WAFs provide a basic level of security for web applications.  WAFs are appropriate if the organizations that have invested in application security as WAFs provide a valuable additional defense in depth mitigation. 

WAFs mitigate the risk of an attacker being able to exploit commonly seen security vulnerabilities for applications. WAFs provide a basic level of security for web applications. This mechanism is an important mitigation because attackers target web applications for an ingress point into an organization (similar to a client endpoint).

Azure Application Gateway has WAF capabilities to inspect web traffic and detect attacks at the HTTP layer. It's a load balancer and HTTP(S) full reverse proxy that can do secure socket layer (SSL) encryption and decryption. 
  
For example, your workload is hosted in Application Service Environments(ILB ASE). The APIs are consolidated internally and exposed to external users. This external exposure could be achieved using an Application Gateway. This service is a load balancer that forwards request to the internal API Management service, which in turn consumes the APIs deployed in the ASE. Application Gateway is also configured over port 443 for secured and reliable outbound calls.

> [!TIP]
>
> The design considerations for the preceding example are described in [Publishing internal APIs to external users](/azure/architecture/example-scenario/apps/publish-internal-apis-externally).
  
Azure Front Door and Azure Content Delivery Network (CDN) also have WAF capabilities. 

### Azure Firewall

Protect the entire virtual network against potentially malicious traffic from the internet and other external locations. It inspects incoming traffic and only passes the allowed requets to pass through.  

A common design is to implment a DMZ or a permimeter network in front of the application. The DMZ is a separate subnet with the firewall. 

> [!TIP]
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: DMZ between Azure and your on-premises datacenter](https://github.com/mspnp/reference-architectures/tree/master/dmz/secure-vnet-hybrid).
>
> The design considerations are described in [Deploy highly available NVAs](/architecture/reference-architectures/dmz/secure-vnet-dmz).

### Combination approach

 When you want higher security and there's a mix of web and non-web workloads in the virtual network use both Azure Firewall and Application Gateway. There are several ways in which those two services can work together. 
 
For example, you want to filter egress traffic. You want to allow connectivity to a specific Azure Storage Account but not others. You'll need fully qualified domain name (FQDN)-based filters. In this case run Firewall and Application Gateway in parallel.

Another popular pattern is when when you want Azure Firewall to inspect all traffic and WAF to protect web traffic, and the application needs to know the client's source IP address. In this case, place Application Gateway in front of Firewall. Conversely, you can place Firewall in front of WAF if you want to inspect and filter traffic before it reaches the Application Gateway.

For more information, see [Firewall and Application Gateway for virtual networks](azure/architecture/example-scenario/gateway/firewall-application-gateway).


Use Azure Security Center to detect misconfiguration risks related to the above.

### Authentication
Disable insecure legacy protocols for internet-facing services. 
Legacy authentication methods are among the top attack vectors for cloud-hosted services. Those methods don’t support additional factors beyond passwords and are prime targets for password spraying, dictionary, or brute force attacks.  

## Mitigate DDoS attacks

**How do you implement DDoS protection?**
***

Enable Distributed Denial of Service (DDoS) mitigations for all business-critical web application and services. DDoS attacks are common and can be debilitating. An attack can completely block access or take down the services. There are two common options:

- DDoS protection at virtual network level. The protection usually focuses on the network (layer 3) level. Azure Virtual Network resources offers **Basic** and **Standard** tiers for DDoS protection. Enable DDoS Protection Standard for all business-critical web application and services. 

  The [Windows N-tier application on Azure with SQL Server](../../reference-architectures/n-tier/n-tier-sql-server.yml) reference architecture uses DDoS Protection Standard because this option:
  - Uses adaptive tuning, based on the application's network traffic patterns, to detect threats. 
  - Guarantees 100% SLA. 
  - Can be cost effective. For example, during a DDoS attack, the first set of attacks cause  the provisioned resources to scale out. For a resource such as a virtual machine scale set, 10 machines can grow to 100, increasing overall costs. With Standard protection, you don't have to worry about the cost of the scaled resources because Azure will provide the cost credit. 

- DDoS protection at higher levels that profile your services. This option provides a baseline for your deployments and then uses machine learning techniques to detect anomalous traffic and proactively protects based on protection level set prior to service degradation. Adopt the advance protection for any services where downtime will negatively impact the business.

For information about Standard DDoS Protection, see [Azure DDoS Protection Service](/azure/virtual-network/ddos-protection-overview).

## Adopt DevOps

Developers shouldn't publish their code directly to app servers. 

**Does the organization have an CI/CD process for publishing code in this workload?**
***

Implement lifecycle of continuous integration, continuous delivery (CI/CD) for applications. Have processes and tools in place that aid in an automated and gated CD/CD deployment process.

**How are the publishing methods secured?**
***
Application resources allowing multiple methods to publish app content, such as FTP, Web Deploy should have the unused endpoints disabled. For Azure Web Apps, SCM is the recommended endpoint. It can be protected separately with network restrictions for sensitive use cases.


## Next step
> [!div class="nextstepaction"]
> [Data flow](design-network-flow.md)

## Related links
> Go back to the main article: [Network security](design-network.md)