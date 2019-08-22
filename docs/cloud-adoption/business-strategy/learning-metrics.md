---
title: "How can we align efforts to meaningful learning metrics?"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the concept of learning metrics
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: strategy
---

<!-- markdownlint-disable MD026 -->

# How can we align efforts to meaningful learning metrics?

The [business outcomes overview](business-outcomes/index.md) discussed ways to measure and communicate the impact a transformation will have on the business. Unfortunately, it can take years for some of those outcomes to produce measurable results. The board and C-suite are unhappy with reports that show a 0% delta for long periods of time.

Learning metrics are interim, shorter-term metrics that can be tied back to longer-term business outcomes. These metrics align well with a growth mindset and help position the culture to become more resilient. Rather than highlighting the anticipated lack of progress toward a long-term business goal, learning metrics highlight early indicators of success. The metrics also highlight early indicators of failure, which are likely to produce the greatest opportunity for you to learn and adjust the plan.

As with much of the material in this framework, we assume you're familiar with the [transformation journey](../governance/journeys/index.md) that best aligns with your desired business outcomes. This article will outline a few learning metrics for each transformation journey to illustrate the concept.

## Cloud migration

This transformation focuses on cost, complexity, and efficiency, with an emphasis on IT operations. The most easily measured data behind this transformation is the movement of assets to the cloud. In this kind of transformation, the digital estate is measured by virtual machines (VMs), racks or clusters that host those VMs, datacenter operational costs, required capital expenses to maintain systems, and depreciation of those assets over time.

As VMs are moved to the cloud, dependence on on-premises legacy assets is reduced. The cost of asset maintenance is also reduced. Unfortunately, businesses can't realize the cost reduction until clusters are deprovisioned and datacenter leases expire. In many cases, the full value of the effort isn't realized until the depreciation cycles are complete.

Always align with the CFO or finance office before making financial statements. However, IT teams can generally estimate current monetary cost and future monetary cost values for each VM based on CPU, memory, and storage consumed. You can then apply that value to each migrated VM to estimate the immediate cost savings and future monetary value of the effort.

## Application innovation

Cloud-enabled application innovation focuses largely on the customer experience and the customer's willingness to consume products and services provided by the company. It takes time for increments of change to affect consumer or customer buying behaviors. But application innovation cycles tend to be much shorter than they are in the other forms of transformation. The traditional advice is that you should start with an understanding of the specific behaviors that you want to influence and use those behaviors as the learning metrics. For example, in an e-commerce application, total purchases or add-on purchases could be the target behavior. For a video company, time watching video streams could be the target.

The challenge with customer behavior metrics is that they can easily be influenced by outside variables. So it's often important to include related statistics with the learning metrics. These related statistics can include release cadence, bugs resolved per release, code coverage of unit tests, number of page views, page throughput, page load time, and other app performance metrics. Each can show different activities and changes to the code base and the customer experience to correlate with higher-level customer behavior patterns.

## Data innovation

Changing an industry, disrupting markets, or transforming products/services can take years. In a cloud-enabled data innovation effort, experimentation is key to measuring success. Be transparent by sharing prediction metrics like percent probability, number of failed experiments, and amount of models trained. Failures will accumulate faster than successes. These metrics can be discouraging and it is important that the executive team understands the time and investment needed to leverage on data properly.

On the other hand, some positive indicators are often associated with data-driven learning: centralization of heterogeneous data sets, data ingress, and democratization of data. While the team is learning about the customer of tomorrow, real results can be produced today. Supporting learning metrics could include:

- Number of models available
- Number of partner data sources consumed
- Devices producing ingress data
- Volume of ingress data
- Types of data

An even more valuable metric is the number of dashboards created from combined data sources. This number reflects the current-state business processes that are affected by new data sources. By sharing new data sources openly, your business can take advantage of the data by using reporting tools like Power BI to produce incremental insights and drive business change.

## Next steps

After learning metrics are aligned, you're ready to start [assessing the digital estate](../digital-estate/index.md) against those metrics. The result will be a [transformation backlog or migration backlog](../migrate/migration-considerations/prerequisites/technical-complexity.md).

> [!div class="nextstepaction"]
> [Assess the digital estate](../digital-estate/index.md)
