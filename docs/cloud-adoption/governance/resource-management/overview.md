---
title: "Fusion: How can a company add Resource Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Resource management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: How can a company add Resource Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Resource Management is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the five disciplines of Cloud Governance, Resource management includes monitoring of application, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance SLA violations, and proactively avoid performance SLA violations through automated remediation.

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

**Potential activities**

* Define Azure resource and [resource groups](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/governance/resource-management/azure-resource-access?branch=brian%2FCOMIntegration) for your cloud provider subscription. 
* Determine whether you'll deploy [single team](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/governance/resource-management/governance-single-team?branch=brian%2FCOMIntegration) or [multiple team](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/governance/resource-management/governance-multiple-teams?branch=brian%2FCOMIntegration) governance strategy for your resources. 
* Determine your worlkload and account owners.
* Consider establishing a permissions model of least privilege where users have no permissions by default. 
* Establish cloud roles and responsibilities for access control to all services.

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Implement your [Resource Management Tool Chain](toolchain.md) by rolling out in a pre-deployment phase.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**
* Authenticate users and authorize user access to resources.
* Enforce common configurations amongst resource groups to create proactive point-in-time governance.
* Leverage a resource grouping strategy to enforce architecture guidelines over time.
* Define dependencies between resources.
* Conduct access performance to measure the quality of services received.
* Utilize [resource naming and tagging schemes](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/infrastructure/resource-tagging/overview?branch=brian%2FCOMIntegration) for your resrouces. 
* Ensure a consistent grouping structure by using a template deployment.
* Consider deploying [policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) to manage subscription level enforcement using configuration settings and resource creation rules. 

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Resource Management Tool Chain](toolchain.md) from pre-deployment to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**
* Determine whether changes need to be made to managing your resources.
* Improve Ops by implementing efficient query capabilities across your adoption efforts. 
* Align resources to changing business needs and governance requirements.
* Ensure that your virtual machines, virtual networks, and storage accounts reflect actual resource access needs during each release, and adjust as necessary.
* Review your access resources, resoure groups, and Azure subscriptions, and adjust as necessary.
* Monitor changes in resource access plans and validate with stakeholders if additional sign-offs are needed.
* Update changes to the Architecture Guidelines document to reflect actual costs.

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
* Remediate underused resources and determine if they're worth continuing.
* Detect misalignments and anomalies between the plan and actual resource usage.
* Aid the Cloud Adoption Team and Cloud Strategy Team in understanding and resolving these anomalies. 
* Determine if changes needd to be made to resource management for billing and SLAs.

## Next steps

Now that you understand the concept of cloud resource governance, move on to learn more about [how resource access is managed](azure-resource-access.md) in Azure in preparation for learning how to design a governance model for a [single team](governance-single-team.md) or [multiple teams](governance-multiple-teams.md).

> [!div class="nextstepaction"]
> [Learn about resource access in Azure](azure-resource-access.md)
