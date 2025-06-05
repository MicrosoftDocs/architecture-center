---
author: ssumner
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Use the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) to handle service disruptions that aren't transient faults. The Circuit Breaker pattern prevents an application from continuously attempting to access a nonresponsive service. It releases the application and helps prevent wasting CPU cycles so the application retains its performance integrity for end users.