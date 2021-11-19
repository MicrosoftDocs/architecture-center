---
title: Error handling for resilient apps
description: Review best practices for handling errors in resilient Azure applications. Understand transient fault handling, request timeouts, cascading failures, and more.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you managing errors & failures?
  - article
---

# Error handling for resilient applications in Azure

Ensuring your application can recover from errors is critical when working in a distributed system. You test your applications to prevent errors and failure, but you need to be prepared for when applications encounter issues or fail. Understanding how to handle errors and prevent potential failure becomes important, as testing doesn't always catch everything.

Many things in a distributed system are outside your span of control and your means to test. This can be the underlying cloud infrastructure, third party runtime dependencies, etc. You can be sure something will fail eventually, so you need to prepare for that.

## Key points

- Uncover issues or failures in your application's retry logic.
- Configure request timeouts to manage inter-component calls.
- Implement retry logic to handle transient application failures and transient failures with internal or external dependencies.
- Configure and test health probes for your load balancers and traffic managers.
- Segregate read operations from update operations across application data stores.

## Transient fault handling

Track the number of transient exceptions and retries over time to uncover issues or failures in your application's retry logic. A trend of increasing exceptions over time may indicate that the service is having an issue and may fail. To learn more, see [Retry service specific guidance](../../best-practices/retry-service-specific.md).

Use the [Retry pattern](../../patterns/retry.md), paying particular attention to [issues and considerations](../../patterns/retry.md#issues-and-considerations). Avoid overwhelming dependent services by implementing the [Circuit Breaker pattern](../../patterns/circuit-breaker.md). Review and incorporate additional best practices guidance for [Transient fault handling](../../patterns/circuit-breaker.md). While calling systems that have [Throttling pattern](../../patterns/circuit-breaker.md) implemented, ensure that your retries are not counter productive.

:::image type="icon" source="../../_images/github.png" border="false"::: A reference implementation is available [here](https://github.com/mspnp/microservices-reference-implementation/tree/master/src/shipping/workflow). It uses [Polly](https://github.com/App-vNext/Polly/wiki/Circuit-Breaker) and [IHttpClientBuilder](/dotnet/api/microsoft.extensions.dependencyinjection.ihttpclientbuilder?view=dotnet-plat-ext-5.0) to implement the Circuit Breaker pattern.

## Request timeouts

When making a service call or a database call, ensure that appropriate request timeouts are set. Database Connection timeouts are typically set to 30 seconds. For guidance on how to troubleshoot, diagnose, and prevent SQL connection errors, see [transient errors for SQL Database](/azure/sql-database/sql-database-connectivity-issues).

Leverage design patterns that encapsulate robust timeout strategies like [Choreography pattern](../../patterns/choreography.md) or [Compensating Transaction pattern](../../patterns/compensating-transaction.md).

:::image type="icon" source="../../_images/github.png" border="false"::: A reference implementation is available on [GitHub](https://github.com/mspnp/microservices-reference-implementation).

## Cascading Failures

The [Circuit Breaker pattern](../../patterns/circuit-breaker.md) provides stability while the system recovers from a failure and minimizes the impact on performance. It can help to maintain the response time of the system by quickly rejecting a request for an operation that's likely to fail, rather than waiting for the operation to time out, or never return.

A circuit breaker might be able to test the health of a service by sending a request to an endpoint exposed by the service. The service should return information indicating its status.

[Retry pattern](../../patterns/retry.md). Describes how an application can handle anticipated temporary failures when it tries to connect to a service or network resource by transparently retrying an operation that has previously failed.

:::image type="icon" source="../../_images/github.png" border="false"::: Samples related to this pattern are [here](https://github.com/mspnp/samples/tree/master/Reliability/RetryPatternSample).

## Application Health Probes

Configure and test health probes for your load balancers and traffic managers. Ensure that your health endpoint checks the critical parts of the system and responds appropriately.

- For [Azure Front Door](/azure/frontdoor/front-door-overview) and [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview), the health probe determines whether to fail over to another region. Your health endpoint should check any critical dependencies that are deployed within the same region.
- For [Azure Load Balancer](/azure/load-balancer/load-balancer-overview), the health probe determines whether to remove a VM from rotation. The health endpoint should report the health of the VM. Don't include other tiers or external services. Otherwise, a failure that occurs outside the VM will cause the load balancer to remove the VM from rotation.

:::image type="icon" source="../../_images/github.png" border="false"::: Samples related to heath probes are [here](https://github.com/mspnp/samples/tree/master/Reliability/HealthProbesSample).

- ARM template that deploys an Azure Load Balancer and health probes that detect the  health of the sample service endpoint.

- An ASP.NET Core Web API that shows configuration of health checks at startup.

## Command and Query Responsibility Segregation (CQRS)

Achieve levels of scale and performance needed for your solution by segregating read and write interfaces by implementing the [CQRS pattern](../../patterns/cqrs.md).

## Next step

> [!div class="nextstepaction"]
> [Chaos engineering](./chaos-engineering.md)

## Related links

- For information on transient faults, see [Troubleshoot transient connection errors](/azure/azure-sql/database/troubleshoot-common-connectivity-issues).
- For guidance on implementing health monitoring in your application, see [Health Endpoint Monitoring pattern](../../patterns/health-endpoint-monitoring.md).

Go back to the main article: [Testing](test-checklist.md)
