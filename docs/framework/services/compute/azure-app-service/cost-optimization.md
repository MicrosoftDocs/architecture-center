---
title: Azure App Service and cost optimization
description: Focuses on the Azure App Service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to Service Cost Optimization.
author: v-stacywray
ms.date: 11/10/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-app-service
categories:
  - compute
  - management-and-governance
---

# Azure App Service and cost optimization

[Azure App Service](/azure/app-service/overview) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. This service adds the power of Microsoft Azure to your application, such as:

- Security
- Load balancing
- Autoscaling
- Automated management

To explore how to optimize costs for Azure App Service in your workload, reference key features in [Why use App Service?](/azure/app-service/overview#why-use-app-service)

The following sections include a checklist and recommended configuration options specific to Azure App Service.

## Checklist

**Have you configured Azure App Service while considering cost optimization?**
***

> [!div class="checklist"]
> - Ensure the ASE subnet is appropriately sized.
> - Consider cost savings by using the App Service Premium v3 plan over the Premium v2 plan.
> - Always use a scale-out and scale-in rule combination.
> - Understand the behavior of multiple scaling rules in a profile.
> - Consider Basic or Free tier for non-production usage.

## Configuration recommendations

Explore the following table of recommendations to optimize your App Service configuration for service cost:

|ASE Recommendation|Description|
|------------------|------------|
|Ensure the ASE subnet is appropriately sized.|The size of the subnet used to host an ASE directly affects maximum scale. An ASE with no App Service plans will use `12` to `13` addresses before you create an app. It's recommended that you deploy ASEs into a `/24` subnet. The maximum number of nodes in an ASE is `100`. During a scale-up event, the new machines are provisioned and placed into the subnet before the applications are migrated to the new machines, and the old machines are removed. The subnet must allow for at least `200` machines to handle the maximum deployment size, which requires a `/24` subnet. If you plan for insufficient capacity, scale-out operations will be limited.|
|Use App Service Premium v3 plan over the Premium v2 plan|The App Service Premium (v3) Plan has a `20%` discount versus comparable Pv2 configurations. Reserved Instance commitment (1Y, 3Y, Dev/Test) discounts are available for App Services running in the Premium v3 plan.|
|Use a scale-out and scale-in rule combination|If you use only one part of the combination, autoscale will only take action in a single direction (scale out, or in) until it reaches the maximum, or minimum instance counts defined in the profile. This scaling behavior isn't optimal, ideally you want your resource to scale up at times of high usage to ensure availability. Similarly, at times of low usage, you want your resource to scale down, so you can realize cost savings.|
|Understand the behavior of multiple scaling rules in a profile.|There are cases where you may have to set multiple rules in a profile. On scale-out, autoscale runs if `any` rule is met. On scale-in, autoscale requires `all` rules to be met.|
|Consider Basic or Free tier for non-production usage.|For non-prod App Service plans, consider scaling to Basic or Free Tier and scale up, as needed, and scale down when not in use – for example, during a Load Test exercise or based on the capabilities provided (such as custom domain, SSL, and more).|

## Next step

> [!div class="nextstepaction"]
> [Azure App Service and operational excellence](./operational-excellence.md)
