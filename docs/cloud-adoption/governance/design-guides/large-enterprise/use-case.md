---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 2/1/2018
---

# Fusion: Use Case for Enterprise MVP Governance Design Guide

The [Enterprise MVP Governance Design Guide](./design-guide.md) presents a highly opinionated view of adopting governance for Azure. That design guide serves as a starting point to develop a custom governance position for enterprises that are moving to Azure but are not ready to invest heavily in governance disciplines. This article outlines the use case, which influence the synthesized [corporate policies](corporate-policy.md) aligned to this use case. Before adopting the opinionated design guide, this article can help the reader understand if that opinion is relevant and aligned to their specific environment.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader of this design guide. It is simply a starting point to be customized and refined, as needed. For additional guidance on establishing corporate policies that better align, see the series of articles on [defining corporate policy](../../policy-compliance/overview.md). If a specific governance discipline isn't aligned with the reader's required implementation, see the series of articles on the [disciplines of cloud governance](../../governance-disciplines.md).

## Use Case for the Enterprise MVP Governance Design Guide

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund an enterprise scale cloud governance program.

This design guide focuses on a scenario that is closer to the latter case; The company has a relatively low risk tolerance. However, the budgeted efforts to adoption the cloud are also relatively low risk. The following are characteristics that were factored into the design of the cloud governance strategy and this design guide.

> [!NOTE]
> For readers that are familiar with the [Governance Design Guide for Future Proof](../future-proof/design-guide.md), this design guide is based on some subtle changes to the use case. The company in this use case is larger, more geographically dispersed, more complex, and has many more assets in the digital estate. See the details below for more information.

### Relevant Business Characteristics

* Sales and operations both span multiple geographic areas with global customers in multiple markets
* The business grew through acquisition and operates across three business units based on target customer base. Budgeting is a complex matrix across business unit and function.
* The business views most of IT as a capital drain or a cost center.

### Current State

* IT operates more than 20 privately-owned datacenters around the globe.
* Each datacenter is connected by a series of regional leased lines, creating a loosely-bound global WAN
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over 6 months.
* A few IT assets have been deployed to the cloud
* Multiple development teams are working in a dev/test capacity to learn about cloud native capabilities
* The BI team is experimenting with big data in the cloud
* The governance team has set a policy that customer's PII (Personally Identifiable Information) and financial data can not be hosted in the cloud, which limits mission critical applications in the current deployments.

### Future State

* The cloud adoption plan calls for 500% growth in cloud adoption this year
* The CIO and CFO have committed to terminating two datacenter leases within the next 36 months, by migrating more than 5,000 assets to the cloud
* Both App Dev and BI will likely release production solutions to the cloud in the next 24 months.
* The governance team's policy on PII and financial data will need to evolve for either of the future state visions to be realized.

### Objective of the design guide

For the future state to be realized, PII and Financial Data will have to go to the cloud. For that to happen, the cloud will need a robust cloud governance strategy.
The business is not willing to invest in Cloud Governance today. However, Cloud Governance is likely to be a wise investment in the near future.
The objective of this design guide is to establish a common foundation for all deployments. That foundation will need to scale as new policies and governance disciplines are added.

## Next steps

Before attempting to implement this design guide, validate alignment to this Use Case and the resultant [Corporate Policy](./corporate-policy.md) that influenced the creation of the design guide. More than likely, this guide will require customization. To aid in making relevant decisions and customizing this guide, the following links may be of value:

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)
