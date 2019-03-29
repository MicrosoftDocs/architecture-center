---
title: "Assess assets prior to migration"
description: Assess assets prior to migration
author: BrianBlanchard
ms.date: 4/4/2019
---

# Assess assets prior to migration

Not everything should be migrated to the cloud. Further, every asset is not compatible with cloud platforms. Before migrating assets to the cloud, it is important to assess the workload and each asset. During assessment, the Cloud Adoption Team will evaluate technical compatibility, required architecture, performance/sizing expectations, and dependencies to ensure the migrated workload can be promoted to production.

Assess is the first of four incremental activities that occur within an iteration. As discussed in the pre-requisite article regarding [technical complexity and change management](../pre-requisites/technical-complexity.md), a decision should be made in advance to determine how this phase is executed. In particular, will assessments be completed by the Cloud Adoption Team during the same sprint as the actual migration effort? Alternatively, will a wave or factory model be leveraged to complete assessments in a separate iteration? If the answer to this basic process question can't be answered by every member of the team, it may be wise to revisit the [pre-requisites section](../pre-requisites/index.md).

## Objective

Assess a migration candidate, evaluating the workload, associated assets, and dependencies prior to migration.

## Definition of Done

This process is complete when the following are known about a single migration candidate:

* Defined path from on-premises to cloud, including production promotion approach decision
* Any required approvals, changes, cost estimates, and/or validation processes have been completed to allow the cloud adoption team to execute the migration

## Accountability during assessment

The cloud adoption team is accountable for the entire assessment process. However, members of the cloud strategy team will have a few responsibilities as listed below.

## Responsibilities during assessment

In addition to the high level accountability, there are a number of actions that an individual or group of individuals will need to be directly responsible for. The following are a few activities that will require assignments to responsible parties.

* **Business priority:** The team understands the purpose for migrating this workload, including any intended impact to the business
    * A member of the cloud strategy team should carry final responsibility for this activity, under the direction of the cloud adoption team.
* **Evaluation:** The workload is evaluated for compatibility and dependencies.
    * It is advised that this activity be assigned to a subject matter expert who is familiar with the architecture and operations of the candidate workload
* **Architect:** The team has agreed upon the final state architecture for the migrated workload
* **Cost:** The cost of the target architecture has been estimated and the overall budget has been adjusted
* **Migration support:** The team has decided how the technical work of the migration will be completed, included decisions regarding partner and/or microsoft support
* **Backlog alignment:** The cloud adoption team reviews requirements and commits to the migration of the candidate workload. Once committed, the release backlog and iteration backlog are to be updated accordingly
* **Final approval:** Any necessary approvers have reviewed the plan and signed off on the approach to migrate the asset
    * To avoid surprises later in the process, it is advised that at least one representative of the business be involved in the approval process

> [!CAUTION]
> The above actions assume a large, complex migration involving multiple roles with varying levels of responsibility requiring a detailed approval process. The Cloud Adoption Team and Cloud Strategy Team are advised to use this process for the first workload migration. Then evaluate the process after the that workload has been verified and tested. The team will then be able to easily verify which activities added value & which were unnecessary overhead.

## Next steps

With a general understanding of the assessment process, the reader is ready begin the process by [aligning business priorities](business-priorities.md).

> [!div class="nextstepaction"]
> [Align business priorities](business-priorities.md)