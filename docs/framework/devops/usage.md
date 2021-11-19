---
title: Usage monitoring
description: Provides information and requirements for usage monitoring as it relates to monitoring and diagnostics. 
author: v-stacywray
ms.date: 11/16/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Usage monitoring

Usage monitoring tracks how the features and components of an application are used.

This article describes how you can use the data gathered from usage monitoring to gain insight into operational events that affect your application and workloads.

## Benefits of usage monitoring

The following list explores the use cases for data gathered from usage monitoring:

- Determine which features you use heavily and determine any potential hotspots in the system. High-traffic elements may benefit from functional partitioning or even replication to spread the load more evenly. You can use this information to figure out which features you don't use often and possible candidates for retirement, or replacement in a future version of the system.
- Collect information about the operational events of the system under normal use. For example, in an e-commerce site, you can record the statistical information about the number of transactions and the volume of customers that are responsible for them. You can use this information for capacity planning as the number of customers grows.
- Detect user satisfaction with the performance or functionality of the system. For example, if a large number of customers in an e-commerce system regularly abandon their shopping carts, this behavior may mean there's a problem with the checkout functionality.
- Generate billing information. An application or service may charge customers for the resources they use.
- Enforce quotas. If a user exceeds their paid quota of processing time or resource usage during a specific period, the system can limit their access or throttle processing.

## Requirements for usage monitoring

To analyze system usage, you'll need monitoring information that includes:

- The number of requests that each subsystem processes and directs to each resource.
- The work that each user does.
- The volume of data storage that each user occupies.
- The resources that each user accesses.

## Requirements for data collection

You can track usage at a relatively high level. Usage tracking can note the start and end times of each request and the nature of the request, such as read, write, and so on, depending on the resource in question. Retrieve this information through the following ways:

- Trace user activity.
- Capture performance counters that measure the usage for each resource.
- Monitor each users' resource consumption.

For accounting purposes, you'll want to identify which users are responsible for doing which operations, and the resources that these operations use. The gathered information should be detailed enough for accurate billing.

## Next steps

> [!div class="nextstepaction"]
> [Issue tracking](./issue-tracking.md)