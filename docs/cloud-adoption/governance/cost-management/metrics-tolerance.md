---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/3/2019
---

# Fusion: Metrics, indicators, and risk tolerance

This article is intended to help you quantify business risk tolerance as it relates to cost management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Cost Management discipline.

## Metrics

Cost management generally focuses on metrics related to costs. As part of your risk analysis you'll want to gather data related to your current and planned spending on cloud-based workloads to determine how much risk you face, and how important investment in cost governance is to your cloud adoption strategy.

The following are examples of useful metrics that you should gather to help evaluate risk tolerance within the security management discipline:

- Annual spend: The total annual cost for services provided by a cloud provider
- Monthly spend: The total monthly cost for services provided by a cloud provider
- Forecast vs actual ratio: The ratio comparing forecasted and actual spend (monthly or annual)
- Pace of adoption (MOM) ratio: The percentage of the delta in cloud costs from month to month
- Accumulated cost: Total accrued daily spending, starting from the beginning of the month
- Spending trends: Spending trend against the budget

## Risk tolerance indicators

During early deployments, such as Dev/Test or experimental first workloads, cost management is likely to be of relatively low risk. As more assets are deployed, the risk grows and the business' tolerance for risk is likely to decline. Additionally, as more cloud adoption teams are given the ability to configure or deploy assets to the cloud, the risk grows and tolerance decreases. Conversely, growing a cost management discipline will take people from the cloud adoption phase to deploy more innovative new technologies.

In the early stages of cloud adoption, you will work with your business to determine a risk tolerance baseline. Once you have a baseline, you will need to determine the criteria that would trigger an investment in the cost management discipline. These criteria will likely be different for every organization.

Once you have identified [business risks](./business-risks.md), you will work with your business to identify benchmarks that you can use to identify triggers that could potentially increase those risks. The following are a few examples of how metrics, such as those mentioned above, can be compared against your risk baseline tolerance to indicate your business's need to further invest in cost management.

- Commit driven (most common): A company that is committed to spending $X,000,000 this year on a cloud vendor. They need a cost management discipline to ensure that the business doesn't overspend by more than 20%, and they will use at least 90% of that commitment.
- Percentage trigger: A company with cloud spending that is stable for their production systems. If that changes by more that X%, then a cost management discipline will be a wise investment.
- Over provision trigger: A company who believes their deployed solutions are over provisioned. Cost management is a priority investment until they can demonstrate proper alignment of provisioning and asset utilization.
- Monthly spend trigger: A company that spends over $x,000 per month is considered a sizable cost. If spending exceeds that amount in a given month, they will need to invest in cost management.
- Annual spend trigger: A company with an IT R&D budget that allows for spending $X,000 per year on cloud experimentation. They may run production workloads in the cloud, but they will still be considered experimental solutions if the budget doesn't exceed that amount. Once it goes over, they will need to treat the budget like a production investment and manage spending closely.
- OpEx adverse (uncommon): As a company, they are very OpEx adverse and will need cost management controls in place before deploying a dev/test workload.

## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating cost policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Establish Policy Adherence Processes](./processes.md)
