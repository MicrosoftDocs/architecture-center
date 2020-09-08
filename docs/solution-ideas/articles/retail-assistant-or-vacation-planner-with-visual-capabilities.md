---
title: Retail Assistant with Visual Capabilities
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: The retail assistant or vacation planner can help your customers have interactions with your business bot and provide suggestions based on the visual information.
ms.custom: acom-architecture, ai-ml, chatbot, ecommerce, retail assistant, cognitive services, vacation planner, visual capabilities, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/retail-assistant-or-vacation-planner-with-visual-capabilities/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - web
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/retail-assistant-or-vacation-planner-with-visual-capabilities.png
---

# Retail Assistant with Visual Capabilities using Cognitive Services

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The retail assistant or vacation planner can help your customers have interactions with your business bot and provide suggestions based on the visual information.

## Architecture

![Architecture diagram](../media/retail-assistant-or-vacation-planner-with-visual-capabilities.png)
*Download an [SVG](../media/retail-assistant-or-vacation-planner-with-visual-capabilities.svg) of this architecture.*

## Data Flow

1. Users interact with your business assistant
1. Assistant understands context from LUIS
1. Assistant passes visual context to the Bing Visual Search API
1. Optionally Bot gets more information for user queries exclusively from your domain using the Bing Custom Search API
