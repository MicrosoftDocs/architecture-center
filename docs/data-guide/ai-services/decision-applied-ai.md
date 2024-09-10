---
title: Decision-making with Azure AI services
description: Learn about decision-making capabilities of Azure AI services. Learn which service to use for a specific use cases.
author: kruti-m
ms.author: krmeht
ms.date: 09/09/2024
ms.topic: conceptual
ms.service: architecture-center
ms.collection: ce-skilling-ai-copilot
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

# Decision-making with Azure AI services

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. 

In this article, we focus on the services that offer decision-making capabilities of Azure AI services.

## Services

The following services provide decision making capabilities for Azure AI services:

- [Azure Bot Service](https://azure.microsoft.com/products/bot-services/).
- [Azure AI Safety](/azure/ai-services/content-safety/overview).

Each service has its own capabilities and use cases.

### Azure AI Safety service

[Azure AI Safety](https://azure.microsoft.com/products/ai-services/ai-language) is an AI service that detects harmful user-generated and AI-generated content in applications and services. Azure AI Content Safety includes text and image APIs that allow you to detect material that is harmful. The interactive Content Safety Studio allows you to view, explore, and try out sample code for detecting harmful content across different modalities.


#### Capabilities

The following table provides a list of capabilities available in Azure AI Safety service:


| Capabilities                        | Functionality          | Concepts guide | 
| :-------------------------- | :---------------------- | --| 
| [Prompt Shields](/rest/api/contentsafety/text-operations/detect-text-jailbreak) | Scans text for the risk of a User input attack on a Large Language Model. | [Prompt Shields concepts](/azure/ai-services/content-safety/concepts/jailbreak-detection)|
| [Groundedness detection](/rest/api/contentsafety/text-groundedness-detection-operations/detect-groundedness-options) (preview) | Detects whether the text responses of large language models (LLMs) are grounded in the source materials provided by the users. | [Groundedness detection concepts](/azure/ai-services/content-safety/concepts/groundedness)|
| [Protected material text detection](/rest/api/contentsafety/text-operations/detect-text-protected-material) | Scans AI-generated text for known text content (for example, song lyrics, articles, recipes, selected web content). | [Protected material concepts](/azure/ai-services/content-safety/concepts/protected-material)|
| Custom categories API (preview)    | Lets you create and train your own custom content categories and scan text for matches. | [Custom categories concepts](/azure/ai-services/content-safety/concepts/custom-categories)|
| Custom categories (rapid) API (preview) | Lets you define emerging harmful content patterns and scan text and images for matches. | [Custom categories concepts](/azure/ai-services/content-safety/concepts/custom-categories)|
| [Analyze text](/rest/api/contentsafety/text-operations/analyze-text) API      | Scans text for sexual content, violence, hate, and self harm with multi-severity levels. | [Harm categories](/azure/ai-services/content-safety/concepts/harm-categories)| 
| [Analyze image](/rest/api/contentsafety/image-operations/analyze-image) API         | Scans images for sexual content, violence, hate, and self harm with multi-severity levels. | [Harm categories](/azure/ai-services/content-safety/concepts/harm-categories)| 


#### Use cases

The following list contains some use cases in which a software developer or team would require a content moderation service:

- User prompts submitted to a generative AI service.
- Content produced by generative AI models.
- Online marketplaces that moderate product catalogs and other user-generated content.
- Gaming companies that moderate user-generated game artifacts and chat rooms.
- Social messaging platforms that moderate images and text added by their users.
- Enterprise media companies that implement centralized moderation for their content.
- K-12 education solution providers filtering out content that is inappropriate for students and educators.


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


- [Azure AI Safety](/azure/ai-services/content-safety/overview)
- [Azure OpenAI](/azure/ai-services/openai/overview)
- [Learning path: Develop natural language processing solutions with Azure AI Services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)


## Related resources

- [Language and document processing with Azure AI services](language-api.md)
- [Types of speech API services](speech-api.md)
- [Types of vision API services](vision-api.md)
