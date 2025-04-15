---
title: Choose an Azure speech recognition and generation technology
description: Learn about Azure's AI speech recognition and generation capabilities such as speech-to-text, and speech translation, and text-to-speech capabilities.
author: ritesh-modi
ms.author: rimod
categories:
  - analytics
ms.date: 3/20/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
products:
  - ai-services
ms.custom:
  - analytics
  - guide
  - arb-aiml
---

# Choose an Azure AI speech recognition and generation technology

[Azure AI services](/azure/ai-services/what-are-ai-services) help workload designers and developers to create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Azure AI services that offer speech recognition and generation capabilities such as speech-to-text and text-to-speech conversions, audio translation, speaker recognition, as well as reading support for people with learning differences.

> [!NOTE]
> To gather insights on terms or phrases or get detailed contextual analysis of spoken or written language, see [Choose an Azure AI targeted language processing technology](targeted-language-processing.md).

## Services

The following Azure AI services can provide speech recognition and generation capabilities for your workload.

- [Azure AI Speech](#azure-ai-speech) provides natural language processing for text analysis.
    - **Use** Speech service when you need to transcribe or translate spoken speech, identify speakers in a conversation. You can also use the service as a lower cost alternative for natural sounding speech generation to the higher quality [Whisper](/azure/ai-services/openai/concepts/models) in the OpenAI models.
    - **Don't use** Speech service for chat, content summarization, moderation, or guiding users through scripts. Use other models for those things instead.

- [Immersive Reader](#immersive-reader) is a tool that implements proven techniques to improve reading comprehension for emerging readers, language learners, and people with learning differences.
    - **Use** Immersive Reader to provide an improved readability experience tailored for language learners or people with learning differences.
    - **Don't use** Immersive Reader for traditional text to speech use cases.

### Azure AI Speech

[Azure AI Speech](/azure/ai-services/speech-service/overview) provides speech to text and text to speech capabilities with a Speech resource. You can transcribe speech to text with high accuracy, produce natural-sounding text to speech voices, translate spoken audio, and use speaker recognition during conversations. Create custom voices, add specific words to your base vocabulary, or build your own models. Run Speech anywhere, in the cloud or at the edge in containers.

Speech is available for many languages and regions.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Speech service.

| Capability | Description |
|----------|-------------|
|[Batch transcription](/azure/ai-services/speech-service/batch-transcription)| Transcribe a large amount of audio data in storage. Both the Speech to text REST API and Speech CLI support batch transcription.|
|[Intent recognition](/azure/ai-services/speech-service/intent-recognition)|  An intent is something the user wants to do: book a flight, check the weather, or make a call. With intent recognition, your applications, tools, and devices can determine what the user wants to initiate or do based on options. You define user intent in the intent recognizer or conversational language understanding (CLU) model.|
|[Pronunciation assessment](/azure/ai-services/speech-service/how-to-pronunciation-assessment) |  Evaluates speech pronunciation and gives speakers feedback on the accuracy and fluency of spoken audio. |
|[Speaker recognition](/azure/ai-services/speech-service/speaker-recognition-overview)| Speaker recognition can help determine who is speaking in an audio clip. The service can verify and identify speakers by their unique voice characteristics, by using voice biometry.|
| [Speech-to-text](/azure/ai-services/speech-service/speech-to-text) |Converts audio streams to text in real time or in batch.|
|[Text-to-speech](/azure/ai-services/speech-service/text-to-speech) | Enables your applications, tools, or devices to convert text into human-like synthesized speech. |
|[Speech translation](/azure/ai-services/speech-service/speech-translation) | Provides multi-language speech-to-speech and speech-to-text translation of audio streams. |
|[Video translation](/azure/ai-services/speech-service/video-translation-overview)| Translate and generate videos in multiple languages automatically. |

#### Use cases

The following table describes some of the ways that you can use Azure AI Speech.

| Use case | Capability to use | Description |
|----------|-----------------|---------------|
| [Audio content creation](/azure/ai-services/speech-service/text-to-speech#more-about-neural-text-to-speech-features) | Speech-to-text | You can use neural voices to make interactions with chatbots and voice assistants more natural and engaging, convert digital texts such as e-books into audiobooks and enhance in-car navigation systems. |
| [Call center transcription](/azure/ai-services/speech-service/call-center-overview) | Speech-to-text | Transcribe calls in real-time or process a batch of calls, redact personally identifying information, and extract insights such as sentiment to help with your call center use case.|
| [Captioning](/azure/ai-services/speech-service/captioning-concepts)| Speech-to-text | Synchronize captions with your input audio, apply profanity filters, get partial results, apply customizations, and identify spoken languages for multilingual scenarios.|
| [Language learning](/azure/ai-services/speech-service/language-learning-overview)| Speech-to-text| Provide pronunciation assessment feedback to language learners, support real-time transcription for remote learning conversations, and read aloud teaching materials with neural voices.
| [Voice assistants](/azure/ai-services/speech-service/voice-assistants)| Text-to-speech | Create natural, human like conversational interfaces for their applications and experiences. The voice assistant feature provides fast and reliable interaction between a device and an assistant implementation.|

### Immersive Reader

[Immersive Reader](https://www.onenote.com/learningtools), part of Azure AI services, is an inclusively designed tool that implements proven techniques to improve reading comprehension for new readers, language learners, and people with learning differences such as dyslexia. With the Immersive Reader client library, you can use the same technology used in Microsoft Word and Microsoft OneNote to provide a great experience to your workload's users.

#### Capabilities

The following is a list of capabilities your workload could use to help your users' reach their reading comprehension goals.

- Isolate content to improve readability
- Display pictures for common words and terms
- Help understand parts of speech and grammar by highlighting verbs, nouns, pronouns, and more
- Read content aloud, such as user selected text in your workload's UI
- Translate content into many languages in real time, which helps to improve comprehension for readers learning a new language
- Break words into syllables to improve readability or to sound out new words

## Next steps

- [What is the Speech service?](/azure/ai-services/speech-service/overview)
- [Learning path: Develop natural language processing solutions with Azure AI services](/training/paths/develop-language-solutions-azure-ai/)

## Related resources

- [Azure AI Language capabilities guide](targeted-language-processing.md)
- [Azure AI Vision capabilities guide](image-video-processing.md)
