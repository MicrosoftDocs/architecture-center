---
title: "Fusion: What tools can help better manage costs in Azure?"
description: Explanation of the concept cost management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/11/2018
---

# Fusion: What tools can help better manage costs in Azure?

In the [Intro to Cloud Governance](../overview.md), [Cost Management](overview.md) is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing cloud spend plans, allocations of cloud budgets, monitoring/enforcement of cloud budgets, detecting costly anomalies, and adjusting the plan when actual spending is misaligned.

Unlike the cloud-agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

|  | [Azure Portal](https://azure.microsoft.com/en-us/features/azure-portal/)  | [Azure Cost Management](https://docs.microsoft.com/en-us/azure/cost-management/overview-cost-mgt)  | [Azure EA Content Pack](https://docs.microsoft.com/en-us/power-bi/service-connect-to-azure-enterprise)  | [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) |
|---------|---------|---------|---------|---------|
|Enterprise Agreement Required?     | No         | Yes (not required with [Cloudyn](https://docs.microsoft.com/en-us/azure/cost-management/overview))         | Yes         | No         |
|Budget Control     | No         | Yes         | No         | Yes         |
|Monitor spend on single resource    | Yes         | Yes         | Yes         | No         |
|Monitor spend across multiple resources    | No         | Yes        | Yes         | No         |
|Control spend on single resource     | Yes - manual sizing         | Yes         | No         | Yes         |
|Enforce spend across multiple resources    | No         | Yes         | No         | Yes         |
|Monitor & detect trends     | Yes - limited         | Yes        | Yes         | No         |
|Detect spend anomalies     | No         | Yes        | Yes         | No        |
|Socialize deviations     | No        | Yes        | Yes        | No        |
