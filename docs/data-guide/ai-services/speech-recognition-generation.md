---
title: Choose an Azure Speech Recognition and Generation Technology
description: Learn about speech recognition and generation capabilities in Foundry Tools, including speech-to-text, text-to-speech, speech translation, and avatar creation.
author: hudua
ms.author: hudua
ms.date: 03/20/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure speech recognition and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) helps developers and organizations create AI-based, advanced, production-ready applications that align with responsible AI practices by using out-of-the-box, prebuilt, and customizable APIs and models.

This article describes speech-to-text (STT) and text-to-speech (TTS) capabilities in Tools. You can transcribe speech to text with high accuracy, produce natural-sounding TTS voices, translate spoken audio, and conduct live AI voice conversations. Create custom voices, add specific words to your base vocabulary, or build your own models. Run Azure Speech in Foundry Tools anywhere, including in the cloud or at the edge in containers.

- [Azure Speech](#azure-speech) provides STT, TTS, speech translation, speaker identification, and custom voice capabilities. Use Azure Speech for real-time or batch transcription, natural-sounding voice synthesis, multilingual audio translation, and brand-specific custom voices.

- [Azure OpenAI in Foundry Models](#azure-openai) provides audio models, including GPT-4o Realtime for low-latency voice conversations, GPT-4o audio models for completions-based audio generation, and audio API models for file-based STT transcription, speech translation, and TTS synthesis. Use Azure OpenAI for scenarios that combine audio with language understanding, reasoning, or generation in a single model call.

## Azure Speech

[Azure Speech](/azure/ai-services/speech-service/overview) is a service in Tools that provides STT, TTS, speech translation, and other capabilities. You can transcribe speech to text with high accuracy, produce natural-sounding TTS voices, translate spoken audio, and conduct live AI voice conversations.

| Use Azure Speech for these tasks | Don't use Azure Speech for these tasks |
| :----------| :-------------|
| Transcribe or translate spoken speech to text in real time or batch processing. | Analyze text for sentiment or extract entities. For these tasks, use [Azure Language in Foundry Tools](/azure/ai-services/language-service/overview). |
| Generate natural-sounding speech from text by using neural voices. | Moderate content for safety. For content moderation, use [Content Safety in Foundry Control Plane](/azure/ai-services/content-safety/overview). |
| Identify speakers in a conversation by using voice biometry. | Translate text documents while preserving formatting. For document translation, use [Azure Translator in Foundry Tools](/azure/ai-services/translator/overview). |
| Create custom voices unique to your brand or product. | |

### Available Azure Speech features

The following table provides a list of features available in Azure Speech.

| Feature | Description |
| :----------| :-------------|
| [STT](/azure/ai-services/speech-service/speech-to-text) | Converts audio into text. Choose from [real-time transcription](/azure/ai-services/speech-service/get-started-speech-to-text) for streaming audio, [fast transcription](/azure/ai-services/speech-service/fast-transcription-create) for prerecorded audio files, or [batch transcription](/azure/ai-services/speech-service/batch-transcription) for processing large volumes of audio asynchronously. |
| [TTS](/azure/ai-services/speech-service/text-to-speech) | Converts input text into humanlike synthesized speech by using neural voices powered by deep neural networks. Use [Speech Synthesis Markup Language (SSML)](/azure/ai-services/speech-service/speech-synthesis-markup) to fine-tune pitch, pronunciation, speaking rate, and volume. |
| [TTS avatar](/azure/ai-services/speech-service/text-to-speech-avatar/what-is-text-to-speech-avatar) | Converts text into a digital video of a photorealistic human that speaks with a natural-sounding voice. The video can be synthesized asynchronously or in real time for lifelike synthetic talking avatar videos. |
| [Speech translation](/azure/ai-services/speech-service/speech-translation) | Enables real-time, multilingual translation of speech to your applications, tools, and devices. Use it for speech-to-speech (S2S) and STT translation. |
| [Language model speech (preview)](/azure/ai-services/speech-service/llm-speech) | Provides improved quality, deep contextual understanding, multilingual support, and prompt-tuning capabilities. Supports transcription and translation tasks. |
| [Language identification](/azure/ai-services/speech-service/language-identification) | Identifies languages spoken in audio by comparing them against a list of supported languages. Use language identification on its own, with STT recognition, or with speech translation. |
| [Pronunciation assessment](/azure/ai-services/speech-service/how-to-pronunciation-assessment) | Evaluates speech pronunciation and gives speakers feedback on the accuracy and fluency of spoken audio. Language learners can practice, get instant feedback, and improve their pronunciation. |
| [Custom speech](/azure/ai-services/speech-service/custom-speech-overview) | Create and train custom speech models by using acoustic, language, and pronunciation data when the base model isn't sufficient for audio that contains ambient noise or industry-specific jargon. |
| [Custom voice](/azure/ai-services/speech-service/custom-neural-voice) | Create a custom voice that's recognizable and unique to your brand or product. Custom voices are private and can provide a competitive advantage. |

### Choose an Azure Speech feature

The following table provides a list of possible use cases for Azure Speech.

| Use case | Feature | Description |
| :----------|:-----------------|:---------------|
| [Captioning](/azure/ai-services/speech-service/captioning-concepts) | STT | Sync captions with your input audio, apply profanity filters, get partial results, apply customizations, and identify spoken languages for multilingual scenarios. |
| [Audio content creation](/azure/ai-services/speech-service/text-to-speech#neural-text-to-speech-features) | TTS | Make interactions with chatbots and voice agents more natural and engaging, convert digital texts like e-books into audiobooks, and enhance in-car navigation systems. |
| [Call center transcription](/azure/ai-services/speech-service/call-center-overview) | STT | Transcribe calls in real time or process a batch of calls, redact personal information, and extract insights like sentiment to improve customer experience. |
| [Language learning](/azure/ai-services/speech-service/language-learning-overview) | Pronunciation assessment | Provide pronunciation assessment feedback to language learners, support real-time transcription for remote learning conversations, and read teaching materials aloud by using neural voices. |
| [Voice Live API](/azure/ai-services/speech-service/voice-live) | TTS | Create natural, humanlike conversational interfaces for applications and experiences. The API provides fast, reliable interactions between a human and an agent implementation. |
| [Video avatar creation](/azure/ai-services/speech-service/text-to-speech-avatar/what-is-text-to-speech-avatar) | TTS avatar | Create lifelike and high-quality synthetic talking avatar videos for various real-time and batch applications while adhering to responsible AI practices. |

### Integration options

You can integrate Azure Speech into your applications by using the following tools:

- [Speech Studio](/azure/ai-services/speech-service/speech-studio-overview) provides UI-based tools for building and integrating features from Azure Speech by using a no-code approach.

- [Speech SDK](/azure/ai-services/speech-service/speech-sdk) exposes many Azure Speech capabilities across multiple programming languages and platforms.

- [Speech CLI](/azure/ai-services/speech-service/spx-overview) is a command-line tool that lets you use Azure Speech without writing code.

- [REST APIs](/azure/ai-services/speech-service/rest-speech-to-text) let you access Azure Speech when you can't or shouldn't use the Speech SDK.

### Deployment options

You can deploy Azure Speech in the cloud or on-premises. By using [containers](/azure/ai-services/speech-service/speech-container-howto), you can run the service nearer to your data for compliance, security, or other operational reasons. Azure Speech deployment in [sovereign clouds](/azure/ai-services/speech-service/sovereign-clouds) is available for government entities and their partners.

## Azure OpenAI

[Azure OpenAI](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#azure-openai-in-microsoft-foundry-models) provides audio models through the following interfaces:

- [Realtime API](/azure/foundry/openai/how-to/realtime-audio#quickstart) for low-latency voice conversations

- [Chat Completions API with audio](/azure/foundry/openai/audio-completions-quickstart) for flexible audio generation and transcription in a single model call

- [Audio API](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-api) via the `/audio` endpoint for file-based transcription, translation, and TTS

### Available Azure OpenAI audio models

The following table lists the available Azure OpenAI audio models by API and capability.

| API | Capability | Models | Description |
| :--- | :--- | :--- | :--- |
| [Realtime API](/azure/foundry/openai/how-to/realtime-audio#quickstart) | Real-time voice conversation | `gpt-realtime`, `gpt-realtime-mini`, `gpt-4o-realtime-preview`, `gpt-4o-mini-realtime-preview` | Low-latency, speech-in and speech-out conversations for live voice agents, interactive assistants, and streaming audio scenarios |
| [Chat Completions API](/azure/foundry/openai/audio-completions-quickstart) | Audio generation and transcription | `gpt-4o-audio-preview`, `gpt-4o-mini-audio-preview`, `gpt-audio`, `gpt-audio-mini` | Combines audio input and output with language reasoning, summarization, or generation in a single model call |
| [Audio API `/audio/transcriptions`](/azure/foundry/openai/whisper-quickstart) | STT | `whisper`, `gpt-4o-transcribe`, `gpt-4o-mini-transcribe`, `gpt-4o-transcribe-diarize` | - File-based transcription of prerecorded audio <br><br> - The `gpt-4o-transcribe-diarize` model includes speaker diarization |
| [Audio API `/audio/translations`](/azure/foundry/openai/whisper-quickstart) | Speech translation | `whisper` | Translates spoken audio in supported languages into English text |
| [Audio API `/audio/speech`](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-api) | TTS | `tts`, `tts-hd`, `gpt-4o-mini-tts` | - Synthesizes text into natural-sounding speech <br><br> - The `tts-hd` model is optimized for quality, and `gpt-4o-mini-tts` supports prompt-guided style and tone |

### When to use Azure OpenAI audio vs. Azure Speech

The following table lists tasks best suited for Azure OpenAI audio models versus tasks best suited Azure Speech.

| Use Azure OpenAI audio models | Use Azure Speech |
| :----------| :-------------|
| You need low-latency, real-time voice conversations with a generative AI model by using the [Realtime API](/azure/foundry/openai/how-to/realtime-audio#quickstart). | You need high-volume [real-time](/azure/ai-services/speech-service/get-started-speech-to-text) or [batch](/azure/ai-services/speech-service/batch-transcription) speech transcription with predictable accuracy and cost. |
| You need general-purpose transcription or translation without custom vocabulary or acoustic tuning by using [Whisper](/azure/foundry/openai/whisper-quickstart) or [GPT-4o audio models](/azure/foundry/openai/audio-completions-quickstart). | You need [speaker diarization](/azure/ai-services/speech-service/batch-transcription-create), [custom speech models](/azure/ai-services/speech-service/custom-speech-overview), or custom vocabulary for domain-specific or noisy audio. |
| Your workload combines speech input with downstream reasoning, summarization, or language understanding in a single model call. | You need natural-sounding [TTS](/azure/ai-services/speech-service/text-to-speech) output by using neural voices, including custom brand voices built with [custom voice](/azure/ai-services/speech-service/custom-neural-voice). |
| You need unplanned, flexible audio processing that benefits from prompt-based control or TTS with prompt-guided style by using `gpt-4o-mini-tts`. | You require [on-premises or container deployment](/azure/ai-services/speech-service/speech-container-howto) for compliance, data residency, or [sovereign cloud](/azure/ai-services/speech-service/sovereign-clouds) requirements. |

## Related resources

- [Azure Language capabilities guide](targeted-language-processing.md)
- [Azure Vision in Foundry Tools capabilities guide](image-video-processing.md)
