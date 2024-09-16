---
title: Choose an AI services technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: robbagby
ms.author: pnp
categories:
  - ai-machine-learning
  - analytics
ms.date: 09/16/2024
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

[Azure AI services](/azure/ai-services/what-are-ai-services) you create intelligent, market-ready, and responsible AI applications with prebuilt and customizable APIs and models. Example applications include natural language processing for conversations, search, documents, translation, speech, and vision. Most of the services require very little training to get started, and can be customized to meet your specific needs.

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



### Considerations

- Because Azure AI services are only available over the web, internet connectivity is required. The only exception to this is the Custom Vision service, whose trained model you can export for prediction on devices and at the IoT Edge.
- Although considerable customization is supported, the available services might not suit all predictive analytics requirements.

## Categories of Azure AI services

Azure offers a number of AI services that can be grouped into categories based on their capabilities:

| Category guide | Service descriptions |
| --- |  --- |
|  [Targeted language processing guide ](../ai-services/targeted-language-processing.md) |Azure AI Language &bullet; Azure AI Translator &bullet; Azure AI Document Intelligence |
|[Speech recognition and generation guide ](../ai-services/speech-recognition-generation.md) | Azure AI Speech &bullet; Immersive Reader |
| [Image and video processing guide](../ai-services/image-video-processing.md) | Azure AI Vision &bullet; Azure AI Custom Vision &bullet; Azure AI Video Indexer &bullet; Azure AI Face &bullet; Azure OpenAI|
|  [Large language chat models ](../ai-services/large-language-chat.md.md) | Azure AI Search &bullet; Azure OpenAI |
| [Azure AI Content Safety](https://azure.microsoft.com/products/ai-services/ai-content-safety/) | Azure AI Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and sprocesses images and text to flag content that's potentially offensive or unwanted. It's able to automatically detect and scan content regardless of its source language. |
|[Custom Machine Learning](https://azure.microsoft.com/products/ai-services/openai-service/) |  Azure Machine Learning service procures and exposes many proprietary and open source models that you can use directly or customize further with more training. It also supports the creation of brand new models of any type using your own data. |


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
