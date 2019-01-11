---
title: "Fusion: Monitor and enforce cost management"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Cost management policy compliance processes

This article discusses an approach to creating processes that support a [cost management](./overview.md) governance discipline. Effective governance of cloud costs starts with recurring processes designed to support policy compliance. However, you can automate these processes and supplement with tooling to reduce the overhead of governance and allow for faster response to deviation.

## Planning, review, and reporting processes

The best cost management tools in the cloud are only as good as the processes and policies that they support. The following is a set of manual processes for any cost management discipline.

**Deployment planning:** Prior to deployment of any asset, establish a forecasted budget based on expected cloud allocation.

**Annual planning:** On an annual basis, perform a roll-up analysis on all deployed and to-be-deployed assets. Align budgets by business units, departments, teams, and other appropriate divisions to empower self-service adoption. Ensure that the leader of each billing unit is aware of the budget and how to track spending.

This is the time to make a pre-commitment or pre-purchase to maximize discounting. It is wise to align annual budgeting with the cloud vendor's fiscal year to further capitalize on year-end discount options.

**Quarterly planning:** On a quarterly basis, review budgets with each billing unit leader to align forecast and actual spend. If there are changes to the plan or unexpected spending patterns, align and reallocate the budget.

**Monthly reporting:** On a monthly basis, report actual spend against forecast. Notify billing leaders of any unexpected deviations.

These basic processes will help align spending and establish a foundation for the cost management discipline.

## Compliance violation triggers and enforcement actions

When violations are detected, you should take enforcement actions to realign with policy. You can automate most violation triggers using the tools outlined in the [Azure-Specific Toolchain](./toolchain.md).

The following are examples of triggers: 

* Monthly budget deviations: Disuss any deviations in monthly spend exceeding 20% Forecast versus Actual ratio with billing unit leader. Record resolutions and changes in forecast.
* Pace of adoption: Any deviation at a subscription level exceeding 20% will trigger a review with billing unit leader. Record resolutions and changes in forecast.

## Next steps

Using the [Cloud Management template](./template.md), document the processes and triggers that align to the current cloud adoption plan.

For guidance on executing cloud management policies in alignment with adoption plans, see the article on [maturity alignment](maturity-adoption-alignment.md).

> [!div class="nextstepaction"]
> [Align Discipline Maturity with Cloud Adoption Phases](./maturity-adoption-alignment.md)
