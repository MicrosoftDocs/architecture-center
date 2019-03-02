---
title: "Iteration and Release Backlog"
description: Building an iteration and release backlog
author: BrianBlanchard
ms.date: 4/4/2019
---

# Managing change in an incremental migration effort

This article assumes, migration processes are incremental in nature, running parallel to the [Govern process](../../../governance/overview.md). However, the same guidance could be used to populate initial tasks in a "Work Breakdown Structure" for traditional waterfall change management approaches.

## Release Backlog

A Release Backlog consists of a series of assets (VMs, Databases, files, applications, etc...) that must be migrated before a workload can be released for production usage in the cloud. During each iteration, the Cloud Adoption Team will document and estimate the efforts required to move each asset to the cloud. See Iteration Backlog below.

## Iteration Backlog

An iteration backlog is a list of the detailed work required to migrate a specific number of assets from the existing digital estate to the cloud. This list is often stored in an agile management tool, like Azure DevOps, as Work Items.

Prior to starting the first iteration, the Cloud Adoption Team will specify an iteration duration, usually 2-4 weeks. This time box is important to create a start and finish time period for each set of committed activities. Maintaining consistent execution windows makes it easy to gauge velocity (pace of migration) and alignment to evolving business needs.

Prior to each iteration, the team will review the Release backlog, estimating the effort and priorities of assets to be migrated. The team then commits to deliver a set amount of agreed upon migrations. Once agreed by the Cloud Adoption Team, the list of activities become the **Current Iteration Backlog**.

During each iteration, team members will work as a self-organizing team to fulfill commitments in the Current Iteration Backlog.

## Next steps

Once an iteration backlog is defined and accepted by the Cloud Adoption Team, [change management approvals](./approve.md) can be finalized.

> [!div class="nextstepaction"]
> [Approve Changes](../approve.md)