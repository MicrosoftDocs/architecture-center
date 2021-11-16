---
title: Best practices for endpoint security
description: Examine best practices for protecting application endpoints in Azure. Explore public endpoints. Mitigate distributed denial-of-service (DDoS) attacks.
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
categories:
  - networking
---

# Best practices for endpoint security on Azure

An *endpoint* is an address exposed by a web application so that external entities can communicate with it. A malicious or an inadvertent interaction with the endpoint can compromise the security of the application and even the entire system. One way to protect the endpoint is by placing filter controls on the network traffic that it receives, such as defining rule sets. A defense-in-depth approach can further mitigate risks. Include supplemental controls that protect the endpoint if the primary traffic controls fail.

This article describes way in which you can protect web applications with Azure services and features. For product documentation, see Related links.

## Key points

- Protect all public endpoints with Azure Front Door, Application Gateway, Azure Firewall, Azure DDoS Protection.
- Use web application firewall (WAF) to protect web workloads.
- Protect workload publishing methods and restrict ways that are not in use.
- Mitigate DDoS attacks. Use Standard protection for critical workloads where outage would have business impact. Also consider CDN as another layer of protection.
- Develop processes and procedures to prevent direct internet access of virtual machines (such as proxy or firewall) with logging and monitoring to enforce policies.
- Implement an automated and gated CI/CD deployment process.

## Public endpoints

A public endpoint receives traffic over the internet. The endpoints make the service easily accessible to attackers.

Service Endpoints and Private Link can be leveraged to restrict access to PaaS endpoints only from authorized virtual networks, effectively mitigating data intrusion risks and associated impact to application availability. Service Endpoints provide service level access to a PaaS service, while Private Link provides direct access to a specific PaaS resource to mitigate data exfiltration risks such as malicious admin scenarios.

Configure service endpoints and private links where appropriate.

**Are all public endpoints of this workload protected?**

---

An initial design decision is to assess whether you need a public endpoint at all. If you do, protect it by using these mechanisms.

For more information, see [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) and [What is Azure Private Endpoint?](/azure/private-link/private-endpoint-overview)

### Web application firewalls (WAFs)

WAFs provide a basic level of security for web applications. WAFs are appropriate if the organizations that have invested in application security as WAFs provide additional defense-in-depth mitigation.

WAFs mitigate the risk of an attacker to exploit commonly seen security vulnerabilities for applications. WAFs provide a basic level of security for web applications. This mechanism is an important mitigation because attackers target web applications for an ingress point into an organization (similar to a client endpoint).

External application endpoints should be protected against common attack vectors, from Denial of Service (DoS) attacks like Slowloris to app-level exploits, to prevent potential application downtime due to malicious intent. Azure-native technologies such as Azure Firewall, Application Gateway/Azure Front Door, WAF, and DDoS Protection Standard Plan can be used to achieve requisite protection (Azure DDoS Protection).

Azure Application Gateway has WAF capabilities to inspect web traffic and detect attacks at the HTTP layer. It's a load balancer and HTTP(S) full reverse proxy that can do secure socket layer (SSL) encryption and decryption.

For example, your workload is hosted in Application Service Environments(ILB ASE). The APIs are consolidated internally and exposed to external users. This external exposure could be achieved using an Application Gateway. This service is a load balancer. It forwards request to the internal API Management service, which in turn consumes the APIs deployed in the ASE. Application Gateway is also configured over port 443 for secured and reliable outbound calls.

> [!TIP]
>
> The design considerations for the preceding example are described in [Publishing internal APIs to external users](../../example-scenario/apps/publish-internal-apis-externally.yml).

Azure Front Door and Azure Content Delivery Network (CDN) also have WAF capabilities.

#### Suggestion actions

Protect all public endpoints with appropriate solutions such as Azure Front Door, Application Gateway, Azure Firewall, Azure DDOS Protection, or any third-party solution.

**Learn more**

- [What is Azure Firewall?](/azure/firewall/overview)
- [Azure DDoS Protection Standard overview](/azure/ddos-protection/ddos-protection-overview)
- [Azure Front Door documentation](/azure/frontdoor/)
- [What is Azure Application Gateway?](https://azure.microsoft.com/services/application-gateway/#overview)

### Azure Firewall

Protect the entire virtual network against potentially malicious traffic from the internet and other external locations. It inspects incoming traffic and only passes the allowed requests to pass through.

A common design is to implement a DMZ or a perimeter network in front of the application. The DMZ is a separate subnet with the firewall.

> [!TIP]
> The design considerations are described in [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml).

### Combination approach

When you want higher security and there's a mix of web and non-web workloads in the virtual network use both Azure Firewall and Application Gateway. There are several ways in which those two services can work together.

For example, you want to filter egress traffic. You want to allow connectivity to a specific Azure Storage Account but not others. You'll need fully qualified domain name (FQDN)-based filters. In this case run Firewall and Application Gateway in parallel.

Another popular design is when you want Azure Firewall to inspect all traffic and WAF to protect web traffic, and the application needs to know the client's source IP address. In this case, place Application Gateway in front of Firewall. Conversely, you can place Firewall in front of WAF if you want to inspect and filter traffic before it reaches the Application Gateway.

For more information, see [Firewall and Application Gateway for virtual networks](../../example-scenario/gateway/firewall-application-gateway.yml).

It's challenging to write concise firewall rules for networks where different cloud resources dynamically spin up and down. Use [Microsoft Defender for Cloud](/azure/security-center/) to detect misconfiguration risks.

### Authentication

Disable insecure legacy protocols for internet-facing services. Legacy authentication methods are among the top attack vectors for cloud-hosted services. Those methods don't support other factors beyond passwords and are prime targets for password spraying, dictionary, or brute force attacks.

## Mitigate DDoS attacks

In a distributed denial-of-service (DDoS) attack, the server is overloaded with fake traffic. DDoS attacks are common and can be debilitating. An attack can completely block access or take down  services. Make sure all business-critical web application and services have DDoS mitigation beyond the default defenses so that the application doesn't experience downtime because that can negatively impact business.

Microsoft recommends adopting advanced protection for any services where downtime will have negative impact on the business.

**How do you implement DDoS protection?**
***

Here are some considerations:

- DDoS protection at the infrastructure level in which your workload runs. Azure infrastructure has built-in defenses for DDoS attacks.
- DDoS protection at the network (layer 3) layer. Azure provides additional protection for services provisioned in a virtual network.
- DDoS protection with caching. Content delivery network (CDN) can add another layer of protection. In a DDoS attack, a CDN intercepts the traffic and stops it from reaching the backend server. Azure CDN is natively protected. Azure also supports popular CDNs that are protected with proprietary DDoS mitigation platform.
- Advanced DDoS protection. In your security baseline, consider features with monitoring techniques that use machine learning to detect anomalous traffic and proactively protect your application before service degradation occurs.

For example, the [Windows N-tier application on Azure with SQL Server](../../reference-architectures/n-tier/n-tier-sql-server.yml) reference architecture uses Azure DDoS Protection Standard because this option:
- Uses adaptive tuning, based on the application's network traffic patterns, to detect threats.
- Guarantees 100% SLA.
- Can be cost effective. For example, during a DDoS attack, the first set of attacks cause the provisioned resources to scale out. For a resource such as a virtual machine scale set, 10 machines can grow to 100, increasing overall costs. With Standard protection, you don't have to worry about the cost of the scaled resources because Azure will provide a cost credit.

For information about Azure DDoS Protection services, see [Azure DDoS Protection Standard documentation](/azure/ddos-protection/).

### Suggested action

Identify critical workloads that are susceptible to DDoS attacks and enable Distributed Denial of Service (DDoS) mitigations for all business-critical web applications and services.

### Learn more

For a list of reference architectures that demonstrate the use of DDoS protection, see [Azure DDoS Protection reference architectures](/azure/ddos-protection/ddos-protection-reference-architectures).

## Adopt DevOps

Developers shouldn't publish their code directly to app servers.

**Does the organization have an CI/CD process for publishing code in this workload?**

---

Implement lifecycle of continuous integration, continuous delivery (CI/CD) for applications. Have processes and tools in place that aid in an automated and gated CI/CD deployment process.

**How are the publishing methods secured?**

---

Application resources allowing multiple methods to publish app content, such as FTP, Web Deploy should have the unused endpoints disabled. For Azure Web Apps, SCM is the recommended endpoint. It can be protected separately with network restrictions for sensitive use cases.

## Next step

> [!div class="nextstepaction"]
> [Data flow](design-network-flow.md)

### Related links

- [Azure Firewall](/azure/firewall/overview)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)
- [Azure DDoS Protection Standard](/azure/ddos-protection/)

> Go back to the main article: [Network security](design-network.md)
