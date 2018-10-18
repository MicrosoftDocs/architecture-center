---
title: Commerce Chatbot 
description: Together, the Azure Bot Service and Language Understanding service enable developers to create conversational interfaces for various scenarios like banking, travel, and entertainment. For example, a hotels concierge can use a bot to enhance traditional e-mail and phone call interactions by validating a customer via Azure Active Directory and using Cognitive Services to better contextually process customer requests using text and voice. The Speech recognition service can be added to support voice commands.
author: adamboeglin
ms.date: 10/18/2018
---
# Commerce Chatbot 
Together, the Azure Bot Service and Language Understanding service enable developers to create conversational interfaces for various scenarios like banking, travel, and entertainment. For example, a hotels concierge can use a bot to enhance traditional e-mail and phone call interactions by validating a customer via Azure Active Directory and using Cognitive Services to better contextually process customer requests using text and voice. The Speech recognition service can be added to support voice commands.

## Architecture
<img src="media/commerce-chatbot.svg" alt='architecture diagram' />

## Data Flow
1. Customer uses your mobile app
1. Using Azure AD B2C, the user authenticates
1. Using the custom Application Bot, user requests information
1. Cognitive Services helps process the natural language request
1. Response is reviewed by customer who can refine the question using natural conversation
1. Once the user is happy with the results, the Application Bot updates the customers reservation
1. Application insights gathers runtime telemetry to help development with Bot performance and usage