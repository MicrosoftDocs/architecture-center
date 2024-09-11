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

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. Example applications include natural language processing for conversations, search, documents, translation, speech, and vision.

## Key Benefits

- **Client libraries and REST APIs**. Azure AI services client libraries and REST APIs provide direct access to your service. These tools provide programmatic access to the Azure AI services, their baseline models, and in many cases allow you to programmatically customize your models and solutions.
- **Continuous integration and deployment.** You can use Azure DevOps and GitHub Actions to manage your deployments. Use CI/CD integrations to train and deploy custom models for Speech and the Language Understanding (LUIS) service.
- **On-premises containers**. Many of the Azure AI services can be deployed in containers for on-premises access and use. Using these containers gives you the flexibility to bring Azure AI services closer to your data for compliance, security, or other operational reasons. 
- **Training models**. Some services allow you to bring your own data, then train a model. Trained custom models allow you to extend the model using the service's data and algorithm with your own data. The output matches your needs. 
- **Azure AI services in the ecosystem.** With Azure and Azure AI services, you have access to a broad ecosystem, such as:
    - Automation and integration tools like Logic Apps and Power Automate.
    - Deployment options such as Azure Functions and the App Service.
    - Azure AI services Docker containers for secure access.
    - Tools like Apache Spark, Azure Databricks, Azure Synapse Analytics, and Azure Kubernetes Service for big data scenarios.



**Considerations:**
- Because Azure AI services are only available over the web, internet connectivity is required. The only exception to this is the Custom Vision service, whose trained model you can export for prediction on devices and at the IoT Edge.
- Although considerable customization is supported, the available services might not suit all predictive analytics requirements.

## Categories of Azure AI services

Azure offers a number of AI services that can be grouped into categories based on their capabilities:

| Category | Capabilities guide | Service descriptions |
| --- | --- | --- |
| [Language](https://azure.microsoft.com/products/ai-services/language-service/) | [Azure AI language capabilities guide ](../ai-services/language-service-capabilities.md) | [Azure AI Language service](../ai-services/language-service-capabilities.md#azure-ai-language-service) is a cloud-based service that provides Natural Language Processing (NLP) features for understanding and analyzing text. Use this service to help build intelligent applications using the web-based Language Studio, REST APIs, and client libraries. [Azure AI Translator](../ai-services/language-service-capabilities.md#azure-ai-translator) is a cloud-based neural machine translation service that is part of the Azure AI services family and can be used with any operating system. Translator powers many Microsoft products and services used by thousands of businesses worldwide for language translation and other language-related operations.|
| [Speech](https://azure.microsoft.com/products/ai-services/speech-services/) | [Azure AI Speech capabilities guide ](../ai-services/speech-service-capabilities.md) | [Azure AI Speech service](../ai-services/speech-service-capabilities.md) provides speech to text and text to speech capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text to speech voices, translate spoken audio, and use speaker recognition during conversations. |
| [Vision](https://azure.microsoft.com/products/ai-services/vision-services/) | [Azure AI Vision capabilities guide](../ai-services/vision-service-capabilities.md) | Vision AI services are services that provide image and video recognition capabilities. [Azure AI Vision service](../ai-services/vision-service-capabilities.md#vision-service) provides advanced algorithms that process images and return information based on the visual features you're interested in. It provides four services: OCR, Face service, Image Analysis, and Spatial Analysis. [Azure AI Custom Vision](../ai-services/vision-service-capabilities.md#custom-vision-service) is an image recognition service that lets you build, deploy, and improve your own image identifier models. [Azure AI Face service](../ai-services/vision-service-capabilities.md#face-service) provides AI algorithms that detect, recognize, and analyze human faces in images.  |
| [Azure AI Content Safety](https://azure.microsoft.com/products/ai-services/ai-content-safety/) | N/A|Azure AI Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and services. Azure AI Content Safety includes text and image APIs that allow you to detect material that is harmful. The interactive Content Safety Studio allows you to view, explore, and try out sample code for detecting harmful content across different modalities.Content filtering software can help your app comply with regulations or maintain the intended environment for your users.|
|[Azure AI Document Intelligence](https://azure.microsoft.com/products/ai-services/ai-document-intelligence) | N/A | AI Document Intelligence is an AI service that applies advanced machine learning to extract text, key-value pairs, tables, and structures from documents automatically and accurately. Turn documents into usable data and shift your focus to acting on information rather than compiling it.|
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

- If your use case requires speech-to-text, text-to-speech, or speech-to-speech, use a [Speech service](../ai-services/speech-service-capabilities.md).
- If your use case requires language or document analysis, text assessment, or  text-to-text, use a [Language service](../ai-services/language-service-capabilities.md).
- If you need to analyze images, video, or text, use a [Vision service](../ai-services/vision-service-capabilities.md).


## Deploying Azure AI service resources

When you [create an Azure AI services resource](/azure/ai-services/multi-service-resource?pivots=azportal#types-of-cognitive-services-resources), you can either deploy services independently or use the Azure AI services multi-service resource. To see which services are supported by multi-service resource, see [Supported services with a multi-service resource](/azure/ai-services/multi-service-resource?pivots=azportal#supported-services-with-a-multi-service-resource).

- Deploy an individual service if you don't need other services or if you want to manage access and billing on a per-service basis.
- Deploy the multi-service resource if you're using multiple services and want to manage access and billing for all services together.

> [!NOTE]
> The resource categories in these services change frequently. Be sure to check the latest documentation for new categories.

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

- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)
- [Azure AI Services documentation](/azure/ai-services/)
- [What are Azure AI Services?](/azure/ai-services/what-are-ai-services)


## Related resources

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
