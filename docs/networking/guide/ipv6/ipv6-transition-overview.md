---
title: Overview of Transitioning to IPv6
description: Get started with transitioning your existing Azure networks and resources to IPv6.  Review key planning activities and guidance for adopting IPv6.
author: bsteph
ms.author: bstephenson
ms.date: 10/25/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-network
categories:
  - networking
---

# Overview of Transitioning to IPv6

This guide outlines a strategy for transitioning a heritage IPv4 network environment in Azure to one that takes advantage of IPv6 addresses.  IPv6 is being adopted by many organizations to be compliant with new regulations and mandates and to allow their business to grow unhindered by a lack of IPv4 addresses. By using IPv6, organizations can take advantage of built-in security features such as IPSec  and flow labeling, improved performance, and simplified network configurations as well as the larger volume of IP addresses.

As organizations utilizing Azure already have IPv4 deployed, this guide gives instructions for transitioning resources to use IPv6 without disrupting the existing resources.

The discussion below discusses how to enable IPv6 in your existing [Hub and Spoke network topology](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli).

This guide will review the following elements:

- [IP Space Planning for IPv6 Networks](ipv6-ip-planning.md) in Azure, to guide you in planning your address blocks for your environment.
- [Transitioning Hub Networks to IPv6](ipv6--transition-hub.md), to guide you on updating your hub network to using IPv6 to act as a connection point between workload spokes, hybrid connectivity, and the hosting of shared network appliances.

To understand more about the capabilities of IPv6 virtual networks, see [IPv6 for Azure Vnet](https://learn.microsoft.com/azure/virtual-network/ip-services/ipv6-overview).

## Next steps

- Learn more about [IPv6 for Azure Vnet](/azure/virtual-network/ip-services/ipv6-overview)
- Begin your [IP Space Planning for IPv6 Networks](ipv6-ip-planning.md)
- Learn steps for [Transitioning Hub Networks to IPv6](ipv6--transition-hub.md)
