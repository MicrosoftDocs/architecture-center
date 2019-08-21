---
title: "Cost Management tools in Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Cost Management tools in Azure
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Cost Management tools in Azure

[Cost Management](./index.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing cloud spending plans, allocating cloud budgets, monitoring and enforcement of cloud budgets, detecting costly anomalies, and adjusting the cloud governance plan when actual spending is misaligned.

The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

| Tool | [Azure portal](https://azure.microsoft.com/features/azure-portal)  | [Azure Cost Management](/azure/cost-management/overview-cost-mgt)  | [Azure EA Content Pack](/power-bi/service-connect-to-azure-enterprise)  | [Azure Policy](/azure/governance/policy/overview) |
|---------|---------|---------|---------|---------|
|Enterprise Agreement required?     | No         | No         | Yes         | No         |
|Budget control     | No         | Yes         | No         | Yes         |
|Monitor spending on single resource    | Yes         | Yes         | Yes         | No         |
|Monitor spending across multiple resources    | No         | Yes        | Yes         | No         |
|Control spending on single resource     | Yes - manual sizing         | Yes         | No         | Yes         |
|Enforce spending across multiple resources    | No         | Yes         | No         | Yes         |
|Enforce accounting metadata on resources    | No         | No         | No         | Yes         |
|Monitor and detect trends     | Yes - limited         | Yes        | Yes         | No         |
|Detect spending anomalies     | No         | Yes        | Yes         | No        |
|Socialize deviations     | No        | Yes        | Yes        | No        |
