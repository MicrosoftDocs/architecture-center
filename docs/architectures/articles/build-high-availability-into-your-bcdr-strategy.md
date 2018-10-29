---
title: Build high availability into your BCDR strategy
description: Virtual machines (VMs) are physically separated
across zones, and a virtual network is created
using load balancers at each site. These locations
are close enough for high availability replication,
so your applications stay running, despite any
issues at the physical locations.
author: adamboeglin
ms.date: 10/29/2018
---
# Build high availability into your BCDR strategy

## Architecture
<img src="media/build-high-availability-into-your-bcdr-strategy.svg" alt='architecture diagram' />

## Data Flow
1. Create zone-redundant Load Balancer
1. Create front-end subnet
1. Create DB subnet
1. Create VMs in three Availability Zones
1. Configure zone-redundant SQL DB
1. Add VMs to the load balancers back-end pool
1. Deploy your application on VMs for redundancy and high availability