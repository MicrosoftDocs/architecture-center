---
title: "Fusion: Policy enforcement" 
description: Discussion of policy enforcement subscriptions as a core design priority in Azure migrations
author: rotycenh
ms.date: 12/27/2018
---

# Fusion: Policy enforcement

Defining organizational policy is not effective unless there is a way to enforce it across your organization. A key aspect to planning any cloud migration is determining how best to combine tools provided by the cloud platform with your existing IT processes to maximize policy compliance across your entire cloud estate.

## Policy enforcement decision guide

![Plotting policy enforcement options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-policy-enforcement.png)

Jump to: [Baseline recommended practices](#baseline-recommended-practices) | [Policy compliance monitoring](#policy-compliance-monitoring) | [Policy enforcement](#policy-enforcement) | [Cross-organization policy](#cross-organization-policy) | [Automated enforcement](#automated-enforcement)

As your cloud estate grows, you will be faced with a corresponding need to maintain and enforce policy across a larger array of resources, subscriptions, and tenants. The larger your estate, the more complex your enforcement mechanisms will need to be to ensure consistent adherence and fast violation detection. Platform-provided policy enforcement mechanisms at the resource or subscription level are usually sufficient for smaller cloud deployments, while larger deployments may need to take advantage of more sophisticated mechanisms involving deployment standards, resource grouping and organization, and integrating policy enforcement with your logging and reporting systems.

The key inflection point when choosing the complexity of your policy enforcement strategy is primarily focused on the number of subscriptions or tenants required by your [subscription design](../subscriptions/overview.md). The amount of control granted to various user roles within your cloud estate might influence these decisions as well.

## Baseline recommended practices

For single subscription and simple cloud deployments, many corporate policies can be enforced using features that are native to most cloud platforms. Even at this relatively low level of deployment complexity, the consistent use of the patterns discussed throughout the CAF [decision guides](../overview.md) can help establish a baseline level of policy compliance.

For example:

- [Deployment templates](../resource-consistency/overview.md) can provision resources with standardized structure and configuration.
- [Tagging and naming standards](../resource-tagging/overview.md) can help organize operations and support accounting and business requirements.
- Traffic management and networking restrictions can be implemented through [software defined networking](../software-defined-network/overview.md).
- [Role-based access control](../identity/overview.md) can secure and isolate your cloud resources.

Start your cloud policy enforcement planning by examining how the application of the standard patterns discussed throughout these guides can help meet your organizational requirements.

## Policy compliance monitoring

Another key factor, even for relatively small cloud deployments, is the ability to verify that cloud-based applications and services comply with organizational policy, promptly notifying the responsible parties if a resource becomes noncompliant. Effectively [logging and reporting](../log-and-report/overview.md) the compliance status of your cloud workloads is a critical part of a corporate policy enforcement strategy.

As your cloud estate grows, additional tools such as [Azure Security Center](/azure/security-center/) can provide integrated security and threat detection, and help apply centralized policy management and alerting for both your on-premises and cloud assets.

## Policy enforcement

You can also apply configuration settings and resource creation rules at the subscription level to help ensure policy alignment.

[Azure Policy](/azure/governance/policy/overview) is an Azure service for creating, assigning, and managing policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. Azure Policy evaluates your resources for noncompliance with assigned policies. For example, you might want to limit the SKU size of virtual machines in your environment. Once a corresponding policy is implemented, new and existing resources would be evaluated for compliance. With the right policy, existing resources can be brought into compliance.

## Cross-organization policy

As your cloud estate grows to span many subscriptions that require enforcement, you will need to focus on a tenant-wide enforcement strategy to ensure policy consistency.

Your [subscription design](../subscriptions/overview.md) will need to account for policy as it relates to your organizational structure. In addition to helping support complex organization within your subscription design, [Azure management groups](../subscriptions/overview.md#management-groups) can be used to assign Azure Policy rules across multiple subscriptions.

## Automated enforcement

While standardized deployment templates are effective at a smaller scale, [Azure Blueprints](/azure/governance/blueprints/overview) allows large-scale standardized provisioning and deployment orchestration of Azure solutions. Workloads across multiple subscriptions can be deployed with consistent policy settings for any resources created.

For IT environments integrating cloud and on-premises resources, you may need use logging and reporting systems to provide hybrid monitoring capabilities. Your third-party or custom operational monitoring systems may offer additional policy enforcement capabilities. For complicated cloud estates, consider how best to integrate these systems with your cloud assets.

## Next steps

Learn how resource consistency is used to organize and standardize cloud deployments in support of subscription design and governance goals.

> [!div class="nextstepaction"]
> [Resource consistency](../resource-consistency/overview.md)
