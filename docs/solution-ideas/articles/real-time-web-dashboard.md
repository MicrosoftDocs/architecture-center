---
title: Real-time Web Dashboard
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Securely monitor and control data streamed from Internet-connected devices
ms.custom: acom-architecture, analytics, data, signalr service, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/real-time-web-dashboard/'
ms.service: architecture-center
ms.category:
  - iot
  - web
  - analytics
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/real-time-web-dashboard.png
---

# Real-time Web Dashboard

[!INCLUDE [header_file](../header.md)]

Securely monitor and control data streamed from Internet-connected devices.

## Architecture

![Architecture diagram](../media/real-time-web-dashboard.png)
*Download an [SVG](../media/real-time-web-dashboard.svg) of this architecture.*

## Data Flow

1. Web app connects to SignalR Service and receives token
1. User connects to web app and gets SignalR endpoint and token
1. User connects to SignalR Service
1. Data from real-time source sent to SignalR Service and user
