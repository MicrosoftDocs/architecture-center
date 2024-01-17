# Hybrid DNS Solutions in Azure
One of the primary challenges organizations face when transitioning to the cloud is managing DNS. In traditional setups, on-premises DNS servers handle name resolution, typically involving multiple machines that host internal zones and forward requests for public domains to external DNS servers.

However, operating in a hybrid environment, where resources are distributed between on-premises and cloud settings, introduces additional complexities. When addressing these challenges, several common questions arise:

- Should we adopt a lift-and-shift approach?
- What architectural modifications are necessary?
- Can we leverage any native cloud capabilities?
- How do we ensure our DNS solution clearly defines traffic flow?

Navigating these issues can be overwhelming. The purpose of this guide is to outline prevalent DNS solutions, explore the advantages and disadvantages of each, and assist in making a well-informed decision. Unfortunately, there is no universal 'best' or 'one-size-fits-all' solution. This is true for most cloud deployments, and DNS solutions are no exception.

## Assessment
Before exploring the various DNS solutions, it's crucial to thoroughly assess your current DNS setup and define the objectives for the new solution. The aim is to gain a comprehensive understanding of the existing situation and what you wish to achieve with the upgrade.

Often, organizations, especially those new to cloud environments or under pressure to meet tight deadlines, rush into decisions without a well-thought-out plan. This haste can lead to technical debt and the need for retroactive fixes, which is far from ideal.

For instance, if your organization has specific requirements, such as avoiding an IaaS (Infrastructure as a Service) platform due to internal or external compliance rules, certain solutions might not be suitable. On the other hand, if other requirements are more pressing, you may find your options limited. It's important to remember that revisiting the planning stage after deployment is a scenario best avoided.

### Identify Different Workloads
---
Begin by cataloging the various workloads, such as offices in different regions, remote user access, application-specific DNS requirements, proxy usage, dependencies, and DNS traffic flows. Documenting these details is essential to identify potential blind spots proactively, rather than addressing them retrospectively.  

### Identify the technical and business requirements
---
Determine the compliance requirements and any limitations on services for the new DNS solution. Consider specific targets such as Recovery Time Objectives (RTO) and Service Level Agreements (SLAs). A good starting point is to reference the Well-Architected Framework (WAF) and assess how your solution aligns with its pillars. This step is vital for understanding the framework within which your solution must operate.

### Set Clear Goals and Document Challenges
---
Identify the unique challenges your organization faces, drawing on lessons learned. Set explicit objectives for what issues the new solution should resolve. Remember, each environment is unique, and you may encounter challenges specific to your organization. Document these findings and establish clear strategies for addressing them.  

### Analyze Impact and Plan for Traffic Flow
---
Assess the potential impact of DNS changes and plan measures to mitigate this impact. Ensure clarity in how DNS traffic will flow and understand its implications on routing and security. Avoiding ambiguity in traffic flow is crucial for a successful implementation.

## DNS Solution 1
![](https://github.com/infobozk/architecture-center/blob/a0635858802c1b138f1c44f474b9d861c31f998e/docs/hybrid/images/hybrid-dns-infra-1.png)

This scenario outlines a popular DNS solution involving:

- Local DNS servers at on-premises locations.
- Connectivity to Azure through ExpressRoute and/or VPN.
- IaaS DNS virtual machines (VMs) hosted in Azure.

This design is straightforward and familiar to most managing teams. It effectively extends the existing DNS solution by incorporating Azure as 'another datacenter'.

Benefits:

- **DNSSec Support:** Available with Windows DNS Service and select third-party solutions.
- **DNS Policy:** Enables filters and split-brain operations.
- **Automatic Zone Replication:** All hosted zones are automatically replicated, with optional modifications.
- **Cross-Cloud Compatibility:** Functions across different cloud providers.
- **Centralized Management:** Central servers can host zones, while local servers (e.g., in branch offices) can operate in a read-only mode, allowing centralized management of DNS entries.

Disadvantages:

- **Maintenance of IaaS Components:** These components require ongoing maintenance.
- **Limited Automation in Non-Domain Environments:** While AD-domain joined machines automatically receive DNS entries, environments without domain use may need additional automation or tooling for updating the hosted zone.

When resolving names for Azure resources, such as PrivateLink endpoints, there are several approaches to consider:

- **Direct Hosting on DNS Servers:** The zones can be hosted directly on the DNS servers, eliminating the need for conditional forwarding.
- **Using Private DNS Zones:** This option involves utilizing Azure Private DNS Zones. In this case, on-premises servers will need a conditional forwarding rule to direct DNS queries to Azure-hosted DNS virtual machines. These virtual machines must have the Private DNS Zone linked to their Virtual Network.
- **Centralized DNS Servers:** Some organizations prefer using Azure-hosted DNS VMs as primary servers, with local servers in read-only mode. This setup offers a single-pane-of-glass approach, centralizing most DNS administrative tasks.
- **Setup and Maintenance of Conditional Forwarding Rules**: These rules need to be established and regularly maintained.
- **Dependency on Connectivity**: Choosing the conditional forwarding option creates a reliance on the network connection between on-premises infrastructure and Azure. For effective name resolution, this connection must be active. In most scenarios, if the connection is down, traffic won't flow in either direction, making name resolution redundant. However, in certain cases, this dependency might not be desirable. It's important to consider this when planning your infrastructure.

## DNS Solution 2
![](https://github.com/infobozk/architecture-center/blob/a0635858802c1b138f1c44f474b9d861c31f998e/docs/hybrid/images/hybrid-dns-infra-2.png)
This variation involves replacing the IaaS VM in Azure with the Azure Private DNS Resolver, a managed solution. It requires two dedicated subnets for its inbound and outbound endpoints. From the on-premises perspective, DNS queries are forwarded to the private IP addresses of the inbound endpoints. The traffic flow is similar to Scenario 2, but the key difference is the absence of DNS servers running in Azure.

Benefits:
- **Fully Managed:** Offers built-in high availability and zone redundancy.
- **Cost Reduction:** Lower operating costs compared to traditional IaaS solutions.
- **Private Access:** Enables conditional forwarding to and from on-premises for Private DNS zones.
- **Scalability:** High performance for each endpoint. DevOps Friendly: Compatible with Terraform, ARM, or Bicep for pipeline building.

Potential drawbacks:

- **No DNSSec Support:** This feature is not available with Azure Private DNS Resolver.
- **Limited Policy Functionality:** Offers less policy control compared to traditional DNS servers.
- **No IPv6 Support:** Currently does not support IPv6.

## DNS Solution 3
![](https://github.com/infobozk/architecture-center/blob/5322fa65c5b3e4d6b18c516c0240781292e1382b/docs/hybrid/images/hybrid-dns-infra-3.png)

This architecture is a variation of DNS Solution 2, featuring the use of the centralized Azure Firewall as the primary DNS endpoint for Azure resources. The key benefits of this approach include:

- **Singular DNS Endpoint:** All Azure resources use the Azure Firewall for DNS queries, centralizing DNS management.
- **Enhanced Logging:** The Azure Firewall logs all DNS entries, simplifying the tracking and analysis of DNS queries.
- **Simplified Configuration:** Managing DNS settings becomes more streamlined with a single point of configuration.
- **Simplified Compliance:** For organizations that need to comply with various regulatory standards, using Azure Firewall can simplify compliance efforts, as it adheres to Azure's compliance certifications and standards.
Potential Disadvantage:

In this setup, the Azure Firewall is configured to serve as the DNS server. It leverages the default Azure-provided DNS service for resolving internet-based Fully Qualified Domain Names (FQDNs). Additionally, this solution incorporates the DNS Forwarding Rulesets of the DNS Private Resolver.

Since the Azure Firewall does not support conditional forwarding, additional components are still necessary to forward DNS queries to
the on-premises DNS servers. This ensures that name resolution for internal resources is handled effectively, despite the lack of conditional forwarding capability in the Azure Firewall itself.

# Summary
The solutions outlined represent some of the more commonly used options in our toolkit. However, it's crucial to remember that the cloud environment is continuously evolving. Best practices and recommendations are subject to change over time. Always consider this dynamic nature when referring to this or any other guideline.
