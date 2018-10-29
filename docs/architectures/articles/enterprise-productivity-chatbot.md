---
title: Enterprise Productivity Chatbot 
description: Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Office 365 calendar, customer cases stored in Dynamics CRM and much more.
author: adamboeglin
ms.date: 10/29/2018
---
# Enterprise Productivity Chatbot 
Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Office 365 calendar, customer cases stored in Dynamics CRM and much more.

## Architecture
<img src="media/enterprise-productivity-chatbot.svg" alt='architecture diagram' />

## Data Flow
1. Employee access Enterprise Productivity Bot
1. Azure Active Directory validates the employees identity
1. The Bot is able to query the employees Office 365 calendar via the Azure Graph
1. Using data gathered from the calendar, the Bot access case information in Dynamics CRM
1. Information is returned to the employee who can filter down the data without leaving the Bot
1. Application insights gathers runtime telemetry to help the development with Bot performance and usage