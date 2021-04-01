---
title: Network security strategies on Azure
description: Best practices for network security in Azure, including network segmentation, network management, containment strategy, and internet edge strategy.
author: PageWriter-MSFT
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Network security

Protect assets by placing controls on network traffic originating in Azure, between on-premises and Azure hosted resources, and traffic to and from Azure. If security measures aren't in place attackers can gain access, for instance, by scanning across public IP ranges. Proper network security controls can provide defense-in-depth elements that help detect, contain, and stop attackers who gain entry into your cloud deployments. 

## Checklist
**How have you secured the network of your workload?**
***

> [!div class="checklist"]
> - Segment your network footprint and create secure communication paths between segments. Align the network segmentation with overall enterprise segmentation strategy.
> - Design security controls that identify and allow or deny traffic, access requests, and application communication between segments. 
> - Protect all public endpoints with Azure Front Door, Application Gateway, Azure Firewall, Azure DDoS Protection.
> - Mitigate DDoS attacks with DDoS **Standard** protection for critical workloads.
> - Prevent direct internet access of virtual machines.
> - Control network traffic between subnets (east-west) and application tiers (north-south).
> - Protect from data exfiltration attacks through a defense-in-depth approach with controls at each layer.


## In this section
Follow these questions to assess the workload at a deeper level. The recommendations in this section are based on using Azure Virtual Networking. 

|Assessment|Description|
|---|---|
|[**How does the organization implement network segmentation to detect and contain adversary movement?**](design-network-segmentation.md)|Create segmentation in your network footprint to group the related assets and isolation. Align the network segmentation with the enterprise segmentation strategy.
|[**Should this workload be accessible from public IP addresses?**](design-network-connectivity.md)|Use native Azure networking feature to restrict access to individual application services. Explore multiple levels (such as IP filtering or firewall rules) to prevent application services from being accessed by unauthorized actors.|
|[**Are public endpoints of this workload protected?**](design-network-endpoints.md)|Use Azure Firewall to protect Azure Virtual Network resources. Web Application Firewall (WAF) mitigates the risk of an attacker being able to exploit commonly known security application vulnerabilities like cross-site scripting or SQL injection.|
|[**Is the traffic between subnets, Azure components and tiers of the workload managed and secured?**](design-network-flow.md)|Place controls between subnets of a VNet. Detect threats by allowing or denying ingress and egress traffic.|

## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to the [Azure Security Benchmarks Network Security](/azure/security/benchmarks/security-controls-v2-network-security).

## Azure services
- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview)
- [Azure Firewall](/azure/firewall/overview)
- [Azure ExpressRoute](/azure/expressroute/)
- [Azure Private Link](/azure/private-link/)

## Reference architecture
Here are some reference architectures related to network security:

- [Hub-spoke network topology in Azure](../../reference-architectures/hybrid-networking/hub-spoke.yml)
- [Deploy highly available NVAs](../../reference-architectures/dmz/nva-ha.yml)
- [Windows N-tier application on Azure with SQL Server](../../reference-architectures/n-tier/n-tier-sql-server.yml)
- [Azure Kubernetes Service (AKS) production baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml)


## Next steps

Monitor the communication between segments. Use data to identify anomalies, set alerts, or block traffic to mitigate the risk of attackers crossing segmentation boundaries. 

> [!div class="nextstepaction"]
> [Monitor identity, network, data risks](./monitor-identity-network.md)

## Related links

Combine network controls with application, identity, and other technical control types. This approach is effective in preventing, detecting, and responding to threats outside the networks you control. For more information, see these articles:
- [Applications and services security](design-apps-services.md)
- [Identity and access management considerations](design-identity.md)
- [Data protection](design-storage.md)

Ensure that resource grouping and administrative privileges align to the segmentation model. For more information, see [Administrative account security](design-admins.md).


> Go back to the main article: [Security](overview.md)