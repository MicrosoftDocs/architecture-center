---
title: Data management for cost optimization
description: Describes some of the decisions you may need to make when optimizaing your data footprint for cost.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Data management for cost optimization

## Optimize data transfer
Data Transfer costs, most notably, network egress from Azure are areas typically not factored in to multi-cloud and hybrid architecture decisions. Not understanding the true cost of network transfer is a key area often overlooked.

## Data retention and archival
In typical systems, not all data needs to be available for online processing. Data no longer needed can be removed, freeing up underlying storage.

## Tiered storage
In typical systems, not all data needs to be available for online processing. For the data that needs to be retained long-term, finding the right tradeoffs on durability and latency against costs allows for cost changes.

## Appropriate storage services
Some types of storage are better suited to different workloads.