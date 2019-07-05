---
title: "Timelines in a cloud adoption plan"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Timelines in a cloud adoption plan
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Timelines in a cloud adoption plan

In the prior article in this series, workloads and tasks were assigned to [releases and iterations](./iteration-paths.md). Those assignments feed the timeline estimates in this article.

Work breakdown structures (WBS) are commonly used in sequential project management tools to represent how dependent tasks will be completed over a period of time. Such structures work well when tasks are sequential in nature. The interdependencies in tasks found in cloud adoption make such structures difficult to manage. To fill this gap, timelines can be estimated based on iteration path assignments by obfuscating complexity.

## Estimate timelines

To develop a timeline, start with releases. Those release objectives create a target date for any impacts back to the business. Iterations aid in aligning those releases with specific time durations.

If more granular milestones are required in the timeline, leverage iteration assignment to indicate milestones. To do this, assume that the last instance of a workload-related task can serve as the final milestone. Alternatively, it is common for teams to tag the final task with a milestone tag.

Regardless of the level of granularity, use the last day of the iteration as the date for each milestone. This ties completion of workload adoption to a specific date that can be tracked in a spreadsheet or sequential project management tool like Microsoft Project.

## Delivery plans in Azure DevOps

If you are using Azure DevOps to manage you cloud adoption plan, the [microsoft delivery plan](https://marketplace.visualstudio.com/items?itemName=ms.vss-plans) extension can quickly create a visual representation of the timeline based on iteration and release assignments.
