---
title: Contract Management
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Knowledge mining can help organizations to scour thousands of pages of sources to create an accurate bid.
ms.custom: acom-architecture
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
ms.author: pracjain
social_image_url: /azure/architecture/solution-ideas/articles/media/contract-management.png
---

<!-- cSpell:ignore pracjain -->

# Contract Management

Many companies create products for multiple sectors, hence the business opportunities with different vendors and buyers increases exponentially. Knowledge mining can help organizations to scour thousands of pages of sources to create an accurate bid. Minor details in the bidding process can make the difference between a healthy profit or lost opportunity on a project.

![Architecture Diagram](../media/contract-management.png)

## Data Flow

There are three steps: Ingest, Enrich and Exploration.

First, the unstructured and structured data is ingested then enrichment of this data with AI to extract information and find and finally explore the newly structured data via search, existing business applications or analytics solutions.

1. The user can ingest different types of content like user guides, forms, product manuals, product pricing proposals, cost sheets, project reports
2. This content is enriched by using key phrase extraction, optical character recognition, entity recognition, customized models to flag potential risk or essential information
3. And finally, the user can integrate the search index in to the portal to expand the knowledge base as users share more information

## Components

Key technologies used to implement tools for technical content review and research

- [Azure Cognitive Search](https://docs.microsoft.com/azure/search/)
- [Microsoft Text Analytics API](https://azure.microsoft.com/services/cognitive-services/text-analytics/)
- [Microsoft Translator Text API](https://azure.microsoft.com/services/cognitive-services/translator-text-api/)
- [Microsoft Form Recognizer](https://azure.microsoft.com/services/cognitive-services/form-recognizer/)
- [Web API custom skill interface](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface)

## Next steps

Using the [knowledge mining solution accelerator](https://docs.microsoft.com/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining/) to build an initial knowledge mining prototype with Azure Cognitive Search.

Building custom skills with Microsoft's [Custom Web API](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface)
