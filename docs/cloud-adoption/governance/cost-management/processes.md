---
title: "Fusion: Monitor and enforce cost management"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Cost management policy compliance processes

This article discusses an approach to creating processes that support a [cost management](./overview.md) governance discipline. Effective governance of cloud costs starts with recurring manual processes designed to support policy compliance. This requires regular involvement of the cloud governance team and interested business stakeholders to review and update policy and ensure policy compliance. In addition, many ongoing monitoring and enforcement processes can be automated or supplemented with tooling to reduce the overhead of governance and allow for faster response to policy deviation.

## Planning, review, and reporting processes

The best cost management tools in the cloud are only as good as the processes and policies that they support. The following is a set of example processes commonly involved in the cost management discipline. Use these examples as a starting point when planning the processes that will allow you to continue to update cost policy based on business change and feedback from the business teams subject to cost governance guidance.

**Initial risk assessment and planning**: As part of your initial adoption of the cost management discipline, identify your core business risks and tolerances related to cloud costs. Use this information to discuss budget and cost-related risks with members of your business teams and develop a baseline set of policies for mitigating these risks to establish your initial governance strategy.

**Deployment planning:** Prior to deployment of any asset, establish a forecasted budget based on expected cloud allocation. Ensure that ownership and accounting information for the deployment is documented.  

**Annual planning:** On an annual basis, perform a roll-up analysis on all deployed and to-be-deployed assets. Align budgets by business units, departments, teams, and other appropriate divisions to empower self-service adoption. Ensure that the leader of each billing unit is aware of the budget and how to track spending.

This is the time to make a pre-commitment or pre-purchase to maximize discounting. It is wise to align annual budgeting with the cloud vendor's fiscal year to further capitalize on year-end discount options.

**Quarterly planning:** On a quarterly basis, review budgets with each billing unit leader to align forecast and actual spend. If there are changes to the plan or unexpected spending patterns, align and reallocate the budget.

This quarterly planning process is also a good time to evaluate the current membership of your cloud governance team for knowledge gaps related to current or future business plans. Invite relevant staff and workload owners to participate in reviews and planning as either temporary advisors or permanent members of your team.

**Education and Training**: On a bi-monthly basis, offer training sessions to make sure business and IT staff are up-to-date on the latest cost management policy requirements. As part of this process review and update any documentation, guidance, or other training assets to ensure they are in sync with the latest corporate policy statements.

**Monthly reporting:** On a monthly basis, report actual spend against forecast. Notify billing leaders of any unexpected deviations.

These basic processes will help align spending and establish a foundation for the cost management discipline.

## Ongoing monitoring processes

A successful cost management governance strategy depends on visibility into the past, current, and planned future cloud-related spending. Without the ability to analyze the relevant metrics and data of your existing costs, you cannot identify changes in your risks or detect violations of your risk tolerances. The ongoing governance processes discussed above require quality data to ensure policy can be modified to better protect your infrastructure against changing business  requirements and cloud usage.

Ensure that your IT teams have implemented automated systems for monitoring your cloud spending and usage for unplanned deviations from expected costs. Establish reporting and alerting systems to ensure prompt detection and mitigation of potential policy violations.

## Compliance violation triggers and enforcement actions

When violations are detected, you should take enforcement actions to realign with policy. You can automate most violation triggers using the tools outlined in the [Azure-Specific Toolchain](toolchain.md).

The following are examples of triggers:

* Monthly budget deviations: Discuss any deviations in monthly spend exceeding 20% Forecast versus Actual ratio with billing unit leader. Record resolutions and changes in forecast.
* Pace of adoption: Any deviation at a subscription level exceeding 20% will trigger a review with billing unit leader. Record resolutions and changes in forecast.

## Next steps

Using the [Cloud Management template](./template.md), document the processes and triggers that align to the current cloud adoption plan.

For guidance on executing cloud management policies in alignment with adoption plans, see the article on [maturity alignment](maturity-adoption-alignment.md).

> [!div class="nextstepaction"]
> [Align Discipline Maturity with Cloud Adoption Phases](./maturity-adoption-alignment.md)
