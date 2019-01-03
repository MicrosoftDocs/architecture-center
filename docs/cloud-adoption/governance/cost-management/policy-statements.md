---
title: "Fusion: Cost management sample policy statements"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Cost management sample policy statements

The following policy statements provide examples of that could mitigate specific business risks through design guidance and the implementation of specific tools for cost governance montoring & enforcement.

## Future Proof

**Business Risk:** Current criteria doesn't warrant an investment in a Cost Management Discipline from the governance team. However, such an investment is anticipated in the future.

**Policy Statement:** All assets deployed to the cloud should be associated with a billing unit, application/workload, and meet naming standards. This policy will ensure that future cost management efforts will be effective.

**Design Guidance:** For guidance on establishing a future proofed foundation, see the [design guide for Cloud Native deployments](../design-guides/future-proof.md).

## Budget Overrun

**Business Risk:** Self-service deployment creates a risk of overspending.

**Policy Statement:** Any cloud deployment must be allocated to a billing unit with approved budget and a mechanism for budgetary limits.

**Design Guidance:** In Azure, budget can be controlled with [Azure Cost Management](/azure/cost-management/manage-budgets)

## Under Utilization

**Business Risk:** The company has pre-paid for cloud services or has made an annual commitment to spend a specific amount. There is a risk that the agreed upon amount won't be used, resulting in a lost investment.

**Policy Statement:** Each billing unit with an allocated cloud budget will meet annually to set budgets, quarterly to adjust budgets, and will allocate time monthly to review planned vs actual spend. Any deviations greater than 20% will be discussed with the billing unit leader monthly. For tracking purposes, all assets must be assigned to a billing unit.

**Design Guidance:**

* In Azure, planned vs actual spend can be managed via [Azure Cost Management](/azure/cost-management/quick-acm-cost-analysis). 
* There are several options for grouping resources by billing unit. In Azure, a [resource grouping model](../../infrastructure/resource-grouping.md) should be chosen in conjunction with the governance team and applied to all assets.

## Over Provisioned Assets

**Business Risk:** In traditional on-prem datacenters, it is common practice to deploy assets with extra capacity planning for growth in the distant future. The cloud can scale more quickly than traditional equipment. Assets in the cloud are also priced based on the technical capacity. There is a risk of the old on-prem practice artificially inflating cloud spending.

**Policy Statement:** Any asset deployed to the cloud must be enrolled in a program that can monitor utilization and report any capacity in excess of 50% of utilization. Any asset deployed to the cloud must be grouped or tagged in a logical manner, so governance team members can engage the workload owner regarding any optimization of over provisioned assets.

**Design Guidance:**

* In Azure, [Azure Advisor](/azure/advisor/advisor-cost-recommendations) can provide optimization recommendations.
* There are several options for grouping resources by billing unit. In Azure, a [resource grouping model](../../infrastructure/resource-grouping.md) should be chosen in conjunction with the governance team and applied to all assets.

## Over optimization

**Business Risk:** Effective cost management can actually create a new risk. Optimization of spend is an inverse to system performance. When reducing costs, there is a risk of over tightening spend and producing poor user experiences.

**Policy Statement:** Any asset that directly impacts customer experiences must be identified through grouping or tagging. Before optimizing any asset that impacts customer experience, the Cloud Governance Team must adjust optimization based on no less than 90 days of utilization trends. Any seasonal or event driven bursts must also be documented and considered when optimizing these assets.

**Design Guidance:**

* In Azure, [Azure Monitor's insights features](/azure/azure-monitor/insights/vminsights-performance) can help with analysis of system utilization.
* There are several options for grouping and tagging resources based on their role. In Azure, a [resource grouping model](../../infrastructure/resource-grouping.md) should be chosen in conjunction with the governance team and applied to all assets.

## Next steps

Use these sample policies as a starting point to develop policies that address specific business risks aligned with your cloud adoption plans.

To begin developing your own custom policy statements related to cost management, download the [Cost Management Template](template.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns. Then modify that design to incorporate specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)