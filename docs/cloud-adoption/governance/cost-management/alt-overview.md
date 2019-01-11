---
title: "Fusion: Find the right balance of cost management in a cloud governance strategy"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/03/2019
---

# Fusion: Find the right balance of cost management in a cloud governance strategy

Cloud adoption creates a paradigm shift when it comes to cost governance. Management of cost in a traditional on-premises world is based on refresh cycles, data center acquisitions, host renewals, and recurring maintenance. Each of these costs can be forecasted, planned, and refined to align with annual capital expenditure budgets.

In the cloud businesses tend to take a more reactive approach to cost management. In many cases, customers will pre-purchase or commit to use a set amount of cloud services. This model assumes that maximizing discounts, based on how much a customer plans to spend with a specific cloud vendor, will create the perception of a proactive, planned cost cycle. However, that perception will only become a reality if the business, in turn, adopts mature cost management disciplines.

The cloud offers self-service capabilities that were previously unheard of in traditional on-premises datacenters. These new capabilities empower businesses to be more agile, less restrictive, and more open to adopt new technologies. However, the downside of self-service is that end users can unknowingly exceed allocated budgets. Conversely, the same users could experience a change in plans and unexpectedly not use the amount of cloud services that the business forecasted. The potential of shift in either direction prompts for a cost management discipline within the governance team. The remainder of this article discusses corporate policies and manual processes that business can implement to protect against misaligned cost forecasts.

## Business risk

The cost management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

- Budget control: Not controlling budget can lead to excessive spending with a cloud vendor
- Utilization loss: Pre-purchases or pre-commits that are not used can result in wasted investments
- Spending anomalies: Unexpected spikes in either direction can be indicators of improper usage
- Overprovisioned assets: When assets are deployed in a configuration that exceed the needs of an application or virtual machine (VM), this can increase costs and create waste

## Risk tolerance

During early deployments, such as Dev/Test or first workloads, cost management is likely to be relatively low risk. As more assets are deployed, the risk grows and the business' tolerance for risk is likely to decline. Additionally, as your cloud adoption team acheives the ability to configure and deploy assets to the cloud, risks will grow and tolerance will decrease. Conversely, growing a cost management discipline will take you from adoption to the cloud towards deploying more innovative new technologies.

In the early stages of cloud adoption, work with your business to determine a risk tolerance baseline. With this baseline, next determine the criteria that will trigger an investment in cost management, which will be different for each business. 

The following are a few examples of risk tolerances and investment criteria:

* Commit driven (most common): A company that is committed to spending $X,000,000 this year on a cloud vendor. They need a cost management discipline to ensure that the business doesn't overspend by more than 20%, and they will use at least 90% of that commitment.
* Percentage trigger: A company with cloud spending that is stable for their production systems. If that changes by more that X%, then a cost management discipline will be a wise investment.
* Over=provision trigger: A company who believes their deployed solutions are over provisioned. Cost management is a priority investment until they can demonstrate proper alignment of provisioning and asset utilization.
* Monthly spend trigger: A company that spends over $x,000 per month is considered a sizable cost. If spending exceeds that amount in a given month, they will need to invest in cost management.
* Annual spend trigger: A company with an IT R&D budget that allows for spending $X,000 per year on cloud experimentation. They may run production workloads in the cloud, but they will still be considered experimental solutions if the budget doesn't exceed that amount. Once it goes over, they will need to treat the budget like a production investment and manage spending closely.
* OpEx adverse (uncommon): As a company, they are very OpEx adverse and will need cost management controls in place before deploying a dev/test workload.

Be sure to work with your business and finance departments to understand which triggers that will make them uncomfortable with spending on a cloud solution. Once these triggers are established, it's much easier to understand the amount to invest in a cost management discipline. Based on your business' tolerance, the following processes and policies can be used to govern spending.

## Suggested processes

The best cost management tools in the cloud are only as good as the processes and policies that they support. The following is a set of manual processes that are suggested for any cost management discipline, once an investment in this discipline is warranted.

**Deployment planning:** Prior to deployment of any asset, establish a forecasted budget based on expected cloud allocation.

**Annual planning:** On an annual basis, perform a roll-up analysis on all deployed and to-be-deployed assets. Align budgets by business units, departments, teams, or other appropriate divisions to empower self-service adoption. Ensure that the leader of each billing unit is aware of the budget and how to track spending.

This may be an ideal time to make a pre-commitment or pre-purchase to maximize discounting. You can also consider aligning annual budgeting with the cloud vendor's fiscal year to further capitalize on year-end discount options.

**Quarterly planning:** On a quarterly basis, review budgets with each billing unit leader to align forecast and actual spending. If there are changes to the plan or unexpected spending patterns, align and reallocate the budget.

**Monthly reporting:** On a monthly basis, report actual spending against your forecasted budget. Notify billing leaders of any unexpected deviations.

These basic processes will help align spending and establish a foundation for the cost management discipline.

## Common policy statements to strengthen the cost management discipline

In addition to the core processes for establishing and monitoring the baseline, there are a number of policy statements that can be implemented to mitigate business risks. This section outlines common policy statements:

**Future proof:** Current criteria doesn't warrant an investment in a cost management discipline from the governance team. However, such an investment is anticipated in the future. Current policy requires that all assets deployed to the cloud be associated with a billing unit, application/workload, and meet naming standards. This policy will ensure that future cost management efforts will be effective. For guidance on establishing a future proofed foundation, see the [design guide for Cloud Native deployments](../design-guides/future-proof/design-guide.md).

**Budget overrun:** If overspending is a significant concern, implement tooling with the cloud provider to limit spending for each billing unit. This will align forecasts with a budgetary spending limit that can't be easily exceeded. One policy statement you can use to mitigate this risk is asserting that any assets deployed to the cloud must be aligned to a billing unit with approved budget, and a mechanism for budgetary limits. In a Microsoft context, Azure Cost Management and/or Azure Policy can be used to enforce this policy automatically.

**Under utilization:** If waste is a concern for your business, implement a monitoring solution to report any underutilized assets. This will identify opportunities to reduce waste and tighten spending. The corporate policy will state that all deployed assets must be registered with a solution that can monitor usage and report on any under utilization. In a Microsoft context, Azure Advisor could be used to provide this type of feedback.

**Poor user experience:** If user experience is more important than asset costs, the opposite type of policy may be important for some assets. For instance, the policy may state that any asset that hosts a customer facing web or mobile property must scale to meet performance service level agreements (SLAs). For example, requiring scale sets for any asset with port 80 open will enforce such a policy. Azure Policy and Azure Blueprints can help enforce the rule in an Azure environment.  

Use any of these corporate policies or create new ones. The goal of each policy is to advance a cost management discipline in your organization. Ultimately, the goal is for you to mitigate risks that can't be tolerated, with as little resistance to cloud adoption as is possible. Balancing risk, tolerance, and policy will create cloud goverance disciplines that are easy to enforce and safe for the business to operate.

## Next steps

After establishing risk, tolerance, processes, and corporate policy, you will implement a cost management discipline.

Each of the policies above reference a cloud service that can be used to implement the policy. For additional tooling references, see the [Azure Specific Toolchain](toolchain.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns with your business. Then modify that design to incorporate specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)
