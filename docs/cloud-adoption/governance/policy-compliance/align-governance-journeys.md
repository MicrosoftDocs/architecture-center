---
title: "Align your cloud governance design guide with corporate policy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: "Align your cloud governance design guide with corporate policy"
author: BrianBlanchard
ms.author: brblanch
ms.date: 01/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
---
<!---
I've established policies. How to help developers adopt these policies?
Draft an architecture design guide.

[Aspirational statement] If you're using Azure, you can use one of ours as a starting point. The choose one of the following 6 as a starting point and mold it to fit your policies.
--->

# Align your cloud governance design guide with corporate policy

After you've [defined cloud policies](define-policy.md) based on your [identified risks](understanding-business-risk.md), you'll need to generate actionable guidance that aligns with these policies for your IT staff and developers to refer to. Drafting a cloud governance design guide allows you to specify specific structural, technological, and process choices based on the policy statements you generated for each of the [five governance disciplines](../governance-disciplines.md).

A cloud governance design guide should establish the architecture choices and design patterns for each of the core infrastructure components of cloud deployments that best meet your policy requirements. Alongside these you should provide a high-level explanation of the technology, tools, and processes that will support each of these design decisions.

Although your risk analysis and policy statements may, to some degree, be cloud platform agnostic, your design guide should provide platform-specific implementation details that your IT and dev teams can use when creating and deploying cloud-based workloads. Focus on the architecture, tools, and features of your chosen platform when making design decision and providing guidance.

While cloud design guides should take into account some of the technical details associated with each infrastructure component, they are not meant to be extensive technical documents or specifications. Make sure your guides address your policy statements and clearly state design decisions in a format easy for staff to understand and reference.

<!-- markdownlint-enable MD033 -->

## Using the actionable governance guides

If you're planning to use the Azure platform for your cloud adoption, the Cloud Adoption Framework provides [actionable governance guides](../journeys/index.md) illustrating the incremental approach of the Cloud Adoption Framework governance model. These narrative guides cover a range of common adoption scenarios, including the business risks, tolerance requirements, and policy statements that went into creating a governance minimum viable product (MVP). These guides represent a synthesis of real-world customer experience of the cloud adoption process in Azure.

While every cloud adoption has unique goals, priorities, and challenges, these samples should provide a good template for converting your policy into guidance. Pick the closest scenario to your situation as a starting point, and mold it to fit your specific policy needs.

## Next steps

With design guidance in place, establish policy adherence processes to ensure policy compliance.

> [!div class="nextstepaction"]
> [Establish policy adherence processes](./processes.md)
