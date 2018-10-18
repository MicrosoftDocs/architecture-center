---
title: Real-time Web Dashboard | Microsoft
description: Securely monitor and control data streamed from Internet-connected devices
author: adamboeglin
ms.date: 10/18/2018
---
# Real-time Web Dashboard | Microsoft
Securely monitor and control data streamed from Internet-connected devices.

## Architecture
<img src="media/real-time-web-dashboard.svg" alt='architecture diagram' />

## Data Flow
1. Web app connects to SignalR Service and receives token
1. User connects to web app and gets SignalR endpoint and token
1. User connects to SignalR Service
1. Data from real-time source sent to SignalR Service and user