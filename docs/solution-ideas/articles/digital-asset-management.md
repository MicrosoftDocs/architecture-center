---
title: Digital Asset Management
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Knowledge mining through a search index makes it easy for end customers and employees to locate what they are looking for faster.
ms.custom: acom-architecture
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
ms.author: pracjain
social_image_url: /azure/architecture/solution-ideas/articles/media/digital-asset-management.png
---

<!-- cSpell:ignore pracjain -->

# Digital Asset Management

This architecture describes digital asset management for knowledge mining.

Given the amount of unstructured data created daily, many companies are struggling to make use of or find information within their files. Knowledge mining through a search index makes it easy for end customers and employees to locate what they are looking for faster.

![Architecture Diagram](../media/digital-asset-management.png)

## Data Flow

There are three steps: Ingest, Enrich and Exploration. First, the unstructured and structured data is ingested then enrichment of this data with AI to extract information and find and finally explore the newly structured data via search, existing business applications or analytics solutions.

1. The user can ingest different types of technical content like article and image archives, photos and videos, internal documents, marketing assets, brochures
2. This content is enriched by using automatic image captioning and object detection with computer vision, celebrity recognition, language translation, and entity recognition
3. And finally, the user can integrate the search index into a website.

## Components

Key technologies used to implement tools for technical content review and research

- [Azure Cognitive Search](https://docs.microsoft.com/azure/search/)
- [Microsoft Computer Vision API](https://azure.microsoft.com/services/cognitive-services/computer-vision/)
- [Microsoft Face API](https://azure.microsoft.com/services/cognitive-services/face/)
- [Web API custom skill interface](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface)

## Next steps

Using the [knowledge mining solution accelerator](https://docs.microsoft.com/samples/azure-samples/azure-search-knowledge-mining/azure-search-knowledge-mining/) to build an initial knowledge mining prototype with Azure Cognitive Search.

Building custom skills with Microsoft's [Custom Web API](https://docs.microsoft.com/azure/search/cognitive-search-custom-skill-interface)
