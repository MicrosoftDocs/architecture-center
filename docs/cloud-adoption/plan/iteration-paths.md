---
title: "Establish iterations and release plans"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Establish iterations and release plans
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Establish iterations and release plans

Agile and other iterative methodologies are built on the concepts of iterations and releases. This article outlines the assignment of iterations and releases during planning efforts. Those assignments will drive timeline visibility to facilitate conversations amongst the cloud strategy team members. It will also align technical tasks in a way that the cloud adoption team can manage ongoing implementation.

## Establish iterations

In an iterative approach to technical implementation, technical efforts are planned around recurring time-blocks of effort. Iterations tend to be one- to six-week time blocks. General consensus suggests that two weeks is the average iteration during for most cloud adoption teams. However, the choice of iteration duration depends on the type of technical effort, the administrative overhead, and the team's preference. To begin aligning efforts to a timeline, it is suggested that a set of iterations be defined for the next 6&ndash;12 months.

## Understand velocity

Aligning efforts to iterations and releases requires an understanding of velocity. Velocity is the amount of work that can be completed in any given iteration. During early planning, velocity is an estimate. After several iterations, velocity becomes a highly valuable indicator of the commitments that the team can make confidently.

Velocity can be measured in abstract terms like story points. It can also be measured in more tangible terms like hours. Most iterative frameworks recommend using abstract measurements to avoid precision and perception challenges. For examples in this article, hours per sprint are used to represent velocity to make the topic more universally understood.

**Example:** A five-person cloud adoption team has committed to two weeks sprints. Current obligations such as, meetings and support of other processes, allows these team members to consistently contribute 20 hours per week to the adoption effort. For this team, the initial estimate of velocity would be 100 hours per sprint.

## Iteration planning

Initially, iterations are planned by evaluating the technical tasks based on the prioritized backlog. Cloud adoption teams estimate the effort required to complete various tasks. Those tasks are then assigned to the first available iteration.

During iteration planning, the cloud adoption teams validate and refine estimates until all available velocity was aligned to specific tasks. This process continues for each prioritized workload until all efforts align to a forecasted iteration.

In this process, the team validates the tasks assigned to the next sprint. Estimates are updated based on the team's conversation about each task. Each task estimated is added to the next sprint, until the available velocity is met. Additional tasks are estimated and added to the next iteration until the velocity of that iteration is also exhausted. This process continues until all tasks were assigned to an iteration.

**Example:** For example purposes only, let's build on the example velocity above. Assume that each workload migration requires 40 tasks, and each task is estimated to take an average of one hour of effort. This equates to approximately 40 hours per workload migration. If these estimates remained consistent across all 10 of the prioritized workloads, then the first 10 workloads would take 400 hours of effort. The velocity defined in the prior example would suggest that the migration of the first 10 workloads would take four iterations (or two months of calendar time). The first iteration would consist of 100 tasks that would result in the effective migration of two workloads. In the next iteration, a similar collection of 100 tasks would result in three workloads being migrated.

> [!WARNING]
> The number of tasks and estimates in the prior example are strictly used as an example. Seldom are technical tasks that consistent. This should not be seen as a reflection of the amount of time required to migrate a workload.

## Release planning

Within cloud adoption, a release is defined as a collection of deliverables that produce enough business value to justify the risk of disruption to business processes. Releasing any workload-related changes into a production environment creates some change to business processes. In ideal scenarios, these changes are seamless and the business seems the value of the change with no significant disruptions to service. However, the risk of business disruption is present with any change and should not be taken lightly.

To ensure the change is justified by the potential return of introducing the change, the cloud strategy team should participate in release planning. Once tasks are aligned to sprints, it is possible to determine a rough timeline of when each workload will be ready for production release. The cloud strategy team would review the timing of each release and identify the inflection point between risk and business value.

**Example:** Continuing the above example, the cloud strategy team has reviewed the iteration plan. Their review identified two release points. During iteration two, a total of five workloads would be ready for migration. Those five workloads would provide significant business value and would trigger the first release. The next release would come two iterations later, when the next five workloads are ready for release.

## Assign iteration paths and tags

For customers managing cloud adoption plans in Azure DevOps, the above processes would be reflected by assigning an iteration path to each task and user story. Tagging each workload with a specific release is also recommended. That tagging and assignment will feed automatic population of timeline reports.

## Next steps

[Estimate timelines](./timelines.md) to properly communicate expectations.

> [!div class="nextstepaction"]
> [Estimate timelines](./timelines.md)
