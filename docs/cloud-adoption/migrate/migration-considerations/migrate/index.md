---
title: "Executing a migration"
description: Executing a migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Executing a migration

Once a workload has been assessed, it can be migrated to the cloud. This article series will explain the various activities that may be involved in the execution of a migration.

## Objective

The objective of a migration is to migrate a single workload to the cloud.

## Definition of Done

The migration phase is complete, when an application or workload is staged and ready for testing in the cloud. Including all dependent assets required for the application to function. During the optimize process, the workload is prepared for production usage.

This definition of done is contrary to what many readers may expect. In some cases, teams will introduce production users to a migrated workload during this phase. While not usually suggested, it can be an effective approach to execution, especially in smaller or less complex migrations. The next article in this series, [Deciding on a promotion model](./promotion-models.md) can help the reader understand when it would be best to promote a migrated workload to production.

## Accountability during migration

The cloud adoption team is accountable for the entire migrate process. However, members of the cloud strategy team will have a few responsibilities as listed below.

## Responsibilities during migration

In addition to the high level accountability, there are a number of actions that an individual or group of individuals will need to be directly responsible for. The following are a few activities that will require assignments to responsible parties.

* **Remediation:** Resolve any compatibility issues that prevent the workload from being migrated to the cloud.
    * As discussed in the pre-requisite article regarding [technical complexity and change management](../pre-requisites/technical-complexity.md), a decision should be made in advance to determine how this activity is executed. In particular, will remediation be completed by the Cloud Adoption Team during the same sprint as the actual migration effort? Alternatively, will a wave or factory model be leveraged to complete remediation in a separate iteration? If the answer to this basic process question can't be answered by every member of the team, it may be wise to revisit the [pre-requisites section](../pre-requisites/index.md).
* **Replicate:** Create a copy of each asset in the cloud to synchronize VMs, Data, and Applications with resources in the cloud.
    * Depending on the promotion model, different tools may be required to complete this activity.
* **Stage:** Once all assets for a workload have been replicated and verified, the workload can be staged for business testing and execution of a business change plan.

## Next steps

With a general understanding of the migration process, the reader is ready begin the process by [deciding on a promotion model](./promotion-models.md).

> [!div class="nextstepaction"]
> [Decide on a promotion model](./promotion-models.md)