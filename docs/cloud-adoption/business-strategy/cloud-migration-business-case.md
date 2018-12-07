---
title: "Enterprise Cloud Adoption: Building a Cloud Migration Business Case"
description: Things to consider when building out a business justification for cloud migration
author: BrianBlanchard
ms.date: 11/30/2018
---

# Enterprise Cloud Adoption: Building a cloud migration business case

Cloud migrations can generate early Return on Investment (ROI) from cloud transformation efforts. However the process for developing a clear business justification with tangible, relevant costs and returns can be a complex process.This article will help the reader think through the data needed to create a financial model that aligns with cloud migration outcomes. First, lets dispel a few myths to align this conversation and prepare the reader for common mistakes made during this process.

## Dispelling cloud migration myths

**Cloud is always cheaper:** Its a common belief that it is cheaper to operate a datacenter in the cloud, than it is on-prem. While this can be an accurate statement, it's not an absolute. In some cases, cloud operating costs could be higher than on-prem costs. A few common examples would include: Poor Cost Governance, Misalignment of system architectures, Duplication of processes, Unusual system configurations, Increases in staffing costs. Many of these can be mitigated to create early ROI. Following the guidance in [Building the business justification](#building-the-business-justification) can help detect and avoid these misalignments. Dispelling the following myths could help with mitigation as well.

**Everything should go into the cloud:** There are also a number of business drivers for choosing a hybrid solution. Before finalizing the business model, it is wise to complete a first round quantitative analysis as described in the [Digital Estate articles](../digital-estate/rationalize-incremental.md) within Enterprise Cloud Adoption. For additional information on the individual quantitative drivers involved in rationalization, see the article on the [5 Rs of rationalization](../digital-estate/rationalize-incremental.md). Either approach will leverage easily obtained inventory data and a brief quantitative analysis to identify workloads or applications that could result in higher costs in the cloud. These approaches could also identify dependencies or traffic patterns that would necessitate a hybrid solution.

**Mirroring my on-premises environment will help me save money in the cloud:** During Digital Estate planning, it is not unheard of for customers to detect unused capacity in excess of 50% of the provisioned environment. If assets are provisioned in the cloud to match current provisioning, cost savings will be hard to realize. Consider reducing the size of the deployed assets to align with usage patterns, not provisioning patterns.

**Server costs drive cloud migration business cases:** Sometimes this is true. For some companies, it is important to reduce on-going capital expenses related to servers. However, this too depends. Companies with 5-8 year hardware refresh cycles are unlikely to see fast returns on their cloud migration. Companies with standardized or enforced refresh cycles can hit a break even point quickly. In either case, other expenses may be the financial triggers that justify the migration. The following are a few examples of costs that are commonly overlooked when taking a server-only or VM-only view of costs:

* Software costs of virtualization, servers, and middleware can be extensive. Cloud providers eliminate some of these costs. Two examples of a Cloud provider reducing virtualization costs would be programs like [Azure Hybrid Benefits](https://azure.microsoft.com/en-us/pricing/hybrid-benefit/#services) or [Reservations](https://azure.microsoft.com/en-us/reservations/)
* Business losses due to outages can quickly exceed hardware or software costs. If the current datacenter is unstable, work with the business to quantify the impact of outages in terms of opportunity costs or actual business costs.
* Environmental costs can also be impactful as well. For the average American family, their home is the biggest investment and highest cost in their budget. The same is often true for data centers as well. Real estate, facilities, and utility costs should represent a fair portion of the on-prem costs. When data centers are retired, those facilities can be repurposed by the business, or potentially the business could be released from the costs entirely.

**Operating Expense (OpEx) is better than Capital Expense (CapEx):** As explained in the [fiscal outcomes](business-outcomes/fiscal-outcomes.md) article, OpEx can be a very good thing. However, there are a number of industries that can see OpEx as a negative. The following are a few examples that would trigger tighter integration with the accounting and business units regarding the OpEx conversation:

* When the business sees capital assets as a driver for business valuation, CapEx reductions could be a negative outcome. While not a universal standard, this sentiment is most commonly seen in retail, manufacturing, construction industries.
* OpEx increases can also be seen as a negative outcome in businesses owned by a private equity firm or seeking capital influx.
* If the business is focused heavily on improving sales margins or reducing Cost of Goods Sold (COGS), he OpEx could be a negative outcome.

OpEx is not always a bad thing. Businesses are more likely to see OpEx as more favorable than CapEx. For instance, this approach can be well received by businesses that are attempting to improve cash flow, reduce capital investments, or decrease asset holdings.

Before providing a business justification that focuses on a conversion from CapEx to OpEx, understand which is better for the business. Accounting and procurement can often help best align the message to financial objectives.

**Moving to the cloud is like flipping a switch:** Migrations are a manually intense technical transformation. When developing a business justification, especially justifications that are time sensitive, consider the following aspects that could increase the time it takes to migrate assets:

* Bandwidth limitations: The amount of bandwidth between the current datacenter and the Cloud provider will drive timelines during migration.
* Business testing timelines: Testing applications with the business to certify readiness and performance can be time consuming. Aligning power users and testing processes is critical.
* Migration execution timelines: The amount of time and human effort required to execution the migration can increase costs and delay timelines. Allocating employees or contracting partners can also delay the process and should be accounted for in the plan.

The above common impacts and many others can slow the process of migration and increase costs.

## Building the business justification

The following process will define an approach to developing the business justification for cloud migrations. While interacting with this content, if the calculations or financial terms require additional explanation, see the article on [Financial Models](financial-models.md) for additional clarification.

At the highest level, the formula for business justification is simple. However, the subtle data points required to populate the formula can be difficult to align. At the highest level, the business justification focuses on the Return on Investment (ROI) associated with the proposed technical change. The generic formula for ROI is listed in the graphics below:

![Return on Investment (ROI) equals (Gain from Investment – Cost of Investment) / Cost of Investment](../_images/formula-roi.png)
*Figure 1. Return on Investment (ROI) calculation*

Unpacking this formula a bit creates a migration specific view of the formulas that drive each of the input variables on the right side of this equation. Each of those formulas will be pictured and described in the sections below.

### Migration Specific Initial Investment

* Cloud providers like Azure offer calculators to estimate cloud investments. An example of such a calculator is the [Azure Pricing calculator](https://azure.microsoft.com/en-in/pricing/)
* Some Cloud providers also support cost delta calculators. An example of a cost delta calculator would be the [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco)
* For more refined cost structures, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise.
* Estimate cost of migration
* Estimate the cost of any expected training opportunities. [Microsoft Learn](https://docs.microsoft.com/learn/) may be able to help mitigate those costs.
* In some companies, the time invested by existing staff members may need to be included in the initial costs. Consult the finance office for guidance.
* Discuss any additional costs or burden costs with the finance office for validation.

### Migration Specific Revenue Deltas

This section is often overlooked when creating a migration business justification. In some areas, the Cloud can cut costs. However, the ultimate goal of any transformation is going to yield better results, when it looks a bit further into the future. Consider the downstream impacts to understand long term revenue improvements. What new technologies will be available to the business after this migration, that can't be leveraged today? What projects or business objectives are blocked by dependencies on legacy technologies? What programs are on-hold, pending high cap-ex technology costs?

After considering the opportunities unlocked by the Cloud, work with the business to calculate the revenue increases that could come from those opportunities.

### Migration Specific Cost Deltas
Calculate any changes to costs that will come from the proposed migration. See [Financial Models](financial-models.md) article for details of the different types of cost deltas. Cloud providers often provide tools for cost delta calculations. An example of a cost delta calculator would be the [Azure Total Cost of Ownership (TCO) Calculator](https://azure.com/tco)

Other examples of costs that may be reduced by a Cloud Migration:

* Data Center termination or reduction (Environmental costs)
* Reduction in power consumed (Environmental costs)
* Rack Termination (Physical asset recovery)
* Prevent a hardware refresh (Cost Avoidance)
* Avoid a software renewal (Operational Cost Reduction or Cost Avoidance)
* Vendor consolidation (Operational Cost Reduction and potential Soft Cost Reduction)

### Surprising Results

If the ROI for a Cloud Migration isn't in line with expectations, the common myths above may prove valuable.

However, it is important to understand that a cost savings outcome is not always possible. There are applications that cost more to operate in the cloud than on-prem. These applications can significantly skew results in an analysis.

When the ROI is below 20%, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise, with specific attention to [rationalization](../digital-estate/rationalize.md) or [incremental rationalization](../digital-estate/rationalize-incremental.md). During quantitative analysis, perform a review of each application to find workloads that skew the results. It could be wise to remove those workloads from the plan. If usage data is available, consider reducing the size of VMs to match usage.

If the ROI is still misaligned, seek help from your Microsoft sales representative or [engage an experienced partner](https://azure.microsoft.com/en-us/migration/partners/).