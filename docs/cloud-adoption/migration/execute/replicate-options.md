---
title: "Enterprise Cloud Adoption: Migration Execution"
description: A process within Cloud Migration that focuses on the tasks of migrating workloads to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: Migration Execution

The [Migration section](../overview.md) of the [Enterprise Cloud Adoption framework](../../overview.md), outlines the processes typically required to migrate a datacenter to the cloud. This series of articles, expands on the [Migration Execution Process](overview.md) within any migration. This process represents the bulk of effort during any Cloud Transformation that involves a migration of infrastructure assets to the cloud.
  
In this process, the Cloud Migration Team will execute a process which focuses on the technical tasks associated with migrating assets to the cloud.
![Migration Execution Process and related activities](../../_images/migration-execute.png)
*Figure 1. Migration Execution Process and related activities.*

Generally, this process is incremental in nature, running parallel to the [Govern process](../govern/overview.md). Each increment is typically time-bound to a consistent number of weeks. For instance, the team will attempt to migrate a committed number of VMs over the course of a 2-week iteration/sprint. Additional information about [incremental change management](../plan/incremental-change-management.md) is available in the [Plan process](../plan/overview.md) of this framework.

This process assumes that a re-host or re-platform model of migration (often referred to as a "Lift & Shift") is most appropriate for the workloads or applications being migrated. This will be validated during the "Architect" activity of this process, see activity #2 below. For other approaches to migration, see the [rationalize process](../plan/rationalize.md).

## Activities and Functions

The Migrate process consists of the following activities:

* Iteration or Release Backlog: Creation of a detailed plan to guide the work completed during a single iteration or a workload release.

Iteration Activities: Completed in every iteration regardless of release timing

* [Assess](assess.md): Evaluate the workload and associated assets (VMs, DBs, source, etc...) to validate Azure compatibility, identify any necessary remediation, and refine plans for work to be completed.
* [Architect](architect.md): Evaluate dependencies required to operate the workload. Assert final architecture decisions regarding the hosting strategy for the chosen workload.
* [Remediate](remediate.md): Assessment or Architecture outputs will often identify basic changes required before deploying a workload. Such as, OS upgrades. This activity focuses on implementing those changes prior to migration. In some rare cases, remediation may require a parallel iteration/sprint of it's own to maintain velocity (pace of execution).
* [Replicate](replicate.md): Once an asset is ready for migration, it must be replicated to the desired cloud architecture. The article on this activity will describe the tools and approaches that can support replication to Azure.

Release Activities: During iterations in which a release is to be tested or promoted, the following activities are also likely to be executed, in addition to standard iteration activities:

* [Stage](stage.md): Once all assets required to operate a workload have been replicated to Azure, the workload can be staged for release.
* [UAT Testing](uat-test.md): Staged workload can be tested by power users to validate function and performance.
* [User Adoption Plan](user-adoption-plan.md): Once a workload passes UAT, a User Adoption Plan can be established an initiated. This plan will guide the activities related to readiness and promotion of a workload.
* [Ready](ready.md): Activities related to pre-production readiness. Often includes addition performance tuning, dependency/routing validation, etc...
* [Promote](promote.md): The process of promoting a workload to production. Generally focuses on re-routing production traffic to the new assets & decomissioning of replaced assets.
* [Business Priorities](business-priorities.md): At the end of each release, a business stakeholder review will advise changes to the migration and release backlog, based on progress towards business outcomes and changes in market condition assumptions.

## Next steps

To begin executing the Migrate process, [Assess activities](assess.md) could be a good place to learn more.

> [!div class="nextstepaction"]
> [Assess Inventory](assess.md)