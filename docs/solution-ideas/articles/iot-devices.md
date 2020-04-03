---
title: IoT devices
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Create seamless conversational interfaces with all of your internet-accessible devices—from your connected television or fridge to devices in a connected power plant. LUIS is able to integrate up to 500 intents to translate commands into smart actions.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, iot, 'https://azure.microsoft.com/solutions/architecture/iot-devices/'
ms.service: architecture-center
ms.category:
  - iot
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/iot-devices.png
---

# IoT devices

[!INCLUDE [header_file](../header.md)]

Create seamless conversational interfaces with all of your internet-accessible devices—from your connected television or fridge to devices in a connected power plant. LUIS is able to integrate up to 500 intents to translate commands into smart actions.

## Architecture

![Architecture Diagram](../media/iot-devices.png)
*Download an [SVG](../media/iot-devices.svg) of this architecture.*

## Data Flow

1. User logs into Skype and accesses the IoT bot
1. Using voice, the user asks the bot to turn on the lights via the IoT device
1. The request is relayed to a third-party service that has access to the IoT device network
1. The results of the command are returned to the user
1. Application Insights gathers runtime telemetry to help development with bot performance and usage
