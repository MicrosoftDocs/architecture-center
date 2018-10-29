---
title: FAQ Chatbox with data champion model 
description: The QnA Maker tool makes it super easy for the content owners to maintain their knowledge base of QnAs. Combined with Bot Service and LUIS, it's easy to setup an FAQ chatbot which responds from differnet knowledge bases depending on the intent of the query.
author: adamboeglin
ms.date: 10/29/2018
---
# FAQ Chatbox with data champion model 
The QnA Maker tool makes it easy for the content owners to maintain their knowledge base of Questions and Answers. Combined with Bot Service and Language Understanding, it becomes simple to setup a FAQ chatbot which responds from different knowledge bases depending on the intent of the query.

## Architecture
<img src="media/faq-chatbot-with-data-champion-model.svg" alt='architecture diagram' />

## Data Flow
1. Employee access FAQ Bot
1. Azure Active Director validates the employee's identity
1. Query is send to a LUIS model to get the intent of the query
1. Based in the intent, the query is redirected to the appropriate Knowledge base
1. QnA Maker gives the best match to the incoming query
1. The result is shown to the employee
1. Data Champions manage and update their QnA Knowledge base based on the feedback from user traffic