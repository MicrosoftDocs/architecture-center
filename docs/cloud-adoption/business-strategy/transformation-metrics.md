---
title: "Fusion: How can we align efforts to meaningful transformation metrics?"
description: Explanation of the concept of transformation metrics
author: BrianBlanchard
ms.date: 10/10/2018
---

# Fusion: How can we align efforts to meaningful transformation metrics?

The articles on [Business Outcomes](business-outcomes/overview.md) discussed ways to measure and communicate the impact a transformation will have on the business. Unfortunately, it can take years for some of those outcomes to produce measurable results. The Board and C-Suite generally are not happy to see reports that show a 0% delta for long periods of time. This article will discuss shorter term metrics that can be tied back to longer term business outcomes.

As with much of the material in this framework, it is assumed that the reader is familiar with the [Transformation Journey](../transformation-journeys/overview.md) that best aligns with the desired business outcomes.

**Operational Transformation:** This transformation focuses on cost, complexity, and efficiency with an emphasis on IT operations. The most easily measured data behind this transformation is the movement of assets to the cloud. In this kind of transformation, the digital estate would be measured by Virtual Machines (VMs), Racks or Clusters hosting those VMs, DataCenter operational costs, required Capital Expenses to maintain systems, and depreciation of those assets over time.

As the number of VMs is moved, the dependence on on-prem legacy assets is reduced. The costs of maintaining those assets is also reduced. Unfortunately, businesses can't realize the cost reduction until clusters are de-provisioned and DataCenter leases expire. In many cases, the full value of the effort isn't realized until the depreciation cycles are complete.

Always align with the CFO or finance office before making financial statements. However, IT teams can generally estimate  current money cost and future money cost values for each VM based on CPU, Memory, and Storage consumed. That value can then be applied to each migrated VM to show estimate the immediate cost savings of the effort, as well as the future money value of the effort.

**Incremental Transformation:** Incremental Transformation focuses largely on the customer experience and the customer's willingness to consume products and services provided by the company. Increments of change take time to impact consumer or customer buying behaviors. However, these cycles tend to be much shorter than they are in the other forms of transformation. It is often advised that the team start with an understanding of the specific behaviors to be influenced and use those as the transformation metrics. For instance: In an e-commerce application, total purchases or add-on purchases could be the target behavior. In a video company, time watching video streams could be another.

The challenge with customer behavior metrics is that they can easily be influenced by outside variables. As such, it is often important to include other related statistics with the transformation metrics. For instance: Release cadence, bugs resolved per release, code coverage of unit tests, number of page views, page throughput, page load time, and other app performance metrics. Each can show different activities and changes to the code base and the customer experience to correlate with the higher level customer behavior patterns.

**Disruptive Transformation:** Changing an industry, disrupting markets, and transforming products/services can each take years. In a disruptive transformation, experimentation is key to measuring success. Be transparent and share prediction metrics like percent probability, number of failed experiments, amount of data trained. Failures will accumulate faster than successes. Sadly, these metrics can be discouraging. It is very important that the executive team have a clear understanding regarding the time and investment required to properly train data and make accurate predictions.

Conversely, there are positive indicators that are often associated with data driven learning; centralization of data, data ingress, and democratization of data. While the team is learning about the customer of tomorrow, real results can be produced today. Supporting transformation metrics could include things like: Number of models available in the cloud, number of partner data sources consumed, devices producing ingress data, volume of ingress data. Even more valuable metrics would be the number of dashboard created from consolidated data sources. The number of current state business processes impacted by new data sources. By sharing new data sources openly, the business can engage the data using model reporting tools like PowerBI to produce incremental insights and drive change in the current business.

## Next steps

Once Transformation Metrics have been aligned, the team is ready to begin [Assessing the Digital Estate](../digital-estate/overview.md) against those metrics.
The result will be a [Transformation Backlog or Migration Backlog](../migration/plan/migration-backlog.md).

> [!div class="nextstepaction"]
> [Assess the Digital Estate](../digital-estate/overview.md)