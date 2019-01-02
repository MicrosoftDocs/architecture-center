---
title: "Fusion: Monitor and enforce cost management"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Monitor and enforce cost management

This article discusses an approach to monitoring and enforcing policies that govern [cost management](./overview.md). Effective governance of cloud costs starts with recurring processes. However, those processes can be automated and supplemented with tooling to reduce the overhead of governance and allow for faster response to deviation.

## Cost Management Processes

The best cost management tools in the cloud, can only be as good as the processes and policies they support. The following is a set of manual processes that are suggested for any cost management discipline.

**Deployment Planning:** Prior to deployment of any asset, establish a forecasted budget based on expected cloud allocation.

**Annual Planning:** On an annual basis, perform a roll up analysis on all deployed and to be deployed assets. Align budgets by business units, teams, or other appropriate divisions to empower self-service adoption. Ensure the leader of each billing unit is aware of the budget and how to track spend.

This could be a good point in time to make a pre-commitment or pre-purchase to maximize discounting. It could be wise to align annual budgeting with the cloud vendor's fiscal year to further capitalize on year end discount options.

**Quarterly Planning:** On a quarterly basis, review budgets with each billing unit leader to align forecast and actual spend. If there are changes to the plan or unexpected spending patterns, align and reallocate the budget.

**Monthly Reporting:** On a monthly basis, report actual spend against forecast. Notify billing leaders of any unexpected deviations.

These basic processes will help align spending and establish a foundation for the cost management discipline.

## Violation Triggers and Enforcement Actions

When violations are detected, enforcement actions are likely to be taken to realign with policy. The following are a few examples of triggers. Most violation triggers can be automated using the tools outlined in the [Azure-Specific Toolchain](./toolchain.md).

* Monthly Budget Deviations: Any deviations in monthly spend exceeding 20% Forecast vs Actual ratio will be discussed with billing unit leader. Resolutions or changes in forecast will be recorded.
* Pace of Adoption: Any deviation at a subscription level exceeding 20% will trigger a review with billing unit leader. Resolutions or changes in forecast will be recorded.

## Next steps

Using the [Cloud Management Template](./template.md), document the processes and triggers that align to the current cloud adoption plan.

FOr guidance on executing cloud management policies in alignment with cloud adoption plans, see the article on [maturity alignment](maturity-adoption-alignment.md).

> [!div class="nextstepaction"]
> [Align Discipline Maturity with Cloud Adoption Phases](./maturity-adoption-alignment.md)