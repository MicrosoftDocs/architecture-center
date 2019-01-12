---
title: "Fusion: Motivations and business risks that drive security governance"
description: Explanation of the concept security management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/8/2019
---

# Fusion: Motivations and business risks that drive security governance

This article discusses the reasons that customers typically adopt a security management discipline within a cloud governance strategy. It also provides a few examples of business risks which drive policy statements.

## Is security management relevant?

Security is a key concern for any IT organization. Cloud deployments face many of the same security risks as workloads hosted in traditional on-premises datacenters. However, the nature of public cloud platforms, with a lack of direct ownership of the physical hardware storing and running your workloads, means cloud security requires its own policy and processes.

One of the primary things that set cloud security governance apart from traditional security policy is the ease with which resources can be created, potentially adding vulnerabilities if security isn't considered before deployment. The flexibility that technologies like [software defined networking (SDN)](../../infrastructure/software-defined-networking/overview.md) provide for rapidly changing your cloud-based network topology can also easily modify your overall network attack surface in unforeseen ways. Cloud platforms also provide tools and features that can improve your security capabilities in ways not always possible in on-premises environments. 

The amount you invest into security policy and processes will depend a great deal on the nature of your cloud deployment. Initial test deployments may only need the most basic of security policies in place, while a mission-critical workload will entail addressing complex and extensive security needs. All deployments will need to engage with the discipline at some level.

The security management discipline discussed in this section of the Fusion guidance covers the corporate policies and manual processes that you can put in place to protect your cloud deployment against security risks.

> [!NOTE]
>While it is important to understand [Identity Management](../identity-management/overview.md) in the context of Security Management and how that relates to Access Control, the [Five Disciplines of Cloud Governance](../overview.md) calls out [Identity Management](../identity-management/overview.md) as its own discipline, separate from security management.

## Business risk

The security management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

- **Data leaks**. Inadvertent exposure or loss of sensitive cloud-hosted data can lead to losing customers, contractual breaches, or legal consequences.
- **Service disruption**. Outages and other performance issues due to insecure infrastructure interrupts normal operations and can result in lost productivity or lost business.

## Next steps

Using the [Cloud Management Template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's [tolerance for risk](./metrics-tolerance.md) and the indicators / key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./metrics-tolerance.md)
