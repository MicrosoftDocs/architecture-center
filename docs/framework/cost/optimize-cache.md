---
title: Use cached data
description: Optimize by caching data that doesn't change frequently. Caching can result in faster response times.
author: PageWriter-MSFT
ms.date: 08/10/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Caching data

Caching is a strategy where you store a copy of the data in front of the main data store. The cache store is typically located closer to the consuming client than the main store. Advantages of caching include faster response times and the ability to serve data quickly. In doing so, you can save on the overall cost. Be sure to assess the built-in caching features of Azure services used in your architecture. Azure also offers caching services, such as Azure Cache for Redis or Azure CDN.

For information about what type of data is suitable for caching, see [Caching](../../best-practices/caching.md).

## Lower costs associated with reliability and latency

Caching can be a cheaper way of storing data, providing reliability, and reducing network latency.

- Depending on the type of the data, determine if you need the complex capabilities of the backend data store, such as data consistency. If the data is fully static, you can choose to store it only in a caching store. If the data doesn't change frequently, consider placing a copy of the data in a caching store and refresh it from time to time. For example, an application stores images in blob storage. Every time it requests an image, the business logic generates a thumbnail from the main image and returns it to the caller. If the main image doesn't change too often, then return the previously generated thumbnails stored in a cache. This way you can save on resources required to process the image and lower the request response rate.
- If the backend is unavailable, the cache continues to handle requests by using the copy until the backend fails over to the backup data store.
- Caching can also be an effective way of reducing network latency. Instead of reaching the central server, the response is sent by using the cache. That way, the client can receive the response almost instantaneously. If you need higher network performance and the ability to support more client connections, choose a higher tier of the caching service. However, higher tiers will incur more costs.

## Caching can be expensive

Incorrect use of caching can result in severe business outcomes and higher costs.

- Adding a cache will lead to multiple data sources in your architecture. There are added costs to keeping them in sync. You may need to fill the cache before putting it in production. Filling the cache on the application's first access can introduce latency or seeding the cache can have impact on application's start time. If you don't refresh the cache, your customers can get stale data.

    Invalidate the cache at the right time when there's latest information in the source system. Use strategies to age out the cache when appropriate.

- To make sure the caching layer is working optimally, add instrumentation. That feature will add complexity and implementation cost.

Caching services such as Azure Cache for Redis are billed on the tier you choose. Pricing is primarily determined on the cache size and network performance and they're dependent. A smaller cache will increase latency. Before choosing a tier, estimate a baseline. An approach can be by load testing the number of users and cache size.
