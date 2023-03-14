---
title: Different Types of Speech API Services
description: Learn about Azure Cognitive Service for Speech that provides speech-to-text and text-to-speech capabilities.
author: krmeht
ms.author: architectures
categories: azure
ms.date: 03/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
  - speech-service
ms.custom:
  - analytics
  - guide
---

# Different Types of Speech API Services

**When to use Speech API's/ When to use Language API's?**

Azure Cognitive Services provides with Speech API's and Language API's which often overlap with the functionalities they cater.

- Speech API's - Assist in spoken language transformations
- Language API's - Understand conversations and unstructured text

The key differentiation factor among the choice you make between the 2 is the use case intent. If you only wish to transform the format in either real-time or in batches its recommended to go with Speech services approach. If you wish to dig deeper insights in terms detailed analysis of either spoken or written languages (Transform+Analyze+Filter) its recommended to go with Language services approach.Language support varies by Speech service functionality.

## Resource Categories

- **A Speech resource** - choose this resource type if you only plan to use the Speech service, or if you want to manage access and billing for the resource separately from other services.
- **A Cognitive Services resource** - choose this resource type if you plan to use the Speech service in combination with other cognitive services, and you want to manage access and billing for these services together.

## Key considerations

- **Type of Data:** Text/Audio
- **Processing Mechanism:** Batch/Real-Time

The following flow chart helps you how to go about choosing the Speech service based on your processing needs
![Diagram that shows how to select Speech Services](../images/CognitiveServicesSpeechAPI.png)

In the above diagram the left side of the graph focusses on input data type : the Audio Format to output data type Audio/Text

1. Speech-To-Text - used to transcribe speech from an audio source to text format.
2. Speech-To-Speech (Speech Translation) - used to translate speech in one language to text or speech in another.

The right side of the graph focusses on input data type Text to output data type as Audio Format

1. Text-To-Speech - used to generate spoken audio from a text source.

### Common Use Cases

Some of the common use cases for them as follows: </br></br>
**Speech-To-Text API's** </br>

- Providing closed captions for recorded or live videos
- Creating a transcript of a phone call or meeting
- Automated note dictation
- Determining intended user input for further processing

**Text-To-Speech API's**</br>

- Generating spoken responses to user input.
- Creating voice menus for telephone systems.
- Reading email or text messages aloud in hands-free scenarios.
- Broadcasting announcements in public locations, such as railway stations or airports.

**Speech-To-Speech API's**</br>

- Real-time closed captioning for a speech or simultaneous two-way translation of a spoken conversation

### Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-track Engineer
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect

Co-authors:

- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-track Engineer
- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect

### Next steps

- [What is Azure Cognitive Service for Speech](/azure/cognitive-services/speech-service/overview)
- [Speech API's Bifurcations](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-speech-api-s-azure-ai-applied-services/ba-p/3509510)

### Learning Paths

- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)]
- [Learning path: Process and Translate Speech with Azure Cognitive Speech Services](/training/paths/process-translate-speech-azure-cognitive-speech-services/)
