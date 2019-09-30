---
title: "Building a cost-conscious organization"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn best practices for building a cost-conscious organization.
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/04/2019
ms.topic: article
ms.service: cloud-adoption-framework
ms.subservice: organize
---

# Building a cost-conscious organization

As outlined in [Motivations: Why are we moving to the cloud?](../business-strategy/motivations-why-are-we-moving-to-the-cloud.md), there are many sound reasons for a company to adopt the cloud. When cost reduction is a primary driver, it's important to create a cost-conscious organization.

Ensuring cost consciousness is not a one-time activity. Like other cloud-adoption topics, it's iterative. The following diagram outlines this process to focus on three interdependent activities: *visibility*, *accountability*, and *optimization*. These processes play out at macro and micro levels, which we describe in detail in this article.

![Cost-conscious process](../_images/ready/cost-optimization-process.png)
*Figure 1 - Outline of the cost-conscious organization.*

## General cost-conscious processes

- **Visibility:** For an organization to be conscious of costs, it needs visibility into those costs. Visibility in a cost-conscious organization requires consistent reporting for the teams adopting the cloud, finance teams who manage budgets, and management teams who are responsible for the costs. This visibility is accomplished by establishing:
  - The right reporting scope.
  - Proper resource organization (management groups, resource groups, subscriptions).
  - Clear tagging strategies.
  - Proper access controls (RBAC).

- **Accountability:** Accountability is as important as visibility. Accountability starts with clear budgets for adoption efforts. Budgets should be well established, clearly communicated, and based on realistic expectations. Accountability requires an iterative process and a growth mindset to drive the right level of accountability.

- **Optimization:** Optimization is the action that creates cost reductions. During optimization, resource allocations are modified to reduce the cost of supporting various workloads. This process requires iteration and experimentation. Each reduction in cost reduces performance. Finding the right balance between cost control and end-user performance expectations demands input from multiple parties.

The following sections describe the roles that the *cloud strategy team*, *cloud adoption team,* *cloud governance team*, and *cloud center of excellence* (CCoE)  play in developing a cost-conscious organization.

## Cloud strategy team

Building cost consciousness into cloud-adoption efforts starts at the leadership level. To be effective long term, the [cloud strategy team](./cloud-strategy.md) should include a member of the finance team. If your financial structure holds business managers accountable for solution costs, they should be invited to join the team as well. In addition to the core activities that are typically assigned to the cloud strategy team, all members of the cloud strategy team should also be responsible for:

- **Visibility:** The cloud strategy team and [cloud governance team](./cloud-governance.md) need to know the actual costs of the cloud-adoption efforts. Given the executive-level view of this team, they should have access to multiple cost scopes to analyze spending decisions. Typically, an executive needs visibility into the total costs across all cloud "spend." But as active members of the cloud strategy team, they should also be able to view costs per business unit or per billing unit to validate showback, chargeback, or other [cloud accounting models](../business-strategy/cloud-accounting.md).

- **Accountability:** Budgets should be established between the cloud strategy, [cloud governance](./cloud-governance.md), and [cloud adoption](./cloud-adoption.md) teams based on expected adoption activities. When deviations from budget occur, the cloud strategy team and the cloud governance team must partner to quickly determine the best course of action to remediate the deviations.

- **Optimization:** During optimization efforts, the cloud strategy team can represent the investment and return value of specific workloads. If a workload has strategic value or financial impact on the business, cost-optimization efforts should be monitored closely. If there's no strategic impact on the organization and no inherent cost for poor performance of a workload, the cloud strategy team may approve overoptimization. To drive these decisions, the team must be able to view costs on a per-project scope.

## Cloud adoption team

The [cloud adoption team](./cloud-adoption.md) is at the center of all adoption activities. So, they're the first line of defense against overspending. This team has an active role in all three phases of cost-consciousness.

- **Visibility:**

  - **Awareness:** It's important for the cloud adoption team to have visibility into the cost-saving goals of the effort. Simply stating that the cloud-adoption effort will help reduce costs is a recipe for failure. *Specific* visibility is important. For example, if the goal is to reduce datacenter TCO by 3 percent or annual operating expenses by 7 percent, disclose those targets early and clearly.
  - **Telemetry:** This team needs visibility into the impact of their decisions. During migration or innovation activities, their decisions have a direct effect on costs and performance. The team needs to balance these two competing factors. Performance monitoring and cost monitoring that's scoped to the team's active projects are important to provide the necessary visibility.

- **Accountability:** The cloud adoption team needs to be aware of any preset budgets that are associated with their adoption efforts. When real costs don't align with the budget, there's an opportunity to create accountability. Accountability doesn't equate to penalizing the adoption team for exceeding budget, because budget excess can result from necessary performance decisions. Instead, accountability means educating the team about the goals and how their decisions affect those goals. Additionally, accountability includes providing a dialog in which the team can communicate about decisions that led to overspending. If those decisions are misaligned with the goals of the project, this effort provides a good opportunity to partner with the cloud strategy team to make better decisions.

- **Optimization:** This effort is a balancing act, as optimization of resources can reduce the performance of the workloads that they support. Sometimes anticipated or budgeted savings can't be realized for a workload because the workload doesn't perform adequately with the budgeted resources. In those cases, the cloud adoption team has to make wise decisions and report changes to the cloud strategy team and the cloud governance team so that budgets or optimization decisions can be corrected.

## Cloud governance team

Generally, the [cloud governance team](./cloud-governance.md) is responsible for cost management across the entire cloud-adoption effort. As outlined in the [cost management discipline](../governance/cost-management/index.md) topic of the Cloud Adoption Framework's governance methodology, cost management is the first of the five disciplines of cloud governance. Those articles outline a series of deeper responsibilities for the cloud governance team.

This effort focuses on the following activities that are related to the development of a cost-conscious organization:

- **Visibility:** The cloud governance team works as a peer of the cloud strategy team to plan cloud-adoption budgets. These two teams also work together to regularly review actual expenses. The cloud governance team is responsible for ensuring consistent, reliable cost reporting and performance telemetry.

- **Accountability:** When budget deviations occur, the cloud strategy team and the cloud governance team must partner to quickly determine the best course of action to remediate the deviations. Generally, the cloud governance team will act on those decisions. Sometimes the action may be simple retraining for the affected [cloud adoption team](./cloud-adoption.md). The cloud governance team can also help optimize deployed assets, change discounting options, or even implement automated cost-control options like blocking deployment of unplanned assets.

- **Optimization:** After assets are migrated to or created in the cloud, you can employ monitoring tools to assess performance and utilization of those assets. Proper monitoring and performance data can identify assets that should be optimized. The cloud governance team is responsible for ensuring that the monitoring and cost-reporting tools are consistently deployed. They can also help the adoption teams identify opportunities to optimize based on performance and cost telemetry.

## Cloud center of excellence

While not typically responsible for cost management, the CCoE can have a significant impact on cost-conscious organizations. Many foundational IT decisions affect costs at scale. When the CCoE does their part, costs can be reduced for multiple cloud-adoption efforts.

- **Visibility:** Any management group or resource group that houses core IT assets should be visible to the CCoE team. The team can use this data to farm opportunities to optimize.

- **Accountability:** While not typically accountable for cost, the CCoE can hold itself accountable for creating repeatable solutions that minimize cost and maximize performance.

- **Optimization:** Given the CCoE's visibility to multiple deployments, the team is in an ideal position to suggest optimization tips and to help adoption teams better tune assets.

## Next steps

Practicing these responsibilities at each level of the business helps drive a cost-conscious organization. To begin acting on this guidance, review the [organizational readiness introduction](./index.md) to help identify the right team structures.

> [!div class="nextstepaction"]
> [Identify the right team structures](./index.md)
