---
title: Choose a cognitive services technology
description: Learn about Microsoft cognitive services that you can use in artificial intelligence applications and data flows.
author: kruti-m
ms.author: architectures
categories: azure
ms.date: 03/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-custom-vision
ms.custom:
  - cognitive services
  - AI guide
---

# Choose a Microsoft cognitive services technology

Microsoft cognitive services are cloud-based APIs that you can use in artificial intelligence (AI) applications and data flows. They provide you with pretrained models that are ready to use in your application, requiring no data and no model training on your part. The cognitive services are developed by Microsoft's AI and Research team and expose the latest deep learning algorithms. They are consumed over HTTP REST interfaces. In addition, SDKs are available for many common application development frameworks.

**Key benefits**:

- Minimal development effort for state-of-the-art AI services. (Using pre-defined algorithms or by creating custom algorithms on top of the pre-built libraries)
- Easy integration into apps via HTTP REST interfaces.
- Enable developers and data scientists of all skill levels to easily add AI capabilities to their apps

**Considerations**:

- Only available over the web. Internet connectivity is generally required. An exception is the Custom Vision Service, whose trained model you can export for prediction on devices and at the IoT edge.
- Although considerable customization is supported, the available services may not suit all predictive analytics requirements.

## Categories of Azure Cognitive Services

In Azure, there are dozens of Cognitive Services available. The following is a listing categorized by the functional area they support:

| Service | Decision Guide | Description |
| --- | --- | --- |
| [Language](https://azure.microsoft.com/products/cognitive-services/language-service/) | [decision guide](../cognitive-services/LanguageAPI.md) | Language cognitive services are services that provide Natural Language Processing (NLP) features for understanding and analyzing text. |
| [Speech](https://azure.microsoft.com/products/cognitive-services/speech-services/) | [decision guide](../cognitive-services/SpeechAPI.md) | Speech cognitive services are services that provide industry-leading speech capabilities such as speech-to-text, text-to-speech, speech translation, and speaker recognition. |
| [Vision](https://azure.microsoft.com/products/cognitive-services/vision-services/) | [decision guide](../cognitive-services/VisionAPI.md) | Vision cognitive services are services that provide image and video recognition capabilities. |
| Decision services<br/><ul><li>[Anomoly Detector](https://azure.microsoft.com/products/cognitive-services/anomaly-detector/)</li><li>[Content Moderator](https://azure.microsoft.com/products/cognitive-services/content-moderator/)</li><li>[Personalizer](https://azure.microsoft.com/products/cognitive-services/personalizer/)</li></ul><br/>Applied AI Services<br/><ul><li>[Azure Cognitive Search](https://azure.microsoft.com/products/search/)</li></ul> | [decision guide](../cognitive-services/DecisionAndAppliedAI.md) | Decision cognitive services are services that provides Natural Language Processing (NLP) features to provide recommendations for informed and efficient decision-making |
| [Open AI](https://azure.microsoft.com/products/cognitive-services/openai-service/) | N/A | Azure OpenAI Service provides REST API access to OpenAI's powerful language models |

## Common Use Cases

The following are some common use cases for Azure Cognitive Services.

| Use Case | Category |
| --- | --- |
| Transcribe audible speech into readable, searchable text. | Speech |
| Convert text to lifelike speech for more natural interfaces. | Speech |
| Integrate real-time speech translation into your apps. | Speech |
| Identify and verify the people speaking based on audio. | Speech |
| Identify commonly-used and domain-specific terms. | Language |
| Automatically detect sentiments and opinions from text. | Language |
| Distill information into easy-to-navigate questions and answers. | Language |
| Enable your apps to interact with users through natural language. | Language  |
| Translate more than 100 languages and dialects. | Language |
| Identify and analyze content within images and videos. | Vision |
| Customize image recognition to fit your business needs. | Vision |
| Identify potential problems early on. | Decision services / Anomoly Detector  |
| Detect potentially offensive or unwanted content. | Decision services / Content Moderator  |
| Create rich, personalized experiences for every user. | Decision services / Personalizer  |
| Apply advanced coding and language models to a variety of use cases. | OpenAI  |

## Key selection criteria

To narrow the choices, start by answering these questions:

- Are you processing something related to spoken Language or Are you processing Text/Images/Documents ?

- Do you have the data to train a model? If yes, consider the custom services that enable you to train their underlying models with data that you provide, for improved accuracy and performance.

The diagram below provides a basic flow chart on how you would go about selecting the API service based on your use case
To narrow the choices, start by answering these questions:

![Diagram that shows how to select between various APIs in Cognitive Services](../images/CognitiveServicesIntroPageFlow.png)

Once the first decision is made you go deeper into your requirements.

- In case your decision had something to do with spoken Languages was it anything to do with Speech-To-Text, Text-To-Speech, Speech-To-Speech [**Speech API's**](../cognitive-services/SpeechAPI.md)
- Or perform some kind of language analysis/Text Assessment/ Text-To-Text [**Language API's**](../cognitive-services/LanguageAPI.md)
- Are you trying to observe & assess docs/text/documents [**Vision API's**](../cognitive-services/VisionAPI.md)
- Or do you want to observe and take some decision on the display [**Decision API's &/or Applied AI**](../cognitive-services/DecisionAndAppliedAI.md)

## Deploying services

When [deploying Cognitive Services](/azure/cognitive-services/cognitive-services-apis-create-account#types-of-cognitive-services-resources), you can either deploy services independently or use the Azure Cognitive Services multi-service resource. The multi-service resource deploys Decision, Language, Speech, Vision, and Applied AI services. Use the following to guide you on deploying services.

- Deploy the individual service if you do not need other services or if you want to manage access and billing on a per-service basis.
- Deploy the multi-service Cognitive Services resource if you are using multiple services and want to manage access and billing for all the services together.

> [!NOTE]
> Resource categories under these API services are ever evolving rapidly. Please make sure you check the latest documents for additional categories

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect
- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-track Engineer
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect

Co-authors:

- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-track Engineer

### Next steps

- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)
- [Azure Cognitive Services documentation](/azure/cognitive-services)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [Which AI Am I?](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/which-ai-am-i-azure-ai-applied-services-part-1/ba-p/3506572)

### Related resources

- [Automate document processing through Form Recognizer](../../example-scenario/ai/automate-document-processing-azure-form-recognizer.yml)
- [Build Chatbot for Hotel booking](../../example-scenario/ai/commerce-chatbot.yml)
- [End-to-end computer vision at the edge for manufacturing](../../reference-architectures/ai/end-to-end-smart-factory.yml)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](../../example-scenario/ai/speech-to-text-transcription-analytics.yml)
