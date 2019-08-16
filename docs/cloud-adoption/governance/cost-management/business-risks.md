---
title: "Cost Management motivations and business risks"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Cost Management motivations and business risks
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

# Cost Management motivations and business risks

This article discusses the reasons that customers typically adopt a Cost Management discipline within a cloud governance strategy. It also provides a few examples of business risks that drive policy statements.

<!-- markdownlint-disable MD026 -->

## Is Cost Management relevant?

In terms of cost governance, cloud adoption creates a paradigm shift. Management of cost in a traditional on-premises world is based on refresh cycles, datacenter acquisitions, host renewals, and recurring maintenance issues. You can forecast, plan, and refine each of these costs to align with annual capital expenditure budgets.

For cloud solutions, many businesses tend to take a more reactive approach to Cost Management. In many cases, businesses will prepurchase, or commit to use, a set amount of cloud services. This model assumes that maximizing discounts, based on how much the business plans on spending with a specific cloud vendor, creates the perception of a proactive, planned cost cycle. However, that perception will only become a reality if the business also implements mature Cost Management disciplines.

The cloud offers self-service capabilities that were previously unheard of in traditional on-premises datacenters. These new capabilities empower businesses to be more agile, less restrictive, and more open to adopt new technologies. However, the downside of self-service is that end users can unknowingly exceed allocated budgets. Conversely, the same users can experience a change in plans and unexpectedly not use the amount of cloud services forecasted. The potential of shift in either direction justifies investment in a Cost Management discipline within the governance team.

## Business risk

The Cost Management discipline attempts to address core business risks related to expenses incurred when hosting cloud-based workloads. Work with your business to identify these risks and monitor each of them for relevance as you plan for and implement your cloud deployments.

Risks will differ between organization, but the following serve as common cost-related risks that you can use as a starting point for discussions within your cloud governance team:

- **Budget control:** Not controlling budget can lead to excessive spending with a cloud vendor.
- **Utilization loss:** Prepurchases or precommitments that go unused can result in wasted investments.
- **Spending anomalies:** Unexpected spikes in either direction can be indicators of improper usage.
- **Overprovisioned assets:** When assets are deployed in a configuration that exceed the needs of an application or virtual machine (VM), they can increase costs and create waste.

## Next steps

Using the [Cloud Management template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's tolerance for risk and the indicators and key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./metrics-tolerance.md)
