---
title: "Fusion: Find the right balance of cost management in a Cloud Governance strategy"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Find the right balance of cost management in a Cloud Governance strategy

Cloud adoption creates a paradigm shift when it comes to cost governance. Management of cost in a traditional on-prem world is based on refresh cycles, data center acquisitions, host renewals, or recurring maintenance. Each of these costs can be forecasted, planned, and refined to align with annual Capital Expenditure budgets.

In the cloud, customers tend to take a more re-active approach to cost management. In many cases, the customer will pre-purchase, or commit to use, a set amount of cloud services. This model maximizes discounts based on how much of the customer plans to spend with the specific cloud vendor. This creates the perception of a proactive, planned cost cycle. However, that perception is only reality, if mature cost management disciplines are in place.

The cloud offers self-service capabilities that were unheard of in traditional on-prem datacenters. Those new capabilities empower the business to be more agile, less restrictive, and more open to adopt new technologies. However, the downside of self-service is that end users can unknowingly exceed allocated budgets. Conversely, the same users could experience a change in plans and unexpectedly not use the amount of cloud services forecasted. The potential of shift in either direction prompts for a cost management discipline within the governance team. The remainder of this article will discuss corporate policies and manual processes that can protect against misaligned cost forecasts.

## Business Risk

The cost management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

* Budget Control: Not controlling budget could lead to excessive spending with a cloud vendor
* Utilization Loss: Pre-purchases or pre-commits that are not used could result in wasted investments
* Spend Anomalies: Unexpected spikes in either direction could be indicators of improper usage
* Over provisioned Assets: When assets are deployed in a configuration that exceeds the needs of an application or vm, it increases costs and creates waste.

## Risk Tolerance

During early deployments, such as Dev/Test or first workloads, cost management is likely to be of relatively low risk. As more assets are deployed, the risk grows and the business' tolerance for risk is likely to decline. Additionally, as more cloud adoption teams are given the ability to configure or deploy assets to the cloud, the risk grows and tolerance decreases. Conversely, growing a cost management discipline will take people from the effort to adoption the cloud and deploy innovative new technologies.

In the early stages of cloud adoption, work with the business to determine a risk tolerance baseline. In this baseline, determine the criteria that would trigger an investment in cost management. This may be different with every company. The following are a few examples of risk tolerances and investment criteria:

* Commit driven (Most Common): Our company is committing to spend $X,000,000 this year with a cloud vendor. We need a cost management discipline to ensure we don't overspend by more than 20% and use at least 90% of that commitment.
* Percentage Trigger: Cloud spend is stable for production systems. If that changes by more that X%, then a cost management discipline would be a wise investment.
* Over Provision Trigger: We believe deployed solutions are over provisioned. Cost management is a priority investment until we can demonstrate proper alignment of provisioning and asset utilization.
* Monthly spend trigger: Any monthly spend over $x,000 is considered a sizable cost. If spend exceeds that amount in a given month, we will need to invest in cost management.
* Annual spend trigger: IT's R&D budget will allow for $X,000 per year in cloud experimentation. We may run production workloads in the cloud, but it will still be considered an experimental solution if the budget doesn't exceed that amount. Once it goes over, we will need to treat the budget like a production investment and manage spend closely.
* OpEx adverse (uncommon): As a company, we are very OpEx adverse and will need cost management controls in place before deploying a dev/test workload.

Work with the business and finance departments to understand the triggers that would make them uncomfortable with spending in the cloud. Once those triggers are established, it's easier to understand how much to investment in a Cost Management Discipline. Based on that tolerance, the following processes and policies could be used to govern spend.

## Suggested Processes

The best cost management tools in the cloud, can only be as good as the processes and policies they support. The following is a set of manual processes that are suggested for any cost management discipline, once an investment in this discipline is warranted.

**Deployment Planning:** Prior to deployment of any asset, establish a forecasted budget based on expected cloud allocation.

**Annual Planning:** On an annual basis, perform a roll up analysis on all deployed and to be deployed assets. Align budgets by business units, teams, or other appropriate divisions to empower self-service adoption. Ensure the leader of each billing unit is aware of the budget and how to track spend.

This could be a good point in time to make a pre-commitment or pre-purchase to maximize discounting. It could be wise to align annual budgeting with the cloud vendor's fiscal year to further capitalize on year end discount options.

**Quarterly Planning:** On a quarterly basis, review budgets with each billing unit leader to align forecast and actual spend. If there are changes to the plan or unexpected spending patterns, align and reallocate the budget.

**Monthly Reporting:** On a monthly basis, report actual spend against forecast. Notify billing leaders of any unexpected deviations.

These basic processes will help align spending and establish a foundation for the cost management discipline.

## Common Corporate Policies to strengthen a Cost Management Discipline

In addition to the core processes for establishing and monitoring the baseline, there are a number of policies that can be implemented to mitigate business risks. This section will outline a few common policies:

**Budget Overrun:** If overspending is a significant concern, implement tooling with the cloud provider to limit spending for each billing unit. This will align forecasts with a budgetary spending limit that can't be easily exceeded. One policy statement to mitigate this risk, is asserting that any assets deployed to the cloud must be aligned to a billing unit, with approved budget, and a mechanism for budgetary limits. In a Microsoft context, Azure Cost Management and/or Azure Policy could be used to enforce this policy automatically.

**Under Utilization:** If waste is a concern, implement a monitoring solution to report on any underutilized assets. This will identify opportunities to reduce waste and tighten spending. The corporate policy could state that all deployed assets must be registered with a solution that can monitor usage and report on any under utilization. In a Microsoft context, Azure Advisor could be used to provide this type of feedback.

**Poor user experience:** If user experience is more important than asset costs, the opposite type of policy may be important for some assets. For instance, the policy may state that any asset that hosts a customer facing web or mobile property must scale to meet performance SLAs. Requiring scale sets for any asset with port 80 open would enforce such a policy. Azure Policy and Azure Blueprints could help enforce the rule in an Azure environment.  

Feel free to use these corporate policies or create new ones, the goal of each policy is to advance a Cost Management Discipline. Ultimately, the goal is to mitigate risks that can't be tolerated, with as little resistance to cloud adoption as is possible. Balancing risk, tolerance, and policy will create Cloud Goverance disciplines that are easy to enforce and safe for the business to operate.

## Next steps

After establishing risk, tolerance, processes, and corporate policy, it's time to implement a cost management discipline.

Each of the policies above reference a cloud service that can be used to implement the policy. For additional tooling references, see the [Azure Specific Toolchain](toolchain.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns. Then modify that design to incorporate specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)