---
title: Network security strategies
description: Best practices for network security in Azure, including network segmentation, network management, containment strategy, and internet edge strategy.
author: PageWriter-MSFT
ms.date: 09/07/2020
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
- Protect non-public accessible services with network restrictions / IP firewall.
- Design security controls that identify and allow expected traffic, access requests, and application communication between segments.


## In this section
Follow these questions to assess the workload at a deeper level. The recommendations in this section are based on using Azure Virtual Networking. 

|Assessment|Description|
|---|---|
|[**Does the organization identify and isolate groups of resources from other parts of the organization to aid in detecting and containing adversary movement within the enterprise?**](design-network-segmentation.md)|Create segmentation in your network footprint to group the related assets and isolation. Align the network segmentation with the enterprise segmentation strategy.|accounts) identities at a central location.|
|[**Should the services of this workload be accessible from public IP addresses**](design-network-connectivity.md)|Use native Azure networking feature to restrict access to individual application services. Explore multiple levels (such as IP filtering or firewall rules) to prevent application services from being accessed by unauthorized actors.|

## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to the [Azure Security Benchmarks Network Security](/azure/security/benchmarks/security-controls-v2-network-security).

## Azure services
[Azure Virtual Network](/azure/virtual-network/virtual-networks-overview)
[Azure Firewall](/azure/firewall/overview)
[Azure ExpressRoute](/azure/expressroute/)
[Azure Private Link](/azure/private-link/)


## Reference architecture
Here are some reference architectures related to network security:

[Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)

## Next steps

Monitor the communication between segments. Use data to identify anomalies, set alerts, or block traffic to mitigate the risk of attackers crossing segmentation boundaries. 

> [!div class="nextstepaction"]
> [Monitor identity, network, data risks](/azure/architecture/framework/security/monitor-identity-network)

## Related links

Combine network controls with application, identity, and other technical control types. This approach is effective in preventing, detecting, and responding to threats outside the networks you control. For more information see these articles:
- [Applications and services security](design-apps-services.md)
- [Identity and access management considerations](design-identity.md)
- [Data protection](design-storage.md)

Ensure that resource grouping and administrative privileges align to the segmentation model. For more information, see [Administrative account security](design-admins.md).


> Go back to the main article: [Security](overview.md)