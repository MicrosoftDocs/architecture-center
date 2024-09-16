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
ms.service: azure-architecture-center
ms.subservice: architecture-guide
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

[Azure AI services](/azure/ai-services/what-are-ai-services) offers a suite of models that support a broad array of functionality. Most require little or no specific AI expertise to use. So whether you're a student, run a small-business, are launching a startup, or lead a large enterprise-scale project, you can get started right away. It's easy to embed AI functionality into your applications. For many use cases, these prebuilt models are sufficient to provide exactly what your application requires. However, most prebuilt models support further customization and fine tuning as necessary, without the need to re-engineer a new model.

Some projects require functionality that goes beyond what prebuilt models can provide. You could need to use your own data exclusively to build a new model, or perform functions outside the scope of any existing prebuilt models. In those cases, [Azure Machine Learning services](/azure/machine-learning) let you to build custom models of any type or scale. While these solutions require more expertise, they can also support bespoke requirements for organizations of every scale and for every budget.

This article provides a comparison and decision guide between the different offerings of Azure AI and Azure Machine Learning services. It's organized by broad category to help you choose which service or model is right for your use case.


## Categories of Azure AI services

Azure offers a number of AI services that can be grouped into categories based on their capabilities:

| Category guide | Service descriptions |
| --- |  --- |
|  [Targeted language processing guide ](../ai-services/targeted-language-processing) |Azure AI Language &bullet; Azure AI Translator &bullet; Azure AI Document Intelligence |
|[Speech recognition and generation guide ](../ai-services/speech-recognition-generation.md) | Azure AI Speech &bullet; Immersive Reader |
| [Image and video processing guide](../ai-services/image-video-processing.md) | Azure AI Vision &bullet; Azure AI Custom Vision &bullet; Azure AI Video Indexer &bullet; Azure AI Face &bullet; Azure OpenAI|
|  [Large language chat models ](../ai-services/large-language-chat.md) | Azure AI Search &bullet; Azure OpenAI |
| [Azure AI Content Safety](https://azure.microsoft.com/products/ai-services/ai-content-safety/) | Azure AI Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and sprocesses images and text to flag content that's potentially offensive or unwanted. It's able to automatically detect and scan content regardless of its source language. |
|[Custom Machine Learning](https://azure.microsoft.com/products/ai-services/openai-service/) |  Azure Machine Learning service procures and exposes many proprietary and open source models that you can use directly or customize further with more training. It also supports the creation of brand new models of any type using your own data. |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:


Other contributors:



*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)
- [Azure AI Services documentation](/azure/ai-services/)
- [What are Azure AI Services?](/azure/ai-services/what-are-ai-services)


## Related resources

- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
