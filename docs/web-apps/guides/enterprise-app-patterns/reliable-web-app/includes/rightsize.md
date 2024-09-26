Use the performance tiers (SKUs) of Azure services that meet the needs of each environment without excess. To right-size your environments, follow these recommendations:

- *Estimate costs.* Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost of each environment.

- *Cost optimize production environments.* Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Continuously monitor resource usage and adjust SKUs to align with actual performance needs.

- *Cost optimize preproduction environments.* [Prepoduction environments](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments) should use lower-cost resources, disable unneeded services, and apply discounts such as [Azure Dev/Test pricing](https://azure.microsoft.com/pricing/dev-test/#overview). Ensure [preproduction environments are sufficiently similar to production](/azure/well-architected/cost-optimization/optimize-environment-costs#balance-similarity-with-production) to avoid introducing risks. This balance ensures that testing remains effective without incurring unnecessary costs.

- *Define SKUs using infrastructure as code (IaC).* Implement IaC to dynamically select and deploy the correct SKUs based on the environment. This approach enhances consistency and simplifies management.