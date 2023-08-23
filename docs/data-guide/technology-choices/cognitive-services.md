---
title: Choose a cognitive services technology
description: Learn about Azure cognitive services that you can use in AI applications and data flows. Choose the appropriate service for your use case.
author: kruti-m
ms.author: krmeht
categories: 
  - ai-machine-learning
  - analytics
ms.date: 06/01/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - ai-services
  - azure-applied-ai-services
  - azure-custom-vision
ms.custom:
  - cognitive services
  - AI guide
---

# Choose an Azure Cognitive Services technology

Azure Cognitive Services is a set of cloud-based APIs that you can use in AI applications and data flows. It provides pretrained models that are ready to use in your applications, requiring no data and no model training on your part. The services are developed by the Microsoft AI and Research team and expose the latest deep learning algorithms. They're consumed over HTTP REST interfaces. In addition, SDKs are available for many common application development frameworks.

**Key benefits:**

- Minimal development effort for state-of-the-art AI services. Use predefined algorithms or create custom algorithms on top of pre-built libraries.
- Easy integration into apps via HTTP REST interfaces.
- Developers and data scientists of all skill levels can easily add AI capabilities to apps.

**Considerations:**

- These services are only available over the web. Internet connectivity is generally required. An exception is the Custom Vision service, whose trained model you can export for prediction on devices and at the IoT edge.
- Although considerable customization is supported, the available services might not suit all predictive analytics requirements.

## Categories of Azure cognitive services

Dozens of cognitive services are available in Azure. Here's a list, categorized by the functional area they support:

| Service | Link to decision guide | Description |
| --- | --- | --- |
| [Language](https://azure.microsoft.com/products/cognitive-services/language-service/) | [Choose a language service](../cognitive-services/language-api.md) | Language cognitive services are services that provide Natural Language Processing (NLP) features for understanding and analyzing text. |
| [Speech](https://azure.microsoft.com/products/cognitive-services/speech-services/) | [Choose a speech service](../cognitive-services/speech-api.md) | Speech cognitive services are services that provide speech capabilities like speech-to-text, text-to-speech, speech translation, and speaker recognition. |
| [Vision](https://azure.microsoft.com/products/cognitive-services/vision-services/) | [Choose a vision service](../cognitive-services/vision-api.md) | Vision cognitive services are services that provide image and video recognition capabilities. |
| Decision services<br/><ul><li>[Anomaly Detector](https://azure.microsoft.com/products/cognitive-services/anomaly-detector/)</li><li>[Content Moderator](https://azure.microsoft.com/products/cognitive-services/content-moderator/)</li><li>[Personalizer](https://azure.microsoft.com/products/cognitive-services/personalizer/)</li></ul><br/>Applied AI Services<br/><ul><li>[Azure Cognitive Search](https://azure.microsoft.com/products/search/)</li></ul> | [Choose a decision API or applied AI service](../cognitive-services/decision-applied-ai.md) | Decision cognitive services are services that provide NLP features to produce recommendations for informed and efficient decision-making. |
| [Azure OpenAI Service](https://azure.microsoft.com/products/cognitive-services/openai-service/) | N/A | Azure OpenAI Service provides REST API access to powerful OpenAI  language models. |

## Common use cases

The following are some common use cases for Azure Cognitive Services.

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

![Diagram that shows how to select a Cognitive Services API.](../cognitive-services/images/cognitive-services-flow-chart.png)

- If your use case requires speech-to-text, text-to-speech, or speech-to-speech, use a [speech API](../cognitive-services/speech-api.md).
- If your use case requires language analysis, text assessment, or  text-to-text, use a [language API](../cognitive-services/language-api.md).
- If you need to analyze images, video, or text, use a [vision API](../cognitive-services/vision-api.md).
- If you need to make a decision, use a [decision API or Applied AI Services](../cognitive-services/decision-applied-ai.md).

## Deploying services

When you [deploy Cognitive Services](/azure/cognitive-services/cognitive-services-apis-create-account#types-of-cognitive-services-resources), you can either deploy services independently or use the Cognitive Services multi-service resource. The multi-service resource deploys decision, language, speech, vision, and applied AI services. 

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

- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)
- [Azure Cognitive Services documentation](/azure/cognitive-services)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [Blog post: Which AI Am I?](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/which-ai-am-i-azure-ai-applied-services-part-1/ba-p/3506572)

## Related resources

- [Automate document processing by using Azure Form Recognizer](../../example-scenario/ai/automate-document-processing-azure-form-recognizer.yml)
- [Build a chatbot for hotel booking](../../example-scenario/ai/commerce-chatbot.yml)
- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](../../example-scenario/ai/speech-to-text-transcription-analytics.yml)
