---
title: "Fusion: Governance Design Guide to establish  Enterprise Guardrails"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 2/1/2019
---

# Fusion: Use Case behind the Governance Design Guide to establish Enterprise Guardrails

This article outlines the use case which serves as the back story for the [Enterprise Guardrails - Governance Design Guide](./design-guide.md). The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company is now ready to deploy production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business is ready to invest additional time and energy in cloud governance.

## Required understanding

This use case builds on the design guide, corporate policy, and use case outlined in the Enterprise MVP - Governance Design Guide. Implementation of this design guide assumes that the foundation defined in the Enterprise MVP design guide has been implemented. Review the checklist on that design guide before proceeding with this design guide. See the [References](#references) at the end of this document for links and additional background on that design guide.

> [!TIP]
> It is unlikely that the use case below will align 100% with the corporate environment of any reader. This series of articles is simply a starting point to be customized and refined, as needed. After reviewing the use case, see the [References](#references) at the end of this article for guidance on personalizing this guide.

## Use Case for the Enterprise Guardrails Governance Design Guide

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund a holistic cloud governance program.

This design guide focuses on a scenario that is closer to the former of the two cases; The business in this use case maintains a relatively low risk tolerance. The business has also expressed sensitivity regarding customer data, given the high number of businesses which have lost market share due to consumer data leaks. Further, interruptions to business processes would come at defined financial costs. The low tolerance for risk and desire to deploy production workloads have motivated business and IT leadership to invest in Cloud Governance.

### Relevant Business Characteristics

The business characteristics remain largely unchanged from Enterprise MVP Design Guide's use case, with the exception of the last point below.

* Sales and operations both span multiple geographic areas with global customers in multiple markets
* The business grew through acquisition and operates across three business units based on target customer base. Budgeting is a complex matrix across business unit and function.
* The business views most of IT as a capital drain or a cost center.
* IT has demonstrated an interest in supporting new revenue opportunities via Business Intelligence (BI), improved customer experiences via Application Development (App Dev), and cost reductions via Information Technology (IT). Old sentiment for IT as an organization is subtly shifting. Several teams are seeing strategic value in ITs contributions.

### Current State

Roughly twelve months have passed since the Enterprise MVP Design Guide's use case was drafted. Over the last twelve months, changes have been made as portions of the future state have been realized. Significant growth has been seen in the areas of Disaster Recovery, Application Modernization, and Business Intelligence.

The most relevant change in the current state is regarding protected data. The CIO met with a number of her colleagues and the companies legal staff. Additionally a business management consultant with expertise in cyber security was engaged to help the existing IT Governance team draft new policy statements regarding protected data. Collectively, this team was able to foster board level support to remove the existing policy preventing PII and financial data from being hosted in the cloud. However, the trade off was a requirement to adopt a series of security requirements and a governance process to validate and document adherence to those policies.

**Additional current state details:**

* IT operates more than 20 privately-owned datacenters around the globe.
* Each datacenter is connected by a series of regional leased lines, creating a loosely-bound global WAN
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over 18 months.
* *Dozens* of IT assets have been deployed to the cloud. *Some secondary business assets have been deployed to the cloud*
* Multiple application development teams embedded within business units have implemented CI/CD pipelines to deploy a number of cloud native applications that don't interact with protected data.
* The BI team actively curates logistics, inventory, and third party data in the cloud to drive new predictions which shape business processes. However, their view is constrained until customer and financial data can be integrated into the data platform.
* The policy on PII and financial data has been modernized. However, the new policy is contingent upon the implementation of security and governance policies. Teams are still stalled.

### Future State

* The cloud adoption plan over the last year exceed the planned growth, due to a high volume of demand for cloud services from the business units
* The IT team is progressing on the CIO and CFO's plans to retire two data centers. More than 2,000 of the 5,000 assets in those two data centers have been retired or migrated. During the 24 months left in the plan, the team will implement security and governance requirements to allow them to migrate the production workloads in those data centers. When completed, this project is expected to produce a $20M/year cost savings or $100M total.

![TCO cost comparison of the cloud migration project, resulting in a $100M USD cost reduction](../../../_images/governance/calculator-enterprise.png)


* Additionally IT has developed a business justification for migrate 5 more datacenters to Azure, which further decrease IT costs and produce greater business agility. While smaller in scale, the retirement of those datacenters is expected to double the cost savings.
* Early experiments from App Dev and BI have produced early improvements in customer experiences and data-driven decisions. Both team would like to expand adoption of the cloud over the next 18 months.
* Capital expense and operational expense budgets have been allocated to fund the implementation of security and governance policies, tools, and processes. The forecasted cost savings from the datacenter retirement are more than sufficient to offset this new initiative. IT and Business Leadership are confident this temporary investment will accelerate the realization of additional returns in other areas.

### Objectives of the design guide

Acceleration of IT modernization is dependent on the confidence, trust, and empowerment that will come from a mature governance strategy. The objective of this design guide is to implement the tools, metrics, and processes required to establish and monitor the governance strategy to support this use case. Having implemented the guidance in the Enterprise MVP Governance Design Guide, this process can be accelerated.

## References

### Enterprise MVP Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Enterprise MVP Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Enterprise MVP Use Case](../future-proof/use-case.md)**: The use case that drives the Enterprise MVP design guide.
**[Enterprise MVP Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Enterprise MVP Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Enterprise MVP Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to this Use Case and the resultant [Corporate Policy](./corporate-policy.md) that influenced the creation of the design guide.

> [!div class="nextstepaction"]
> [Enterprise Guardrails Policy Statements](./corporate-policy.md)
