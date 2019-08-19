---
title: "Executing a migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Executing a migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Execute a migration

After a workload has been assessed, it can be migrated to the cloud. This series of articles explains the various activities that may be involved in the execution of a migration.

## Objective

The objective of a migration is to migrate a single workload to the cloud.

## Definition of *done*

The migration phase is complete when a workload is staged and ready for testing in the cloud, including all dependent assets required for the workload to function. During the optimize process, the workload is prepared for production usage.

This definition of *done* can vary, depending on your testing and release processes. The next article in this series covers [deciding on a promotion model](./promotion-models.md) and can help you understand when it would be best to promote a migrated workload to production.

## Accountability during migration

The cloud adoption team is accountable for the entire migration process. However, members of the cloud strategy team have a few responsibilities, as discussed in the following section.

## Responsibilities during migration

In addition to the high-level accountability, there are actions that an individual or group needs to be directly responsible for. The following are a few activities that require assignments to responsible parties:

- **Remediation.** Resolve any compatibility issues that prevent the workload from being migrated to the cloud.
  - As discussed in the prerequisite article regarding [technical complexity and change management](../prerequisites/technical-complexity.md), a decision should be made in advance to determine how this activity is to be executed. In particular, will remediation be completed by the cloud adoption team during the same sprint as the actual migration effort? Alternatively, will a wave or factory model be used to complete remediation in a separate iteration? If the answer to this basic process question can't be answered by every member of the team, it may be wise to revisit the section on [prerequisites](../prerequisites/index.md).
- **Replication.** Create a copy of each asset in the cloud to synchronize VMs, data, and applications with resources in the cloud.
  - Depending on the promotion model, different tools may be required to complete this activity.
- **Staging.** After all assets for a workload have been replicated and verified, the workload can be staged for business testing and execution of a business change plan.

## Next steps

With a general understanding of the migration process, you are ready to [decide on a promotion model](./promotion-models.md).

> [!div class="nextstepaction"]
> [Decide on a promotion model](./promotion-models.md)
