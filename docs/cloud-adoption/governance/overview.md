---
title: "Enterprise Cloud Adoption: governance overview"
description: Overview of governance content for Azure enterprise cloud adoption
author: BrianBlanchard
ms.date: 10/03/2018
---

# Enterprise Cloud Adoption: Governance overview

This section of Azure enterprise cloud adoption covers the topic of *governance*. If you are new to the topic of goverance in Azure, you can begin with [what is cloud resource governance?](../getting-started/what-is-governance.md) and [resource access management in Azure](../getting-started/azure-resource-access.md) in the [getting started](../getting-started/overview.md) section.

## Actionable governance guidance in the Enterprise Cloud Adoption Framework

Currently, the scope of this framework limits the conversation to initial governance design when preparing to deploy a workload. If you are familiar with the concept of governance, this section covers [governance design for a simple workload](governance-single-team.md) and [governance design for multiple teams and multiple workloads](governance-multiple-teams.md). Both of these documents include an implementation guide.

## Governance position of the Enterprise Cloud Adoption Framework

Governance is a broadly used term, referring both to the high level **concept of governance**, as outlined in the [Governance, Risk, and Compliance triangle](governance-risk-compliance-concept.md) and **governance practices** as outlined in this article. Throughout the Enterprise Cloud Adoption (ECA) framework, the topic of governance focuses on actionable governance practices, which include policies, management disciplines, and governance automation required to safely govern Cloud Adoption.


![Governance disciplines: Cost, Security, Identity, Resource, & Configuration management each emanating from Policies and Compliance](../_images/governance-and-services.png)
*Figure 1. Governance Disciplines.*


**Policy & Compliance:** The cloud offers many options for implementing management tools. However, a tool that is not grounded in pragmatic policies can produce unsatisfactory results. When defining a cloud governance strategy, it is wise to start with existing corporate policy, but apply a Growth Mindset accepting the inevitability of policy change. In some cases, regulatory compliance will supercede corporate policy and require a set of more stringent guidelines. Mature, enforceable, and flexible policies are the root of any mature governance strategy. When policies accurately reflect tangible risks and the business' tolerance for risk, as opposed to technical dogma, the policies and resultant strategy can be molded to align with the Cloud or any other form of technical deployment.

**Management Disciplines:** This framework focuses on five core management disciplines which extend corporate policies into the cloud to support safe Cloud Adoption. Those disciplines include [Cost Management](what-is-cost-management.md), [Security Management](what-is-security-management.md), [Identity Management](what-is-identity-management.md), [Resource Management](what-is-resource-management.md), and [Configuration Management](what-is-configuration-management.md). When policy focuses on risk & tolerance, management disciplines can extend those policies by applying proper risk mitigation to the chosen [deployment model](../getting-started/cloud-deployment-models.md).

**Governance Automation:** Throughout ECA, governance automation is defined as the tools and approaches that enable effective enforcement of policy across multiple management disciplines. In this context, Governance Automation includes logging, monitoring, notification, and automated enforcement of policy & compliance across management disciplines and [deployment models](../getting-started/cloud-deployment-models).

## Next steps

The first step to taking action in any governance strategy, is a [policy review](what-is-a-policy-review.md). [Policy and Compliance](What-is-policy-and-compliance.md) could be a useful guide during your policy review.

> [!div class="nextstepaction"]
> [Prepare for a policy review](what-is-a-policy-review.md)