---
title: Choose an Azure AI Technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: davihern
ms.author: davihern
ms.date: 11/22/2025
ms.update-cycle: 180-days
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# Choose an Azure AI services technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) provide a suite of data science tools, models, and inferencing capabilities that support a broad range of functions. Most AI services require little to no AI expertise. This accessibility makes them available to students, small-business owners, startups, and large enterprises alike. Instead of building custom solutions, Microsoft recommends that you use these services to embed intelligent functionality into your workloads. In many cases, prebuilt models and software-as-a-service solutions provide the necessary capabilities. However, many services support further customization and fine-tuning without the need to redesign your workload.

Some projects require capabilities beyond what prebuilt models provide. You might need to use your own data exclusively to build a new model or perform functions that existing prebuilt models don't support. In these cases, you can use [Azure Machine Learning](/azure/machine-learning) to build custom models of any type or scale. These solutions require more expertise, but they provide tailored functionality for organizations of any size and budget.

This article compares AI services and machine learning solutions. It's organized by broad categories to help you choose the right service or model for your use case.

## Categories of AI services

Azure provides several AI services that can be grouped into categories based on their capabilities:

| Technology selection guide | Service descriptions |
| :----- | :----- |
| [Azure AI agents](/azure/ai-foundry/) | - [Foundry Agent Service](/azure/ai-services/agents/overview) <br><br> - [Foundry Models](/azure/ai-foundry/concepts/foundry-models-overview)<br><br> - [Observability](/azure/ai-foundry/concepts/observability?view=foundry&preserve-view=true) |
| [Retrieval Augmented Generation](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) | - [Azure AI Search](/azure/search/search-what-is-azure-search) <br><br> - [Azure Document Intelligence in Foundry Tools](/azure/ai-services/document-intelligence/overview) <br><br> - [Models](/azure/ai-foundry/concepts/foundry-models-overview) |
| [Targeted language processing](/azure/architecture/data-guide/ai-services/targeted-language-processing) | - [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) <br><br> - [Azure Translator in Foundry Tools](/azure/ai-services/translator/overview) <br><br> - [Azure Document Intelligence in Foundry Tools](/azure/ai-services/document-intelligence/overview) <br><br> - [Models](/azure/ai-foundry/concepts/foundry-models-overview) |
| [Speech recognition and generation](/azure/architecture/data-guide/ai-services/speech-recognition-generation) | - [Speech service](/azure/ai-services/speech-service/overview) <br><br> - [Immersive Reader](/training/educator-center/product-guides/immersive-reader/) <br><br> - [Models](/azure/ai-foundry/concepts/foundry-models-overview) |
| [Image and video processing guide](/azure/architecture/data-guide/ai-services/image-video-processing) | - [Azure Vision in Foundry Tools](/azure/ai-services/computer-vision/overview) <br><br> - [Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/overview) <br><br> - [Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) <br><br> - [Azure AI Face](/azure/ai-services/computer-vision/overview-identity) <br><br> - [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) <br><br> - [Models](/azure/ai-foundry/concepts/foundry-models-overview) |
| [Azure AI Content Safety](/azure/ai-services/content-safety/overview) | Azure AI Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and processes images and text to flag content that's potentially offensive or unwanted. It can automatically detect and scan content regardless of its source language. |
| [Custom Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) | [Azure Machine Learning](/azure/machine-learning/) procures and exposes many proprietary and open-source models that you can use directly or customize further with more training. It also supports the creation of new models of any type and is trained by using your own data. |
| [Local on-device inference](/azure/ai-foundry/foundry-local/what-is-foundry-local) | [Foundry Local](/azure/ai-foundry/foundry-local/get-started) is an on-device AI inference solution that provides performance, privacy, customization, and cost benefits. |

## Next steps

- [Learning path: Get started with AI services](/training/paths/create-custom-copilots-ai-studio/)
- [Microsoft Foundry documentation](/azure/ai-foundry)
- [What are Foundry Tools?](/azure/ai-services/what-are-ai-services)

## Related resources

- [Image classification on Azure](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing)
