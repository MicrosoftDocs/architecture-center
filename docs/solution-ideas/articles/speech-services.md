---
title: Speech Services
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: A custom acoustic model helps Speech Services understand speakers even with background noise or poor phone connections.
ms.custom: acom-architecture, speech service, speech, services, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/speech-services/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/speech-services.png
---

# Speech Services

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

With Speech Services, it's easy to transcribe every call. Index the transcription for [full-text search](https://docs.microsoft.com/azure/search/search-what-is-azure-search), or apply [Text Analytics](https://docs.microsoft.com/azure/cognitive-services/Text-Analytics) to detect sentiment, language, and key phrases for insights. If your call center recordings involve specialized terminology, such as product names or IT jargon, create a custom [language model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-customize-language-model) to teach Speech Services the vocabulary. A custom [acoustic model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-customize-acoustic-models) helps Speech Services understand speakers even with background noise or poor phone connections.

For more information, read how [batch transcription](https://docs.microsoft.com/azure/cognitive-services/speech-service/batch-transcription) works with Speech Services.

## Architecture

![Architecture Diagram](../media/speech-services.png)
*Download an [SVG](../media/speech-services.svg) of this architecture.*

## Data Flow

1. Adapt a model for your domain and deploy that model
1. Upload your recordings to a blob container
1. Create a POST request to batch transcription
1. Speech Services schedules the transcription job
1. Stereo files are split into two channels
1. Mono files undergo diarization to distinguish between speakers
1. Download the transcription using the transcription ID
