---
title: Choose an Azure AI Services Technology
description: Learn about Azure AI services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: ritesh-modi
ms.author: rimod
categories:
  - ai-machine-learning
  - analytics
ms.date: 03/20/2025
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
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

[Azure AI services](/azure/ai-services/what-are-ai-services) offers a suite of data science tools, models, and inferencing capabilities that support a broad array of functionality. Most require little or no specific AI expertise to use. So whether you're a student, run a small-business, are launching a startup, or lead a large enterprise-scale project, you can get started right away. It's recommended to use these services, over building custom solutions, to embed intelligent application functionality into your workload. For many use cases, these prebuilt models and SaaS solutions are sufficient to provide what your workload requires. However, many of these capabilities support further customization and fine tuning as necessary, without the need to redesign your workload.

Some projects require functionality that goes beyond what prebuilt models can provide. You could need to use your own data exclusively to build a new model, or perform functions outside the scope of any existing prebuilt models. In those cases, [Azure Machine Learning services](/azure/machine-learning) let you build custom models of any type or scale. While these solutions require more expertise, they can also support bespoke requirements for organizations of every scale and for every budget.

This article provides a comparison and decision guide between the different offerings of Azure AI and Azure Machine Learning services. It's organized by broad categories to help you choose which service or model is right for your use case.

## Categories of Azure AI services

Azure provides several AI services that can be grouped into categories based on their capabilities:

| Technology selection guide | Service descriptions |
| :--- | :--- |
| [Azure AI Agents](/azure/ai-foundry/) | - Azure AI Agent Service <br><br> - Azure AI Model Inference <br><br> - Azure AI Projects <br><br> - Azure AI Evaluation |
| [Retrieval Augmented Generation](../../ai-ml/guide/rag/rag-solution-design-and-evaluation-guide.md) | - Azure AI Search <br><br> - Azure AI Document Intelligence <br><br> - Azure OpenAI Service |
| [Targeted language processing](../ai-services/targeted-language-processing.md) | - Microsoft Azure AI Language <br><br> - Microsoft Azure AI Translator <br><br> - Azure AI Document Intelligence <br><br> - Azure OpenAI |
| [Speech recognition and generation](../ai-services/speech-recognition-generation.md) | - Microsoft Azure AI Speech <br><br> - Immersive Reader <br><br> - Azure OpenAI |
| [Image and video processing guide](../ai-services/image-video-processing.md) | - Microsoft Azure AI Vision <br><br> - Microsoft Azure AI Custom Vision <br><br> - Microsoft Azure AI Video Indexer <br><br> - Azure AI Face <br><br> - Azure OpenAI |
| [Microsoft Azure AI Content Safety](/azure/ai-services/content-safety/) | Content Safety is an AI service that detects harmful user-generated and AI-generated content in applications and processes images and text to flag content that's potentially offensive or unwanted. It can automatically detect and scan content regardless of its source language. |
| [Custom Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) | Machine Learning procures and exposes many proprietary and open-source models that you can use directly or customize further with more training. It also supports the creation of new models of any type, trained by using your own data. |

## Next steps

- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai/)
- [Azure AI Services documentation](/azure/ai-services/)
- [What are Azure AI services?](/azure/ai-services/what-are-ai-services)

## Related resources

- [Video ingestion and object detection on the edge and in the cloud](../../ai-ml/idea/video-ingestion-object-detection-edge-cloud.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
