---
title: "Fusion: Governance Design Guide a Production Workload"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: Use Case behind the Governance Design Guide for a Production Workload

This article outlines the use case which serves as the back story for the [Production Workload - Governance Design Guide](./design-guide.md). The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company has begun deploying production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business can now justify investing time and energy in cloud governance.

## Required understanding

This use case builds on the design guide, corporate policy, and use case outlined in the Future Proof - Governance Design Guide. See the [References](#references) at the end of this document for additional background on that design guide. Implementation of the Production Workload design guide assumes that the foundation defined in the future proof design guide has been implemented. Review the checklist on that design guide before proceeding with this design guide.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader of this design guide. It is simply a starting point to be customized and refined, as needed. After reviewing the use case, see the [References](#references) at the end of this article for guidance on personalizing this guide.

## Use Case for the Production Workload Governance Design Guide

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund a holistic cloud governance program.

This design guide focuses on a scenario that is closer to the former of the two cases; The business maintains a relatively modest risk tolerance in this use case. In spite of that risk tolerance, business and IT leadership recognize the inherit risks of moving production workloads to a new platform. The business has also expressed sensitivity regarding customer data, given the high number of businesses which has lost market share due to consumer data leaks. Further, the business is concerned that the increased governance investment will result in significant long-term increases in cost. As such, the business is now ready to invest in cloud governance.

### Relevant Business Characteristics

The business characteristics remain largely unchanged from Future Proof Design Guide's use case, with the exception of the last point below.

* All sales and operations reside in a single country with a small percentage of global customers
* The business operates as a single business unit, with budget aligned to functions (Sales, Marketing, Operations, IT, etc...)
* The business views most of IT as a capital drain or a cost center.
* IT has demonstrated an interest in supporting new revenue opportunities via Business Intelligence (BI), improved customer experiences via Application Development (App Dev), and cost reductions via Information Technology (IT). Old sentiment for IT as an organization is subtly shifting. Several teams are seeing strategic value in ITs contributions.

### Current State

Roughly six months have passed since the Future Proof Design Guide's use case was drafted. Over the last six months, changes have been made as portions of the future state have been realized. Significant growth has been seen in the areas of Disaster Recovery, Application Modernization, and Business Intelligence.

The most relevant change in the current state is regarding protected data. The CIO met with a number of her colleagues and the companies legal staff. Additionally a business management consultant with expertise in cyber security was engaged to help draft new policy statements regarding protected data. Collectively, this team was able to foster board level support to remove the existing policy preventing PII and financial data from being hosted in the cloud. However, the trade off was a requirement to adopt a series of security requirements and a governance process to validate and document adherence to those policies. Additionally, the Chief Finance Officer (CFO) is demanding greater visibility and regularly reporting regarding cloud costs, to ensure alignment to planned investments.

**Additional current state details:**

* IT operates two hosted infrastructure environments. On environment hosts production assets. The second hosts disaster recovery and some Dev/Test assets. These environments are hosted by two different providers. IT refers to these environment as their two datacenters called Prod and DR respectively.
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over *12* months.
* IT has depleted 75% of the DR data center, by moving disaster recovery and dev/test assets to Azure. The assets that remain contain protected data.
* *Dozens* of IT assets have been deployed to the cloud. *Some secondary business assets have been deployed to the cloud*
* The application development teams have implemented CI/CD pipelines to deploy a number of cloud native applications that don't interact with protected data.
* The BI team actively curates logistics, inventory, and third party data in the cloud to drive new predictions which shape business processes. However, their view is constrained until customer and financial data can be integrated into the data platform.
* The policy on PII and financial data has been modernized. However, the new policy is contingent upon the implementation of security and governance policies. Teams are still stalled.

### Future State

* The IT team still plans to retire the Disaster Recovery data center within the original 12 month plan. During the six months left in the plan, the team will implement security and governance requirements. They will then be able to migrate the remaining 25% of the DR datacenter. At that point, the DR datacenter will be retired, removing more than $1M USD per year from the IT budget.
* Additionally IT has developed a business justification for migrating more than 50% of the assets in the Prod datacenter to Azure, which further decrease IT costs and produce greater business agility.
* Early experiments from App Dev and BI have produced early improvements in customer experiences and data-driven decisions. Both team would like to expand adoption of the cloud over the next 18 months.
* Capital expense and operational expense budgets have been allocated to fund the implementation of security and governance policies, tools, and processes. The forecasted cost savings from the datacenter retirement are more than sufficient to offset this new initiative. IT and Business Leadership are confident this temporary investment will accelerate the realization of additional returns in other areas.
* Cost monitoring and reporting is to be added to the cloud solution. IT is still serving as a cost clearing house. This means that payment for cloud services continues to come from IT procurement. However, reporting should tie direct operational expenses to the functions that are consuming the cloud costs. This model is referred to as "Show Back"

### Objectives of the design guide

Acceleration of IT modernization is dependent on the confidence, trust, and empowerment that will come from a mature governance strategy. The objective of this design guide is to implement the tools, metrics, and processes required to establish and monitor the governance strategy to support this use case. Having implemented the guidance in the Future Proof Governance Design Guide, this process can be accelerated.

## References

### Future Proof Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Future Proof Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Future Proof Use Case](../future-proof/use-case.md)**: The use case that drives the Future Proof design guide.
**[Future Proof Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Future Proof Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Future Proof Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to this Use Case and the resultant [Corporate Policy](./corporate-policy.md) that influenced the creation of the design guide.

> [!div class="nextstepaction"]
> [Production Workload Policy Statements](./corporate-policy.md)
