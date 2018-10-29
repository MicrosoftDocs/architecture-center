---
title: Information Chatbot | Microsoft
description: This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Search.
author: adamboeglin
ms.date: 10/29/2018
---
# Information Chatbot | Microsoft
This Informational Bot can answer questions defined in a knowledge set or FAQ using Cognitive Services QnA Maker and answer more open-ended questions using Azure Search.

## Architecture
<img src="media/information-chatbot.svg" alt='architecture diagram' />

## Data Flow
1. Employee starts the Application Bot
1. Azure Active Directory validates the employees identity
1. The employee can ask the bot what type of queries are supported
1. Cognitive Services returns a FAQ built with the QnA Maker
1. The employee defines a valid query
1. The Bot submits the query to Azure Search which returns information about the application data
1. Application insights gathers runtime telemetry to help development with Bot performance and usage