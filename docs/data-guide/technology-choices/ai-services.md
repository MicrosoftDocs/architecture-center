---
title: Choose an AI services technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: kruti-m
ms.author: krmeht
categories:
  - ai-machine-learning
  - analytics
ms.date: 09/09/2024
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - ai-services
  - azure-applied-ai-services
  - azure-custom-vision
ms.custom:
  - cognitive services
  - AI guide
  - arb-aiml
---

# Choose an Azure AI services technology

[Azure AI services](/azure/azure/ai-services) is a out-of-the-box, prebuilt, customizable APIs and models that help you build responsible AI applications and data flows. AI services are developed by the Microsoft AI and Research team and expose the latest deep learning algorithms.  Most Azure AI services are available through REST APIs and client library SDKs in popular development languages. 

**Key benefits:**

- Minimal development effort for state-of-the-art AI services. Use predefined algorithms or create custom algorithms on top of pre-built libraries.
- Easy integration into apps via HTTP REST interfaces.
- Developers and data scientists of all skill levels can easily add AI capabilities to apps.

**Considerations:**

- Because Azure AI services are only available over the web, internet connectivity is required. The only exception to this is the Custom Vision service, whose trained model you can export for prediction on devices and at the IoT Edge.
- Although considerable customization is supported, the available services might not suit all predictive analytics requirements.

## Categories of Azure AI services

Azure offers a large number of AI services that can be grouped into the following functional categories:


| Category | Link to decision guide | Description |
| --- | --- | --- |
| [Language](https://azure.microsoft.com/products/ai-services/language-service/) | [Choose a language service](../ai-services/language-api.md) | Language AI service is a service that providse Natural Language Processing (NLP) features for understanding and analyzing text. |
| [Speech](https://azure.microsoft.com/products/ai-services/speech-services/) | [Choose a speech service](../ai-services/speech-api.md) | Speech AI services are services that provide speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. |
| [Vision](https://azure.microsoft.com/products/ai-services/vision-services/) | [Choose a vision service](../ai-services/vision-api.md) | Vision AI services are services that provide image and video recognition capabilities. |
| [Search](https://azure.microsoft.com/products/ai-services/ai-search/) | ||Azure AI Search provides secure information retrieval at scale over user-owned content in traditional and generative AI search applications. |
|[Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service/) | N/A | Azure OpenAI Service provides REST API access to OpenAI's powerful language models including GPT-4o, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and Embeddings model series. These models can be easily adapted to your specific task including but not limited to content generation, summarization, image understanding, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio. |

## Common use cases

The following are some common use cases for Azure AI services.

| Use case | Category |
| --- | --- |
| Transcribe audible speech into readable, searchable text. | Speech |
| Convert text to lifelike speech for more natural interfaces. | Speech |
| Integrate real-time speech translation into your apps. | Speech |
| Identify and verify the person speaking by using voice characteristics. | Speech |
| Identify commonly used and domain-specific terms. | Language |
| Automatically detect sentiments and opinions in text. | Language |
| Distill information into easy-to-navigate questions and answers. | Language |
| Enable your apps to interact with users through natural language. | Language  |
| Translate more than 100 languages and dialects. | Language |
| Identify and analyze content in images and video. | Vision |
| Customize image recognition to fit your business needs. | Vision |
| Identify potential problems early. | Decision services / Anomaly Detector  |
| Detect potentially offensive or unwanted content. | Decision services / Content Moderator  |
| Create rich, personalized experiences for every user. | Decision services / Personalizer  |
| Apply advanced coding and language models to various use cases. | Azure OpenAI  |

## Key selection criteria

To narrow down the choices, start by answering these questions:

- Are you processing something related to spoken language, or are you processing text, images, or documents?

- Do you have the data to train a model? If yes, consider using the custom services that enable you to train their underlying models with data that you provide. Doing so can improve accuracy and performance.

This flow chart can help you choose the best API service for your use case.

![Diagram that shows how to select a AI Services API.](../ai-services/images/ai-services-flow-chart.png)

- If your use case requires speech-to-text, text-to-speech, or speech-to-speech, use a [speech API](../ai-services/speech-api.md).
- If your use case requires language analysis, text assessment, or  text-to-text, use a [language API](../ai-services/language-api.md).
- If you need to analyze images, video, or text, use a [vision API](../ai-services/vision-api.md).
- If you need to make a decision, use a [decision API or Applied AI Services](../ai-services/decision-applied-ai.md).

## Deploying services

When you [deploy AI Services](/azure/ai-services/ai-services-apis-create-account#types-of-ai-services-resources), you can either deploy services independently or use the Azure AI services multi-service resource. The multi-service resource deploys decision, language, speech, vision, and applied AI services.

- Deploy an individual service if you don't need other services or if you want to manage access and billing on a per-service basis.
- Deploy the multi-service resource if you're using multiple services and want to manage access and billing for all services together.

> [!NOTE]
> The resource categories in these API services change frequently. Be sure to check the latest documentation for new categories.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-Track Engineer
- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-Track Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learning path: Provision and manage Azure AI Services](/training/paths/provision-manage-azure-ai-services)
- [Azure AI Services documentation](/azure/ai-services)
- [What are Azure AI Services?](/azure/ai-services/what-are-ai-services)
- [Blog post: Which AI Am I?](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/which-ai-am-i-azure-ai-applied-services-part-1/ba-p/3506572)

## Related resources

- [Automate document processing by using Azure AI Document Intelligence](../../ai-ml/architecture/automate-document-processing-azure-form-recognizer.md)
- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
