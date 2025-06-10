---
title: Choose an Azure AI Services Technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: ritesh-modi
ms.author: rimod
ms.date: 03/20/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom:
  - cognitive services
  - AI guide
  - arb-aiml
---

# Choose an Azure AI services technology

[Azure AI services](/azure/ai-services/what-are-ai-services) provide a suite of data science tools, models, and inferencing capabilities that support a broad range of functions. Most AI services require little to no AI expertise. This accessibility makes them available to students, small-business owners, startups, and large enterprises alike. Instead of building custom solutions, Microsoft recommends that you use these services to embed intelligent functionality into your workloads. In many cases, prebuilt models and software-as-a-service solutions provide the necessary capabilities. However, many services support further customization and fine-tuning without the need to redesign your workload.

Some projects require capabilities beyond what prebuilt models provide. You might need to use your own data exclusively to build a new model or perform functions that existing prebuilt models don’t support. In these cases, you can use [Azure Machine Learning](/azure/machine-learning) to build custom models of any type or scale. These solutions require more expertise, but they provide tailored functionality for organizations of any size and budget.

This article compares AI services and Machine Learning solutions. It’s organized by broad categories to help you choose the right service or model for your use case.

## Categories of AI services

Azure provides several AI services that can be grouped into categories based on their capabilities:

| Technology selection guide | Service descriptions |
| :----- | :----- |
| [Azure AI agents](/azure/ai-foundry/) | - [Azure AI Agent Service](/azure/ai-services/agents/overview) <br><br> - [Azure AI model inference](/azure/ai-foundry/model-inference/overview) <br><br> - [Azure AI projects](/azure/ai-foundry/how-to/create-projects?tabs=ai-studio#tabpanel_2_ai-studio) <br><br> - [Azure AI evaluation](/azure/ai-foundry/concepts/evaluation-approach-gen-ai) |
| [Retrieval Augmented Generation](../../ai-ml/guide/rag/rag-solution-design-and-evaluation-guide.md) | - [Azure AI Search](/azure/search/search-what-is-azure-search) <br><br> - [Azure AI Document Intelligence](/azure/ai-services/document-intelligence/overview) <br><br> - [Azure OpenAI Service](/azure/ai-services/openai/overview) |
| [Targeted language processing](../ai-services/targeted-language-processing.md) | - [Microsoft Azure AI Language](/azure/ai-services/language-service/overview) <br><br> - [Microsoft Azure AI Translator](/azure/ai-services/translator/overview) <br><br> - Document Intelligence <br><br> - Azure OpenAI |
| [Speech recognition and generation](../ai-services/speech-recognition-generation.md) | - [Microsoft Azure AI Speech](/azure/ai-services/speech-service/overview) <br><br> - [Immersive Reader](/training/educator-center/product-guides/immersive-reader/) <br><br> - Azure OpenAI |
| [Image and video processing guide](../ai-services/image-video-processing.md) | - [Microsoft Azure AI Vision](/azure/ai-services/computer-vision/overview) <br><br> - [Microsoft Azure AI Custom Vision](/azure/ai-services/custom-vision-service/overview) <br><br> - [Microsoft Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) <br><br> - [Azure AI Face](/azure/ai-services/computer-vision/overview-identity) <br><br> - Azure OpenAI |
| [Microsoft Azure AI Content Safety](/azure/ai-services/content-safety/) | Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and processes images and text to flag content that's potentially offensive or unwanted. It can automatically detect and scan content regardless of its source language. |
| [Custom Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) | Machine Learning procures and exposes many proprietary and open-source models that you can use directly or customize further with more training. It also supports the creation of new models of any type and is trained by using your own data. |

## Next steps

- [Learning path: Get started with AI services](/training/paths/get-started-azure-ai/)
- [AI services documentation](/azure/ai-services/)
- [What are AI services?](/azure/ai-services/what-are-ai-services)

## Related resources

- [Video ingestion and object detection on the edge and in the cloud](../../ai-ml/idea/video-ingestion-object-detection-edge-cloud.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
