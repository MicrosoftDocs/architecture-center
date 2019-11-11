---
title: "What is data classification?"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: What is data classification?
author: BrianBlanchard
ms.author: brblanch
ms.date: 02/11/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

<!-- markdownlint-disable MD026 -->

# What is data classification?

Data classification allows you to determine and assign value to your organization's data, and is a common starting point for governance. The data classification process categorizes data by sensitivity and business impact in order to identify risks. Once data is classified, it can be managed in ways that protect sensitive or important data from theft or loss.

## Understand data risks, then manage them

Before any risk can be managed, it must be understood. In the case of data breach liability, that understanding starts with data classification. Data classification is the process of associating a meta data characteristic to every asset in a digital estate, which identifies the type of data associated with that asset.

Microsoft suggests that any asset which has been identified as a potential candidate for migration or deployment to the cloud should have documented meta data to record the data classification, business criticality, and billing responsibility. These three points of classification can go a long way to understanding and mitigating risks.

## Microsoft's data classification

The following is a list of classifications Microsoft uses. Depending on your industry or existing security requirements, data classifications standards may already exist within your organization. If no standard exists, we invite you to use this sample classification to better understand your own digital estate and risk profile.

- **Non-business:** Data from your personal life that does not belong to Microsoft.
- **Public:** Business data that is freely available and approved for public consumption.
- **General:** Business data that is not meant for a public audience.
- **Confidential:** Business data that could cause harm to Microsoft if overshared.
- **Highly confidential:** Business data that would cause extensive harm to Microsoft if overshared.

## Tagging data classification in Azure

Every cloud provider should offer a mechanism for recording metadata about any asset. In the case of Azure, resource tags are the suggested approach for metadata storage, and these tags can be used to apply data classification information to deployed resources. Although tagging cloud assets by classification is not a replacement for a formal data classification process, it provides a valuable tool for managing resources and applying policy.

For additional information on resource tagging in Azure, see the article on [Using tags to organize your Azure resources](/azure/azure-resource-manager/resource-group-using-tags).

## Next steps

Apply data classifications during one of the actionable governance guides.

> [!div class="nextstepaction"]
> [Choose an actionable governance guide](../journeys/index.md)
