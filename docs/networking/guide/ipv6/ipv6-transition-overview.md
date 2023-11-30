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

This guide outlines strategies for transitioning a IPv4 network environment in Azure to IPv6. Transitioning from IPv4 to IPv6 is a necessary evolution in internet technology. It involves updating virtual network infrastructures to support the IPv6 protocol. It's a move that is essential due to the near exhaustion of available IPv4 addresses. The IPv6 protocol not only provides a significantly larger pool of internet addresses to accommodate future growth but also offers enhanced security features (native IPSec), flow labeling, and simplified network configurations.

As organizations utilizing Azure already have IPv4 deployed, this guide gives instructions for transitioning resources to use IPv6 without disrupting the existing resources.

This guide provides instructions for how to enable IPv6 in your existing [Hub and Spoke network topology](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli).  This configuration allows you to use IPv6 in your existing IPv4 networks, and continue to use IPv4 network routing even while transitioning to IPv6.  However, it does not enable IPv6 only communication for services.

This guide covers the following elements:

- [IP Space Planning for IPv6 Networks](ipv6-ip-planning.md) in Azure, to guide you in planning your address blocks for your environment.
- [Transitioning Hub Networks to IPv6](ipv6-transition-hub.md), to guide you on updating your hub network to using IPv6 to act as a connection point between workload spokes, hybrid connectivity, and the hosting of shared network appliances.

To understand more about the capabilities of IPv6 virtual networks, see [IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview).

## Next steps

- Learn more about [IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview)
- Begin your [IP Space Planning for IPv6 Networks](ipv6-ip-planning.md)
- Learn steps for [Transitioning Hub Networks to IPv6](ipv6-transition-hub.md)
