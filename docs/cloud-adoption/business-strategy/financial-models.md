---
title: Create a financial model for cloud transformation
titleSuffix: Fusion
description: How to create a financial model for cloud transformation
author: BrianBlanchard
ms.date: 12/10/2018
---

# Fusion: How to create a financial model for cloud transformation

Creating a financial model that accurately represents the full business value of any cloud transformation can be complicated. Financial models and business justifications tend to be different from one organization to the next. This article establishes some formulas and points out a few things that are commonly missed when creating a financial model.

## Return on investment (ROI)

Return on investment (ROI) is often an important criteria with the C-Suite or the board. ROI is used to compare different ways to invest limited capital resources. The formula for ROI is fairly simple. The details required to create each input to the formula may not be as simple. Essentially, ROI is the amount of return produced from an initial investment. Usually it is represented as a percentage:

![Return on Investment (ROI) equals (Gain from Investment – Cost of Investment) / Cost of Investment](../_images/formula-roi.png)

<!-- markdownlint-disable MD036 -->
*ROI = (Gain from Investment &minus; Initial Investment) / Initial Investment*
<!-- markdownlint-enable MD036 -->

In the next sections, we will walk through the data needed to calculate the initial investment and the gain from investment (earnings).

## Calculating initial investment

Initial investment is the capital expenditure (CapEx) and operating expenditure (OpEx) required to complete a transformation. The classification of costs can vary depending on accounting models and CFO preference. However, this category would include things like: Professional services to transform, software licenses that are used solely during the transformation, cost of cloud services during the transformation, and potentially the cost of the salaried employees during the transformation.

Add these costs together to create an estimate of the initial investment.

## Calculating the gain from investment

Gain from investment often requires a second formula for calculation, which is very specific to the business outcomes and associated technical changes. Earnings are not as simple as calculating reduction in costs.

To calculate earnings, two variables are required:

![Gain from Investment equals Revenue Deltas + Cost Deltas](../_images/formula-gain-from-investment.png)

<!-- markdownlint-disable MD036 -->
*Gain from Investment = Revenue Deltas + Cost Deltas*
<!-- markdownlint-enable MD036 -->

Each is described below.

## Revenue Delta

Revenue delta should be forecasted in partnership with the business. Once the business stakeholders agree on a revenue impact, that can be used to improve the earning position.

## Cost Deltas

Cost deltas are the amount of increase or decrease that will come as a result of the transformation. There are a number of independent variables that can impact cost deltas. Earnings are largely based on hard costs like capital expense reductions, cost avoidance, operational cost reductions, and depreciation reductions. The following sections are examples of cost deltas to consider.

### Depreciation reductions or acceleration

For guidance on depreciation, speak with the CFO or finance team. The following is meant to serve as a general reference on the topic of depreciation.

When capital is invested in the acquisition of an asset, that investment could be used for financial or tax purposes to produce ongoing benefits over the expected lifespan of the asset. Some companies see depreciation as a positive tax advantage. Others see it as committed, ongoing expense similar to other recurring expenses attributed to the annual IT budget.

Speak with the finance office to see if elimination of depreciation is possible, and if it would make a positive contribution to cost deltas.

### Physical asset recovery

In some cases, retired assets can be sold as a source of revenue. Often, this revenue is lumped into cost reduction for simplicity. However, it's truly an increase in revenue and may be taxed as such. Speak with the finance office to understand the viability of this option and how to account for the resulting revenue.

### Operational cost reductions

Recurring expenses required to operate the business are often referred to as operational expenses (OpEx). OpEx is a very broad category. In most accounting models, it would include software licensing, hosting expenses, electric bills, real estate rentals, cooling expenses, temporary staff required for operations, equipment rentals, replacement parts, maintenance contracts, repair services, Business Continuity/Disaster Recovery (BC/DR) services, and a number of other expenses that don't require capital expense approvals.

This category is one of the largest earnings areas when considering an Operational Transformation Journey. Time invested in making this list exhaustive is seldom wasted. Ask questions of the CIO and finance team to ensure all operational costs are accounted for.

### Cost avoidance

When an operational expense (OpEx) is expected, but not yet in an approved budget, it may not fit into a cost reduction category. For instance, if VMWare and Microsoft licenses need to be renegotiated and paid next year, they aren't fully qualified costs yet. Reductions in those expected costs would be treated like operational costs for the sake of cost delta calculations. Informally, however, they should be referred to as "cost avoidance," until negotiation and budget approval is complete.

### Soft cost reductions

In some companies, soft costs such as reductions in operational complexity or reduction in full-time staff to operate a datacenter could also be included. However, including soft costs can be ill-advised. Including soft costs inserts an undocumented assumption that the reduction in costs will equate to tangible cost savings. Technology projects seldom result in actual soft cost recovery.

### Headcount reductions

Time savings for staff are often included under soft cost reduction. When those time savings map to actual reduction of IT salary or staffing, it could be calculated separately as a headcount reduction.

That said, the skills needed on-premises generally map to a similar (or higher level) set of skills needed in the cloud. That means people generally don't get laid off after a cloud migration.

An exception is when operational capacity is provided by a third party or managed services provider (MSP). If IT systems are managed by a third party, the costs to operate could be replaced by a cloud-native solution or cloud-native MSP. A cloud native MSP is likely to operate more efficiently and potentially at a lower cost. If that's the case, operational cost reductions belong in the hard cost calculations.

### Capital expense reductions or avoidance

Capital expenses (CapEx) are slightly different that operational expenses. Generally, this category is driven by refresh cycles or datacenter expansion. An example of a datacenter expansion would be a new high-performance cluster to host a Big Data solution or data warehouse, and would generally fit into a CapEx category. More common are the basic refresh cycles. Some companies have rigid hardware refresh cycles, meaning assets are retired and replaced on a regular cycle (usually every 3, 5, or 8 years). These cycles often coincide with asset lease cycles or forecasted lifespan of equipment. When a refresh cycle hits, IT draws CapEx to acquire new equipment.

If a refresh cycle is approved and budgeted, the Cloud Transformation could help eliminate that cost. If a refresh cycle is planned but not yet approved, the Cloud Transformation could create a CapEx cost avoidance. Both scenarios would be added to the cost delta.
