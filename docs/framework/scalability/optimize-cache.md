---
title: Caching data for performance optimization
description: Examine caching considerations for performance optimization. Caching is a strategy where you store a copy of the data in front of the main data store.
author: v-aangie
ms.date: 01/11/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-cache-redis
categories:
  - management-and-governance
---

# Caching data for performance optimization

Caching is a strategy where you store a copy of the data in front of the main data store. Advantages of caching include faster response times and the ability to serve data quickly, which can improve user experience. The cache store is typically located closer to the consuming client than the main store.

Caching is most effective when a client instance repeatedly reads the same data, especially if all the following conditions apply to the original data store:

- It remains relatively static.
- It's slow compared to the speed of the cache.
- It's subject to a high level of contention.
- It's far away when network latency can cause access to be slow.

Caching can dramatically improve performance, scalability, and availability. The more data that you have and the larger the number of users that need to access this data, the greater the benefits of caching become. That's because caching reduces the latency and contention that's associated with handling large volumes of concurrent requests in the original data store.

Incorporating appropriate caching can also help reduce latency by eliminating repetitive calls to microservices, APIs, and data repositories. The key to using a cache effectively lies in determining the most appropriate data to cache, and caching it at the appropriate time. Data can be added to the cache on demand the first time it is retrieved by an application. This means that the application needs to fetch the data only once from the data store, and that subsequent access can be satisfied by using the cache. To learn more, see [Determine how to cache data effectively](../../best-practices/caching.md#determine-how-to-cache-data-effectively).

For details, see [Caching](../../best-practices/caching.md).

## Azure Cache for Redis

[Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) improves the performance and scalability of an application. It processes large volumes of application requests by keeping frequently accessed data in the server memory that can be written to and read from quickly. Based on the [Redis](https://redis.io/) software, Azure Cache for Redis brings critical low-latency and high-throughput data storage to modern applications.

Azure Cache for Redis also improves application performance by supporting common application architecture patterns. Some of the most common include data cache and content cache. For the most common patterns and their descriptions, see [Common application architecture patterns](/azure/azure-cache-for-redis/cache-overview#key-scenarios).

## Azure Content Delivery Network (CDN)

A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. CDNs store cached content on edge servers in point-of-presence (POP) locations that are close to end users, to minimize latency. To learn more about CDN, see [What is a content delivery network on Azure?](/azure/cdn/cdn-overview)

Azure CDN offers the following key features:

- [**Dynamic site acceleration (DSA)**](/azure/cdn/cdn-dynamic-site-acceleration) - Provide users with a fast, reliable, and personalized web experience, independent of their browser, location, device, or network.
- [**CDN caching rules**](/azure/cdn/cdn-caching-rules) - Control Azure CDN caching behavior.
- [**HTTPS custom domain support**](/azure/cdn/cdn-custom-ssl?tabs=option-1-default-enable-https-with-a-cdn-managed-certificate) - Deliver your sensitive data securely when it is sent across the internet and protect your web applications from attacks.
- [**Azure diagnostics logs**](/azure/cdn/cdn-azure-diagnostic-logs) - Export basic usage metrics from your CDN endpoint to different kinds sources so that you can consume them in a customized way.
- [**File compression**](/azure/cdn/cdn-improve-performance) - Improve file transfer speed and increase page-load performance by reducing a file's size before it is sent from the server.
- [**Geo-filtering**](/azure/cdn/cdn-restrict-access-by-country-region) - Restrict access to your content by country/region by creating rules on specific paths on your CDN endpoint.

## Next
> [!div class="nextstepaction"]
> [Partition](./optimize-partition.md)
