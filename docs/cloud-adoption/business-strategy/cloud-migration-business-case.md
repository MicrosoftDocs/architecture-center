---
title:  Building a cloud migration business case
titleSuffix: Enterprise Cloud Adoption
description: Things to consider when building a business justification for cloud migration
author: BrianBlanchard
ms.date: 12/10/2018
ms.topic: article
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Enterprise Cloud Adoption: Building a cloud migration business case

Cloud migrations can generate early return on investment (ROI) from cloud transformation efforts. However, developing a clear business justification with tangible, relevant costs and returns can be a complex process. This article will help you think about what data is needed to create a financial model that aligns with cloud migration outcomes. First, let's dispel a few myths about cloud migration, so your organization can avoid some common mistakes.

## Dispelling cloud migration myths

**Myth: Cloud is always cheaper.** It's a common belief that operating a datacenter in the cloud is always cheaper than on-premises. While this can be true, it's not an absolute. In some cases, cloud operating costs can actually be higher. Often this is caused by poor cost governance, misalignment of system architectures, duplication of processes, unusual system configurations, or increased staffing costs. Luckily, many of these problems can be mitigated to create early ROI. Following the guidance in [Building the business justification](#building-the-business-justification) can help detect and avoid these misalignments. Dispelling the other myths listed here can also help.

**Myth: Everything should go into the cloud.** In fact, there are a number of business drivers that may lead you to choose a hybrid solution. Before finalizing the business model, it's wise to complete a first round quantitative analysis as described in the [Digital Estate articles](../digital-estate/5-rs-of-rationalization.md). For additional information on the individual quantitative drivers involved in rationalization, see [The 5 Rs of rationalization](../digital-estate/5-rs-of-rationalization.md). Either approach will use easily obtained inventory data and a brief quantitative analysis to identify workloads or applications that could result in higher costs in the cloud. These approaches could also identify dependencies or traffic patterns that would necessitate a hybrid solution.

**Myth: Mirroring my on-premises environment will help me save money in the cloud.** During Digital Estate planning, it's not unheard of for customers to detect unused capacity in excess of 50% of the provisioned environment. If assets are provisioned in the cloud to match current provisioning, cost savings will be hard to realize. Consider reducing the size of the deployed assets to align with usage patterns, not provisioning patterns.

**Myth: Server costs drive the business cases for cloud migration.** Sometimes this is true. For some companies, it's important to reduce ongoing capital expenses related to servers. However, this depends on several factors. Companies with a 5&ndash; to 8&ndash;year hardware refresh cycle are unlikely to see fast returns on their cloud migration. Companies with standardized or enforced refresh cycles can hit a break-even point quickly. In either case, other expenses may be the financial triggers that justify the migration. The following are a few examples of costs that are commonly overlooked when taking a server-only or VM-only view of costs:

- Software costs of virtualization, servers, and middleware can be extensive. Cloud providers eliminate some of these costs. Two examples of a cloud provider reducing virtualization costs are the [Azure Hybrid Benefits](https://azure.microsoft.com/pricing/hybrid-benefit/#services) and [Reservations](https://azure.microsoft.com/reservations/) programs.
- Business losses due to outages can quickly exceed hardware or software costs. If the current datacenter is unstable, work with the business to quantify the impact of outages in terms of opportunity costs or actual business costs.
- Environmental costs can also be impactful. For the average American family, their home is the biggest investment and highest cost in their budget. The same is often true for data centers. Real estate, facilities, and utility costs represent a fair portion of on-premises costs. When data centers are retired, those facilities can be repurposed by the business, or potentially the business could be released from the costs entirely.

**Myth: Operating Expense (OpEx) is better than Capital Expense (CapEx).** As explained in the [fiscal outcomes](business-outcomes/fiscal-outcomes.md) article, OpEx can be a good thing. However, there are a number of industries that can see OpEx as a negative. The following are a few examples that would trigger tighter integration with the accounting and business units regarding the OpEx conversation:

- When the business sees capital assets as a driver for business valuation, CapEx reductions could be a negative outcome. While not a universal standard, this sentiment is most commonly seen in retail, manufacturing, and construction industries.
- OpEx increases can also be seen as a negative outcome in businesses owned by a private equity firm or seeking capital influx.
- If the business is focused heavily on improving sales margins or reducing Cost of Goods Sold (COGS), the OpEx could be a negative outcome.

OpEx is not always a bad thing. Businesses are more likely to see OpEx as more favorable than CapEx. For instance, this approach can be well received by businesses that are attempting to improve cash flow, reduce capital investments, or decrease asset holdings.

Before providing a business justification that focuses on a conversion from CapEx to OpEx, understand which is better for the business. Accounting and procurement can often help best align the message to financial objectives.

**Myth: Moving to the cloud is like flipping a switch.** Migrations are a manually intense technical transformation. When developing a business justification, especially justifications that are time sensitive, consider the following aspects that could increase the time it takes to migrate assets:

- Bandwidth limitations: The amount of bandwidth between the current datacenter and the Cloud provider will drive timelines during migration.
- Business testing timelines: Testing applications with the business to certify readiness and performance can be time consuming. Aligning power users and testing processes is critical.
- Migration execution timelines: The amount of time and human effort required to execute the migration can increase costs and delay timelines. Allocating employees or contracting partners can also delay the process and should be accounted for in the plan.

Technical and cultural impediments can slow cloud adoption. When time is an important aspect of the business justification, the best mitigation is proper planning. There are two suggested approaches during planning which can help mitigate timeline risks.

- First, invest the time and energy in understanding technical adoption constraints. While pressure to move quickly may be high, it is important to account for realistic execution timelines.
- Second, if culture or people impediments arise, they will have more serious impacts than the technical constraints. Cloud adoption creates change, which produces the desired transformation. Unfortunately, people sometimes fear change and may need additional support to align with the plan. Identify key people on the team that are opposed to change and engage them early.

To maximize readiness and mitigation of timeline risks, prepare executive stakeholders by firmly aligning business value and business outcomes. Help those stakeholders understand the changes that will come with this transformation. Be clear and set realistic expectations from the beginning. When people or technology slow the process, executive support will be easier to enlist.

## Building the business justification

The following process defines an approach to developing the business justification for cloud migrations. While reading this content, if the calculations or financial terms require additional explanation, see the article on [Financial Models](financial-models.md) for additional clarification.

At the highest level, the formula for business justification is simple. However, the subtle data points required to populate the formula can be difficult to align. At the highest level, the business justification focuses on the return on investment (ROI) associated with the proposed technical change. The generic formula for ROI is:

ROI = (Gain from Investment &minus; Initial Investment) / Initial Investment

Unpacking this formula creates a migration-specific view of the formulas that drive each of the input variables on the right side of this equation. The remaining sections of this article offer some considerations to take into account.

![ROI equals (Gain from Investment – Cost of Investment) / Cost of Investment](../_images/formula-roi.png)

## Migration-specific initial investment

- Cloud providers such as Azure offer calculators to estimate cloud investments. An example of such a calculator is the [Azure Pricing calculator](https://azure.microsoft.com/en-in/pricing/).
- Some cloud providers also support cost delta calculators. An example of a cost delta calculator is the [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco).
- For more refined cost structures, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise.
- Estimate the cost of migration.
- Estimate the cost of any expected training opportunities. [Microsoft Learn](https://docs.microsoft.com/learn/) may be able to help mitigate those costs.
- In some companies, the time invested by existing staff members may need to be included in the initial costs. Consult the finance office for guidance.
- Discuss any additional costs or burden costs with the finance office for validation.

## Migration-specific revenue deltas

This aspect is often overlooked when creating a migration business justification. In some areas, the cloud can cut costs. However, the ultimate goal of any transformation is to yield better results over time. Consider the downstream impacts to understand long-term revenue improvements. What new technologies will be available to the business after this migration, that can't be leveraged today? What projects or business objectives are blocked by dependencies on legacy technologies? What programs are on-hold, pending high cap-ex technology costs?

After considering the opportunities unlocked by the cloud, work with the business to calculate the revenue increases that could come from those opportunities.

## Migration-specific cost deltas

Calculate any changes to costs that will come from the proposed migration. See [Financial Models](financial-models.md) for details of the different types of cost deltas. Cloud providers often provide tools for cost delta calculations. An example of a cost delta calculator is the [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco).

Other examples of costs that may be reduced by a Cloud Migration:

- Data Center termination or reduction (Environmental costs)
- Reduction in power consumed (Environmental costs)
- Rack Termination (Physical asset recovery)
- Prevent a hardware refresh (Cost Avoidance)
- Avoid a software renewal (Operational Cost Reduction or Cost Avoidance)
- Vendor consolidation (Operational Cost Reduction and potential Soft Cost Reduction)

## When ROI results are surprising

If the ROI for a cloud migration isn't in line with expectations, it may be valuable to revisit the common myths listed at the begining of this article.

However, it's important to understand that a cost savings outcome is not always possible. There are applications that cost more to operate in the cloud than on-premises. These applications can significantly skew results in an analysis.

When the ROI is below 20%, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise, with specific attention to [rationalization](../digital-estate/rationalize.md). During quantitative analysis, perform a review of each application to find workloads that skew the results. It could be wise to remove those workloads from the plan. If usage data is available, consider reducing the size of VMs to match usage.

If the ROI is still misaligned, seek help from your Microsoft sales representative or [engage an experienced partner](https://azure.microsoft.com/en-us/migration/partners/).

## Next steps

> [!div class="nextstepaction"]
> [Create a financial model for cloud transformation](financial-models.md)