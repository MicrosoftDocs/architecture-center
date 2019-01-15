---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Use Case for Future Proof Governance Design Guide

The [Future Proof Governance Design Guide](./design-guide.md) presents a highly opinionated view of adopting governance for Azure. That design guide serves as a starting point to develop a custom governance position for enterprises that are moving to Azure but are not ready to invest heavily in governance disciplines. This article outlines the use case, which influence the synthesized [corporate policies](./corporate-policy.md) aligned to this use case. Before adopting the opinionated design guide, this article can help the reader understand if that opinion is relevant and aligned to their specific environment.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader of this design guide. It is simply a starting point to be customized and refined, as needed. For additional guidance on establishing corporate policies that better align, see the series of articles on [defining corporate policy](../../policy-compliance/overview.md). If a specific governance discipline isn't aligned with the reader's required implementation, see the series of articles on the [disciplines of cloud governance](../../governance-disciplines.md).

## Use Case for the Future Proof Governance Design Guide

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund a holistic cloud governance program.

This design guide focuses on a scenario that is closer to the latter case; Budgeted cloud adoption plans are relatively low risk. The company also has a relatively modest risk tolerance. The following are characteristics that were factored into the design of the cloud governance strategy and this design guide.

### Relevant Business Characteristics

* All sales and operations reside in a single country with a small percentage of global customers
* The business operates as a single business unit, with budget aligned to functions (Sales, Marketing, Operations, IT, etc...)
* The business views most of IT as a capital drain or a cost center.

### Current State

* IT operates two hosted infrastructure environments. On environment hosts production assets. The second hosts disaster recovery and some Dev/Test assets. These environments are hosted by two different providers. IT refers to these environment as their two datacenters called Prod and DR respectively.
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over 6 months.
* Few IT assets have been deployed to the cloud.
* The application development teams is working in a dev/test capacity to learn about cloud native capabilities.
* The BI team is experimenting with big data in the cloud.
* The company has a loosely defined policy stating that customer's PII (Personally Identifiable Information) and financial data can not be hosted in the cloud, which limits mission critical applications in the current deployments.

### Future State

* This year, the IT team will complete a project to retire the disaster recovery aspects of the DR "Data Center", increasing cloud adoption.
* Both App Dev and BI would like to release production solutions to the cloud in the next 24 months.
* The CIO is reviewing the policy on PII and financial data to allow for the future state goals.

### Objectives of the design guide

For the future state to be realized, protected data will go to the cloud, someday. For that to happen, the business is demanding a defined strategy for governing and securing the cloud environment. The business is not willing to invest in Cloud Governance today. However, Cloud Governance is likely to be a wise investment in the near future.
The objective of this design guide is to establish a common foundation for all deployments. That foundation will need to scale as new policies and governance disciplines are added.

## Next steps

Before attempting to implement this design guide, validate alignment to this Use Case and the resultant [Corporate Policy](./corporate-policy.md) that influenced the creation of the design guide. More than likely, this guide will require customization. To aid in making relevant decisions and customizing this guide, the following links may be of value:

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)
