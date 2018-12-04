---
title: "Enterprise Cloud Adoption: Things to consider when creating a Cloud Transformation financial model"
description: Explanation of the concept cloud financial models
author: BrianBlanchard
ms.date: 10/10/2018
---

# Enterprise Cloud Adoption: How to create a financial model for cloud transformation?

Creating a financial model that accurately represents the full business value of any cloud transformation can be complicated. Financial models and full business justification tends to be different from one organization to the next. This article will help establish a few formulas and point out a few things commonly missed when creating a financial model.

## Return on Investment (ROI)

For readers with an MBA, this first section might not add a lot of value. No one will be offended, if you choose to skip ahead. For the technically minded reader, this basic understanding can prove very important.

Return on Investment (ROI) is often an important criteria with the C-Suite and/or the board. ROI is used to compare different ways to invest limited capital resources. The formula for ROI is fairly simple. The details required to create each input to the formula may not be as simple. Essentially, ROI is the amount of return produced from an initial investment. Usually it is represented as a percentage.

![Return on Investment (ROI) equals (Gain from Investment – Cost of Investment) / Cost of Investment](../_images/formula-roi.png)
*Figure 1. Return on Investment (ROI) equals (Gain from Investment – Cost of Investment) / Cost of Investment*

In the next sections, we will walk through the data needed to calculate Earnings and Initial Investment.

## Calculate "Initial Investment"

Initial Investment is the Capital Expenditure (CapEx) and Operating Expenditure (OpEx) required to complete a transformation. The classification of costs can vary depending on accounting models and CFO preference. However, this category would include things like: Professional Services to transform, Software licenses that are used solely during the transformation, Cost of Cloud services during the transformation, and potentially the cost of the salaried employees during the transformation.

Add these costs together to create an estimate of the Initial Investment. 

## Calculate "Gain from Investment"

Gain from investment often requires a second formula for calculation, which is very specific to the business outcomes and associated technical changes. Earnings are not as simple as calculating reduction in costs.
To calculate earnings, two variables are required:

![Gain from Investment equals Revenue Deltas + Cost Deltas](../_images/formula-gain-from-investment.png)
*Figure 2. Gain from Investment equals Revenue Deltas + Cost Deltas*

Each is described below in [Calculate Delta in revenue](#revenue-delta) and [Calculate Delta in Costs](#cost-delta).

## Revenue Delta

Revenue Delta should be forecasted in partnership with the business. Once the business stakeholders agree on a revenue impact, that can be used to improve the Earning position.

## Cost Deltas

Cost Deltas are the amount of increase or decrease that will come as a result of the transformation. There are a number of independent variables that can impact cost deltas. Earnings are largely based on hard costs like Capital Expense Reductions, Cost Avoidance, Operational Cost Reductions, and Depreciation Reductions. The following sections are examples of Cost Deltas to be considered.

### Depreciation Reductions or Acceleration

For guidance on depreciation, speak with the CFO or finance team. The following is meant to serve as a general reference on the topic of depreciation.

When capital is invested in the acquisition of an asset, that investment could be used for financial or tax purposes to produce on-going benefits over the expected lifespan of the asset. Some companies see depreciation as a positive tax advantage. Others see it as committed, on-going expense similar to other recurring expense attributed to the annual IT budget.

Speak with the finance office to see if elimination of depreciation is possible & if it would make a positive contribution to Cost Deltas.

### Physical Asset Recovery

In some cases, retired assets can be sold as source of revenue. Often times, this is lumped into cost reduction for simplicity. However, it is true an increase in revenue & may be taxed as such. Speak with the finance office to understand the viability of this option & how to account for the resulting revenue.

### Operational Cost Reductions

Recurring expenses required to operate the business are often referred to as Operational Expenses (OpEx). OpEx is a very broad category. In most accounting models, it would include software licensing, hosting expenses, electric bills, real estate rentals, cooling expenses, temporary staff required for operations, equipment rentals, replacement parts, maintenance contracts, repair services, Business Continuity/Disaster Recovery (BC/DR) services, and a number of other expenses that don't require capital expense approvals.

This is one of the largest earnings areas when considering an Operational Transformation Journey. Time invested in making this list exhaustive is seldom wasted. Ask questions of the CIO and finance team to ensure all operational costs are accounted for.

### Cost Avoidance

When an Operational Expense (OpEx) is expected, but not yet in an approved budget, it may not fit into a cost reduction category. For instance, if VMWare and Microsoft Licenses need to be renegotiated and paid next year, they aren't fully qualified costs yet. Reductions in those expected costs would be treated like Operational Costs for the sake of Cost Delta calculations. However, conversationally, they should be referred to as Cost Avoidance, until negotiation and budget approval is complete.

### Soft Cost Reductions

In some companies, Soft Costs such as reductions in Operational Complexity or reduction in FTE efforts to operate a DataCenter could also be included. However, including Soft Costs can be ill advised. Inclusion of Soft Costs inserts an undocumented assumption that the reduction in costs will equate to tangible cost savings. Seldom do technology projects result in actual soft cost recovery.

### Headcount Reductions

Often included in Soft Cost Reduction are time savings for staff. When those time savings map to actual reduction of IT salary or staffing, it could be calculated separately as a headcount reduction

**Warning:** The skills needed on-prem generally map to a similar (or higher level) set of skills needed in the cloud, meaning people don't generally get laid off after a cloud migration.

The exception to this warning, is when operational capacity is provided by a third party or managed services provider (msp). If IT systems are managed by a 3rd party, the costs to operate could be replaced by a cloud native solution or cloud-native msp. In such a case, the cloud native msp is likely to operate more efficiently and potentially at a lower cost. If that is the case, then operational cost reductions belong in the hard cost calculations.

### Capital Expense Reductions or Avoidance

Capital Expenses (CapEx) are slightly different that Operational Expenses. Generally, this category is driven by refresh cycles or DataCenter expansion. DataCenter Expansions like a new high-performance cluster to host a Big Data solution or data warehouse would generally fit into a CapEx category. More common are the basic refresh cycles. Some companies have rigid hardware refresh cycles, meaning assets are retired and replaced on a regular cycle (usually 3, 5, or 8 years). These cycles often coincide with asset lease cycles or forecasted lifespan of equipment. When a refresh cycle hits, IT draws CapEx to acquire new equipment.

If a refresh cycle is approved and budgeted, the Cloud Transformation could help eliminate that cost. If a refresh cycle is planned but not yet approved, the Cloud Transformation could create a CapEx cost avoidance. Both scenarios would be added to the Cost Delta.
