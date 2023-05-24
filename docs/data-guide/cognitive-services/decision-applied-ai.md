---
title: Decision APIs and Applied AI Services
description: Learn about Cognitive Services Decision APIs, which can help you make recommendations for decision-making, and Applied AI Services, which provides NLP features.
author: kruti-m
ms.author: krmeht
ms.date: 05/30/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
categories: 
  - ai-machine-learning
ms.custom:
  - analytics
  - guide
---

# Decision APIs and Applied AI Services

Azure Cognitive Services Decision APIs are cloud-based APIs that provide natural language processing (NLP) features to produce recommendations for informed and efficient decision-making. They can help you make smart decisions faster.

Azure Applied AI Services combine Cognitive Services, specialized AI, and built-in business logic to provide ready-to-use AI solutions for frequently encountered business scenarios. Azure Cognitive Search is a cloud search service that has built-in AI capabilities.

## Services

Here are a few of the specific services:

- [Azure Bot Service](https://azure.microsoft.com/products/bot-services/) provides an integrated development environment for creating conversational AI bots without writing code. It's integrated with [Power Virtual Agents](https://powervirtualagents.microsoft.com/), which is available as both a standalone web app and a discrete app in Microsoft Teams.
- [Anomaly Detector](/azure/cognitive-services/anomaly-detector/overview) ingests time-series data of all types and selects the best anomaly detection algorithm. The Anomaly Detector API enables you to monitor and detect abnormalities in your time-series data even if you have limited knowedge about machine learning. It uses univariate and multivariate APIs to monitor data over time. You can use it for either batch validation or real-time inference.
- [Personalizer](https://azure.microsoft.com/products/cognitive-services/personalizer/) is a cloud-based service that helps your applications choose content items to show your users. Personalizer uses reinforcement learning to select the best item, or *action*, based on collective behavior and reward scores across all users. Actions are content items, like news articles, movies, or products.
- [Content Moderator](/azure/cognitive-services/content-moderator/) is a service that checks text, image, and video content for material that's potentially offensive, risky, or otherwise undesirable.
    - **Text moderation** scans text for offensive content, sexually explicit or suggestive content, profanity, and personal data. You can use pre-built or custom models.
    - **Image moderation** scans images for adult or racy content, detects text in images by using optical character recognition (OCR), and detects faces. You can use pre-built or custom models
    - **Video moderation** scans videos for adult or racy content and returns time markers for the content. This API currently supports only pre-built models.
- [Applied AI Services](/azure/applied-ai-services/what-are-applied-ai-services) enable you to apply AI to key business data scenarios. These services are built on the AI APIs of Cognitive Services. [Azure Cognitive Search](/azure/applied-ai-services/what-are-applied-ai-services#azure-cognitive-search) is one of the key Applied AI Services.

## Key considerations

This flow chart can help you choose the Decision API or Applied AI Services option that suits your needs:

:::image type="content" source="images/cognitive-services-decision-applied-ai.png" alt-text="Diagram that shows how to select Speech Services" lightbox="images/cognitive-services-decision-applied-ai.png":::

## Common use cases

- **Bot Service**
    - Provide help for sales and support.
    - Provide information about store business hours and more.
    - Provide information about employee health and vacation benefits.
    - Answer common employee questions.
    
- **Anomaly Detector**
    - Detect anomalies in your streaming data by using previously seen data points to determine whether the latest one is anomalous.
    - Detect anomalies in an entire data series at a specific time. This operation generates a model by using all of your time-series data. The same model analyzes each data point.
    - Detect any trend change points that exist in your data at a specific time. This operation generates a model by using all of your time-series data. The same model analyzes each data point.

- **Personalizer**
    - Get recommendations for e-commerce. Determine the best products to present to customers to maximize purchases.
    - Get content recommendations. Recommend articles that optimize  click-through rates.
    - Improve content design. Determine placements for advertisements to optimize user engagement on a website.
    - Improve communications. Determine when and how to send notifications  to maximize the likelihood of getting a response.

- **Content Moderator**
  - Scan text, image, or video for potentially risky, offensive, or undesirable content.

- **Applied OpenAI Services**
Azure Cognitive Services with task-specific AI, built-in business logic, programming, orchestration and customization to bring you ready-to-deploy AI solutions. Common use cases include
    - [Content Filtering](/azure/cognitive-services/openai/concepts/content-filter)
    - [Embeddings](/azure/cognitive-services/openai/concepts/understand-embeddings)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*
Principal authors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-track Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect

Co-authors:

- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-track Engineer
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect

### Next steps

- [Power Virtual Agents-Bots](https://learn.microsoft.com/power-virtual-agents/fundamentals-what-is-power-virtual-agents)
- [Anomaly Detector](/azure/cognitive-services/anomaly-detector/)
- [Content Moderator](/azure/cognitive-services/content-moderator/)
- [Personalizer](/azure/cognitive-services/personalizer/what-is-personalizer)
- [Azure Open AI](/azure/cognitive-services/openai/overview)
- [Decision API's Bifurcations](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-decision-api-s-azure-ai-applied/ba-p/3520408)

### Learning paths

- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)]
- [Learning path: Identify principals and practices for Responsible AI](/training/paths/responsible-ai-business-principles/)
- [Learning path: Introduction to responsible bots](/training/modules/responsible-bots-introduction/)
- [Learning path: Get started with artificial intelligence](/training/paths/get-started-with-artificial-intelligence-on-azure/)
