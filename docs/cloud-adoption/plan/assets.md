---
title: "Aligning assets to prioritized workloads"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Aligning assets to prioritized workloads
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Aligning assets to prioritized workloads

Workload is a conceptual description of a collection of assets: VMs, applications, and data sources. In the prior article, prioritize and define workloads, guidance is provided to collect the data that will define the workload. Prior to migration a few of the technical inputs in that list require additional validation. This article will help with validation of the following inputs:

**Applications:** List any applications included in this workload
**VMs/Servers:** List any VM or servers included in the workload
**Data sources:** List any data sources included in the workload
**Dependencies:** List any asset dependencies not included in the workload

There are several options to aggregate this data. The following are a few of the most common approaches.

## Alternative inputs: Migrate, Modernize, Innovate

The objective with these data points is to capture relative technical effort and dependencies, to aid in prioritization. Depending on the desired transition, alternative data points may need to be aggregated to support proper prioritization

**Migrate:** For pure migration efforts, the existing inventory and asset dependencies serve as a fair measure of relative complexity.
**Modernize:** When the goal for a workload is to modernize applications or other assets, these data points are still solid measures for complexity. However, it could be wise to add an input for modernization opportunities to the workload documentation.
**Innovate:** When data or business logic is undergoing material change during a cloud adoption effort, it is considered an innovate type of transformation. THe same is true when new data or new business logic is being created. For any innovate scenarios, the migration of assets will likely represent the smallest amount of effort required. For these scenarios, the team should devise a set of technical data inputs to measure relative complexity.

## Azure Migrate

Azure Migrate provides a set of grouping functions that can accelerate the aggregation of Applications, VMs, Data sources, and dependencies. Once workloads are defined conceptually, those workloads can be used as the basis for grouping assets based on dependency mapping.

The Azure Migrate article provides guidance on [how to group machines based on dependencies](https://docs.microsoft.com/azure/migrate/how-to-create-group-machine-dependencies).

## Configuration management database (CMDB)

Alternatively, for organizations who have a well maintained CMDB within their existing operations management tooling, the CMDB could be used to provide the above data points.

## Next steps

[Review rationalization decisions](./review-rationalization.md) based on asset alignment and workload definitions.

> [!div class="nextstepaction"]
> [Review rationalization decisions](./review-rationalization.md)
