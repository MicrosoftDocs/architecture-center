---
title: "How can we align efforts to meaningful learning metrics?"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of the concept of learning metrics
author: BrianBlanchard
ms.date: 04/04/2019
---

<!-- markdownlint-disable MD026 -->

# How can we align efforts to meaningful learning metrics?

The [business outcomes overview](business-outcomes/index.md) discussed ways to measure and communicate the impact a transformation will have on the business. Unfortunately, it can take years for some of those outcomes to produce measurable results. The board and C-suite are unhappy with reports showing a 0% delta for long periods of time.

The concept of learning metrics creates interim shorter-term metrics that can be tied back to longer-term business outcomes. These metrics align well with a growth mindset and help position the culture to become more resilient. Rather than focus on the anticipated lack of progress toward a long-term business goal, learning metrics focus on early indicators of success. The metrics also focus on early indicators of failure, which are likely to produce the greatest opportunity to learn and adjust the plan.

As with much of the material in this framework, it is assumed that the reader is familiar with the [transformation journey](../governance/journeys/index.md) that best aligns with the desired business outcomes. This article will outline a few learning metrics for each transformation journey to illustrate the concept.

**Cloud migration:** This transformation focuses on cost, complexity, and efficiency with an emphasis on IT operations. The most easily measured data behind this transformation is the movement of assets to the cloud. In this kind of transformation, the digital estate is measured by virtual machines (VMs), racks or clusters hosting those VMs, datacenter operational costs, required capital expenses to maintain systems, and depreciation of those assets over time.

As the number of VMs is moved, the dependence on on-premises legacy assets is reduced. The cost of asset maintenance is also reduced. Unfortunately, businesses can't realize the cost reduction until clusters are deprovisioned and datacenter leases expire. In many cases, the full value of the effort isn't realized until the depreciation cycles are complete.

Always align with the CFO or finance office before making financial statements. However, IT teams can generally estimate current monetary cost and future monetary cost values for each VM based on CPU, memory, and storage consumed. That value can then be applied to each migrated VM to show estimate the immediate cost savings of the effort, as well as the future money value of the effort.

**Application innovation:** Cloud enabled application innovation, focuses largely on the customer experience and the customer's willingness to consume products and services provided by the company. Increments of change take time to affect consumer or customer buying behaviors. However, these cycles tend to be much shorter than they are in the other forms of transformation. It is often advised that the team start with an understanding of the specific behaviors to be influenced and use those behaviors as the learning metrics. For example, in an e-commerce application, total purchases or add-on purchases could be the target behavior. In a video company, time watching video streams could be another.

The challenge with customer behavior metrics is that they can be influenced easily by outside variables. Therefore, it is often important to include other related statistics with the learning metrics (such as release cadence, bugs resolved per release, code coverage of unit tests, number of page views, page throughput, page load time, and other app performance metrics). Each can show different activities and changes to the code base and the customer experience to correlate with the higher-level customer behavior patterns.

**Data innovation:** Changing an industry, disrupting markets, and transforming products/services can each take years. In a cloud enabled data innovation effort, experimentation is key to measuring success. Be transparent and share prediction metrics like percent probability, number of failed experiments, amount of data trained. Failures will accumulate faster than successes. Sadly, these metrics can be discouraging. It is important that the executive team understands the time and investment needed to properly train data and make accurate predictions.

Conversely, some positive indicators are often associated with data-driven learning; centralization of data, data ingress, and democratization of data. While the team is learning about the customer of tomorrow, real results can be produced today. Supporting learning metrics could include things like: Number of models available in the cloud, number of partner data sources consumed, devices producing ingress data, volume of ingress data. An even more valuable metrics is the number of dashboards created from consolidated data sources. The number of current state business processes affected by new data sources. By sharing new data sources openly, the business can engage the data using model reporting tools like Power BI to produce incremental insights and drive change in the current business.

## Next steps

Once learning metrics are aligned, the team is ready to begin [assessing the digital estate](../digital-estate/index.md) against those metrics. The result will be a [transformation backlog or migration backlog](../migrate/migration-considerations/prerequisites/technical-complexity.md).

> [!div class="nextstepaction"]
> [Assess the digital estate](../digital-estate/index.md)
