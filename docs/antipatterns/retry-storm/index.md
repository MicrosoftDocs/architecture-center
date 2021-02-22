---
title: Retry Storm antipattern
titleSuffix: Performance antipatterns for cloud apps
description: TODO
author: johndowns
ms.date: 02/23/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: anti-pattern
ms.custom:
  - article
---

# Retry Storm antipattern

When a service is unavailable or busy, having clients retry their connections too frequently can cause the service to struggle to recover, and can make the problem worse. It also does not make sense to retry forever, since requests are typically only valid for a defined period of time.

## Problem description

* In the cloud, services sometimes experience problems where they are unavailable to clients
* Retrying failed connections is a good thing
* But if the client blindly retries over and over, this can put the service under even more stress
* When the service attempts to recover, it can be overwhelmed by the repeated connection attempts and this can make it harder for it to come back online
* Sample code:
```csharp
public async Task<string> GetDataFromServer()
{
    while(true)
    {
        // TODO check this is actually valid code
        var result = await httpClient.GetAsync(string.Format("http://{0}:8080/api/...", hostName));
        if (! result.IsSuccessStatusCode) continue;

        // ...process result
    }
}
```

## How to fix the problem

* There are things that both clients and servers can do to help with this sort of scenario.
* On the client side:
  * Use official SDKs when communicating to Azure services. These SDKs have built-in retry policies and protections against retry storms.
  * Cap the retries at a maximum - don't thrash forever. While it might seem easier to simply write a `while(true)` loop, in the cloud you need to think about what makes sense for your scenario and ensure you aren't retrying for longer than necessary. For example, would it really make sense to continue trying this once it's failed for a few minutes?
  * Consider using exponential backoff or another non-regular polling strategy.
  * Gracefully handle errors. Bubble errors up to the caller methods when it's clear the service is not going to respond in a reasonable time. Design for this.
  * Consider using the circuit breaker pattern.
  * Obey the `retry-after` header when provided by a server, e.g. from 429s.
  * Consider batching requests and using request pooling where available. Many SDKs do this on your behalf. This will reduce the total number of outbound connection attempts your application makes, although you still need to be careful not to retry these connections too.
* On the server side:
  * Add a gateway layer so you can shut off connections during an incident. This is an example of the bulkhead pattern.
  * Throttle requests at your gateway or API Management layer to ensure you aren't going to accept too many requests for you to cope with.
  * If you are throttling, send back a `retry-after` header.

## Considerations

* Clients should consider the type of error returned. If you get a 4xx-class HTTP error, retrying is generally not going to help.

## How to detect the problem

From a client's perspective, symptoms of this problem could include very long response or processing times due to repeated retries to a server, along with telemetry that indicates that there were repeated attempts to retry the connection.

From a service's perspective, symptoms of this problem could include a large number of requests from one client within a short period of time, or in difficulty recovering from outages.

## Example diagnosis

(to be confirmed - possibly App Insights dashboards or similar)

## Related resources

 * [Retry pattern](https://docs.microsoft.com/azure/architecture/patterns/retry)
 * [Circuit Breaker pattern](https://docs.microsoft.com/azure/architecture/patterns/circuit-breaker)
 * [Transient fault handling best practices](https://docs.microsoft.com/azure/architecture/best-practices/transient-faults)
 * [Service-specific retry guidance](https://docs.microsoft.com/azure/architecture/best-practices/retry-service-specific)
