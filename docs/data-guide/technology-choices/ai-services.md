---
title: Choose an AI services technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: robbagby
ms.author: pnp
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

Azure offers a number of AI services that can be grouped into categories based on their capabilities:


| Category | Capabilities guide | Service descriptions |
| --- | --- | --- |
| [Language and document processing](https://azure.microsoft.com/products/ai-services/language-service/) | [Azure AI language and document processing capabilities guide ](../ai-services/language-api.md) | [Azure AI Language service](https://azure.microsoft.com/products/ai-services/ai-language) is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries. [Azure AI Translator](https://azure.microsoft.com/products/ai-services/ai-translator) is a cloud-based neural machine translation service that is part of the Azure AI services family and can be used with any operating system. Translator powers many Microsoft products and services used by thousands of businesses worldwide for language translation and other language-related operations. [Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence) is a cloud-based Azure AI service that enables you to build intelligent document processing solutions. Massive amounts of data, spanning a wide variety of data types, are stored in forms and documents. Document Intelligence enables you to effectively manage the velocity at which data is collected and processed and is key to improved operations, informed data-driven decisions, and enlightened innovation.|
| [Speech](https://azure.microsoft.com/products/ai-services/speech-services/) | [Azure AI Speech service capabilities guide ](../ai-services/speech-api.md) | [Azure AI Speech service](https://azure.microsoft.com/products/ai-services/ai-speech) provides speech to text and text to speech capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text to speech voices, translate spoken audio, and use speaker recognition during conversations. |
| [Vision](https://azure.microsoft.com/products/ai-services/vision-services/) | [Choose a vision service](../ai-services/vision-api.md) | Vision AI services are services that provide image and video recognition capabilities. |
| [Azure AI Content Safety](https://azure.microsoft.com/products/ai-services/ai-content-safety/) | N/A|Azure AI Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and services. Azure AI Content Safety includes text and image APIs that allow you to detect material that is harmful. The interactive Content Safety Studio allows you to view, explore, and try out sample code for detecting harmful content across different modalities.Content filtering software can help your app comply with regulations or maintain the intended environment for your users.|
|[Azure AI Search](https://azure.microsoft.com/products/ai-services/ai-search/) |N/A|Azure AI Search provides secure information retrieval at scale over user-owned content in traditional and generative AI search applications. |
|[Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service/) | N/A| Azure OpenAI Service provides REST API access to OpenAI's powerful language models including GPT-4o, GPT-4 Turbo with Vision, GPT-4, GPT-3.5-Turbo, and Embeddings model series. These models can be easily adapted to your specific task including but not limited to content generation, summarization, image understanding, semantic search, and natural language to code translation. Users can access the service through REST APIs, Python SDK, or our web-based interface in the Azure OpenAI Studio. |

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
| Detect potentially offensive or unwanted content. | Azure AI Content Safety  |
| Apply advanced coding and language models to various use cases. | Azure OpenAI  |

## Key selection criteria

To narrow down the choices, start by answering these questions:

- Are you processing something related to spoken language, or are you processing text, images, or documents?

- Do you have the data to train a model? If yes, consider using the custom services that enable you to train their underlying models with data that you provide. Doing so can improve accuracy and performance.

This flow chart can help you choose the best API service for your use case.

![Diagram that shows how to select a AI Services API.](../ai-services/images/ai-services-flow-chart.png)

- If your use case requires speech-to-text, text-to-speech, or speech-to-speech, use a [speech API](../ai-services/speech-api.md).
- If your use case requires language or document analysis, text assessment, or  text-to-text, use a [language and document processing with Azure AI services](../ai-services/language-api.md).
- If you need to analyze images, video, or text, use a [vision API](../ai-services/vision-api.md).


## Deploying services

When you [deploy AI Services](/azure/ai-services/ai-services-apis-create-account#types-of-ai-services-resources), you can either deploy services independently or use the Azure AI services multi-service resource. The multi-service resource deploys decision, language, speech, and vision services.

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


## Related resources

- [Automate document processing by using Azure AI Document Intelligence](../../ai-ml/architecture/automate-document-processing-azure-form-recognizer-content.md)
- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
