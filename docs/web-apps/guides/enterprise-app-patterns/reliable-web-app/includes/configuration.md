---
author: claytonsiemens77 
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
The following sections provide guidance about how to implement the configuration updates. Each section aligns with one or more pillars of the Well-Architected Framework.

| Configuration | Reliability (RE) | Security (SE) | Cost Optimization (CO) |Operational Excellence (OE) | Performance Efficiency (PE) | Supporting WAF principles |
|---|---|---|---|---|---| --- |
| Configure user authentication and authorization || ✔ || ✔ || [SE:05](/azure/well-architected/security/identity-access) <br> [OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization) |
| Implement managed identities || ✔ || ✔ || [SE:05](/azure/well-architected/security/identity-access) <br> [OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization) |
| Rightsize environments ||| ✔ ||| [CO:05](/azure/well-architected/cost-optimization/get-best-rates) <br> [CO:06](/azure/well-architected/cost-optimization/align-usage-to-billing-increments) |
| Implement autoscaling | ✔ || ✔ || ✔ | [RE:06](/azure/well-architected/reliability/scaling) <br> [CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) |
| Automate resource deployment ||||✔|| [OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design)|
| Implement monitoring ||| ✔ | ✔ | ✔ | [OE:07](/azure/well-architected/operational-excellence/observability) <br> [PE:04](/azure/well-architected/performance-efficiency/collect-performance-data) |
