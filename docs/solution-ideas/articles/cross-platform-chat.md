---
title: Cross-platform Chat
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Accelerate development of reliable, high-performing chat applications
ms.custom: acom-architecture, chat, signalr service, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/cross-platform-chat/'
ms.service: architecture-center
ms.category:
  - hybrid
  - web
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/cross-platform-chat.png
---

# Cross-platform Chat

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Accelerate development of reliable, high-performing chat applications.

## Architecture

![Architecture Diagram](../media/cross-platform-chat.png)
*Download an [SVG](../media/cross-platform-chat.svg) of this architecture.*

## Data Flow

1. Web chat app connects to SignalR Service and receives token
1. User logs into app with multi-factor authentication; if passed, SignalR endpoint and bearer token returned
1. User connects to the SignalR Service with endpoint and token
