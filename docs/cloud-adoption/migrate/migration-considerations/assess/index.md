---
title: "Assess assets prior to migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Assess assets prior to migration
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Assess assets prior to migration

Many of your existing workloads are ideal candidates for cloud migration, but not every asset is compatible with cloud platforms and not all workloads can benefit from hosting in the cloud. [Digital estate planning](../../../digital-estate/index.md) allows you to generate an overall [migration backlog](../prerequisites/technical-complexity.md#migration-backlog-aligning-business-priorities-and-timing) of potential workloads to migrate. However, this planning effort is high-level. It relies on assumptions made by the cloud strategy team and does not dig deeply into technical considerations.

As a result, before migrating a workload to the cloud it's critical to assess the individual assets associated with that workload for their migration suitability. During this assessment, your cloud adoption team should evaluate technical compatibility, required architecture, performance/sizing expectations, and dependencies to ensure that the migrated workload can be deployed to the cloud effectively.

The *Assess* process is the first of four incremental activities that occur within an iteration. As discussed in the prerequisite article regarding [technical complexity and change management](../prerequisites/technical-complexity.md), a decision should be made in advance to determine how this phase is executed. In particular, will assessments be completed by the cloud adoption team during the same sprint as the actual migration effort? Alternatively, will a wave or factory model be used to complete assessments in a separate iteration? If the answer to this basic process question can't be answered by every member of the team, it may be wise to revisit the [Prerequisites](../prerequisites/index.md)" section.

## Objective

Assess a migration candidate, evaluating the workload, associated assets, and dependencies prior to migration.

## Definition of *done*

This process is complete when the following are known about a single migration candidate:

- The path from on-premises to cloud, including production promotion approach decision, has been defined.
- Any required approvals, changes, cost estimates, or validation processes have been completed to allow the cloud adoption team to execute the migration.

## Accountability during assessment

The cloud adoption team is accountable for the entire assessment process. However, members of the cloud strategy team has a few responsibilities, as listed in the following section.

## Responsibilities during assessment

In addition to the high-level accountability, there are actions that an individual or group needs to be directly responsible for. The following are a few activities that require assignments to responsible parties:

- **Business priority.** The team understands the purpose for migrating this workload, including any intended impact to the business.
  - A member of the cloud strategy team should carry final responsibility for this activity, under the direction of the cloud adoption team.
- **Stakeholder alignment.** The team aligns expectations and priorities with internal stakeholders, identifying success criteria for the migration. What does success look like post-migration?
- **Cost.** The cost of the target architecture has been estimated, and the overall budget has been adjusted.
- **Migration support.** The team has decided how the technical work of the migration will be completed, including decisions regarding partner or Microsoft support.
- **Evaluation.** The workload is evaluated for compatibility and dependencies.
  - This activity should be assigned to a subject matter expert who is familiar with the architecture and operations of the candidate workload.
- **Architect.** The team has agreed on the final state architecture for the migrated workload.
- **Backlog alignment.** The cloud adoption team reviews requirements and commits to the migration of the candidate workload. After commitment, the release backlog and iteration backlog are to be updated accordingly.
- **Work breakdown structure or work-back schedule.** The team establishes a schedule of major milestones identifying goals for when planning, implementation, and review processes are completed.
- **Final approval.** Any necessary approvers have reviewed the plan and have signed off on the approach to migrate the asset.
  - To avoid surprises later in the process, at least one representative of the business should be involved in the approval process.

> [!CAUTION]
> This full list of responsibilities and actions can support large and complex migrations involving multiple roles with varying levels of responsibility, and requiring a detailed approval process. Smaller and simpler migration efforts may not require all of roles and actions described here. To determine which of these activities add value and which are unnecessary overhead, your cloud adoption team and the cloud strategy team are advised to use this full process as part of your first workload migration. After the workload has been verified and tested, the team can evaluate this process and choose which actions to use moving forward.

## Next steps

With a general understanding of the assessment process, you are ready to begin the process by [aligning business priorities](./business-priorities.md).

> [!div class="nextstepaction"]
> [Align business priorities](./business-priorities.md)
