---
title: Error handling for resilient applications in Azure
description: Best practices for handling errors in a resilient way
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you managing errors & failures? 
---

# Error handling for resilient applications in Azure

Ensuring your application can recover from errors is critical when working in a distributed system

## Transient failure handling

Track the number of transient exceptions and retries over time to uncover issues or failures in your application's retry logic. A trend of increasing exceptions over time may indicate that the service is having an issue and may fail. For more information, see [Retry service specific guidance](/azure/architecture/best-practices/retry-service-specific).

Use the [Retry pattern](https://docs.microsoft.com/azure/architecture/patterns/retry), paying particular attention to [issues and considerations](https://docs.microsoft.com/azure/architecture/patterns/retry#issues-and-considerations). Avoid overwhelming dependent services by implementing the [Circuit Breaker pattern](https://docs.microsoft.com/azure/architecture/patterns/circuit-breaker). Review and incorporate additional best practices guidance for [Transient fault handling](https://docs.microsoft.com/azure/architecture/best-practices/transient-faults). While calling systems that have [Throttling pattern](https://docs.microsoft.com/azure/architecture/patterns/throttling) implemented, ensure that your retries are not counter productive.

## Request timeouts

When making a service call or a database call ensure that appropriate request timeouts are set.  Database Connection timeouts are typically set to 30s. Use guidance on troubleshoot, diagnose, and prevent SQL connection errors and [transient errors for SQL Database](https://docs.microsoft.com/azure/sql-database/sql-database-connectivity-issues).

Leverage design patterns that encapsulate robust timeout strategies like [Choreography pattern](https://docs.microsoft.com/azure/architecture/patterns/choreography) or [Compensating Transaction pattern](https://docs.microsoft.com/azure/architecture/patterns/compensating-transaction).

## Cascading Failures

The [Circuit Breaker pattern](https://docs.microsoft.com/azure/architecture/patterns/circuit-breaker#related-patterns-and-guidance) provides stability while the system recovers from a failure and minimizes the impact on performance. It can help to maintain the response time of the system by quickly rejecting a request for an operation that's likely to fail, rather than waiting for the operation to time out, or never return.

[Retry pattern](https://docs.microsoft.com/azure/architecture/patterns/retry). Describes how an application can handle anticipated temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that has previously failed.

[Health Endpoint Monitoring pattern](https://docs.microsoft.com/azure/architecture/patterns/health-endpoint-monitoring). A circuit breaker might be able to test the health of a service by sending a request to an endpoint exposed by the service. The service should return information indicating its status.

## Application Health Probes

Configure and test health probes for your load balancers and traffic managers. Ensure that your health endpoint checks the critical parts of the system and responds appropriately.

- For [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview/), the health probe determines whether to fail over to another region. Your health endpoint should check any critical dependencies that are deployed within the same region.
- For [Azure Load Balancer](/azure/load-balancer/load-balancer-overview/), the health probe determines whether to remove a VM from rotation. The health endpoint should report the health of the VM. Don't include other tiers or external services. Otherwise, a failure that occurs outside the VM will cause the load balancer to remove the VM from rotation.

For guidance on implementing health monitoring in your application, see [Health Endpoint Monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring).

## Command and Query Responsibility Segregation (CQRS)

Achieve levels of scale and performance needed for your solution by segregating read and write interfaces by implementing the [CQRS pattern](https://docs.microsoft.com/azure/architecture/patterns/cqrs).  

