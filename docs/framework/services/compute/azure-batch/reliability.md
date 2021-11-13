---
title: Azure Batch and reliability
description: Focuses on the Azure Batch service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to Service Reliability.
author: v-stacywray
ms.date: 10/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-batch
categories:
  - compute
  - management-and-governance
---

# Azure Batch and reliability

[Azure Batch](/azure/batch/batch-technical-overview) allows you to run large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure.

Use Azure Batch to:

- Create and manage a pool of compute nodes (virtual machines).
- Install applications you want to run.
- Schedule jobs to run on the compute nodes.

The following sections include a design and configuration checklist, recommended design, and configuration options specific to Azure Batch.

## Design and configuration checklist

**Have you designed your workload and configured Azure Batch with resiliency in mind?**
***

> [!div class="checklist"]
> - Keep application binaries and reference data up to date in all regions.
> - Use fewer jobs and more tasks.
> - Use multiple Batch accounts in various regions to allow your application to continue running, if an Azure Batch account in one region becomes unavailable.
> - Build durable tasks.
> - Pre-create all required services in each region, such as the Batch account and storage account.
> - Make sure the appropriate quotas are set on all subscriptions ahead of time, so you can allocate the required number of cores using the Batch account.

## Design and configuration recommendations

Explore the following table of recommendations to optimize your workload design and Azure Batch configuration for service reliability:

|Recommendation|Description|
|------------------|------------|
|Keep application binaries and reference data up to date in all regions.|Staying up to date will ensure the region can be brought online quickly without waiting for file upload and deployment.|
|Use fewer jobs and more tasks.|Using a job to run a single task is inefficient. For example, it's more efficient to use a single job containing `1000` tasks rather than creating `100` jobs that contain `10` tasks each. Running `1000` jobs, each with a single task, would be the least efficient, slowest, and most expensive approach.|
|Use multiple Batch accounts in various regions to allow your application to continue running, if an Azure Batch account in one region becomes unavailable.|It's crucial to have multiple accounts for a highly available application.|
|Build durable tasks.|Tasks should be designed to withstand failure and accommodate retry, especially for long running tasks. Ensure tasks generate the same, single result even if they're run more than once. One way to achieve the same result is to make your tasks *goal seeking*. Another way is to make sure your tasks are *idempotent* (tasks will have the same outcome no matter how many times they're run).|
|Pre-create all required services in each region, such as the Batch account and storage account.|There's often no charge for creating accounts and charges accrue only when you use the account, or when you store data.|

## Next step

> [!div class="nextstepaction"]
> [Azure Batch and operational excellence](./operational-excellence.md)
