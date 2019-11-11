---
title: "Aligning assets to prioritized workloads"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Aligning assets to prioritized workloads
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Align assets to prioritized workloads

Workload is a conceptual description of a collection of assets: VMs, applications, and data sources. The previous article, [Prioritize and define workloads](./workloads.md), gave guidance for collecting the data that will define the workload. Before migration, a few of the technical inputs in that list require additional validation. This article helps with validation of the following inputs:

- **Applications**: List any applications included in this workload.
- **VMs/Servers**: List any VMs or servers included in the workload.
- **Data sources**: List any data sources included in the workload.
- **Dependencies**: List any asset dependencies not included in the workload.

There are several options for assembling this data. The following are a few of the most common approaches.

## Alternative inputs: Migrate, Modernize, Innovate

The objective of the preceding data points is to capture relative technical effort and dependencies as an aid to prioritization. Depending on the transition you want, you may need to gather alternative data points to support proper prioritization.

**Migrate:** For pure migration efforts, the existing inventory and asset dependencies serve as a fair measure of relative complexity.

**Modernize:** When the goal for a workload is to modernize applications or other assets, these data points are still solid measures of complexity. However, it might be wise to add an input for modernization opportunities to the workload documentation.

**Innovate:** When data or business logic is undergoing material change during a cloud adoption effort, it's considered an *innovate* type of transformation. The same is true when you're creating new data or new business logic. For any innovate scenarios, the migration of assets will likely represent the smallest amount of effort required. For these scenarios, the team should devise a set of technical data inputs to measure relative complexity.

## Azure Migrate

Azure Migrate provides a set of grouping functions that can speed up the aggregation of applications, VMs, data sources, and dependencies. After workloads have been defined conceptually, they can be used as the basis for grouping assets based on dependency mapping.

The Azure Migrate documentation provides guidance on [how to group machines based on dependencies](https://docs.microsoft.com/azure/migrate/how-to-create-group-machine-dependencies).

## Configuration-management database

Some organizations have a well-maintained configuration-management database (CMDB) within their existing operations-management tooling. They could use the CMDB alternatively to provide the input data points discussed earlier.

## Next steps

[Review rationalization decisions](./review-rationalization.md) based on asset alignment and workload definitions.

> [!div class="nextstepaction"]
> [Review rationalization decisions](./review-rationalization.md)
