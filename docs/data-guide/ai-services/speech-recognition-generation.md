---
title: Choose an Azure speech recognition and generation technology
description: Learn about Azure Foundry Tools speech recognition and generation capabilities, including speech-to-text, text-to-speech, speech translation, and avatar creation.
author: ritesh-modi
ms.author: rimod
ms.date: 02/19/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure speech recognition and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Foundry tools that provide speech-to-text and text-to-speech capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text-to-speech voices, translate spoken audio, and conduct live AI voice conversations. Create custom voices, add specific words to your base vocabulary, or build your own models. Run Azure Speech anywhere, in the cloud or at the edge in containers.

- [Azure Speech in Foundry Tools](#azure-speech) provides speech-to-text, text-to-speech, speech translation, speaker identification, and custom voice capabilities. Use Azure Speech for real-time or batch transcription, natural-sounding voice synthesis, multilingual audio translation, and brand-specific custom voices.

- [Azure OpenAI in Microsoft Foundry models](#azure-openai-in-microsoft-foundry-models) provides access to OpenAI's powerful language models, including the latest generation of GPT models with audio capabilities and Audio API models such as Whisper for speech-to-text transcription and translation. Use Azure OpenAI in Microsoft Foundry models for audio transcription and translation scenarios that don't require a dedicated speech service.


## Azure Speech

[Azure Speech](/azure/ai-services/speech-service/overview) is part of Foundry Tools and provides speech-to-text, text-to-speech, speech translation, and other capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding text-to-speech voices, translate spoken audio, and conduct live AI voice conversations.

| Use Azure Speech to | Don't use Azure Speech to |
| :----------| :-------------|
| Transcribe or translate spoken speech to text in real time or batch processing. | Analyze text for sentiment or extract entities. For these tasks, use [Azure Language](/azure/ai-services/language-service/overview) instead. |
| Generate natural-sounding speech from text using neural voices. | Moderate content for safety. For content moderation, use [Azure AI Content Safety](/azure/ai-services/content-safety/overview) instead. |
| Identify speakers in a conversation using voice biometry. | Translate text documents while preserving formatting. For document translation, use [Azure Translator](/azure/ai-services/translator/overview) instead. |
| Create custom voices unique to your brand or product. | |

### Available Azure Speech features

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

### Which Speech feature should I use?

The following table provides a list of possible use cases for Azure Speech.

| Use case | Feature | Description |
| :----------|:-----------------|:---------------|
| [Captioning](/azure/ai-services/speech-service/captioning-concepts) | Speech-to-text | Synchronize captions with your input audio, apply profanity filters, get partial results, apply customizations, and identify spoken languages for multilingual scenarios. |
| [Audio content creation](/azure/ai-services/speech-service/text-to-speech#neural-text-to-speech-features) | Text-to-speech | Make interactions with chatbots and voice agents more natural and engaging, convert digital texts such as e-books into audiobooks, and enhance in-car navigation systems. |
| [Call center transcription](/azure/ai-services/speech-service/call-center-overview) | Speech-to-text | Transcribe calls in real time or process a batch of calls, redact personal information, and extract insights such as sentiment to help with your call center use case. |
| [Language learning](/azure/ai-services/speech-service/language-learning-overview) | Pronunciation assessment | Provide pronunciation assessment feedback to language learners, support real-time transcription for remote learning conversations, and read aloud teaching materials with neural voices. |
| [Voice Live](/azure/ai-services/speech-service/voice-live) | Text-to-speech | Create natural, humanlike conversational interfaces for applications and experiences. Provides fast, reliable interaction between a human and an agent implementation. |
| [Video avatar creation](/azure/ai-services/speech-service/text-to-speech-avatar/what-is-text-to-speech-avatar) | Text-to-speech avatar | Create lifelike and high-quality synthetic talking avatar videos for various real-time and batch applications while adhering to responsible AI practices. |

### Integration options

You can integrate Azure Speech into your applications using:

- **[Speech Studio](/azure/ai-services/speech-service/speech-studio-overview)**: UI-based tools for building and integrating features from Azure Speech using a no-code approach.
- **[Speech SDK](/azure/ai-services/speech-service/speech-sdk)**: Exposes many Azure Speech capabilities across multiple programming languages and platforms.
- **[Speech CLI](/azure/ai-services/speech-service/spx-overview)**: Command-line tool for using Azure Speech without writing code.
- **[REST APIs](/azure/ai-services/speech-service/rest-speech-to-text)**: Access Azure Speech when you can't or shouldn't use the Speech SDK.

### Deployment options

Azure Speech can be deployed in the cloud or on-premises. By using [containers](/azure/ai-services/speech-service/speech-container-howto), you can bring the service closer to your data for compliance, security, or other operational reasons. Azure Speech deployment in [sovereign clouds](/azure/ai-services/speech-service/sovereign-clouds) is available for government entities and their partners.
## Related resources

- [Microsoft Azure Language in Foundry Tools capabilities guide](targeted-language-processing.md)
- [Microsoft Azure Vision in Foundry Tools capabilities guide](image-video-processing.md)

### Azure OpenAI in Microsoft Foundry models

[Azure OpenAI in Microsoft Foundry models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#azure-openai-in-microsoft-foundry-models) provides audio models through two interfaces: [GPT-4o audio models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-4o-audio-models) for real-time, low-latency speech-in, speech-out conversational interactions, and [Audio API models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-api) via the `/audio` endpoint for speech-to-text transcription ([Whisper and GPT-4o audio models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-models)), speech translation, and text-to-speech.

| Use Azure OpenAI audio models when | Use Azure Speech when |
| :----------| :-------------|
| You need low-latency, real-time voice conversations with a generative AI model using [GPT-4o Realtime](/azure/ai-services/openai/realtime-audio-quickstart). | You need high-volume [real-time](/azure/ai-services/speech-service/get-started-speech-to-text) or [batch](/azure/ai-services/speech-service/batch-transcription) speech transcription with predictable accuracy and cost. |
| You need general-purpose transcription or translation without custom vocabulary or acoustic tuning, using [Whisper](/azure/ai-services/openai/whisper-quickstart) or [GPT-4o audio models](/azure/ai-services/openai/audio-completions-quickstart). | You need [speaker diarization](/azure/ai-services/speech-service/batch-transcription-create?tabs=portal#display-options-and-speaker-diarization), [custom speech models](/azure/ai-services/speech-service/custom-speech-overview), or custom vocabulary for domain-specific or noisy audio. |
| Your workload combines speech input with downstream reasoning, summarization, or language understanding in a single model call. | You need natural-sounding [text-to-speech](/azure/ai-services/speech-service/text-to-speech) output using neural voices, including custom brand voices built with [Custom Neural Voice](/azure/ai-services/speech-service/custom-neural-voice). |
| You need ad-hoc, flexible audio processing that benefits from prompt-based control. | You require [on-premises or container deployment](/azure/ai-services/speech-service/speech-container-howto) for compliance, data residency, or [sovereign cloud](/azure/ai-services/speech-service/sovereign-clouds) requirements. |

