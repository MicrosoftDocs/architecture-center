---
title: "Fusion: Cost management sample policy statements"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Cost management sample policy statements

Individual cloud policy statements are guidelines for addressing specific risks identified during your risk assessment process. These statements should provide a concise summary of risks and plans to deal with them. Each statement definition should include these pieces of information:

- Business risk - A summary of the risk this policy will address.
- Policy statement - A clear summary explanation of the policy requirements.
- Design options - Actionable recommendations, specifications, or other guidance that IT teams and developers can use when implementing the policy.

The following sample policy statements address a number of common cost-related business risks, and are provided as examples for you to reference when drafting actual policy statements addressing your own organization's needs. Note that these examples are not meant to be proscriptive, and there are potentially several policy options for dealing with any single identified risk. Work closely with business and IT teams to identify the best policy solutions for your particular cost-related risks.  
 
## Future proof

**Business risk:** Current criteria that don't warrant an investment in a Cost Management discipline from the governance team. However, you anticipate such an investment in the future.

**Policy statement:** You should associate all assets deployed to the cloud with a billing unit, application/workload, and meet naming standards. This policy will ensure that future cost management efforts will be effective.

**Design options:** For information on establishing a future proofed foundation, see the discussions related to creating a governance minimum viable product (MVP) in the [actionable design guides](../design-guides/overview.md#incremental-governance-model-mvp-and-continuous-improvement) included as part of the Fusion guidance.

## Budget overruns

**Business risk:** Self-service deployment creates a risk of overspending.

**Policy statement:** Any cloud deployment must be allocated to a billing unit with approved budget and a mechanism for budgetary limits.

**Design options:** In Azure, budget can be controlled with [Azure Cost Management](/azure/cost-management/manage-budgets)

## Underutilization

**Business risk:** The company has pre-paid for cloud services or has made an annual commitment to spend a specific amount. There is a risk that the agreed upon amount won't be used, resulting in a lost investment.

**Policy statement:** Each billing unit with an allocated cloud budget will meet annually to set budgets, quarterly to adjust budgets, and monthly to allocate time for reviewing planned versus actual spend. Discuss any deviations greater than 20% with the billing unit leader monthly. For tracking purposes, assign all assets to a billing unit.

**Design options:**

- In Azure, planned vs actual spend can be managed via [Azure Cost Management](/azure/cost-management/quick-acm-cost-analysis)
- There are several options for grouping resources by billing unit. In Azure, a [resource grouping model](../../infrastructure/resource-grouping/overview.md) should be chosen in conjunction with the governance team and applied to all assets.

## Over provisioned assets

**Business risk:** In traditional on-premises datacenters, it is common practice to deploy assets with extra capacity planning for growth in the distant future. The cloud can scale more quickly than traditional equipment. Assets in the cloud are also priced based on the technical capacity. There is a risk of the old on-premises practice artificially inflating cloud spend.

**Policy statement:** Any asset deployed to the cloud must be enrolled in a program that can monitor utilization and report any capacity in excess of 50% of utilization. Any asset deployed to the cloud must be grouped or tagged in a logical manner, so governance team members can engage the workload owner regarding any optimization of over provisioned assets.

**Design options:**

- In Azure, [Azure Advisor](/azure/advisor/advisor-cost-recommendations) can provide optimization recommendations.
- There are several options for grouping resources by billing unit. In Azure, a [resource grouping model](../../infrastructure/resource-grouping/overview.md) should be chosen in conjunction with the governance team and applied to all assets.

## Overoptimization

**Business risk:** Effective cost management can actually create new risks. Optimization of spend is an inverse to system performance. When reducing costs, there is a risk of over tightening spend and producing poor user experiences.

**Policy statement:** Any asset that directly impacts customer experiences must be identified through grouping or tagging. Before optimizing any asset that impacts customer experience, the cloud governance team must adjust optimization based on no less than 90 days of utilization trends. Document any seasonal or event driven bursts considered when optimizing assets.

**Design options:**

- In Azure, [Azure Monitor's insights features](/azure/azure-monitor/insights/vminsights-performance) can help with analysis of system utilization.
- There are several options for grouping and tagging resources based on roles. In Azure, you should choose a [resource grouping model](../../infrastructure/resource-grouping/overview.md) in conjunction with the governance team and apply this to all assets.

## Next steps

Use the samples mentioned in this article as a starting point to develop policies that address specific business risks that align with your cloud adoption plans.

To begin developing your own custom policy statements related to cost management, download the [Cost Management template](template.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns with your environment. Then modify the design to incorporate your specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)
