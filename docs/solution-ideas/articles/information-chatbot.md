---
title: Information Chatbot
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Cognitive Search.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, ai-ml, 'https://azure.microsoft.com/solutions/architecture/information-chatbot/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/information-chatbot.png
---

# Information Chatbot

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Cognitive Search.

## Architecture

![Architecture Diagram](../media/information-chatbot.png)
*Download an [SVG](../media/information-chatbot.svg) of this architecture.*

## Data Flow

1. Employee starts the Application Bot
1. Azure Active Directory validates the employee's identity
1. The employee can ask the bot what type of queries are supported
1. Cognitive Services returns a FAQ built with the QnA Maker
1. The employee defines a valid query
1. The Bot submits the query to Azure Cognitive Search which returns information about the application data
1. Application insights gathers runtime telemetry to help development with Bot performance and usage
