---
title: Networking cost estimates
description: Describes cost strategies for networking desgin choices
author:  PageWriter-MSFT
ms.date: 4/8/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

## Peering

<hr><b>Do you need to connect virtual networks?</b><hr>

Peering technology is a service used for Azure virtual networks to connect with other virtual networks in the same or different Azure region. Peering technology is used often in hub and spoke architectures. 

An important consideration are the additional costs incurred by peering connections on both egress and ingress traffic traversing the peering connections. 
> ![Task](../../_images/i_best-practices.png) Keeping the top talking services of a workload within the same virtual network, zone and/or region unless otherwise required. Use virtual networks as shared resources for multiple workloads against a single virtual network per workload approach. This approach will localize traffic to a single virtual network and avoid the additional costs on peering charges.

## Private connections from on-premises to cloud