---
title: Load Testing
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you handling user load? 
---

# Load Testing

## Testing at expected peak load

Load test your application at the expected peak load to ensure there are no challenges around performance or stability when operating at full capacity. Review [Changes to load test functionality in Visual Studio and cloud load testing in Azure DevOps](/azure/devops/test/load-test/overview?view=azure-devops) to get an overview of the Microsoft provided load testing tools, along with a comprehensive list of third-party tools you can leverage as well.

## Azure service limits

Different azure services have soft and hard limits associated with them. Understand the limits for the services you consume so that you are not blocked if you need to exceed them. Review [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits) to get a list of the most common Azure limits.

## Understanding application behavior under load

Load test your application to understand how it performs at various scales. Review [Autoscale best practices](/en-us/azure/architecture/best-practices/auto-scaling) to get additional insight into how to evaluate your application as the amount of traffic sent to it increases.

## Measuring typical loads

Knowing the typical and maximum loads on your system help you understand when something is operating outside of its designed limits.  Monitor traffic to your application to understand user behavior.

## Caching

Applications should implement a strategy that helps to ensure that the data in the cache is as up-to-date as possible but can also detect and handle situations that arise when the data in the cache has become stale. Review the [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) to learn how to load data on demand into a cache from a data store. This can improve performance and also helps to maintain consistency between data held in the cache and data in the underlying data store.

## Availability of SKUs

Certain Azure SKUs are only available in certain regions. Understand which SKUs are available in the regions you operate in so you can plan accordingly. Read about [global infrastructure services](https://azure.microsoft.com/global-infrastructure/services/).

