---
author: claytonsiemens77 
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Autoscaling helps ensure that a web app remains resilient, responsive, and capable of handling dynamic workloads efficiently. To implement autoscaling, follow these recommendations:

- *Automate scale-out.* Use [Azure autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Configure autoscaling rules to scale out based on key performance metrics so that your application can handle varying loads.

- *Refine scaling triggers.* Use CPU utilization as your initial scaling trigger if you're unfamiliar with your application’s scaling requirements. Refine your scaling triggers to include other metrics like RAM, network throughput, and disk input/output (I/O). The goal is to match your web application's behavior for better performance.

- *Provide a scale-out buffer.* Set your scaling thresholds to initiate scaling before maximum capacity is reached. For example, configure scaling to occur at 85% CPU utilization rather than waiting until it reaches 100%. This proactive approach helps maintain performance and avoid potential bottlenecks.
