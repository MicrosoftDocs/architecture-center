---
title: "Building a cost-conscious organization"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Describes a best practice for building a cost-conscious organization
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: organize
---

# Building a cost-conscious organization

As outlined in the article on [cloud motivations](../business-strategy/motivations-why-are-we-moving-to-the-cloud.md), there are sound reasons for a company to adopt the cloud. When cost reduction is a primary driver, it's important to create a cost-conscious organization.

Ensuring cost-consciousness is not a one-time activity. Like other cloud adoption topics, it's iterative. The following diagram outlines this iterative process to focus on three interdependent activities: Visibility, Accountability, and Optimization. These three processes play out at macro and micro levels, which will be described in more detail throughout this article.

![Cost-conscious process](../_images/ready/cost-optimization-process.png)
*Figure 1. Outline of the cost-conscious organization*

## General cost-conscious processes

- **Visibility:** For an organization to be conscious of costs, there must be visibility into those costs. Visibility in a cost-conscious organization requires consistent reporting for the teams adopting the cloud, finance teams managing budgets, and management teams who are responsible for the costs. This visibility is accomplished by establishing the right reporting scope, proper resource organization (management groups, resource groups, subscriptions), clear tagging strategies, and proper access controls (RBAC).

- **Accountability:** Equally important to visibility is the need for accountability. Accountability starts with clear budgets for any monitored adoption efforts. These budgets should be well established, clearly communicated, and based on realistic expectations for adoption activities. This requires an iterative process and a growth mindset to drive the right level of accountability.

- **Optimization:** Optimization is the action that creates cost reductions. During optimization, resource allocations are modified to reduce the cost of supporting various workloads. This process requires some iteration and experimentation. Each reduction in cost reduces performance. Finding the right balance between cost control and end-user performance expectations can require input from multiple parties.

The following sections reflect how the [cloud strategy team](./cloud-strategy.md), [cloud governance team](./cloud-governance.md), [cloud adoption team](./cloud-adoption.md), and [cloud center of excellence](./cloud-center-excellence.md) each play a role in developing a cost-conscious organization.

## Cloud strategy team

Building cost consciousness into cloud adoption efforts starts at the leadership level. To be effective long term, the [cloud strategy team](./cloud-strategy.md) should include a member of the finance team. If the current financial structure holds business managers accountable for solution costs, they should be invited to join as well. In addition to the core activities typically assigned to the cloud strategy team, all members of the cloud strategy team will have an added responsibility to participate in the following activities:

- **Visibility:** The [cloud strategy team](./cloud-strategy.md) and  [cloud governance team](./cloud-governance.md) should have visibility into the actual costs associated with the full cloud adoption efforts. Given the executive level view of this team, they should have multiple cost scopes available to analyze ongoing spending decisions. Typically an executive will need visibility into the total costs across all cloud spend. However, as an active member of the cloud strategy team, they should also be able to view costs per business unit or billing unit, to validate showback, chargeback, or other [cloud accounting models](../business-strategy/cloud-accounting.md).

- **Accountability:** Budgets should be established between the [cloud strategy team](./cloud-strategy.md),  [cloud governance team](./cloud-governance.md), and [cloud adoption team](./cloud-adoption.md) based on expected adoption activities. When deviations from budget occur, the [cloud strategy team](./cloud-strategy.md) and  [cloud governance team](./cloud-governance.md) partner to quickly determine the best course of action to remediate the deviations.

- **Optimization:** During optimization efforts, the cloud strategy team can represent the investment and return value of specific workloads. If a workload has strategic value or a financial impact on the business, then cost optimization efforts should be monitored closely. Conversely, if there is no strategic impact on the organization and no inherent costs to poor performance of the workload, then overoptimization may be approved by the cloud strategy team. To drive these decisions, the cloud strategy team should have the ability to view costs on a per project scope.

## Cloud adoption team

The [cloud adoption team](./cloud-adoption.md) is at the center of all adoption activities. As such, they are the first line of defense against overspending. This team has an active role in all three phases of cost consciousness.

- **Visibility:**

  - Awareness: it's important for the [cloud adoption team](./cloud-adoption.md) to have visibility into the cost savings goals associated with the effort. Simply stating that the cloud adoption effort will help reduce costs is a recipe for failure. Specific visibility is important. For example, if the goal is to reduce datacenter TCO by 3% or reduce annual operating expenses by 7%, disclose those targets early and often with this team.
  - Telemetry: In addition to awareness, this group will need visibility into the impact of the decisions they make. During migration or innovation activities, decisions made by this team will have a direct impact on costs and performance. The team will need to balance these two competing factors. Performance monitoring and costs monitoring scoped to the teams' active projects are important to provide the necessary visibility.

- **Accountability:** The [cloud adoption team](./cloud-adoption.md) should be made aware of any preset budgets associated with their adoption efforts. When real costs don't align with the budget, there is an opportunity to create accountability. Accountability does not equate to penalizing the adoption team for exceeding budget, as budget excess could be the result of necessary performance decisions. Instead, to educate the team on the goals and how their decisions impacted those goals. Additionally, accountability includes providing a dialog in which the team can communicate the decisions that led to overspending. If those decisions are misaligned with the goals of the project, this effort provides a good opportunity to partner with the cloud strategy team to find better decisions.

- **Optimization:** This effort is a bit of a balancing act, as optimization of resources also reduces the performance of the workloads they support. There will be times in which an anticipated or budgeted savings can't be realized for a workload because that workload would not perform properly with the budgeted resources. In those cases, it's the responsibility of the [cloud adoption team](./cloud-adoption.md) to make wise decisions and report those changes back to the [cloud strategy team](./cloud-strategy.md) and  [cloud governance team](./cloud-governance.md) so budgets or optimization decisions can be corrected.

## Cloud governance team

Generally, the [cloud governance team](./cloud-governance.md) is responsible for cost management across the entire cloud adoption effort. As outlined in the [cost management discipline](../governance/cost-management/index.md) of the Cloud Adoption Framework's governance methodology, cost management is the first of the five disciplines of cloud governance. Those articles outline a series of deeper responsibilities for the [cloud governance team](./cloud-governance.md).

Related to the development of a cost-conscious organization, this team will focus on the following activities:

- **Visibility:** The cloud governance team works as a peer of the cloud strategy team in the planning of cloud adoption budgets. They also work together to regularly review actual expenses. This team is responsible for ensuring consistent, reliable cost reporting and performance telemetry.

- **Accountability:** When deviations from budget occur, the [cloud strategy team](./cloud-strategy.md) and  [cloud governance team](./cloud-governance.md) partner to quickly determine the best course of action to remediate the deviations. Generally, the cloud governance team will act on those decisions. At times, the action may be simple re-education for the affected [cloud adoption team](./cloud-adoption.md). When necessary, the [cloud governance team](./cloud-governance.md) can also aid in optimizing the deployed assets, changing discounting options, or even implementing automated cost-control options like blocking deployment of unplanned assets.

- **Optimization:** Once assets are migrated or created in the cloud, monitoring tools can begin assessing performance and actual utilization of the deployed assets. Proper monitoring and performance data can identify assets that could be optimized. The cloud governance team is responsible for ensuring that the monitoring tools and cost reporting tools required for optimization are consistently deployed. They can also help the adoption teams identify opportunities to optimize based on performance and cost telemetry.

## Cloud center of excellence (CCoE)

While not typically responsible for cost management, the cloud center of excellence can have a significant impact on cost-conscious organizations. Many foundational IT decisions can impact cost at scale. When the CCoE does their part, these costs can be significantly reduced for multiple different cloud adoption efforts.

- **Visibility:** Any management group or resource group that houses core IT assets should be visible to the CCoE team. The team can use this data to farm opportunities to optimize.

- **Accountability:** While not typically accountable for cost, the CCoE can hold themselves accountable for creating repeatable solutions that minimize cost and maximize performance.

- **Optimization:** Given the CCoE's visibility to multiple deployments, the team is in an optimal position to suggest optimization tips and help adoption teams better tune assets.

## Next steps

Practicing these responsibilities at each level of the business will help drive a cost-conscious organization. To begin acting on this guidance, review the [organizational readiness introduction](./index.md) for help with identifying the right team structures.

> [!div class="nextstepaction"]
> [Identify the right team structures](./index.md)