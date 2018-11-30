---
title: "Fusion: Creating a business case for Cloud Migration"
description: Things to consider when building out a business justification for cloud migration
author: BrianBlanchard
ms.date: 11/30/2018
---

# Fusion: Creating a business justification for Cloud Migration

Cloud migrations are amongst the easiest business justifications to create in IT today. When the numbers line up and are properly interpreted. This article will help the reader think through the data needed to create of a financial model that aligns with cloud migration outcomes. First, lets dispel a few myths to align this conversation.

## Dispelling cloud migration myths

**Cloud is always cheaper:** Its a common belief that it is cheaper to operate a data center in the cloud, than it is on-prem. While this can be an accurate statement, it's not an absolute. There are many use cases which could drive cloud operations costs beyond current on-prem costs. These include: Poor Cost Governance, Misaligned system architecture, Duplication of processes, Increased staffing costs, Unusual system configurations. Many of these can be mitigated. However, they can create an analysis that shows on-prem costs to be higher. When that type of output arises, see the following section for more guidance.

**Everything should go into the cloud:** Quite the contrary. There are a number of workloads that operate better in physical machines. There are also a number of business drivers for choosing a hybrid solution. Before finalizing the business model, it is wise to complete a first round quantitative analysis as described in the [Digital Estate articles](../digital-estate/rationalize-incremental.md) within Fusion.

**IT is efficient:** During Digital Estate planning, it is not unheard of for customers to see unused capacity in excess of 50% of the provisioned environment. If assets are provisioned in the cloud to match current provisioning, cost savings will be hard to realize. Consider reducing the size of the deployed assets to align with usage patterns, not provisioning patterns.

**Server costs drive cloud migrations:** Sometimes this is true. For some companies, it is important to reduce on-going capital expenses related to servers. However, this too depends. Companies with 5-8 year hardware refresh cycles are unlikely to see fast returns on their cloud migration. Companies with standardized or enforced refresh cycles can hit a break even point quickly. In either case, its the other expenses that justify the migration.

* Software costs of virtualization, servers, and middleware can be extensive. Cloud providers eliminate some of these costs. They can also reduce many of these costs through programs like [Hybrid Use Benefits](https://azure.microsoft.com/en-us/pricing/hybrid-benefit/#services)
* Business losses due to outages can quickly exceed hardware or software costs. If the current data center is unstable, work with the business to quantify the impact.
* Environmental costs can also be impactful. For the average American family, their home is the biggest investment and highest cost in their budget. The same is often true for data centers as well. Unfortunately, allocation of real estate, facilities, and utility costs could be masking the environmental costs. 7% test: If environmental costs (real estate, power, cooling) are less than 7% of the total data center costs, there may be a few missing data points

**OpEx is better than CapEx:** As explained in the [fiscal outcomes](business-outcomes/fiscal-outcomes.md) article, OpEx can be a very good thing. However, there are a number of industries that see OpEx as a negative. Before providing a business justification, understand which is better for the business & plan accordingly.

**Moving to the cloud is like flipping a switch:** Migrations are a manually intense technical transformation. If human power is not a limitor, bandwidth will be. The size of the outbound internet pipe limits the speed of any migration. When developing a business case, remember to account for time and potential partner costs to help execute the migration.

## Building the business justification

In the [Financial Models](financial-models.md) article, the process for calculating Return on Investment (ROI) is described in detail. 

The following will fill in the financial model process and formulas with a number of data points to consider:

### Calculate "Initial Investment"

* Estimate Azure costs using any of the [Cost Calculators](../digital-estate/calculate.md).
* For more refined cost structures, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise.
* Estimate cost of migration
* Estimate the cost of any expected training opportunities. [Microsoft Learn](https://docs.microsoft.com/learn/) may be able to help mitigate those costs.
* In some companies, the time invested by existing staff members may need to be included in the initial costs. Consult the finance office for guidance.
* Discuss any additional costs or burden costs with the finance office for validation.

### Revenue Deltas

This section is often overlooked when creating a migration business justification. In some areas, the Cloud can cut costs. However, the ultimate goal of any transformation is going to yield better results, when it looks a bit further into the future. Consider the downstream impacts to understand long term revenue improvements. What new technologies will be available to the business after this migration, that can't be leveraged today? What projects or business objectives are blocked by dependencies on legacy technologies? What programs are on-hold, pending high cap-ex technology costs?

After considering the opportunities unlocked by the Cloud, work with the business to calculate the revenue increases that could come from those opportunties.

### Cost Deltas

Calculate any changes to costs that will come from the proposed migration. See [Financial Models](financial-models.md) article for details of the different types of cost deltas.

Examples of costs that may be reduced by a Cloud Migration:

* Data Center termination (Environmental costs)
* Reduction in power consumed (Environmental costs)
* Rack Termination (Physical asset recovery)
* Prevent a hardware refresh (Cost Avoidance)
* Avoid a software renewal (Operational Cost Reduction or Cost Avoidance)
* Vendor consolidation (Operational Cost Reduction and potential Soft Cost Reduction)

### Surprising Results

If the ROI for a Cloud Migration isn't inline with expectations, the common myths above may prove valuable.

However, it is important to understand that a cost savings outcome is not always possible. There are applications that cost more to operate in the cloud than on-prem. These applications can significantly skew results in an analysis. 

When the ROI is below 20%, consider a [Digital Estate Planning](../digital-estate/overview.md) exercise, with specific attention to [rationalization](../digital-estate/rationalize.md) or [incremental rationalization](../digital-estate/rationalize-incremental.md). During quantitative analysis, perform a review of each application to find workloads that skew the results. It could be wise to remove those workloads from the plan. If usage data is available, consider reducing the size of VMs to match usage.

If the ROI is still misaligned, seek help from your Microsoft sales representative or [engage an experienced partner](https://azure.microsoft.com/en-us/migration/partners/).