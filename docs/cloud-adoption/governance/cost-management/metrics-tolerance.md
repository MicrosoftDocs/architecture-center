---
title: "Fusion: Metrics, Indicators, and Risk Tolerance"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Metrics, Indicators, and Risk Tolerance

This article helps quantify the business's risk tolerance as it relates to cost management. Defining metrics and indicators will help create a business case for making an investment in the maturity of the Cost Management Discipline.

## Metrics

Cost Management generally focuses on metrics related to costs. The following are a few common metrics aligned to this discipline of cloud governance:

- Annual Spend: The total annual cost for services provided by a cloud provider
- Monthly Spend: The total monthly cost for services provided by a cloud provider
- Forecast vs Actual Ratio: The ratio comparing forecasted and actual spend (Monthly or Annual)
- Pace of adoption (MOM) Ratio: The percentage of the delta in cloud costs from month to month

## Risk Tolerance Indicators

During early deployments, such as Dev/Test or first workloads, cost management is likely to be of relatively low risk. As more assets are deployed, the risk grows and the business' tolerance for risk is likely to decline. Additionally, as more cloud adoption teams are given the ability to configure or deploy assets to the cloud, the risk grows and tolerance decreases. Conversely, growing a cost management discipline will take people from the effort to adoption the cloud and deploy innovative new technologies.

In the early stages of cloud adoption, work with the business to determine a risk tolerance baseline. In this baseline, determine the criteria that would trigger an investment in cost management. This may be different with every company. 

The following are a few examples of how the metrics above can indicate a desire to invest in cost management. Once [business risks](./business-risks.md) have been identified, work with the business to identify the benchmarks that would start to make them uncomfortable with each risk.

- Commit driven (Most Common): Our company is committing to spend $X,000,000 this year with a cloud vendor. We need a cost management discipline to ensure we don't overspend by more than 20% and use at least 90% of that commitment.
- Percentage Trigger: Cloud spend is stable for production systems. If that changes by more that X%, then a cost management discipline would be a wise investment.
- Over Provision Trigger: We believe deployed solutions are over provisioned. Cost management is a priority investment until we can demonstrate proper alignment of provisioning and asset utilization.
- Monthly spend trigger: Any monthly spend over $x,000 is considered a sizable cost. If spend exceeds that amount in a given month, we will need to invest in cost management.
- Annual spend trigger: IT's R&D budget will allow for $X,000 per year in cloud experimentation. We may run production workloads in the cloud, but it will still be considered an experimental solution if the budget doesn't exceed that amount. Once it goes over, we will need to treat the budget like a production investment and manage spend closely.
- OpEx adverse (uncommon): As a company, we are very OpEx adverse and will need cost management controls in place before deploying a dev/test workload.

## Next steps

Using the [Cloud Management Template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating cost policy adherence](monitor-enforce.md).

> [!div class="nextstepaction"]
> [Monitor and Enforce Policy Statements](./monitor-enforce.md)