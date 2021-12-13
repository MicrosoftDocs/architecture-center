---
title: Azure Batch and performance efficiency
description: Focuses on the Azure Batch service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to Service Performance.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-batch
categories:
  - compute
  - management-and-governance
---

# Azure Batch and performance efficiency

[Azure Batch](/azure/batch/batch-technical-overview) allows you to run large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure.

Use Azure Batch to:

- Create and manage a pool of compute nodes (virtual machines).
- Install applications you want to run.
- Schedule jobs to run on the compute nodes.

The following sections include a design checklist and recommended design options specific to Azure Batch.

## Design checklist

**Have you designed your workload and configured Azure Batch with performance efficiency in mind?**
***

> [!div class="checklist"]
> - Use fewer jobs and more tasks.

## Design and configuration recommendations

Consider the following recommendation to optimize your workload design and Azure Batch configuration for performance efficiency:

|Recommendation|Description|
|------------------|------------|
|Use fewer jobs and more tasks.|Using a job to run a single task is inefficient. For example, it's more efficient to use a single job containing `1000` tasks rather than creating `100` jobs that contain `10` tasks each. Running `1000` jobs, each with a single task, would be the least efficient, slowest, and most expensive approach.|

## Next step

> [!div class="nextstepaction"]
> [AKS and reliability](../azure-kubernetes-service/reliability.md)
