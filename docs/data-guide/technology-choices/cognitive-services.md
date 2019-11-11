---
title: Choosing a cognitive services technology
description: 
author: zoinerTejada
ms.date: 02/12/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: AI
---

# Choosing a Microsoft cognitive services technology

Microsoft cognitive services are cloud-based APIs that you can use in artificial intelligence (AI) applications and data flows. They provide you with pretrained models that are ready to use in your application, requiring no data and no model training on your part. The cognitive services are developed by Microsoft's AI and Research team and leverage the latest deep learning algorithms. They are consumed over HTTP REST interfaces. In addition, SDKs are available for many common application development frameworks.

The cognitive services include:

- Text analysis
- Computer vision
- Video analytics
- Speech recognition and generation
- Natural language understanding
- Intelligent search

Key benefits:

- Minimal development effort for state-of-the-art AI services.
- Easy integration into apps via HTTP REST interfaces.
- Built-in support for consuming cognitive services in Azure Data Lake Analytics.

Considerations:

- Only available over the web. Internet connectivity is generally required. An exception is the Custom Vision Service, whose trained model you can export for prediction on devices and at the IoT edge.

- Although considerable customization is supported, the available services may not suit all predictive analytics requirements.

<!-- markdownlint-disable MD026 -->

## What are your options when choosing amongst the cognitive services?

<!-- markdownlint-disable MD026 -->

In Azure, there are dozens of Cognitive Services available. The current listing of these is available in a directory categorized by the functional area they support:

- [Vision](https://azure.microsoft.com/services/cognitive-services/directory/vision/)
- [Speech](https://azure.microsoft.com/services/cognitive-services/directory/speech/)
- [Decision](https://azure.microsoft.com/services/cognitive-services/directory/decision/)
- [Search](https://azure.microsoft.com/services/cognitive-services/directory/search/)
- [Language](https://azure.microsoft.com/services/cognitive-services/directory/lang/)

## Key Selection Criteria

To narrow the choices, start by answering these questions:

- What type of data are you dealing with? Narrow your options based on the type of input data you are working with. For example, if your input is text, select from the services that have an input type of text.

- Do you have the data to train a model? If yes, consider the custom services that enable you to train their underlying models with data that you provide, for improved accuracy and performance.

## Capability matrix

The following tables summarize the key differences in capabilities.

### Uses prebuilt models

| Capability |             Input type              |                                                                                Key benefit                                                                                |
|---------------------------------------------------|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                Text Analytics API                 |                Text                 |                                                       Evaluate sentiment and topics to understand what users want.                                                        |
|                Entity Linking API                 |                Text                 |                                               Power your app's data links with named entity recognition and disambiguation.                                               |
| Language Understanding Intelligent Service (LUIS) |                Text                 |                                                          Teach your apps to understand commands from your users.                                                          |
|                 QnA Maker Service                 |                Text                 |                                             Distill FAQ formatted information into conversational, easy-to-navigate answers.                                              |
|              Linguistic Analysis API              |                Text                 |                                                            Simplify complex language concepts and parse text.                                                             |
|           Knowledge Exploration Service           |                Text                 |                                          Enable interactive search experiences over structured data via natural language inputs.                                          |
|              Web Language Model API               |                Text                 |                                                         Use predictive language models trained on web-scale data.                                                         |
|              Academic Knowledge API               |                Text                 |                                        Tap into the wealth of academic content in the Microsoft Academic Graph populated by Bing.                                         |
|               Bing Autosuggest API                |                Text                 |                                                        Give your app intelligent autosuggest options for searches.                                                        |
|               Bing Spell Check API                |                Text                 |                                                             Detect and correct spelling mistakes in your app.                                                             |
|                Translator Text API                |                Text                 |                                                                           Machine translation.                                                                            |
|                Recommendations API                |                Text                 |                                                             Predict and recommend items your customers want.                                                              |
|              Bing Entity Search API               |       Text (web search query)       |                                                           Identify and augment entity information from the web.                                                           |
|               Bing Image Search API               |       Text (web search query)       |                                                                            Search for images.                                                                             |
|               Bing News Search API                |       Text (web search query)       |                                                                             Search for news.                                                                              |
|               Bing Video Search API               |       Text (web search query)       |                                                                            Search for videos.                                                                             |
|                Bing Web Search API                |       Text (web search query)       |                                                        Get enhanced search details from billions of web documents.                                                        |
|                  Bing Speech API                  |           Text or Speech            |                                                                  Convert speech to text and back again.                                                                   |
|              Speaker Recognition API              |               Speech                |                                                       Use speech to identify and authenticate individual speakers.                                                        |
|               Translator Speech API               |               Speech                |                                                                   Perform real-time speech translation.                                                                   |
|                Computer Vision API                |    Images (or frames from video)    | Distill actionable information from images, automatically create description of photos, derive tags, recognize celebrities, extract text, and create accurate thumbnails. |
|                 Content Moderator                 |        Text, Images or Video        |                                                               Automated image, text, and video moderation.                                                                |
|                    Emotion API                    | Images (photos with human subjects) |                                                              Identify the range emotions of human subjects.                                                               |
|                     Face API                      | Images (photos with human subjects) |                                                       Detect, identify, analyze, organize, and tag faces in photos.                                                       |
|                   Video Indexer                   |                Video                |                        Video insights such as sentiment, transcript speech, translate speech, recognize faces and emotions, and extract keywords.                         |

### Trained with custom data you provide

| Capability | Input type | Key benefit |
| --- | --- | --- |
| Custom Vision Service | Images (or frames from video) | Customize your own computer vision models. |
| Custom Speech Service | Speech | Overcome speech recognition barriers like speaking style, background noise, and vocabulary. |
| Custom Decision Service | Web content (for example, RSS feed) | Use machine learning to automatically select the appropriate content for your home page |
| Bing Custom Search API | Text (web search query) | Commercial-grade search tool. |
