---
title: "CAF: Cost Management tools in Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Cost Management tools in Azure
author: BrianBlanchard
---

# Cost Management tools in Azure

[Cost Management](overview.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing cloud spending plans, allocating cloud budgets, monitoring and enforcement of cloud budgets, detecting costly anomalies, and adjusting the cloud governance plan when actual spending is misaligned.

The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

|  | [Azure portal](https://azure.microsoft.com/features/azure-portal)  | [Azure Cost Management](/azure/cost-management/overview-cost-mgt)  | [Azure EA Content Pack](/power-bi/service-connect-to-azure-enterprise)  | [Azure Policy](/azure/governance/policy/overview) |
|---------|---------|---------|---------|---------|
|Enterprise agreement required?     | No         | Yes (not required with [Cloudyn](/azure/cost-management/overview))         | Yes         | No         |
|Budget control     | No         | Yes         | No         | Yes         |
|Monitor spending on single resource    | Yes         | Yes         | Yes         | No         |
|Monitor spending across multiple resources    | No         | Yes        | Yes         | No         |
|Control spending on single resource     | Yes - manual sizing         | Yes         | No         | Yes         |
|Enforce spending across multiple resources    | No         | Yes         | No         | Yes         |
|Monitor and detect trends     | Yes - limited         | Yes        | Yes         | No         |
|Detect spending anomalies     | No         | Yes        | Yes         | No        |
|Socialize deviations     | No        | Yes        | Yes        | No        |
