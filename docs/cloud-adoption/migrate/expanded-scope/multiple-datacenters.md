---
title: "Multiple datacenters"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Multiple datacenters
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Multiple datacenters

Often the scope of a migration involves the transition of multiple datacenters. The following guidance will expand the scope of the [Azure migration guide](../azure-migration-guide/index.md) to address multiple datacenters.

## General scope expansion

Most of this effort required in this scope expansion will occur during the prerequisites, assess, and optimization processes of a migration.

## Suggested prerequisites

Before beginning the migration, you should create epics within the project management tool to represent each datacenter to be migrated. It is then important to understand the business outcomes and motivations, which are justifying this migration. Those motivations can be used to prioritize the list of epics (or datacenters). For instance, if migration is driven by a desire to exit datacenters before leases must be renewed, then each epic would be prioritized based on lease renewal date.

Within each epic, the workloads to be assessed and migrated would be managed as features. Each asset within that workload would be managed as a user story. The work required to assess, migrate, optimize, promote, secure, and manage each asset would be represented as tasks for each asset.

Sprints or iterations would be then consist of a series of tasks required to migrate the assets and user stories committed to by the cloud adoption team. Releases would then consist of one or more workloads or features to be promoted to production.

## Assess process changes

The biggest change to the assess process, when expanding scope to address multiple datacenters, is related to the accurate recording and prioritization of workloads and dependencies across datacenters.

### Suggested action during the assess process

**Evaluate cross datacenter dependencies:** The [dependency visualization tools in Azure Migrate](/azure/migrate/concepts-dependency-visualization) can help pinpoint dependencies. Use of this tool set prior to migration is a good general best practice. However, when dealing with global complexity it becomes a necessary step to the assessment process. Through [dependency grouping](/azure/migrate/how-to-create-group-machine-dependencies), the visualization can help identify the IP addresses and ports of any assets required to support the workload.

> [!IMPORTANT]
> Two important notes: First, a subject matter expert with an understanding of asset placement and IP address schemas is required to identify assets that reside in a secondary datacenter. Second, it is important to evaluate both downstream dependencies and clients in the visual to understand bidirectional dependencies.

## Migrate process changes

Migrating multiple datacenters is similar to consolidating datacenters. After migration, the cloud becomes the singular datacenter solution for multiple assets. The most likely scope expansion during the migration process is the validation and alignment of IP addresses.

### Suggested action during the migrate process

The following are activities that heavily affect the success of a cloud migration:

- **Evaluate network conflicts:** When consolidating datacenters into a single cloud provider, there is a likelihood of creating network, DNS, or other conflicts. During migration, it is important to test for conflicts to avoid interruptions to production systems hosted in the cloud.
- **Update routing tables:** Often, modifications to routing tables are required when consolidating networks or datacenters.

## Optimize and promote process changes

During optimization, additional testing may be required.

### Suggested action during the optimize and promote process

Prior to promotion, it is important to provide additional levels of testing during this scope expansion. During testing, it is important to test for routing or other network conflicts. Further, it is important to isolate the deployed application and retest to validate that all dependencies have been migrated to the cloud. In this case, isolation means separating the deployed environment from production networks. Doing so can catch overlooked assets that are still running on-premises.

## Secure and manage process changes

Secure and manage processes should be unchanged by this scope expansion.

## Next steps

Return to the [Expanded Scope Checklist](./index.md) to ensure your migration method is fully aligned.

> [!div class="nextstepaction"]
> [Expanded scope checklist](./index.md)
