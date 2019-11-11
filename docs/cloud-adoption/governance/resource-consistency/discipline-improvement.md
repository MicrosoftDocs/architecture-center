---
title: "Resource Consistency discipline improvement"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Resource Consistency discipline improvement
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Resource Consistency discipline improvement

The Resource Consistency discipline focuses on ways of establishing policies related to the operational management of an environment, application, or workload. Within the Five Disciplines of Cloud Governance, Resource Consistency includes the monitoring of application, workload, and asset performance. It also includes the tasks required to meet scale demands, remediate performance Service Level Agreement (SLA) violations, and proactively avoid SLA violations through automated remediation.

This article outlines some potential tasks your company can engage in to better develop and mature the Resource Consistency discipline. These tasks can be broken down into planning, building, adopting, and operating phases of implementing a cloud solution, which are then iterated on allowing the development of an [incremental approach to cloud governance](../journeys/index.md#an-incremental-approach-to-cloud-governance).

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1 - Adoption phases of the incremental approach to cloud governance.*

It's impossible for any one document to account for the requirements of all businesses. As such, this article outlines suggested minimum and potential example activities for each phase of the governance maturation process. The initial objective of these activities is to help you build a [Policy MVP](../journeys/index.md#an-incremental-approach-to-cloud-governance) and establish a framework for incremental policy improvement. Your cloud governance team will need to decide how much to invest in these activities to improve your Resource Consistency governance capabilities.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third-party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a cloud governance model.

## Planning and readiness

This phase of governance maturity bridges the divide between business outcomes and actionable strategies. During this process, the leadership team defines specific metrics, maps those metrics to the digital estate, and begins planning the overall migration effort.

**Minimum suggested activities:**

- Evaluate your [Resource Consistency toolchain](toolchain.md) options.
- Understand the licensing requirements for your cloud strategy.
- Develop a draft Architecture Guidelines document and distribute to key stakeholders.
- Become familiar with the resource manager you use to deploy, manage, and monitor all the resources for your solution as a group.
- Educate and involve the people and teams affected by the development of architecture guidelines.
- Add prioritized resource deployment tasks to your migration backlog.

**Potential activities:**

- Work with the business stakeholders and your cloud strategy team to understand the desired cloud accounting approach and cost accounting practices within your business units and organization as a whole.
- Define your [monitoring and policy enforcement](compliance-processes.md) requirements.
- Examine the business value and cost of outage to define remediation policy and SLA requirements.
- Determine whether you'll deploy a [simple workload](./governance-simple-workload.md) or [multiple team](./governance-multiple-teams.md) governance strategy for your resources.
- Determine scalability requirements for your planned workloads.

## Build and predeployment

Several technical and nontechnical prerequisites are required to successful migrate an environment. This process focuses on the decisions, readiness, and core infrastructure that proceeds a migration.

**Minimum suggested activities:**

- Implement your [Resource Consistency toolchain](toolchain.md) by rolling out in a predeployment phase.
- Update the Architecture Guidelines document and distribute to key stakeholders.
- Implement resource deployment tasks on your prioritized migration backlog.
- Develop educational materials and documentation, awareness communications, incentives, and other programs to help drive user adoption.

**Potential activities:**

- Decide on a [subscription design strategy](../../decision-guides/subscriptions/index.md), choosing the subscription patterns that best fit your organization and workload needs.
- Use a [resource consistency](../../decision-guides/resource-consistency/index.md) strategy to enforce architecture guidelines over time.
- Implement [resource naming, and tagging standards](../../decision-guides/resource-tagging/index.md) for your resources to match your organizational and accounting requirements.
- To create proactive point-in-time governance, use deployment templates and automation to enforce common configurations and a consistent grouping structure when deploying resources and resource groups.
- Establish a least-privilege permissions model, where users have no permissions by default.
- Determine who in your organization owns each workload and account, and who will need to access to maintain or modify these resources. Define cloud roles and responsibilities that match these needs and use these roles as the basis for access control.
- Define dependencies between resources.
- Implement automated resource scaling to match requirements defined in the Plan stage.
- Conduct access performance to measure the quality of services received.
- Consider deploying [policy](/azure/governance/policy/overview) to manage SLA enforcement using configuration settings and resource creation rules.

## Adopt and migrate

Migration is an incremental process that focuses on the movement, testing, and adoption of applications or workloads in an existing digital estate.

**Minimum suggested activities:**

- Migrate your [Resource Consistency toolchain](toolchain.md) from predeployment to production.
- Update the Architecture Guidelines document and distribute to key stakeholders.
- Develop educational materials and documentation, awareness communications, incentives, and other programs to help drive user adoption.
- Migrate any existing automated remediation scripts or tools to support defined SLA requirements.

**Potential activities:**

- Complete and test monitoring and reporting data with your chosen on-premises, cloud gateway, or hybrid solution.
- Determine if changes need to be made to SLA or management policy for resources.
- Improve operations tasks by implementing query capabilities to efficiently find resource across your cloud estate.
- Align resources to changing business needs and governance requirements.
- Ensure that your virtual machines, virtual networks, and storage accounts reflect actual resource access needs during each release, and adjust as necessary.
- Verify automated scaling of resources meets access requirements.
- Review user access to resources, resource groups, and Azure subscriptions, and adjust access controls as necessary.
- Monitor changes in resource access plans and validate with stakeholders if additional sign-offs are needed.
- Update changes to the Architecture Guidelines document to reflect actual costs.
- Determine whether your organization requires clearer financial alignment to P&Ls for business units.
- For global organizations, implement your SLA compliance or sovereignty requirements.
- For cloud aggregation, deploy a gateway solution to a cloud provider.
- For tools that don't allow for hybrid or gateway options, tightly couple monitoring with an operational monitoring tool.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities:**

- Customize your [Resource Consistency toolchain](toolchain.md) based on updates to your organization’s changing Cost Management needs.
- Consider automating any notifications and reports to reflect actual resource usage.
- Refine Architecture Guidelines to guide future adoption processes.
- Educate affected teams periodically to ensure ongoing adherence to the architecture guidelines.

**Potential activities:**

- Adjust plans quarterly to reflect changes to actual resources.
- Automatically apply and enforce governance requirements during future deployments.
- Evaluate underused resources and determine if they're worth continuing.
- Detect misalignments and anomalies between planned and actual resource usage.
- Assist the cloud adoption teams and the cloud strategy team in understanding and resolving these anomalies.
- Determine if changes need to be made to Resource Consistency for billing and SLAs.
- Evaluate logging and monitoring tools to determine whether your on-premises, cloud gateway, or hybrid solution needs adjusting.
- For business units and geographically distributed groups, determine if your organization should consider using additional cloud management features such as [Azure management groups](/azure/governance/management-groups) to better apply centralized policy and meet SLA requirements.

## Next steps

Now that you understand the concept of cloud resource governance, move on to learn more about [how resource access is managed](azure-resource-access.md) in Azure in preparation for learning how to design a governance model for a [simple workload](governance-simple-workload.md) or for [multiple teams](governance-multiple-teams.md).

> [!div class="nextstepaction"]
> [Learn about resource access in Azure](azure-resource-access.md)
> [Learn about service-level agreements for Azure](https://azure.microsoft.com/support/legal/sla)
> [Learn about logging, reporting, and monitoring](../../decision-guides/log-and-report/index.md)
