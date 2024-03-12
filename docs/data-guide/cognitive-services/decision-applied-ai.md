---
title: Types of decision APIs and Applied AI Services
description: Learn about Cognitive Services Decision APIs, which can help you make recommendations for decision-making, and Applied AI Services, which provides NLP features.
author: kruti-m
ms.author: krmeht
ms.date: 06/01/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - ai-services
  - azure-bot-service
  - azure-applied-ai-services
categories: 
  - ai-machine-learning
ms.custom:
  - analytics
  - guide
---

# Types of decision APIs and Applied AI Services

Azure Cognitive Services decision APIs are cloud-based APIs that provide natural language processing (NLP) features to produce recommendations for informed and efficient decision-making. They can help you make smart decisions faster.

Azure Applied AI Services combines Cognitive Services, specialized AI, and built-in business logic to provide ready-to-use AI solutions for frequently encountered business scenarios. Azure Cognitive Search is a cloud search service that has built-in AI capabilities.

## Services

Here are a few of the decision and applied AI services:

- [Azure Bot Service](https://azure.microsoft.com/products/bot-services/) provides an integrated development environment for creating conversational AI bots without writing code. It's integrated with [Power Virtual Agents](https://powervirtualagents.microsoft.com/), which is available as both a standalone web app and a discrete app in Microsoft Teams.
- [Anomaly Detector](/azure/cognitive-services/anomaly-detector/overview) ingests time-series data of all types and selects the best anomaly detection algorithm. The Anomaly Detector API enables you to monitor and detect abnormalities in your time-series data even if you have limited knowledge of machine learning. It uses univariate and multivariate APIs to monitor data over time. You can use it for either batch validation or real-time inference.
- [Personalizer](https://azure.microsoft.com/products/cognitive-services/personalizer/) is a cloud-based service that helps your applications choose content items to show your users. Personalizer uses reinforcement learning to select the best item, or *action*, based on collective behavior and reward scores across all users. Actions are content items, like news articles, movies, or products.
- [Content Moderator](/azure/cognitive-services/content-moderator/) is a service that checks text, image, and video content for material that's potentially offensive, risky, or otherwise undesirable.
    - **Text moderation** scans text for offensive content, sexually explicit or suggestive content, profanity, and personal data. You can use prebuilt or custom models.
    - **Image moderation** scans images for adult or racy content, detects text in images by using optical character recognition, and detects faces. You can use prebuilt or custom models.
    - **Video moderation** scans videos for adult or racy content and returns time markers for the content. This API currently supports only prebuilt models.
- [Applied AI Services](/azure/applied-ai-services/what-are-applied-ai-services) enables you to apply AI to key business data scenarios. These services are built on the AI APIs of Cognitive Services. [Azure Cognitive Search](/azure/applied-ai-services/what-are-applied-ai-services#azure-cognitive-search) is a key part of Applied AI Services.

## How to choose a service

This flow chart can help you choose the decision API or Applied AI Services option that suits your needs:

:::image type="content" source="images/cognitive-services-decision-applied-ai.png" alt-text="Diagram that shows how to choose a decision or applied AI service." lightbox="images/cognitive-services-decision-applied-ai.png":::

## Common use cases

- **Bot Service**
    - Provide help for sales and support.
    - Provide information about store business hours and more.
    - Provide information about employee health and vacation benefits.
    - Answer common employee questions.
    
- **Anomaly Detector**
    - Detect anomalies in your streaming data by using previously seen data points to determine whether the latest one is anomalous.
    - Detect anomalies in an entire data series at a specific time. This operation generates a model by using all your time-series data. The same model analyzes each data point.
    - Detect any trend change points that exist in your data at a specific time. This operation generates a model by using all your time-series data. The same model analyzes each data point.

- **Personalizer**
    - Get recommendations for e-commerce. Determine the best products to present to customers to maximize purchases.
    - Get content recommendations. Recommend articles that optimize  click-through rates.
    - Improve content design. Determine placements for advertisements to optimize user engagement on a website.
    - Improve communications. Determine when and how to send notifications  to maximize the likelihood of getting a response.

- **Content Moderator**
  - Scan text, images, or video for potentially risky, offensive, or undesirable content.

- **Applied AI Services** 
   - Implement ready-to-deploy AI solutions. Common use cases include [content filtering](/azure/cognitive-services/openai/concepts/content-filter) and [embeddings](/azure/cognitive-services/openai/concepts/understand-embeddings).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-Track Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-Track Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Power Virtual Agents overview](/power-virtual-agents/fundamentals-what-is-power-virtual-agents)
- [Anomaly Detector](/azure/cognitive-services/anomaly-detector/)
- [Content Moderator](/azure/cognitive-services/content-moderator/)
- [Personalizer](/azure/cognitive-services/personalizer/what-is-personalizer)
- [Azure OpenAI](/azure/cognitive-services/openai/overview)
- [Decision APIs blog post](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-decision-api-s-azure-ai-applied/ba-p/3520408)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)
- [Learning path: Identify principles and practices for responsible AI](/training/paths/responsible-ai-business-principles/)
- [Learning path: Introduction to responsible bots](/training/modules/responsible-bots-introduction/)
- [Learning path: Get started with AI](/training/paths/get-started-with-artificial-intelligence-on-azure/)

## Related resources

- [Types of language API services](language-api.md)
- [Types of speech API services](speech-api.md)
- [Types of vision API services](vision-api.md)
