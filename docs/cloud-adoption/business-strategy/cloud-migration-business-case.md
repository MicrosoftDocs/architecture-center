---
title: "Build a business justification for cloud migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Considerations for building a business justification for cloud migration.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: strategy
ms.custom: governance
---

# Build a business justification for cloud migration

Cloud migrations can generate early return on investment (ROI) from cloud transformation efforts. But developing a clear business justification with tangible, relevant costs and returns can be a complex process. This article will help you think about what data you need to create a financial model that aligns with cloud migration outcomes. First, let's dispel a few myths about cloud migration, so your organization can avoid some common mistakes.

## Dispelling cloud migration myths

**Myth: Cloud is always cheaper.** It's commonly believed that operating a datacenter in the cloud is always cheaper than operating one on-premises. While this assumption might generally be true, it's not always the case. Sometimes cloud operating costs are higher. These higher costs are often caused by poor cost governance, misaligned system architectures, process duplication, atypical system configurations, or greater staffing costs. Fortunately, you can mitigate many of these problems to create early ROI. Following the guidance in [Building the business justification](#building-the-business-justification) can help you detect and avoid these misalignments. Dispelling the other myths described here can help too.

**Myth: Everything should go into the cloud.** In fact, some business drivers might lead you to choose a hybrid solution. Before you finalize a business model, it's smart to complete a first-round quantitative analysis, as described in the [digital estate articles](../digital-estate/5-rs-of-rationalization.md). For more information on the individual quantitative drivers involved in rationalization, see [The 5 Rs of rationalization](../digital-estate/5-rs-of-rationalization.md). Either approach will use easily obtained inventory data and a brief quantitative analysis to identify workloads or applications that could result in higher costs in the cloud. These approaches could also identify dependencies or traffic patterns that would necessitate a hybrid solution.

**Myth: Mirroring my on-premises environment will help me save money in the cloud.** During digital estate planning, it's not unheard of for businesses to detect unused capacity of more than 50% of the provisioned environment. If assets are provisioned in the cloud to match current provisioning, cost savings are hard to realize. Consider reducing the size of the deployed assets to align with usage patterns rather than provisioning patterns.

**Myth: Server costs drive business cases for cloud migration.** Sometimes this assumption is true. For some companies, it's important to reduce ongoing capital expenses related to servers. But it depends on several factors. Companies with a five-year to eight-year hardware refresh cycle are unlikely to see fast returns on their cloud migration. Companies with standardized or enforced refresh cycles can hit a break-even point quickly. In either case, other expenses might be the financial triggers that justify the migration. Here are a few examples of costs that are commonly overlooked when companies take a server-only or VM-only view of costs:

- Costs of software for virtualization, servers, and middleware can be extensive. Cloud providers eliminate some of these costs. Two examples of a cloud provider reducing virtualization costs are the [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/#services) and [Azure reservations](https://azure.microsoft.com/reservations) programs.
- Business losses caused by outages can quickly exceed hardware or software costs. If your current datacenter is unstable, work with the business to quantify the impact of outages in terms of opportunity costs or actual business costs.
- Environmental costs can also be significant. For the average American family, a home is the biggest investment and the highest cost in the budget. The same is often true for datacenters. Real estate, facilities, and utility costs represent a fair portion of on-premises costs. When datacenters are retired, those facilities can be repurposed, or your business could potentially be released from these costs entirely.

**Myth: An operating expense model is better than a capital expense model.** As explained in the [fiscal outcomes](business-outcomes/fiscal-outcomes.md) article, an operating expense model can be a good thing. But some industries view operating expenditures negatively. Here are a few examples that would trigger tighter integration with the accounting and business units regarding the operating expense conversation:

- When a business sees capital assets as a driver for business valuation, capital expense reductions could be a negative outcome. Though it's not a universal standard, this sentiment is most commonly seen in the retail, manufacturing, and construction industries.
- A private equity firm or a company that's seeking capital influx might consider operating expense increases as a negative outcome.
- If a business focuses heavily on improving sales margins or reducing cost of goods sold (COGS), operating expenses could be a negative outcome.

Businesses are more likely to see operating expense as more favorable than capital expense. For example, this approach might be well received by businesses that are trying to improve cash flow, reduce capital investments, or decrease asset holdings.

Before you provide a business justification that focuses on a conversion from capital expense to operating expense, understand which is better for your business. Accounting and procurement can often help align the message to financial objectives.

**Myth: Moving to the cloud is like flipping a switch.** Migrations are a manually intense technical transformation. When developing a business justification, especially justifications that are time sensitive, consider the following aspects that could increase the time it takes to migrate assets:

- **Bandwidth limitations:** The amount of bandwidth between the current datacenter and the cloud provider will drive timelines during migration.
- **Testing timelines:** Testing applications with the business to ensure readiness and performance can be time consuming. Aligning power users and testing processes is critical.
- **Migration timelines:** The amount of time and effort required to implement the migration can increase costs and cause delays. Allocating employees or contracting partners can also delay the process. The plan should account for these allocations.

Technical and cultural impediments can slow cloud adoption. When time is an important aspect of the business justification, the best mitigation is proper planning. During planning, two approaches can help mitigate timeline risks:

- Invest the time and energy in understanding technical adoption constraints. Though pressure to move quickly might be high, it's important to account for realistic timelines.
- If cultural or people impediments arise, they'll have more serious effects than technical constraints. Cloud adoption creates change, which produces the desired transformation. Unfortunately, people sometimes fear change and might need additional support to align with the plan. Identify key people on the team who are opposed to change and engage them early.

To maximize readiness and mitigation of timeline risks, prepare executive stakeholders by firmly aligning business value and business outcomes. Help those stakeholders understand the changes that will come with the transformation. Be clear and set realistic expectations from the beginning. When people or technologies slow the process, it will be easier to enlist executive support.

## Building the business justification

The following process defines an approach to developing the business justification for cloud migrations. For more information about the calculations and financial terms, see the article on [financial models](financial-models.md).

At the highest level, the formula for business justification is simple. But the subtle data points required to populate the formula can be difficult to align. On a basic level, the business justification focuses on the return on investment (ROI) associated with the proposed technical change. The generic formula for ROI is:

![ROI equals (gain from investment minus cost of investment) divided by cost of investment](../_images/formula-roi.png)

We can unpack this equation to get a migration-specific view of the formulas for the input variables on the right side of the equation. The remaining sections of this article offer some considerations to take into account.

## Migration-specific initial investment

- Cloud providers like Azure offer calculators to estimate cloud investments. The [Azure pricing calculator](https://azure.microsoft.com/pricing) is one example.
- Some cloud providers also provide cost-delta calculators. The [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco) is one example.
- For more refined cost structures, consider a [digital estate planning](../digital-estate/index.md) exercise.
- Estimate the cost of migration.
- Estimate the cost of any expected training opportunities. [Microsoft Learn](/learn) might be able to help mitigate those costs.
- At some companies, the time invested by existing staff members might need to be included in the initial costs. Consult the finance office for guidance.
- Discuss any additional costs or burden costs with the finance office for validation.

## Migration-specific revenue deltas

This aspect is often overlooked by strategists creating a business justification for migration. In some areas, the cloud can cut costs. But the ultimate goal of any transformation is to yield better results over time. Consider the downstream effects to understand long-term revenue improvements. What new technologies will be available to your business after the migration that can't be used today? What projects or business objectives are blocked by dependencies on legacy technologies? What programs are on hold, pending high capital expenditures for technology?

After you consider the opportunities unlocked by the cloud, work with the business to calculate the revenue increases that could come from those opportunities.

## Migration-specific cost deltas

Calculate any changes to costs that will come from the proposed migration. See the [financial models](financial-models.md) article for details about the types of cost deltas. Cloud providers often offer tools for cost-delta calculations. The [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco) is one example.

Other examples of costs that might be reduced by a cloud migration:

- Datacenter termination or reduction (environmental costs)
- Reduction in power consumed (environmental costs)
- Rack termination (physical asset recovery)
- Hardware refresh avoidance (cost avoidance)
- Software renewal avoidance (operational cost reduction or cost avoidance)
- Vendor consolidation (operational cost reduction and potential soft-cost reduction)

## When ROI results are surprising

If the ROI for a cloud migration doesn't match your expectations, you might want to revisit the common myths listed at the beginning of this article.

But it's important to understand that a cost savings isn't always possible. Some applications cost more to operate in the cloud than on-premises. These applications can significantly skew results in an analysis.

When the ROI is below 20%, consider a [digital estate planning](../digital-estate/index.md) exercise, paying specific attention to [rationalization](../digital-estate/rationalize.md). During quantitative analysis, review each application to find workloads that skew the results. It might make sense to remove those workloads from the plan. If usage data is available, consider reducing the size of VMs to match usage.

If the ROI is still misaligned, seek help from your Microsoft sales representative or [engage an experienced partner](https://azure.microsoft.com/migration/support).

## Next steps

> [!div class="nextstepaction"]
> [Create a financial model for cloud transformation](./financial-models.md)
