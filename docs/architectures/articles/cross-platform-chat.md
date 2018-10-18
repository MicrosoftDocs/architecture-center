---
title: Cross-platform Chat | Microsoft
description: Accelerate development of reliable, high-performing chat applications
author: adamboeglin
ms.date: 10/18/2018
---
# Cross-platform Chat | Microsoft
Accelerate development of reliable, high-performing chat applications.

## Architecture
<img src="media/cross-platform-chat.svg" alt='architecture diagram' />

## Data Flow
1. Web chat app connects to SignalR Service and receives token
1. User logs into app with multi-factor authentication; if passed, SignalR endpoint and bearer token returned
1. User connects to the SignalR Service with endpoint and token