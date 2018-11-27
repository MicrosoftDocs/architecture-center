---
title: "Fusion: Iteration and Release Backlog"
description: Building an iteration and release backlog
author: BrianBlanchard
ms.date: 10/11/2018
---

# Fusion: Migration Execution

The [Migration section](../overview.md) of the [Fusion framework](../../overview.md), outlines the processes typically required to migrate a DataCenter to the cloud. This series of articles, expands on the [Migration Execution Process](overview.md) within any migration. This article focuses specifically on building an iteration and/or release backlog.
  
This article assumes, migration processes are incremental in nature, running parallel to the [Govern process](../govern/overview.md). However, the same guidance could be used to populate initial tasks in a "Work Breakdown Structure" for traditional waterfall change management approaches.

## Release Backlog

For relative reference, a release backlog is a subset of a [Migration Backlog](../plan/migration-backlog.md).

This artifact consists of a series of assets (VMs, Databases, files, etc...) that must be migrated before a workload can be released for production usage in the cloud. During each iteration, the Cloud Adoption Team will document and estimate the efforts required to move each asset to the cloud. See Iteration Backlog below.

Once all assets have been replicated to the cloud, the workload is ready for [Staging](stage.md), [UAT Testing](business-test.md), & other activities required to [Promote to production](promote.md).

## Iteration Backlog

For relative reference, an iteration backlog is a subset of a release backlog. It is generally a deeper extension of a [Migration Backlog](../plan/migration-backlog.md).

An iteration backlog is a list of the detailed work required to migrate a specific number of digital assets to the cloud. This list is often stored in an agile management tool, like Azure DevOps, as Work Items.

Prior to starting the first iteration, the Cloud Adoption Team will specify an iteration duration, usually 2-4 weeks. This time box is important to create a start and finish time period for each set of committed activities. Maintaining consistent execution windows makes it easy to gauge velocity (pace of migration) and alignment to evolving business needs.

Prior to each iteration, the team will review the Release backlog, estimating the effort and priorities of assets to be migrated. The team then commits to deliver a set amount of agreed upon migrations. Once agreed by the Cloud Adoption Team, the list of activities become the **Current Iteration Backlog**.

During each iteration, team members will work as a self-organizing team to fulfill commitments in the Current Iteration Backlog.

## Next steps

To begin executing the Migrate process, [Assess activities](assess.md) could be a good place to learn more.

> [!div class="nextstepaction"]
> [Assess Inventory](assess.md)