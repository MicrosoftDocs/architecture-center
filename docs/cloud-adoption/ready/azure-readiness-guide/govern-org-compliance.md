---
title: Governance, security, and compliance in Azure
description: Learn how to set up governance, security, and compliance for your Azure environment.
author: tvuylsteke
ms.author: kfollis
ms.date: 04/09/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-edit"
---

# Governance, security, and compliance in Azure

As you establish corporate policy and plan your governance strategies, you can use tools and services like **Azure Policy**, **Azure Blueprints**, and **Azure Security Center** to begin enforcing and automating your organization's governance decisions. It's also recommended that before you start your governance planning, you use the [Governance Benchmark tool](http://aka.ms/caf/gov/assess) to identify potential gaps in your organization's cloud governance approach. For more information on developing governance processes, see the [Cloud Adoption Framework's governance guidance](../../governance/index.md).

# [Azure Policy](#tab/AzurePolicy)

Azure Policy is a service that you use to create, assign, and manage policies. These policies enforce rules on your resources so those resources stay compliant with your corporate standards and service level agreements. Azure Policy scans your resources to identify resources that aren't compliant with the policies you implement. For example, you can have a policy to allow only a specific virtual machine (VM) size to run in your environment. When you implement this policy, it evaluates existing VMs in your environment and any new VMs that are deployed. The policy evaluation generates compliance events for you to use for monitoring and reporting.

Common policies you should consider:

- Enforce tagging for resources and resource groups.
- Restrict regions for deployed resources.
- Restrict expensive SKUs for specific resources.
- Audit use of important optional features like Azure-managed disks.

::: zone target="chromeless"

## Action

Get started by assigning a built-in policy to a management group, subscription, or resource group.

::: form action="OpenBlade[#blade/Microsoft_Azure_Policy/PolicyMenuBlade/GettingStarted]" submitText="Assign Policy" :::

::: zone-end

::: zone target="docs"

## Apply a policy

To apply a policy to a resource group:

1. Go to [Azure Policy](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyMenuBlade/GettingStarted).
1. Select **Assign a policy**.

## Learn more

To learn more, see:

- [Azure Policy](/azure/azure-policy).
- [Cloud Adoption Framework: Policy enforcement decision guide](../../decision-guides/policy-enforcement/index.md)

::: zone-end

# [Azure Blueprints](#tab/AzureBlueprints)

The Azure Blueprints service enables cloud architects and central information technology groups to define a repeatable set of Azure resources that implements and adheres to an organization's standards, patterns, and requirements. Azure Blueprints makes it possible for development teams to rapidly build and stand up new environments with trust they're building within organizational compliance using a set of built-in components -- such as networking -- to speed up development and delivery.

Blueprints are a declarative way to orchestrate the deployment of various resource templates and other artifacts such as:

- Role Assignments
- Policy Assignments
- Azure Resource Manager templates
- Resource Groups

::: zone target="chromeless"

## Action

Get started by creating a blueprint to configure role and policy assignments for the subscription.

::: form action="OpenBlade[#blade/Microsoft_Azure_Policy/BlueprintsMenuBlade/GetStarted]" submitText="Create a blueprint" :::

::: zone-end

::: zone target="docs"

## Create a blueprint

To create a blueprint:

1. Go to [Blueprints - Getting started](https://portal.azure.com/#blade/Microsoft_Azure_Policy/BlueprintsMenuBlade/GetStarted).
1. In the **Create a Blueprint** section, select **Create**.

## Learn more

To learn more, see:

- [Azure Blueprints](/azure/governance/blueprints).
- [Cloud Adoption Framework: Resource consistency decision guide](../../decision-guides/resource-consistency/index.md)

::: zone-end

# [Azure Security Center](#tab/AzureSecurityCenter)

Azure Security Center plays an important part in your governance strategy. It helps you stay on top of security with these features:

- Provides a unified view of security across your workloads.
- Collects, searches, and analyzes security data from a variety of sources, including firewalls and other partner solutions.
- Provides actionable security recommendations to fix issues before they can be exploited.
- Allows you to apply security policies across your hybrid cloud workloads to ensure compliance with security standards.

Many of the security features, like security policy and recommendations, are available for free. Some of the more advanced features, like just-in-time VM access and hybrid workload support are available under the Security Center standard tier. Just-in-time VM access can help reduce the network attack surface by controlling access to management ports on Azure VMs.

> [!TIP]
> Azure Security Center is enabled by default in each subscription. We recommend you enable data collection from virtual machines to allow Azure Security Center to install its agent and begin gathering data.

::: zone target="docs"

To explore Azure Security Center, go to the [Azure portal](https://portal.azure.com/#blade/Microsoft_Azure_Security/SecurityMenuBlade/SecurityMenuBlade/0).

## Learn more

To learn more, see:

- [Azure Security Center](/azure/security-center)
- [Just-in-time VM access](/azure/security-center/security-center-just-in-time#how-does-just-in-time-access-work)
- [Standard vs. free pricing tier](https://azure.microsoft.com/pricing/details/security-center)
- [Cloud Adoption Framework: Security Baseline governance discipline](../../governance/security-baseline/index.md)

::: zone-end

::: zone target="chromeless"
## Action

::: form action="OpenBlade[#blade/Microsoft_Azure_Security/SecurityMenuBlade/SecurityMenuBlade/0]" submitText="Explore Azure Security Center" :::

::: zone-end
