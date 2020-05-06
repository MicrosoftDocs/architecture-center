---
title: Serverless Computing Solution for LOB Apps
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: The solution demonstrates a business process for customer onboarding. This serverless architecture enables you to build and run applications without having to worry about the underlying infrastructure and the associated management and maintenance. By using it, you can dramatically improve developer productivity.
ms.custom: acom-architecture, line of business app, lob app, lift and shift cloud strategy, cloud migration, cloud innovation, lift and shift solution, lift and shift strategy, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/onboarding-customers-with-a-cloud-native-serverless-architecture/'
ms.service: architecture-center
ms.category:
  - migration
  - developer-tools
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/onboarding-customers-with-a-cloud-native-serverless-architecture.png
---

# Serverless Computing Solution for LOB Apps

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This serverless architecture enables you to build and run applications without having to worry about the underlying infrastructure and the associated management and maintenance. By using it, you can dramatically improve developer productivity.

The links to the right give you detailed technical guidance on navigating a particular area of the architecture.

[Decide which compute option to use for your apps](../../guide/technology-choices/compute-decision-tree.md)

[Learn to build Serverless apps](https://docs.microsoft.com/azure/azure-functions)

The links to the right provide documentation on deploying and managing the Azure products listed in the solution architecture above.

[Learn how you can use machine learning](https://docs.microsoft.com/azure/machine-learning/preview)

[Infuse intelligence into your apps with Cognitive Services](https://docs.microsoft.com/azure/cognitive-services)

## Architecture

![Architecture Diagram](../media/onboarding-customers-with-a-cloud-native-serverless-architecture.png)
*Download an [SVG](../media/onboarding-customers-with-a-cloud-native-serverless-architecture.svg) of this architecture.*
<div class="architecture-tooltip-content" id="architecture-tooltip-2">
<p>The customer's photo is posted to Cognitive Services Face API. Face API associates

the customer's photo and name.</p>
</div>

## Data Flow

1. Information about the new customer is posted to a web endpoint.
1. The customer's photo is posted to Cognitive Services Face API. Face API associates the customer's photo and name.
1. The customer information is recorded in Dynamics 365 or other CRM.
1. The information about a new customer is sent to Power BI.
1. The customer information is added to the mailing list (MailChimp).
1. The solution creates a record of the member in SQL Database.
