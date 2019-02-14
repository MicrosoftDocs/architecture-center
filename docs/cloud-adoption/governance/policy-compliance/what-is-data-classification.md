---
title: "CAF: What is Data Classification"
description: What is Data Classification?
author: BrianBlanchard
ms.date: 2/11/2019
---

<!-- markdownlint-disable MD026 -->

# What is data classification?

This is an introductory article on the general topic of Data Classification. Data classification is a very common starting point for all governance.

## Business risks and governance

In most organizations, the primary reasons for investing in governance can be reduced to three business risks:

* Liability associated with data breaches
* Interruption to the business from outages
* Unplanned or unexpected spending

There are many variants of these three business risks. However, these tend to be the most common.

## Understand then mitigate

Before any risk can be mitigated, it must be understood. In the case of data breach liability, that understanding starts with data classification. Data classification is the process of associating a meta data characteristic to every asset in a digital estate, which identifies the type of data associated with that asset.

Microsoft suggests that any asset which has been identified as a potential candidate for migration or deployment to the cloud should have documented meta data to record the data classification, business criticality, and billing responsibility. These three points of classification can go a long way to understanding and mitigating risks.

## Microsoft's data classification

The following is a list of classifications Microsoft uses. Depending on your industry or existing security requirements, data classifications standards may already exist within your organization. If no standard exists, we welcome you to use this sample classification, to help you better understand your digital estate and risk profile.  

* **Non-Business:** Data from your personal life that does not belong to Microsoft
* **Public:** Business data that is freely available and approved for public consumption
* **General:** Business data that is not meant for a public audience
* **Confidential:** Business data that could cause harm to Microsoft if over-shared
* **Highly Confidential:** Business data that would cause extensive harm to Microsoft if over-shared

## Tagging data classification in Azure

Every cloud provider should offer a mechanism for recording metadata about any asset. Metadata is vital to managing assets in the cloud. In the case of Azure, resource tags are the suggested approach for metadata storage. For additional information on resource tagging in Azure, see the article on [Using tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags).

## Next steps

Apply data classifications during one of the actionable governance journeys.

> [!div class="nextstepaction"]
> [Begin an Actionable Governance Journeys](../journeys/overview.md)
