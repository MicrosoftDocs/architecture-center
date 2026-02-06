---
title: Choose an Azure speech recognition and generation technology
description: Learn about Azure Foundry Tools speech recognition and generation capabilities, including speech-to-text, text-to-speech, speech translation, and avatar creation.
author: ritesh-modi
ms.author: rimod
ms.date: 02/05/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure speech recognition and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Foundry Tools that provide speech recognition and generation capabilities such as speech-to-text, text-to-speech, speech translation, and avatar creation, including:

- [Azure Speech](#azure-speech) provides speech-to-text and text-to-speech capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text-to-speech voices, translate spoken audio, and conduct live AI voice conversations. Create custom voices, add specific words to your base vocabulary, or build your own models. Run Azure Speech anywhere, in the cloud or at the edge in containers.

- [Azure AI Immersive Reader](#immersive-reader) is a tool that implements proven techniques to improve reading comprehension for emerging readers, language learners, and people with learning differences.

### Azure Speech

[Azure Speech](/azure/ai-services/speech-service/overview) is part of Foundry Tools and provides speech-to-text, text-to-speech, speech translation, and other capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text-to-speech voices, translate spoken audio, and conduct live AI voice conversations.

| Use Azure Speech to | Don't use Azure Speech to |
| :----------| :-------------|
| Transcribe or translate spoken speech to text in real time or batch processing. | Analyze text for sentiment or extract entities. For these tasks, use [Azure Language](/azure/ai-services/language-service/overview) instead. |
| Generate natural-sounding speech from text using neural voices. | Moderate content for safety. For content moderation, use [Azure AI Content Safety](/azure/ai-services/content-safety/overview) instead. |
| Identify speakers in a conversation using voice biometry. | Translate text documents while preserving formatting. For document translation, use [Azure Translator](/azure/ai-services/translator/overview) instead. |
| Create custom voices unique to your brand or product. | |

#### Available Azure Speech features

The following table provides a list of features available in Azure Speech.

| Feature | Description |
| :----------| :-------------|
| [Speech-to-text](/azure/ai-services/speech-service/speech-to-text) | Converts audio into text. Choose from [real-time transcription](/azure/ai-services/speech-service/get-started-speech-to-text) for streaming audio, [fast transcription](/azure/ai-services/speech-service/fast-transcription-create) for pre-recorded audio files, or [batch transcription](/azure/ai-services/speech-service/batch-transcription) for processing large volumes of audio asynchronously. |
| [Text-to-speech](/azure/ai-services/speech-service/text-to-speech) | Converts input text into humanlike synthesized speech using neural voices powered by deep neural networks. Use [Speech Synthesis Markup Language (SSML)](/azure/ai-services/speech-service/speech-synthesis-markup) to fine-tune pitch, pronunciation, speaking rate, volume, and more. |
| [Text-to-speech avatar](/azure/ai-services/speech-service/text-to-speech-avatar/what-is-text-to-speech-avatar) | Converts text into a digital video of a photorealistic human speaking with a natural-sounding voice. The video can be synthesized asynchronously or in real time for lifelike synthetic talking avatar videos. |
| [Speech translation](/azure/ai-services/speech-service/speech-translation) | Enables real-time, multilingual translation of speech to your applications, tools, and devices. Use for speech-to-speech and speech-to-text translation. |
| [LLM speech (preview)](/azure/ai-services/speech-service/llm-speech) | Large language model (LLM)-enhanced speech model that delivers improved quality, deep contextual understanding, multilingual support, and prompt-tuning capabilities. Supports transcription and translation tasks. |
| [Language identification](/azure/ai-services/speech-service/language-identification) | Identifies languages spoken in audio by comparing them against a list of supported languages. Use by itself, with speech-to-text recognition, or with speech translation. |
| [Pronunciation assessment](/azure/ai-services/speech-service/how-to-pronunciation-assessment) | Evaluates speech pronunciation and gives speakers feedback on the accuracy and fluency of spoken audio. Language learners can practice, get instant feedback, and improve their pronunciation. |
| [Custom speech](/azure/ai-services/speech-service/custom-speech-overview) | Create and train custom speech models with acoustic, language, and pronunciation data when the base model isn't sufficient for audio that contains ambient noise or industry-specific jargon. |
| [Custom voice](/azure/ai-services/speech-service/custom-neural-voice) | Create a custom voice that's recognizable and unique to your brand or product. Custom voices are private and can offer a competitive advantage. |

#### Which Speech feature should I use?

The following table provides a list of possible use cases for Azure Speech.

| Use case | Feature | Description |
| :----------|:-----------------|:---------------|
| [Captioning](/azure/ai-services/speech-service/captioning-concepts) | Speech-to-text | Synchronize captions with your input audio, apply profanity filters, get partial results, apply customizations, and identify spoken languages for multilingual scenarios. |
| [Audio content creation](/azure/ai-services/speech-service/text-to-speech#neural-text-to-speech-features) | Text-to-speech | Make interactions with chatbots and voice agents more natural and engaging, convert digital texts such as e-books into audiobooks, and enhance in-car navigation systems. |
| [Call center transcription](/azure/ai-services/speech-service/call-center-overview) | Speech-to-text | Transcribe calls in real time or process a batch of calls, redact personal information, and extract insights such as sentiment to help with your call center use case. |
| [Language learning](/azure/ai-services/speech-service/language-learning-overview) | Pronunciation assessment | Provide pronunciation assessment feedback to language learners, support real-time transcription for remote learning conversations, and read aloud teaching materials with neural voices. |
| [Voice Live](/azure/ai-services/speech-service/voice-live) | Text-to-speech | Create natural, humanlike conversational interfaces for applications and experiences. Provides fast, reliable interaction between a human and an agent implementation. |
| [Video avatar creation](/azure/ai-services/speech-service/text-to-speech-avatar/what-is-text-to-speech-avatar) | Text-to-speech avatar | Create lifelike and high-quality synthetic talking avatar videos for various real-time and batch applications while adhering to responsible AI practices. |

#### Integration options

You can integrate Azure Speech into your applications using:

- **[Speech Studio](/azure/ai-services/speech-service/speech-studio-overview)**: UI-based tools for building and integrating features from Azure Speech using a no-code approach.
- **[Speech SDK](/azure/ai-services/speech-service/speech-sdk)**: Exposes many Azure Speech capabilities across multiple programming languages and platforms.
- **[Speech CLI](/azure/ai-services/speech-service/spx-overview)**: Command-line tool for using Azure Speech without writing code.
- **[REST APIs](/azure/ai-services/speech-service/rest-speech-to-text)**: Access Azure Speech when you can't or shouldn't use the Speech SDK.

#### Deployment options

Azure Speech can be deployed in the cloud or on-premises. By using [containers](/azure/ai-services/speech-service/speech-container-howto), you can bring the service closer to your data for compliance, security, or other operational reasons. Azure Speech deployment in [sovereign clouds](/azure/ai-services/speech-service/sovereign-clouds) is available for government entities and their partners.

### Azure AI Immersive Reader

[Immersive Reader](/azure/ai-services/immersive-reader/overview), part of Foundry Tools, is an inclusively designed tool that implements proven techniques to improve reading comprehension for new readers, language learners, and people with learning differences such as dyslexia. With the Immersive Reader client library, you can use the same technology used in Microsoft Word and Microsoft OneNote to improve your web applications.

| Use Immersive Reader to | Don't use Immersive Reader to |
| :----------| :-------------|
| Provide an improved readability experience tailored for language learners or people with learning differences. | Generate speech from text for general text-to-speech scenarios. For traditional text-to-speech, use [Azure Speech](#azure-speech) instead. |
| Implement proven reading comprehension techniques in your web applications. | Transcribe audio to text. For speech-to-text, use [Azure Speech](#azure-speech) instead. |
| Embed accessible reading tools into educational or content-rich applications. | Translate entire documents while preserving formatting. For document translation, use [Azure Translator](/azure/ai-services/translator/overview) instead. |

#### Available Immersive Reader features

Immersive Reader is designed to make reading easier and more accessible for everyone. The following features are available to help users achieve their reading comprehension goals:

| Feature | Description |
| :----------| :-------------|
| Isolate content | Isolates content to improve readability by reducing visual distractions. |
| Picture dictionary | Displays pictures for commonly used terms to aid comprehension. |
| Parts of speech | Highlights verbs, nouns, pronouns, and more to help learners understand parts of speech and grammar. |
| Read aloud | Uses speech synthesis (text-to-speech) to read content aloud. Readers can select text to be read aloud. |
| Real-time translation | Translates text into many languages in real time to help improve comprehension for readers learning a new language. |
| Syllabification | Breaks words into syllables to improve readability or to sound out new words. |

#### How Immersive Reader works

Immersive Reader is a standalone web application. When invoked, the Immersive Reader client library displays on top of your existing web application in an `iframe`. When your web application calls the Immersive Reader service, you specify the content to show the reader. The Immersive Reader client library handles the creation and styling of the `iframe` and communication with the Immersive Reader backend service. The Immersive Reader service processes the content for parts of speech, text-to-speech, translation, and more.

#### Integration options

The Immersive Reader client library is available in multiple languages and platforms:

- [C#](/azure/ai-services/immersive-reader/quickstarts/client-libraries?pivots=programming-language-csharp)
- [JavaScript](/azure/ai-services/immersive-reader/quickstarts/client-libraries?pivots=programming-language-javascript)
- [Java (Android)](/azure/ai-services/immersive-reader/quickstarts/client-libraries?pivots=programming-language-java-android)
- [Kotlin (Android)](/azure/ai-services/immersive-reader/quickstarts/client-libraries?pivots=programming-language-kotlin)
- [Swift (iOS)](/azure/ai-services/immersive-reader/quickstarts/client-libraries?pivots=programming-language-swift)

> [!NOTE]
> Immersive Reader doesn't store any customer data.

## Related resources

- [Microsoft Azure AI Language capabilities guide](targeted-language-processing.md)
- [Microsoft Azure AI Vision capabilities guide](image-video-processing.md)
