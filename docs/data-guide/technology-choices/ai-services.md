---
title: Choose an Azure AI Technology
description: Learn about AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: hudua
ms.author: hudua
ms.date: 03/20/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# Choose an AI services technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) provides a suite of data science tools, models, and inferencing capabilities that support a range of functions. Most AI services require little to no AI expertise, so students, small-business owners, startups, and large enterprises can easily use them. Instead of building custom solutions, we recommend that you use these services to embed intelligent functionality into your workloads. In many cases, prebuilt models and software as a service (SaaS) solutions provide the necessary capabilities. But many services support further customization and fine-tuning without the need to redesign your workload.

Some projects require capabilities beyond what prebuilt models provide. You might need to use your own data exclusively to build a new model or perform functions that existing prebuilt models don't support. In these cases, you can use [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) to build custom models of any type or scale. These solutions require more expertise, but they provide tailored functionality for organizations of any size and budget.

This article compares AI services and machine learning solutions. It organizes them by broad categories to help you choose the right service or model for your use case.

## Categories of AI services

The following table groups several AI services that Azure provides into categories based on their capabilities.

| Technology selection guide | Service descriptions |
| :----- | :----- |
| [Agents](/azure/foundry/what-is-foundry) | - [Foundry Agent Service](/azure/foundry/agents/overview) <br><br> - [Foundry Models](/azure/foundry-classic/concepts/foundry-models-overview) <br><br> - [Observability](/azure/foundry/concepts/observability) |
| [Retrieval-augmented generation (RAG)](/azure/architecture/ai-ml/guide/rag/rag-solution-design-and-evaluation-guide) | - [Azure AI Search](/azure/search/search-what-is-azure-search) <br><br> - [Azure Document Intelligence in Foundry Tools](/azure/ai-services/document-intelligence/overview) <br><br> - [Azure Content Understanding in Foundry Tools](/azure/ai-services/content-understanding/overview) <br><br> - [Models](/azure/foundry-classic/concepts/foundry-models-overview) |
| [Targeted language processing](/azure/architecture/data-guide/ai-services/targeted-language-processing) | - [Azure OpenAI in Foundry Models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure) <br><br> - [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview) <br><br> - [Azure Translator in Foundry Tools](/azure/ai-services/translator/overview) <br><br> - [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) <br><br> - [Azure Content Understanding](/azure/ai-services/content-understanding/overview) |
| [Speech recognition and generation](/azure/architecture/data-guide/ai-services/speech-recognition-generation) | - [Azure Speech in Foundry Tools](/azure/ai-services/speech-service/overview) <br><br>  - [Models](/azure/foundry-classic/concepts/foundry-models-overview) |
| [Image and video processing guide](/azure/architecture/data-guide/ai-services/image-video-processing) | - [Azure Vision in Foundry Tools](/azure/ai-services/computer-vision/overview) <br><br> - [Azure Content Understanding](/azure/ai-services/content-understanding/overview) <br><br> - [Microsoft Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) <br><br> - [Microsoft Azure AI Custom Vision](/azure/ai-services/custom-vision-service/overview) <br><br> - [Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) <br><br> - [Models](/azure/foundry-classic/concepts/foundry-models-overview) |
| [Content Safety in Foundry Control Plane](/azure/ai-services/content-safety/overview) | Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and processes images and text to flag potentially offensive or unwanted content. It can automatically detect and scan content regardless of its source language. |
| [Custom models in Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) | [Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) procures and exposes many proprietary and open-source models that you can use directly or customize further with more training. It also supports the creation of new models of any type and is trained by using your own data. |
| [Local on-device inference](/azure/foundry-local/what-is-foundry-local) | [Foundry Local](/azure/foundry-local/get-started) is an on-device AI inference solution that provides performance, privacy, customization, and cost benefits. |

## Next steps

- [Learning path: Develop generative AI apps in Azure](/training/paths/create-custom-copilots-ai-studio/)
- [Microsoft Foundry documentation](/azure/foundry/)
- [Foundry Tools overview](/azure/ai-services/what-are-ai-services)

## Related resource

- [Image classification on Azure](/azure/architecture/ai-ml/idea/intelligent-apps-image-processing)

- [Image classification on Azure](../../ai-ml/idea/intelligent-apps-image-processing.yml)
