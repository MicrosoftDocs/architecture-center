---
author: ssumner
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
To successfully move a web app to the cloud, you need to update your web app code by using the Retry, Circuit Breaker, and Cache-Aside patterns.

:::image type="complex" border="false" source="../../../_images/reliable-web-app-design-patterns.svg" alt-text="Diagram that shows the roles of design patterns in the Reliable Web App pattern." lightbox="../../../_images/reliable-web-app-design-patterns.svg":::
   The diagram illustrates a web application making outbound calls to Azure services and a database. The Retry pattern handles transient failures by retrying failed operations on outbound service calls. The Circuit Breaker pattern prevents repeated attempts to call services that experience persistent failures. The Cache Aside pattern is represented by the web app loading data into a cache from the database on demand, which improves performance and reduces load on the data store.
:::image-end:::

The following design patterns provide workload benefits that map to one or more of the Well-Architected Framework pillars:

1. *The Retry pattern* handles transient failures by retrying operations that might fail intermittently. Implement this pattern on all outbound calls to other Azure services.

1. *The Circuit Breaker pattern* prevents an application from retrying operations that aren't transient. Implement this pattern in all outbound calls to other Azure services.

1. *The Cache-Aside pattern* loads data on demand into a cache from a data store. Implement this pattern on requests to the database.

| Design pattern |Reliability (RE) | Security (SE) | Cost Optimization (CO) | Operational Excellence (OE) | Performance Efficiency (PE) | Supporting WAF principles
|---|---|---|---|---|---| --- |
| [Retry pattern](#implement-the-retry-pattern) | ✔ | | | | |[RE:07](/azure/well-architected/reliability/self-preservation) |
| [Circuit Breaker pattern](#implement-the-circuit-breaker-pattern) | ✔ | | | | ✔ | [RE:03](/azure/well-architected/reliability/failure-mode-analysis)<br>[RE:07](/azure/well-architected/reliability/self-preservation) <br> [PE:07](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) <br> [PE:11](/azure/well-architected/performance-efficiency/respond-live-performance-issues) |
| [Cache-Aside pattern](#implement-the-cache-aside-pattern) |✔ | | | | ✔ | [RE:05](/azure/well-architected/reliability/redundancy)<br>[PE:08](/azure/well-architected/performance-efficiency/optimize-data-performance)<br>[PE:12](/azure/well-architected/performance-efficiency/continuous-performance-optimize) |
