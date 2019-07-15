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

In the previous article in this series, workloads and tasks were assigned to [releases and iterations](./iteration-paths.md). Those assignments feed the timeline estimates in this article.

Work breakdown structures (WBS) are commonly used in sequential project-management tools to represent how dependent tasks will be completed over a period of time. Such structures work well when tasks are sequential in nature. The interdependencies in tasks found in cloud adoption make such structures difficult to manage. To fill this gap, you can estimate timelines based on iteration-path assignments by hiding complexity.

## Estimate timelines

To develop a timeline, start with releases. Those release objectives create a target date for any effects on the business. Iterations aid in aligning those releases with specific time durations.

If more granular milestones are required in the timeline, use iteration assignment to indicate milestones. To do this, assume that the last instance of a workload-related task can serve as the final milestone. Alternatively, teams commonly tag the final task as a milestone.

Regardless of the level of granularity, use the last day of the iteration as the date for each milestone. This use ties completion of workload adoption to a specific date. You can track the date in a spreadsheet or sequential project-management tool like Microsoft Project.

## Delivery plans in Azure DevOps

If you are using Azure DevOps to manage your cloud adoption plan, the [Microsoft Delivery Plans](https://marketplace.visualstudio.com/items?itemName=ms.vss-plans) extension can quickly create a visual representation of the timeline based on iteration and release assignments.
