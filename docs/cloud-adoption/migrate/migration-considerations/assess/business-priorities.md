---
title: "Maintain business priorities during a long-term transformation process"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Maintain business priorities during a long-term transformation process.
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Business Priorities - Maintaining alignment

*Transformation* is often defined as a dramatic or spontaneous change. At the board level, change can look like a dramatic transformation. However, for those who work through the process of change in an organization, transformation is a bit misleading. Under the surface, transformation is better described as a series of properly executed transitions from one state to another.

The amount of time required to rationalize or transition a workload will vary, depending on the technical complexity involved. However, even when this process can be applied to a single workload or group of applications quickly, it takes time to produce substantial changes among a user base. It takes longer for changes to propagate through various layers of existing business processes. If transformation is expected to shape behavior patterns in consumers, the results can take longer to produce significant results.

Unfortunately, the market doesn't wait for businesses to transition. Consumer behavior patterns change on their own, often unexpectedly. The market's perception of a company and its products can be swayed by social media or a competitor's positioning. Fast and unexpected market changes require companies to be nimble and responsive.

The ability to execute processes and technical transitions requires a consistent, stable effort. Quick decisions and nimble actions are needed to respond to market conditions. These two are at odds, making it easy for priorities to fall out of alignment. This article describes approaches to maintaining transitional alignment during migration efforts.

<!-- markdownlint-disable MD026 -->

## How can business and technical priorities stay aligned during a migration?

The cloud adoption team and the cloud governance team focus on the execution of the current iteration and current release. Iterations provide stable increments of technical work, thus avoiding costly disruptions that would otherwise slow the progress of migration efforts. Releases ensure that the technical effort and energy stay focused on the business objectives of the workload migration. A migration project could require many releases over an extended period. By the time it is completed, market conditions have likely changed significantly.

In parallel, the cloud strategy team focuses on executing the business change plan and preparing for the next release. The cloud strategy team generally looks at least one release ahead, and it monitors for changing market conditions and adjusts the migration backlog accordingly. This focus of managing transformation and adjusting the plan creates natural pivots around the technical work. When business priorities change, adoption is only one release behind, creating technical and business agility.

## Business alignment questions

The following questions can help the cloud strategy team shape and prioritize the migration backlog to help ensure that the transformation effort best aligns with current business needs.

- Has the cloud adoption team identified a list of workloads ready for migration?
- Has the cloud adoption team selected a single candidate for an initial migration from that list of workloads?
- Do the cloud adoption team and the cloud governance team have all of the necessary data regarding the workload and cloud environment to be successful?
- Does the candidate workload deliver the most relevant impact for the business in the next release?
- Are there other workloads that are better candidates for migration?

## Tangible actions

During the execution of the business change plan, the cloud strategy team monitors for positive and negative results. When those observations require technical change, the adjustments are added as work items to the release backlog to be prioritized in the next iteration.

When the market changes, the cloud strategy team works with the business to understand how to best respond to the changes. When that response requires a change in migration priorities, the migration backlog is adjusted. This moves up workloads that were previously lower in priority.

## Next steps

With properly aligned business priorities, the cloud adoption team can confidently begin to [evaluate workloads](./evaluate.md) to develop architecture and migration plans.

> [!div class="nextstepaction"]
> [Evaluate workloads](./evaluate.md)
