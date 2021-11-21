---
title: Network security strategies on Azure
description: Best practices for network security in Azure, including network segmentation, network management, containment strategy, and internet edge strategy.
author: PageWriter-MSFT
ms.date: 02/03/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
categories:
  - security
subject:
  - security
  - networking
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

We recommend applying as many as of the best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program.

> [!div class="nextstepaction"]
> [Data protection](./design-storage.md)

## Related links

Combine network controls with application, identity, and other technical control types. This approach is effective in preventing, detecting, and responding to threats outside the networks you control. For more information, see these articles:
- [Applications and services security](design-apps-services.md)
- [Identity and access management considerations](design-identity.md)
- [Data protection](design-storage.md)

Ensure that resource grouping and administrative privileges align to the segmentation model. For more information, see [Administrative account security](design-admins.md).

> Go back to the main article: [Security](overview.md)
