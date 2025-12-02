---
title: Retry Storm Antipattern
description: Learn how to prevent retry storms in cloud applications by using smart retry strategies, circuit breakers, and telemetry insights.
ms.author: pnp
author: claytonsiemens77
ms.date: 07/16/2025
ms.topic: design-pattern
ms.subservice: design-pattern
ms.custom: sfi-image-nochange
---

# Retry Storm antipattern

When a service becomes unavailable or busy, frequent client retries can prevent the service from recovering and worsen the problem. Retrying indefinitely is ineffective because requests typically remain valid only for a limited time.

## Context and problem

In the cloud, services sometimes experience problems and become unavailable to clients or enforce throttling or rate limits. While it's a good practice for clients to retry failed connections to services, they shouldn't retry too frequently or for too long. Retries within a short period of time are unlikely to succeed because the service likely hasn't recovered. Excessive connection attempts during recovery can overwhelm the service and intensify the original problem. This situation is sometimes called a *thundering herd*.

The following example illustrates a scenario where a client connects to a server-based API. If the request doesn't succeed, the client retries immediately and keeps retrying forever. This sort of behavior is often more subtle than this example, but the same principle applies.

```csharp
public async Task<string> GetDataFromServer()
{
    while(true)
    {
        var result = await httpClient.GetAsync(string.Format("http://{0}:8080/api/...", hostName));
        if (result.IsSuccessStatusCode) break;
    }

    // ... Process result.
}
```

## Solution

Client applications should follow best practices to prevent retry storms.

- **Limit the number of retry attempts and duration.** Writing a `while(true)` loop might seem simple, but you usually don't want to retry for a long period of time. The conditions that led to the request being initiated likely changed. Most applications only need to retry for a few seconds or minutes.

- **Pause between retry attempts and increase wait time.** If a service is unavailable, retrying immediately is unlikely to succeed. Gradually increase the amount of time between attempts, for example by using an exponential backoff strategy.
- **Handle service faults gracefully.** If the service doesn't respond, determine whether to abort the attempt and return an error to the user or caller of your component. Consider these failure scenarios when you design your application.
- **Use the [Circuit Breaker pattern](../../patterns/circuit-breaker.md).** This pattern is designed specifically to help avoid retry storms.
- **Honor response headers.** If the server provides a `retry-after` response header, don't attempt to retry until the specified time period passes.
- **Use official SDKs to communicate with Azure services.** These SDKs generally have built-in retry policies and protections against causing or contributing to retry storms. If you communicate with a service that doesn't have an SDK or the SDK improperly handles retry logic, consider using a library like [Polly](https://www.pollydocs.org/) for .NET or [retry](https://www.npmjs.com/package/retry) for JavaScript to handle your retry logic correctly and avoid writing the code yourself.
- **Use an abstraction layer when available.** If you use an environment that supports it, use a service mesh or another abstraction layer to send outbound calls. Typically these tools, such as [Dapr](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview/#retries), support retry policies and automatically follow best practices, like backing off after repeated attempts. This approach eliminates the need to write retry code yourself.
- **Consider batching requests and using request pooling when available.** Many SDKs handle request batching and connection pooling on your behalf, which reduces the total number of outbound connection attempts that your application makes. But avoid retrying these connections too frequently.

Services should also protect themselves from retry storms.

- **Add a gateway layer to block connections during incidents.** This approach follows the [Bulkhead pattern](../../patterns/bulkhead.yml). Azure provides many gateway services for different types of solutions including [Azure Front Door](https://azure.microsoft.com/services/frontdoor/), [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway/), and [Azure API Management](https://azure.microsoft.com/services/api-management/).

- **Throttle requests at your gateway.** This approach prevents back-end components from becoming overwhelmed by excessive requests.
- **Send signals to clients.** When throttling, send back a `retry-after` header to help clients understand when to reattempt their connections. Clients aren't required to honor these headers, but many do.

## Considerations

- **Understand error types.** Some error types don't indicate a service failure, but instead indicate an invalid request from the client. For example, if a client application receives a `400 Bad Request` error response, retrying the same request likely won't help because the server has already informed you that your request isn't valid.

- **Define the appropriate retry duration.** Clients should consider the most appropriate length of time to reattempt connections. The time window should align with business requirements and the ability to reasonably return an error to a user or caller. Most applications only need to retry for a few seconds or minutes.

## Detect the problem

From a client's perspective, symptoms of this problem might include very long response or processing times and telemetry that indicates repeated attempts to retry the connection.

From a service's perspective, symptoms of this problem might include several requests from one client within a short period of time or several requests from a single client while recovering from outages. A service might also struggle to recover after a failure. Or a service might have ongoing cascading failures right after a fault repair.

## Example diagnosis

The following sections illustrate one approach to detect a potential retry storm from both the client and service perspectives.

### Identify patterns by using client telemetry

[Application Insights](/azure/azure-monitor/app/app-insights-overview) records telemetry from applications and makes that data available for querying and visualization. It tracks outbound connections as dependencies and allows users to access and chart this information to identify when a client makes several outbound requests to the same service.

The following screenshot shows a graph on the Metrics tab in the Application Insights portal. It shows the *Dependency failures* metric split by *Remote dependency name*. This scenario has over 21,000 failed connection attempts to a dependency within a short time.

:::image type="complex" source="_images/client-application-insights.png" alt-text="Screenshot of Application Insights that shows 21,000 dependency failures to a single dependency within a 30-minute period." lightbox="_images/client-application-insights.png":::
The diagram is a screenshot from the Application Insights Metrics section. It visualizes dependency failures over time. The interface is structured with a vertical navigation pane on the left. It lists sections like Overview, Activity log, Access control, Diagnose and solve problems, Investigate, Monitoring, Logs, Workbooks, and Users. The main content area displays a line chart titled "Sum Dependency failures for AppInsights by Remote dependency name." It shows the number of failures over a 30-minute UTC time span. The chart features a single prominent spike around 12:30, which indicates a surge in failures. The y-axis quantifies the failure count, while the x-axis tracks time. The chart shows controls for creating or refreshing charts and customizing metrics. A data entry, labeled "GET/api…", displays the value of 21.34k, which represents a specific metric tied to that API call.
:::image-end:::

### Identify patterns by using server telemetry

Server applications might be able to detect large numbers of connections from a single client. In the following example, Azure Front Door acts as a gateway for an application and is [configured to log](/azure/frontdoor/front-door-diagnostics#diagnostic-logging) all requests to a Log Analytics workspace.

To identify client IP addresses that send large numbers of requests to the application within the last day, run the following Kusto query in Log Analytics.

```kusto
AzureDiagnostics
| where ResourceType == "FRONTDOORS" and Category == "FrontdoorAccessLog"
| where TimeGenerated > ago(1d)
| summarize count() by bin(TimeGenerated, 1h), clientIp_s
| order by count_ desc
```

If you run this query during a retry storm, it shows a large number of connection attempts from a single IP address.

:::image type="complex" source="_images/server-log-analytics.png" alt-text="Screenshot of Log Analytics that shows 81,608 inbound connections to Azure Front Door from a single IP address within a one-hour period." lightbox="_images/server-log-analytics.png":::
The diagram displays the Log Analytics query editor interface, which showcases a Kusto Query Language (KQL) query and its runtime results. The interface is structured with a query input pane at the top and a results table. The query filters diagnostic logs from Azure Front Door resources, specifically targeting entries categorized as "FrontdoorAccessLog" generated within the past day. It aggregates the number of access events by client IP address in one-hour time bins and sorts the results by event count in descending order. The results table shows two entries for the same timestamp, February 23, 2021, at 11:00 PM UTC. One IP address generates 81,608 events and another generates 5. This visualization helps users identify high-traffic sources and analyze access patterns to Azure Front Door endpoints over time.
:::image-end:::

## Related resources

- [Retry pattern](../../patterns/retry.yml)
- [Circuit Breaker pattern](../../patterns/circuit-breaker.md)
- [Transient fault handling best practices](../../best-practices/transient-faults.md)
