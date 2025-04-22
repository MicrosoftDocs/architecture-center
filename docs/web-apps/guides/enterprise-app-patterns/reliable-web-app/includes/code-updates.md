---
author: ssumner
ms.author: ssumner
ms.date: 10/15/2024
ms.topic: include
---
To successfully move a web app to the cloud, you need to update your web app code with the Retry pattern, Circuit Breaker pattern, and Cache-Aside pattern.

[![Diagram showing the roles of design patterns in the Reliable Web App pattern.](../../../_images/reliable-web-app-design-patterns.svg)](../../../_images/reliable-web-app-design-patterns.svg#lightbox)

*Figure 3. Roles of the design patterns.*

Each design pattern provides workload design benefits that align with one or more pillars of the Well-Architected Framework. Here's an overview of the patterns you should implement:

1. *Retry pattern.* The Retry pattern handles transient failures by retrying operations that might fail intermittently. Implement this pattern on all outbound calls to other Azure services.

1. *Circuit Breaker pattern.* The Circuit Breaker pattern prevents an application from retrying operations that aren't transient. Implement this pattern in all outbound calls to other Azure services.

1. *Cache-Aside pattern.* The Cache-Aside pattern loads data on demand into a cache from a data store. Implement this pattern on requests to the database.

|Design pattern |Reliability (RE)|Security (SE) |Cost Optimization (CO) |Operational Excellence (OE)|Performance Efficiency (PE)| Supporting WAF principles
|---|---|---|---|---|---| --- |
| [Retry pattern](#implement-the-retry-pattern) |✔| | | | |[RE:07](/azure/well-architected/reliability/self-preservation) |
| [Circuit Breaker pattern](#implement-the-circuit-breaker-pattern) |✔| | | |✔| [RE:03](/azure/well-architected/reliability/failure-mode-analysis)<br>[RE:07](/azure/well-architected/reliability/handle-transient-faults) <br> [PE:07](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) <br> [PE:11](/azure/well-architected/performance-efficiency/respond-live-performance-issues) |
| [Cache-Aside pattern](#implement-the-cache-aside-pattern) |✔| | | |✔| [RE:05](/azure/well-architected/reliability/redundancy)<br>[PE:08](/azure/well-architected/performance-efficiency/optimize-data-performance)<br>[PE:12](/azure/well-architected/performance-efficiency/continuous-performance-optimize) |
