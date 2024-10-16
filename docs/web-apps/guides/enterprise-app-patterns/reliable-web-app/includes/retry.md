---
author: ssumner
ms.author: ssumner
ms.date: 10/15/2024
ms.topic: include
ms.service: azure-architecture-center
---
Add the [Retry pattern](/azure/architecture/patterns/retry) to your application code to address temporary service disruptions. These disruptions are called [transient faults](/azure/architecture/best-practices/transient-faults). Transient faults usually resolve themselves within seconds. The Retry pattern allows you to resend failed requests. It also allows you to configure the request delays and the number of attempts before failure is conceded.
