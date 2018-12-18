---
title: "Fusion: How can a company add Resource Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Resource management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/14/2018
---

# Fusion: How can a company add Resource Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Resource Management is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the five disciplines of Cloud Governance, Resource management includes monitoring of applications, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance Service Level Agreement (SLA) violations, and proactively avoid performance SLA violations through automated remediation.

This article outlines the Cost Management process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in these activities to improve the Resource Management position.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Evaluate your [Resource Management Tool Chain](toolchain.md) options.
* Understand the licensing requirements for your cloud strategy.
* Develop a draft Architecture Guidelines document and distribute to key stakeholders.
* Become familiar with the resource manager you use to deploy, manage, and monitor all the resources for your solution as a group.
* Educate and involve the people and teams impacted by the development of Architecture Guidelines.
* Add prioritized resource deployment tasks to your [migration backlog](../../migration/plan/migration-backlog.md).

**Potential activities**

* Work with the business stakeholders and/or your [cloud strategy team](../../culture-strategy/what-is-a-cloud-strategy-team) to understand the desired [cloud accounting approach](../../business-strategy/cloud-accounting) and cost accounting practices within your business units and organization as a whole.
* Define your monitoring and reporting policies and requirements.
* Examine the business value and cost of outage to define remediation policy and SLA requirements.
* Determine whether you'll deploy [single team](../../governance/resource-management/governance-single-team.md) or [multiple team](../../governance/resource-management/governance-multiple-teams.md) governance strategy for your resources. 
* Determine scalability requirements for your planned workloads. 


## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Implement your [Resource Management Tool Chain](toolchain.md) by rolling out in a pre-deployment phase.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Implement resource deployment tasks on your prioritized migration backlog.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**

* Decide on a [subscription design strategy](../../infrastructure/subscriptions/overview.md), choosing the subscription patterns that best fit your organization and workload needs.
* Leverage a [resource grouping](../../infrastructure/resource-grouping/overview.md) strategy to enforce architecture guidelines over time.
* Implement [resource naming, and tagging standards](../../infrastructure/resource-tagging/overview.md) for your resources to match your organizational and accounting requirements. 
* To create proactive point-in-time governance, use deployment templates and automation to enforce common configurations and a consistent grouping structure when deploying resources and resource groups.
* Evaluate how your cloud-based monitoring systems will integrate with your existing on-premises or other external [monitoring and reporting](../infrastructure/logs-and-reporting/overview.md) solution, and determine if logging data should be replicated to an on-premises, cloud gateway, or hybrid solution. Implement any APIs or other import/export mechanisms used to support this decision.
* Establish a least privilege permissions model, where users have no permissions by default. 
* Determine who in your organization owns each workload and account, and who will need to access to maintain or modify these resources. Define cloud roles and responsibilities that match these needs and use use these roles as the basis for access control.
* Define dependencies between resources.
* Implement automated resource scaling to match requirements defined in the Plan stage.
* Conduct access performance to measure the quality of services received.
* Consider deploying [policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) to manage SLA enforcement using configuration settings and resource creation rules. 


## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Resource Management Tool Chain](toolchain.md) from pre-deployment to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.
* Migrate any existing automated remediation scripts or tools to support defined SLA requirements.

**Potential activities**

* Complete and test integration of cloud monitoring and reporting data with your chosen on-premises, cloud gateway, or hybrid solution. 
* Determine if changes need to be made to SLA or management policy for resources.
* Improve operations tasks by implementing query capabilities to efficiently find resource across your cloud estate. 
* Align resources to changing business needs and governance requirements.
* Ensure that your virtual machines, virtual networks, and storage accounts reflect actual resource access needs during each release, and adjust as necessary. 
* Verify automated scaling of resources meets access requirements.
* Review user access to resources, resource groups, and Azure subscriptions, and adjust access controls as necessary.
* Monitor changes in resource access plans and validate with stakeholders if additional sign-offs are needed.
* Update changes to the Architecture Guidelines document to reflect actual costs.
* Determine whether your organization requires clearer financial alignment to P&Ls for business units.
* For global organizations, implement your SLA compliance or sovereignty requirements.
* For cloud aggregation, deploy a gateway solution to a cloud provider.
* For tools that don't allow for hybrid or gateway options, tightly couple monitoring with an operational monitoring tool.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an  application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities**

* Customize your [Resource Management Tool Chain](toolchain.md) based on updates to your organization’s changing cost management needs.
* Consider automating any notifications and reports to reflect actual resource usage.
* Refine Architecture Guidelines to guide future adoption processes.
* Re-educate impacted teams on a periodic basis to ensure on-going adherence to the Architecture Guidelines.

**Potential activities**

* Adjust plans quarterly to reflect changes to actual resources.
* Automatically apply and enforce governance requirements during future deployments.
* Evaluate underused resources and determine if they're worth continuing.
* Detect misalignments and anomalies between planned and actual resource usage.
* Aid the Cloud Adoption Team and Cloud Strategy Team in understanding and resolving these anomalies. 
* Determine if changes need to be made to resource management for billing and SLAs.
* Evaluate logging and monitoring tools to determine whether your on-premises, cloud gateway, or hybrid solution needs adjusting.
* For business units and geographically-distributed groups, determine if your organization should consider using additional cloud management features (for example [management groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/)) to better apply centralized policy and meet SLA requirements.

## Next steps

Now that you understand the concept of cloud resource governance, move on to learn more about [how resource access is managed](azure-resource-access.md) in Azure in preparation for learning how to design a governance model for a [single team](governance-single-team.md) or [multiple teams](governance-multiple-teams.md).

> [!div class="nextstepaction"]
> [Learn about resource access in Azure](azure-resource-access.md)
> [Learn about SLAs for Azure](https://azure.microsoft.com/en-us/support/legal/sla/)
> [Learn about logging, reporting, and monitoring](../../infrastructure/logs-and-reporting/overview)
