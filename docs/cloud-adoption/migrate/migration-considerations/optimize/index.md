---
title: "Optimize migrated workloads"
description: Optimize migrated workloads
author: BrianBlanchard
ms.date: 4/4/2019
---

# Optimize migrated workloads

After a workload and it's supporting assets have been migrated to the cloud, it must be prepared before it can be promoted to production. In this process, activities ready the workload, size dependent assets, and prepare the business for when the migrated cloud-based workload enters production usage.

## The objective of optimization is to prepare a migrated workload for promotion to production usage.

## Definition of *done*

The optimization process is complete when a workload has been properly configured, sized, and is being used in production .

## Accountability during optimization

The Cloud Adoption Team is accountable for the entire optimization process. However, members of the Cloud Strategy Team, Cloud Operations Team, and Cloud Governance Team should also be responsible for activities within this process.

## Responsibilities during optimization

In addition to the high-level accountability, there are a number of actions that an individual or group needs to be directly responsible for. The following are a few activities that require assignments to responsible parties:

- **Business testing.** Resolve any compatibility issues that prevent the workload from completing its migration to the cloud.
  - Power users from within the business should participate heavily in testing of the migrated workload. Depending on the degree of optimization attempted, multiple testing cycles may be required.
- **Business change plan.** Development of a plan for user adoption, changes to business processes, and modification to business KPIs or learning metrics as a result of the migration effort.
- **Benchmark and optimize.** Study of the business testing and automated testing to benchmark performance. Based on usage, the Cloud Adoption Team refines sizing of the deployed assets to balance cost and performance against expected production requirements.
- **Ready for production.** Prepare the workload and environment for the support of the workload's ongoing production usage.
- **Promote.** Redirect production traffic to the migrated and optimized workload. This activity represents the completion of a release cycle.

In addition to core activities, there are a few parallel activities that require specific assignments and execution plans:

- **Decommission.** Generally, cost savings can be realized from a migration, when the previous production assets are decommissioned and properly disposed of.
- **Retrospective.** Every release creates an opportunity for deeper learning and adoption of a growth mindset. Upon the completion of each release cycle, the Cloud Adoption Team should evaluate the processes used during migration to identify improvements.

## Next steps

With a general understanding of the optimization process, you are ready to begin the process by [establishing a business change plan for the candidate workload](./business-change-plan.md).

> [!div class="nextstepaction"]
> [Business change plan](./business-change-plan.md)