---
author: ssumner
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Add the [Retry pattern](/azure/architecture/patterns/retry) to your application code to address temporary service disruptions. These disruptions are called [transient faults](/azure/architecture/best-practices/transient-faults). Transient faults usually resolve themselves within seconds. The Retry pattern enables you to resend failed requests. It also enables you to configure the delay between retries and the number of attempts to make before conceding failure.
