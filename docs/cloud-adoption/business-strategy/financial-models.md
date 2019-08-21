---
title: "Create a financial model for cloud transformation"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: How to create a financial model for cloud transformation.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: strategy
ms.custom: governance
---

# Create a financial model for cloud transformation

Creating a financial model that accurately represents the full business value of any cloud transformation can be complicated. Financial models and business justifications tend to vary for different organizations. This article establishes some formulas and points out a few things that are commonly missed when strategists create financial models.

## Return on investment

Return on investment (ROI) is often an important criteria for the C-suite or the board. ROI is used to compare different ways to invest limited capital resources. The formula for ROI is fairly simple. The details you'll need to create each input to the formula might not be as simple. Essentially, ROI is the amount of return produced from an initial investment. It's usually represented as a percentage:

![ROI equals (gain from investment minus cost of investment) divided by cost of investment](../_images/formula-roi.png)

In the next sections, we'll walk through the data you'll need to calculate the initial investment and the gain from investment (earnings).

## Calculating initial investment

Initial investment is the capital expense and operating expense required to complete a transformation. The classification of costs can vary depending on accounting models and CFO preference. But this category would include items like professional services to transform, software licenses used only during the transformation, the cost of cloud services during the transformation, and potentially the cost of salaried employees during the transformation.

Add these costs to create an estimate of the initial investment.

## Calculating the gain from investment

Calculating the gain from investment often requires a second formula that's specific to the business outcomes and associated technical changes. Calculating earnings is harder than calculating cost reductions.

To calculate earnings, you need two variables:

![Gain from investment equals revenue deltas plus cost deltas](../_images/formula-gain-from-investment.png)

These variables are described in the following sections.

## Revenue deltas

Revenue deltas should be forecast in partnership with business stakeholders. After the business stakeholders agree on a revenue impact, it can be used to improve the earning position.

## Cost deltas

Cost deltas are the amount of increase or decrease that will be caused by the transformation. Independent variables can affect cost deltas. Earnings are largely based on hard costs like capital expense reductions, cost avoidance, operational cost reductions, and depreciation reductions. The following sections describe some cost deltas to consider.

### Depreciation reduction or acceleration

For guidance on depreciation, speak with the CFO or finance team. The following information is meant to serve as a general reference on the topic of depreciation.

When capital is invested in the acquisition of an asset, that investment could be used for financial or tax purposes to produce ongoing benefits over the expected lifespan of the asset. Some companies see depreciation as a positive tax advantage. Others see it as a committed, ongoing expense similar to other recurring expenses attributed to the annual IT budget.

Speak with the finance office to find out if elimination of depreciation is possible and if it would make a positive contribution to cost deltas.

### Physical asset recovery

In some cases, retired assets can be sold as a source of revenue. This revenue is often lumped into cost reduction for simplicity. But it's truly an increase in revenue and can be taxed as such. Speak with the finance office to understand the viability of this option and how to account for the resulting revenue.

### Operational cost reductions

Recurring expenses required to operate a business are often called operating expenses. This is a broad category. In most accounting models, it includes:

- Software licensing.
- Hosting expenses.
- Electric bills.
- Real estate rentals.
- Cooling expenses.
- Temporary staff required for operations.
- Equipment rentals.
- Replacement parts.
- Maintenance contracts.
- Repair services.
- Business continuity and disaster recovery (BCDR) services.
- Other expenses that don't require capital expense approvals.

This category provides one of the highest earning deltas. When you're considering a cloud migration, time invested in making this list exhaustive is rarely wasted. Ask the CIO and finance team questions to ensure all operational costs are accounted for.

### Cost avoidance

When an operating expenditure is expected but not yet in an approved budget, it might not fit into a cost reduction category. For example, if VMware and Microsoft licenses need to be renegotiated and paid next year, they aren't fully qualified costs yet. Reductions in those expected costs are treated like operational costs for the sake of cost-delta calculations. Informally, however, they should be referred to as "cost avoidance" until negotiation and budget approval is complete.

### Soft-cost reductions

At some companies, soft costs like reductions in operational complexity or reductions in full-time staff for operating a datacenter could also be included in cost deltas. But including soft costs might not be a good idea. When you include soft-cost reductions, you insert an undocumented assumption that the reduction will create tangible cost savings. Technology projects rarely result in actual soft-cost recovery.

### Headcount reductions

Time savings for staff are often included under soft-cost reduction. When those time savings map to actual reduction of IT salary or staffing, they could be calculated separately as headcount reductions.

That said, the skills needed on-premises generally map to a similar (or higher-level) set of skills needed in the cloud. So people aren't generally laid off after a cloud migration.

An exception occurs when operational capacity is provided by a third party or managed services provider (MSP). If IT systems are managed by a third party, the operating costs could be replaced by a cloud-native solution or cloud-native MSP. A cloud-native MSP is likely to operate more efficiently and potentially at a lower cost. If that's the case, operational cost reductions belong in the hard-cost calculations.

### Capital expense reductions or avoidance

Capital expenses are slightly different from operating expenses. Generally, this category is driven by refresh cycles or datacenter expansion. An example of a datacenter expansion would be a new high-performance cluster to host a big data solution or data warehouse. This expense would generally fit into a capital expense category. More common are the basic refresh cycles. Some companies have rigid hardware refresh cycles, meaning assets are retired and replaced on a regular cycle (usually every three, five, or eight years). These cycles often coincide with asset lease cycles or the forecasted life span of equipment. When a refresh cycle hits, IT draws capital expense to acquire new equipment.

If a refresh cycle is approved and budgeted, the cloud transformation could help eliminate that cost. If a refresh cycle is planned but not yet approved, the cloud transformation could avoid a capital expenditure. Both reductions would be added to the cost delta.

## Next steps

Learn more about [cloud accounting](./cloud-accounting.md) models.

> [!div class="nextstepaction"]
> [Cloud accounting](./cloud-accounting.md)
