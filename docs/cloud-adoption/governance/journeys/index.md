---
title: "Cloud governance guides"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Learn about the actionable governance guides provided in the Cloud Adoption Framework.
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: landing-page
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
layout: LandingPage
---

# Cloud governance guides

The actionable governance guides in this section illustrate the incremental approach of the Cloud Adoption Framework governance model, based on the [governance methodology](../methodology.md) previously described. You can establish an agile approach to cloud governance that will grow to meet the needs of any cloud governance scenario.

## Review and adopt cloud governance best practices

To begin your cloud adoption journey, choose one of the following governance guides. Each guide outlines a set of best practices, based on a set of fictional customer experiences. For readers who are new to the incremental approach of the Cloud Adoption Framework governance model, review the high-level introduction to governance theory below before adopting either set of best practices.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
    <li style="display: flex; flex-direction: column;">
        <a href="./small-to-medium-enterprise/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
            <div class="cardSize" style="flex: 1 0 auto; display: flex;">
                <div class="cardPadding" style="display: flex;">
                    <div class="card">
                        <div class="cardText">
                            <h3>Small-to-Medium Enterprise</h3>
                            <p>A governance guide for enterprises that own fewer than five datacenters and manage costs through a central IT or showback model.</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li style="display: flex; flex-direction: column;">
        <a href="./large-enterprise/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
            <div class="cardSize" style="flex: 1 0 auto; display: flex;">
                <div class="cardPadding" style="display: flex;">
                    <div class="card">
                        <div class="cardText">
                            <h3>Large Enterprise</h3>
                            <p>A governance guide for enterprises that own five or more datacenters and manage costs across multiple business units.</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

<!-- markdownlint-enable MD033 -->

## An incremental approach to cloud governance

## Choosing a governance guide

The guides demonstrate how to implement a governance MVP. From there, each guide shows how the cloud governance team can work ahead of the cloud adoption teams as a partner to accelerate adoption efforts. The Cloud Adoption Framework governance model guides the application of governance from foundation through subsequent improvements.

To begin a governance journey, choose one of the two options below. The options are based on synthesized customer experiences. The titles are based on the size of the enterprise for ease of navigation. However, the reader's decision may be more complex. The following tables outline the differences between the two options.

> [!WARNING]
> A more robust governance starting point may be required. In such cases, consider the [Azure Virtual Datacenter](#azure-virtual-datacenter) approach briefly described [below](#azure-virtual-datacenter). This approach is commonly suggested during enterprise-scale adoption efforts, and especially for efforts which exceed 10,000 assets. It is also the de facto choice for complex governance scenarios when any of the following are required: extensive third-party compliance requirements, deep domain expertise, or parity with mature IT governance policies and compliance requirements.

> [!NOTE]
> It’s unlikely that either guide aligns completely to your situation. Choose whichever guide is closest and use it as a starting point. Throughout the guide, additional information is provided to help you customize decisions to meet specific criteria.

### Business characteristics

| Characteristic | Small-to-medium enterprise                                                                              | Large enterprise                                                                                               |
|--------------------------------------------|---------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| Geography (country or geopolitical region) | Customers or staff reside largely in one geography                                                      | Customers or staff reside in multiple geographies                                                              |
| Business units affected                    | Single business unit                                                                                    | Multiple business units                                                                                        |
| IT budget                                  | Single IT budget                                                                                        | Budget allocated across business units                                                                         |
| IT investments                             | Capital expense-driven investments are planned yearly and usually cover only basic maintenance. | Capital expense-driven investments are planned yearly and often include maintenance and a refresh cycle of three to five years. |

### Current state before adopting cloud governance

| State | Small-to-medium enterprise                                                                               | Large enterprise                                                                                                          |
|---------------------------------------------|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| Datacenter or third-party hosting providers | Fewer than five datacenters                                                                                  | More than five datacenters                                                                                                   |
| Networking                                  | No WAN, or 1 &ndash; 2 WAN providers                                                                             | Complex network or global WAN                                                                                             |
| Identity                                    | Single forest, single domain. No requirement for claims-based authentication or third-party multi-factor authentication devices. | Complex, multiple forests, multiple domains. Applications require claims-based authentication or third-party multi-factor authentication devices. |

### Desired future state after incremental improvement of cloud governance

| State | Small-to-medium enterprise                                                                        | Large enterprise                                                                                        |
|----------------------------------------------|---------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| Cost Management – cloud accounting           | Showback model. Billing is centralized through IT.                                                | Chargeback model. Billing could be distributed through IT procurement.                                  |
| Security Baseline – protected data           | Company financial data and IP. Limited customer data. No third-party compliance requirements.     | Multiple collections of customers’ financial and personal data. May need to consider third-party compliance. |
| Resource Consistency – mission-critical applications | Outages are painful but not financially damaging. Existing IT Operations are relatively immature. | Outages have defined and monitored financial impacts. IT operations are established and mature.         |

These two guides represent two extremes of experience for customers who invest in cloud governance. Most companies reflect a combination of the two scenarios above. After reviewing the guide, use the Cloud Adoption Framework governance model to start the governance conversation and modify the baseline guides to more closely meet your needs.

## Azure Virtual Datacenter

Azure Virtual Datacenter is an approach to making the most of the Azure cloud platform's capabilities while respecting an enterprise's security and governance requirements.

Compared to traditional on-premises environments, Azure allows workload development teams and their business sponsors to take advantage of the increased deployment agility that cloud platforms offer. However, as your cloud adoption efforts expand to include mission-critical data and workloads, this agility may conflict with corporate security and policy compliance requirements established by your IT teams. This is especially true for large enterprises that have existing sophisticated governance and regulatory requirements.

The Azure Virtual Datacenter approach aims to address these concerns earlier in the adoption lifecycle by providing models, reference architectures, sample automation artifacts, and guidance to help achieve a balance between developer and IT governance requirements during enterprise cloud adoption efforts. Central to this approach is the concept of a virtual datacenter itself: the implementation of isolation boundaries around your cloud infrastructure through the application of access and security controls, network policies, and compliance monitoring.

A virtual datacenter can be thought of as your own isolated cloud within the Azure platform, integrating management processes, regulatory requirements, and security processes required by your governance policies. Within this virtual boundary, Azure Virtual Datacenter offers example models for deploying workloads while ensuring consistent compliance and provides basic guidance on implementing an organization's separation of roles and responsibilities in the cloud.

### Azure Virtual Datacenter assumptions

Although smaller teams may benefit from the models and recommendations the Azure Virtual Datacenter provides, this approach is designed to guide enterprise IT groups managing large cloud environments. For organizations that meet the following criteria it's recommended that you consider consulting the Azure Virtual Datacenter guidance when designing your Azure-based cloud infrastructure:

- Your enterprise is subject to regulatory compliance requirements that require centralized monitoring and audit capabilities.
- You need to maintain common policy and governance compliance and central IT control over core services.
- Your industry depends on a complex platform which requires complex controls and deep domain expertise to govern the platform. This is most common in large enterprises within finance, oil and gas, or manufacturing.
- Your existing IT governance policies require tighter parity with existing features, even during early stage adoption.

For more information, visit the [Azure Virtual Datacenter](/azure/architecture/vdc) section of the Cloud Adoption Framework.

## Next steps

Choose one of these guides:

> [!div class="nextstepaction"]
> [Small-to-medium enterprise governance guide](./small-to-medium-enterprise/index.md)
>
> [Large enterprise governance guide](./large-enterprise/index.md)
