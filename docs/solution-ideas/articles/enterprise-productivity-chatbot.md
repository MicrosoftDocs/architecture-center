---
title: Enterprise Productivity Chatbot
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Microsoft 365 calendar, customer cases stored in Dynamics CRM and much more.
ms.custom: acom-architecture, bot service, luis, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/enterprise-productivity-chatbot/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/enterprise-productivity-chatbot.png
---

# Enterprise Productivity Chatbot

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Microsoft 365 calendar, customer cases stored in Dynamics CRM and much more.

## Architecture

![Architecture Diagram](../media/enterprise-productivity-chatbot.png)
*Download an [SVG](../media/enterprise-productivity-chatbot.svg) of this architecture.*

## Data Flow

1. Employee access Enterprise Productivity Bot
1. Azure Active Directory validates the employee's identity
1. The Bot is able to query the employee's Microsoft 365 calendar via the Azure Graph
1. Using data gathered from the calendar, the Bot access case information in Dynamics CRM
1. Information is returned to the employee who can filter down the data without leaving the Bot
1. Application insights gathers runtime telemetry to help the development with Bot performance and usage
