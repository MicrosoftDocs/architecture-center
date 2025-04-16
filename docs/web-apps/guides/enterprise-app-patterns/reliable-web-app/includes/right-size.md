---
author: ssumner
ms.author: ssumner
ms.date: 10/15/2024
ms.topic: include
---
Use performance tiers (SKUs) of Azure services that meet the needs of each environment without exceeding them. To rightsize your environments, follow these recommendations:

- *Estimate costs.* Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost of each environment.

- *Cost-optimize production environments.* Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Continuously monitor resource usage and adjust SKUs to align with actual performance needs.

- *Cost-optimize preproduction environments.* [Preproduction environments](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments) should use lower-cost resources and take advantage of discounts like [Azure Dev/Test pricing](https://azure.microsoft.com/pricing/dev-test/#overview). In these environments, you should disable services that aren't needed. At the same time, ensure that [preproduction environments are sufficiently similar to production](/azure/well-architected/cost-optimization/optimize-environment-costs#balance-similarity-with-production) environments to avoid introducing risks. Maintaining this balance ensures that testing remains effective without incurring unnecessary costs.

- *Use infrastructure as code (IaC) to define SKUs.* Implement IaC to dynamically select and deploy the correct SKUs based on the environment. This approach enhances consistency and simplifies management.