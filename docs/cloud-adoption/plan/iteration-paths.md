---
title: "Establish iterations and release plans"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Establish iterations and release plans
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Establish iterations and release plans

Agile and other iterative methodologies are built on the concepts of iterations and releases. This article outlines the assignment of iterations and releases during planning. Those assignments drive timeline visibility to make conversations easier among members of the cloud strategy team. The assignments also align technical tasks in a way that the cloud adoption team can manage during implementation.

## Establish iterations

In an iterative approach to technical implementation, you plan technical efforts around recurring time blocks. Iterations tend to be one-week to six-week time blocks. Consensus suggests that two weeks is the average iteration duration for most cloud adoption teams. But the choice of iteration duration depends on the type of technical effort, the administrative overhead, and the team's preference.

To begin aligning efforts to a timeline, we suggest that you define a set of iterations that last 6 to 12 months.

## Understand velocity

Aligning efforts to iterations and releases requires an understanding of velocity. Velocity is the amount of work that can be completed in any given iteration. During early planning, velocity is an estimate. After several iterations, velocity becomes a highly valuable indicator of the commitments that the team can make confidently.

You can measure velocity in abstract terms like story points. You can also measure it in more tangible terms like hours. For most iterative frameworks, we recommend using abstract measurements to avoid challenges in precision and perception. Examples in this article represent velocity in hours per sprint. This representation makes the topic more universally understood.

**Example:** A five-person cloud adoption team has committed to two-week sprints. Given current obligations like meetings and support of other processes, each team member can consistently contribute 20 hours per week to the adoption effort. For this team, the initial velocity estimate is 100 hours per sprint.

## Iteration planning

Initially, you plan iterations by evaluating the technical tasks based on the prioritized backlog. Cloud adoption teams estimate the effort required to complete various tasks. Those tasks are then assigned to the first available iteration.

During iteration planning, the cloud adoption teams validate and refine estimates. They do so until they have aligned all available velocity to specific tasks. This process continues for each prioritized workload until all efforts align to a forecasted iteration.

In this process, the team validates the tasks assigned to the next sprint. The team updates its estimates based on the team's conversation about each task. The team then adds each estimated task to the next sprint until the available velocity is met. Finally, the team estimates additional tasks and adds them to the next iteration. The team performs these steps until the velocity of that iteration is also exhausted.

The preceding process continues until all tasks are assigned to an iteration.

**Example:** Let's build on the previous example. Assume each workload migration requires 40 tasks. Also assume you estimate each task to take an average of one hour. The combined estimation is approximately 40 hours per workload migration. If these estimates remain consistent for all 10 of the prioritized workloads, those workloads will take 400 hours.

The velocity defined in the previous example suggests that the migration of the first 10 workloads will take four iterations, which is two months of calendar time. The first iteration will consist of 100 tasks that result in the migration of two workloads. In the next iteration, a similar collection of 100 tasks will result in the migration of three workloads.

> [!WARNING]
> The preceding numbers of tasks and estimates are strictly used as an example. Technical tasks are seldom that consistent. You shouldn't see this example as a reflection of the amount of time required to migrate a workload.

## Release planning

Within cloud adoption, a release is defined as a collection of deliverables that produce enough business value to justify the risk of disruption to business processes.

Releasing any workload-related changes into a production environment creates some changes to business processes. Ideally, these changes are seamless, and the business sees the value of the changes with no significant disruptions to service. But the risk of business disruption is present with any change and shouldn't be taken lightly.

To ensure a change is justified by its potential return, the cloud strategy team should participate in release planning. Once tasks are aligned to sprints, the team can determine a rough timeline of when each workload will be ready for production release. The cloud strategy team would review the timing of each release. The team would then identify the inflection point between risk and business value.

**Example:** Continuing the previous example, the cloud strategy team has reviewed the iteration plan. The review identified two release points. During the second iteration, a total of five workloads will be ready for migration. Those five workloads will provide significant business value and will trigger the first release. The next release will come two iterations later, when the next five workloads are ready for release.

## Assign iteration paths and tags

For customers who manage cloud adoption plans in Azure DevOps, the previous processes are reflected by assigning an iteration path to each task and user story. We also recommend tagging each workload with a specific release. That tagging and assignment feed the automatic population of timeline reports.

## Next steps

[Estimate timelines](./timelines.md) to properly communicate expectations.

> [!div class="nextstepaction"]
> [Estimate timelines](./timelines.md)
