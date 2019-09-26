---
title: "Cost Management metrics, indicators, and risk tolerance"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of Cost Management in relation to cloud governance
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Cost Management metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to Cost Management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Cost Management discipline.

## Metrics

Cost Management generally focuses on metrics related to costs. As part of your risk analysis, you'll want to gather data related to your current and planned spending on cloud-based workloads to determine how much risk you face, and how important investment in cost governance is to your cloud adoption strategy.

The following are examples of useful metrics that you should gather to help evaluate risk tolerance within the Cost Management discipline:

- **Annual spending:** The total annual cost for services provided by a cloud provider.
- **Monthly spending:** The total monthly cost for services provided by a cloud provider.
- **Forecasted versus actual ratio:** The ratio comparing forecasted and actual spending (monthly or annual).
- **Pace of adoption (MOM) ratio:** The percentage of the delta in cloud costs from month to month.
- **Accumulated cost:** Total accrued daily spending, starting from the beginning of the month.
- **Spending trends:** Spending trend against the budget.

## Risk tolerance indicators

During early small-scale deployments, such as Dev/Test or experimental first workloads, Cost Management is likely to be of relatively low risk. As more assets are deployed, the risk grows and the business' tolerance for risk is likely to decline. Additionally, as more cloud adoption teams are given the ability to configure or deploy assets to the cloud, the risk grows and tolerance decreases. Conversely, growing a Cost Management discipline will take people from the cloud adoption phase to deploy more innovative new technologies.

In the early stages of cloud adoption, you will work with your business to determine a risk tolerance baseline. Once you have a baseline, you will need to determine the criteria that would trigger an investment in the Cost Management discipline. These criteria will likely be different for every organization.

Once you have identified [business risks](./business-risks.md), you will work with your business to identify benchmarks that you can use to identify triggers that could potentially increase those risks. The following are a few examples of how metrics, such as those mentioned above, can be compared against your risk baseline tolerance to indicate your business's need to further invest in Cost Management.

- **Commitment-driven (most common):** A company that is committed to spending $X,000,000 this year on a cloud vendor. They need a Cost Management discipline to ensure that the business doesn't exceed its spending targets by more than 20%, and that they will use at least 90% of that commitment.
- **Percentage trigger:** A company with cloud spending that is stable for their production systems. If that changes by more that _x%_, then a Cost Management discipline will be a wise investment.
- **Overprovisioned trigger:** A company who believes their deployed solutions are overprovisioned. Cost Management is a priority investment until they can demonstrate proper alignment of provisioning and asset utilization.
- **Monthly spending trigger:** A company that spends over $x,000 per month is considered a sizable cost. If spending exceeds that amount in a given month, they will need to invest in Cost Management.
- **Annual spending trigger:** A company with an IT R&D budget that allows for spending $X,000 per year on cloud experimentation. They may run production workloads in the cloud, but they will still be considered experimental solutions if the budget doesn't exceed that amount. Once it goes over, they will need to treat the budget like a production investment and manage spending closely.
- **Operating expense-adverse (uncommon):** As a company, they are averse to operating expenses and will need Cost Management controls in place before deploying a dev/test workload.

## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Review sample Cost Management policies as a starting point to develop policies that address specific business risks that align with your cloud adoption plans.

> [!div class="nextstepaction"]
> [Review sample policies](./policy-statements.md)
