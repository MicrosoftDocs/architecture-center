---
title: "Fusion: Motivations and business risks that drive resource management governance"
description: Learn about the discipline of resource management as part of a cloud governance strategy.
author: alexbuckgit
ms.date: 1/9/2019
---

# Fusion: Motivations and business risks that drive resource management governance

<!-- markdownlint-disable MD026 -->

## Is resource management relevant?

Resource management is crucial to ensure that resources are deployed, updated, and configured consistently and repeatably. Deprovisioning resources during periods of reduced load or when resources are no longer needed helps control operating costs. Monitoring resources help the business keep their systems running optimally and securely.

## Business risk

The resource management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

- **Cost overruns**. Resources should be assessed to determine expected operating costs under anticipated load. Opportunities should be identified for reducing resource costs by scaling down or deprovisioning resources during periods of low demand.
- **Lack of cost tracking**. The lack of a common naming standard for resources can create confusion and increase the costs of managing and monitoring resource usage. Resources should also be tagged to help keep track of resource costs by their associate application or business unit. Inconsistent or missing resource tags make it difficult to associate costs with parts of the organization that incurred them.
- **Unauthorized resource access**. Assignment of permissions for resource access must be carefully managed to ensure that resources are not improperly accessed, changed, or deleted.  
- **Expeditures for obsolete resources**. Over time, resources that were deployed to support earlier versions of business applications may become obsolete due to application design changes. If these resources are not identified and deprovisioned, the organization may incur costs for resources that provide no value.

## Next steps

Using the [Cloud Management Template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's [tolerance for risk](./metrics-tolerance.md) and the indicators and key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./metrics-tolerance.md)

<!-- markdownlint-enable MD026 -->
