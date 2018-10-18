---
title: Lift and Shift and Innovate - LOB Apps 
description: The solution demonstrates a business process for monitoring and responding to customer feedback. This architecture shows how to easily connect multiple business systems to enable a nimbler customer support.
author: adamboeglin
ms.date: 10/18/2018
---
# Lift and Shift and Innovate - LOB Apps 
This line-of-business application solution provides a mechanism for monitoring and responding to customer feedback. Easily connect multiple business systems to enable nimbler customer support.

## Architecture
<img src="media/modern-customer-support-portal-powered-by-an-agile-business-process.svg" alt='architecture diagram' />

## Data Flow
1. Customer submits feedback posted to a web endpoint.
1. The feedback is posted to Microsoft Cognitive Services Text Analytics API to extract sentiment and keywords.
1. The customer feedback creates a new case in Dynamics CRM or other CRM.
1. The solution sends a text message to the customer, thanking them for the feedback.
1. If the feedback sentiment scores lower than 0.3, the app posts this information to a customer service channel to respond.