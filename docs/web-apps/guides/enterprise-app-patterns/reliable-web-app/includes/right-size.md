---
author: ssumner
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Use performance tiers (SKUs) of Azure services that meet the needs of each environment without exceeding them. To rightsize your environments, do the following actions:

- *Estimate costs.* Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost of each environment.

- *Optimize production environments.* Production environments need SKUs that meet the SLA, features, and scale needed for production. Continuously monitor resource usage and adjust SKUs to align with actual performance needs.

- *Optimize preproduction environments.* [Preproduction environments](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments) should use lower-cost resources and take advantage of discounts like [Azure plan for dev/test pricing](https://azure.microsoft.com/pricing/offers/dev-test/#overview). In these environments, disable services that aren't needed. Also ensure that [preproduction environments are sufficiently similar to production](/azure/well-architected/cost-optimization/optimize-environment-costs#balance-similarity-with-production) environments to avoid introducing risks. Maintain this balance to ensure that testing remains effective without incurring unnecessary costs.

- *Use IaC to define SKUs.* Implement IaC to dynamically select and deploy the correct SKUs based on the environment. This approach enhances consistency and simplifies management.
