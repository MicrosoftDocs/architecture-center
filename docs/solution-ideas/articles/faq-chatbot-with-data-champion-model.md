---
title: FAQ Chatbot with data champion model
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: The QnA Maker tool makes it super easy for the content owners to maintain their knowledge base of QnAs. Combined with Bot Service and LUIS, it's easy to setup an FAQ chatbot which responds from differnet knowledge bases depending on the intent of the query.
ms.custom: acom-architecture, chatbot, QnA, QnA Maker, FAQ, FAQ chatbot, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/faq-chatbot-with-data-champion-model/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/faq-chatbot-with-data-champion-model.png
---

# FAQ Chatbot with data champion model

[!INCLUDE [header_file](../header.md)]

The QnA Maker tool makes it easy for the content owners to maintain their knowledge base of Questions and Answers. Combined with Bot Service and Language Understanding, it becomes simple to setup a FAQ chatbot which responds from different knowledge bases depending on the intent of the query.

## Architecture

![Architecture diagram](../media/faq-chatbot-with-data-champion-model.png)
*Download an [SVG](../media/faq-chatbot-with-data-champion-model.svg) of this architecture.*

## Data Flow

1. Employee access FAQ Bot
1. Azure Active Director validates the employee's identity
1. Query is send to a LUIS model to get the intent of the query
1. Based in the intent, the query is redirected to the appropriate Knowledge base
1. QnA Maker gives the best match to the incoming query
1. The result is shown to the employee
1. Data Champions manage and update their QnA Knowledge base based on the feedback from user traffic
