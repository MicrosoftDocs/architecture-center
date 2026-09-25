---
title: Health Endpoint Monitoring Pattern
description: Implement functional checks in an application that external tools can access at regular intervals through exposed endpoints.
author: claytonsiemens77 
ms.author: pnp
ms.date: 09/24/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Health Endpoint Monitoring pattern

Implement functional checks in an application that external tools and services can access at regular intervals through exposed endpoints. Use the results to verify that the application and its dependencies can serve requests. This pattern supports operational awareness by enabling monitoring tools to detect degraded or unavailable components and reduce their effect on users. It also provides health signals that load balancers and traffic routers can use to direct requests to healthy instances.

## Context and problem

Monitoring web applications and back-end services is a good practice, and business requirements often mandate it to verify that services remain available and perform correctly.

Monitoring cloud-hosted services presents different challenges from monitoring on-premises services. You have less direct control of the hosting environment, and applications can depend on services that platform vendors and third parties provide. Managed monitoring capabilities can help you observe these dependencies.

Applications are affected by network latency, the performance and availability of the underlying compute and storage systems, the network bandwidth between them, shared-resource throttling, and transient faults. A service can fail entirely or partially because of any of these factors. To ensure a required level of availability, you must verify at regular intervals that your service performs correctly. Your service-level objectives (SLO) specify the level that you need to meet.

## Solution

Implement health monitoring by sending requests to an endpoint on your application. The application performs the necessary checks and returns an indication of its status.

A health monitoring check typically combines two factors:

- The checks (if any) that the application or service performs in response to the request to the health verification endpoint
- The analysis of the results by the tool or framework that performs the health verification check

A health interface indicates the status of the application and can provide more detail about the components and services that the application uses. The monitoring tool measures latency and evaluates the response against its configured success criteria.

Choose a health interface that your workload monitoring tool supports, such as HTTPS or standard [gRPC health checking](https://grpc.io/docs/guides/health-checking/). Ensure that the interface is reachable from the network where the monitoring tool runs.

The following figure provides an overview of the pattern.

:::image type="complex" source="./_images/health-endpoint-monitoring-pattern.png" border="false" lightbox="./_images/health-endpoint-monitoring-pattern.png" alt-text="Diagram of an agent monitoring an application and its dependencies through a health endpoint.":::
    On the left, an agent runs on-premises, in a cloud-hosted environment, or as a third-party service. The agent checks a content delivery network, the application, TLS, and other components. A request flows from the agent to the application through a port 80 HTTP or port 443 HTTPS endpoint. The application contains health checks for storage, a database, Service A, Service B, and other dependencies. On the right, bidirectional arrows connect the application to its storage and database. A response flows from the application back to the agent with a 200 OK status. The response reports an overall response time of 50 milliseconds, including 5 milliseconds for storage and 20 milliseconds for the database.
:::image-end:::

The checks are used to make decisions about the status or operation of the workload. Use the appropriate depth:

- **Shallow checks** confirm that the application process can respond, but they don't contact downstream dependencies. Use shallow checks for liveness signals so that a dependency outage doesn't trigger unnecessary application restarts.
- **Deep checks** verify the application and the dependencies required to serve requests. Use them for readiness signals when a dependency failure prevents the instance from doing useful work. Exclude optional dependencies from the decision to remove an instance from service.

Expose separate endpoints when consumers need different health signals. A responsive process isn't necessarily ready to serve requests, and restarting it doesn't repair a failed shared dependency. Allow for initialization before treating startup delays as failures.

Monitoring tools evaluate status codes, response content, and response times. They can also check DNS resolution, TLS certificate expiration, and externally served content. Run checks from locations that represent your users and cover the application instances and dependencies that those users access.

Use the results to drive alerts and controlled remediation, such as removing an unhealthy instance from traffic routing. Configure timeouts and failure thresholds so that transient failures don't trigger unnecessary actions.

This pattern is one part of a broader workload health monitoring strategy. Combine probe results with metrics, logs, traces, platform health data, and SLO thresholds in a [workload health model](/azure/well-architected/design-guides/health-modeling). Alert on meaningful changes to the health of critical flows instead of individual probe failures. [Azure Monitor health models (preview)](/azure/azure-monitor/health-models/overview) provide one way to implement this approach on Azure.

For health signals to support failover, your workload must have redundant application capacity across the failure boundary, such as availability zones or regions. Size each failover target to absorb rerouted traffic.

## Problems and considerations

Consider the following points when deciding how to implement this pattern:

- **Response validation.** Determine whether a basic success result, such as an HTTP 200 (OK) status code, is sufficient to verify that the application is working correctly. A protocol-level result provides a basic measure of application availability but supplies little information about operations, trends, and possible upcoming problems.

- **Number of endpoints.** Determine the number of endpoints to expose for an application. One approach is to expose at least one endpoint for the core services that the application uses and another for lower-priority services. If you use this approach, you can assign different levels of importance to each monitoring result. Also consider exposing one endpoint for each core service to increase monitoring granularity. Each service might require a different level of uptime and response time.

- **Shared versus dedicated endpoints.** Decide whether to use the same endpoint for monitoring and for general access. You can use a dedicated path, such as `/health`, on the general access endpoint to verify that it's reachable. Prefer read-only checks that don't change production data or trigger downstream workflows. If a synthetic transaction must change state, use isolated test accounts and data, prevent real-world side effects, and clean up the test data.

- **Type of information to collect.** Determine what information the service should return in response to monitoring requests. Basic probes might evaluate only the protocol-level status, while other monitoring tools can also validate response content. Choose a tool that supports the required validation. You might need a custom monitoring utility for application-specific response formats.

  Performing excessive processing during the check can overload the application and affect other users. The processing time might also exceed the timeout of the monitoring system, causing the monitoring system to mark the application as unavailable. Most applications include instrumentation such as error handlers and performance counters. These tools can log performance and detailed error information, which might be sufficient. Consider using this data instead of returning additional information from a health verification check.

  Deep health checks that query databases, caches, or external services on every probe request consume connections, CPU, and memory that would otherwise serve user traffic. At high probe frequencies across many instances, this overhead can measurably degrade application performance. Size the check depth and probe interval so that health verification doesn't compete with production requests for constrained resources.

- **Cascading failure from deep probes.** A deep readiness probe that contacts an unreliable or slow dependency can report the instance as unhealthy even though the application itself is functioning. If the load balancer or orchestrator removes those instances, the result is a cascading failure where the monitoring mechanism reduces availability. Mitigate this risk by applying dependency-specific timeouts within the probe, using circuit-breaker logic for unreliable dependencies, or degrading the health status gracefully (for example, reporting degraded rather than unhealthy when a noncritical dependency is unavailable).

- **Caching the endpoint status.** Running the health check frequently might be expensive. For example, if the health status is reported through a dashboard, you don't want every request to the dashboard to trigger a health check. Instead, the system can periodically check health and cache the status, then expose an endpoint that returns the cached result.

  However, caching introduces a staleness window during which the probe result doesn't reflect the current state of dependencies. If a database fails between cache refreshes, the endpoint continues to report healthy and traffic keeps flowing to an unhealthy instance. Size the cache time-to-live (TTL) against the acceptable detection delay for your workload.

- **Probe frequency and cost.** Each health check request consumes compute on the probed instance. At scale, the total cost of probe traffic depends on probe frequency, check depth, and the number of monitored instances and locations. Balance these parameters against your detection requirements and monitoring budget.

- **Security for monitoring endpoints.** Configure security to help protect the endpoints from public access, which might:

  - Expose the application to malicious attacks.
  - Risk the exposure of sensitive information.
  - Attract denial-of-service (DoS) attacks.

  Typically, you configure security in the application configuration. Then you can update the settings easily without restarting the application. Consider using one or more of the following techniques:

  - **Require authentication.** Use authentication that the monitoring service supports, and protect credentials in transit with encryption. Verify that authorized probes can reach the endpoint without an interactive sign-in or a redirect. If a probe can't authenticate, restrict access through network controls and return only the information needed to determine health.

  - **Restrict network access.** Allow only the monitoring sources that need to reach the endpoint, using private connectivity or network access rules where supported. A nonstandard port or hard-to-guess path isn't an access control and doesn't replace authentication and authorization.

  - **Use a separate endpoint for basic tests.** Perform basic functional tests without compromising the operation of the application. Return only the minimum health information that the probe needs, use an encrypted transport, and require authorization before returning detailed diagnostics.

- **Monitoring agent correctness.** Verify that the monitoring agent is performing correctly. One approach is to expose an endpoint that returns a value from the application configuration or a random value that you can use to test the agent. The monitoring system should also perform checks on itself. You can use a self-test or built-in test to prevent the monitoring system from issuing false positive results.

## When to use this pattern

Use this pattern when:

- You need to verify that websites and web applications are available.
- You need to check that websites and web applications operate correctly.
- You need to monitor middle-tier or shared services to detect and isolate failures that can disrupt other applications.

> [!TIP]
> Health monitoring complements existing instrumentation in the application, such as performance counters and error handlers. Health verification checks don't replace application requirements for logging and auditing. Instrumentation can provide valuable information for detecting failures and other problems through counters and error logs, but it can't provide information if an application is unavailable.

This pattern might not be suitable when:

- The components you need to monitor don't expose a compatible health interface that a monitoring tool can reach. In these cases, use platform-level metrics, log-based alerts, or internal heartbeat mechanisms instead.

- No meaningful health signal can be produced without degrading the application. If health verification requires heavyweight operations such as running extended database queries, invoking expensive downstream services, or performing full integration tests on every probe request, the check itself can reduce availability or exceed monitoring timeouts. In these cases, rely on existing instrumentation data such as error rates, performance counters, and dependency telemetry that the application already collects during normal operation.

- You only need to confirm that a process or host is running, not that the application is behaving correctly. A platform-managed transport-level probe can be sufficient when there's no application-specific logic, dependency chain, or functional behavior to verify.

## Workload design

An architect should evaluate how the Health Endpoint Monitoring pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and ensure that it **recovers** to a fully functioning state after a failure occurs. | These endpoints support a workload's reliability alerting and dashboarding efforts. They can also be used as a signal for self-healing remediation.<br/><br/> - [RE:07 Self-preservation](/azure/well-architected/reliability/self-preservation)<br/> - [RE:10 Monitoring and alerting strategy](/azure/well-architected/reliability/monitoring) |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | Standardizing which health endpoints to expose across your workload, and the level of detail in the results, helps you triage problems.<br/><br/> - [OE:07 Monitoring system](/azure/well-architected/operational-excellence/observability) |
| [Performance Efficiency](/azure/well-architected/performance-efficiency/checklist) helps your workload **efficiently meet demands** through optimizations in scaling, data, and code. | Health endpoints improve load balancing logic by routing traffic only to nodes that are verified as healthy. With additional configuration, you can also get metrics on available node capacity.<br/><br/> - [PE:05 Scaling and partitioning](/azure/well-architected/performance-efficiency/scale-partition) |

As with any design decision, consider any trade-offs that this pattern might introduce against the goals of the other pillars.

## Example

Consider an ASP.NET Core web API hosted on Azure App Service. In this example, both Azure SQL Database and Azure Managed Redis are required to serve requests. The application exposes separate endpoints so that a dependency failure changes readiness without changing the process liveness signal.

### Endpoint behavior

- **Liveness (`/healthz/live`).** Return 200 (OK) if the process can respond. Don't query downstream dependencies. An external monitoring tool can use this endpoint to detect an unresponsive process.
- **Readiness (`/healthz/ready`).** Check initialization and both required dependencies. Return 200 (OK) when the application can serve requests, or 503 (Service Unavailable) when a required check fails. Bound each dependency check with a timeout.

The following diagram shows the separate probe paths and the dependencies that only the readiness endpoint checks.

:::image type="complex" source="./_images/health-endpoint-monitoring-app-service.svg" alt-text="Architecture diagram of separate liveness and readiness endpoints in an App Service web API." border="false" lightbox="./_images/health-endpoint-monitoring-app-service.svg":::
    An external monitoring tool on the left probes the liveness endpoint in an ASP.NET Core web API that's hosted on Azure App Service. Below it, App Service Health check probes the readiness endpoint every minute. Only the readiness endpoint connects to Azure SQL Database and Azure Managed Redis on the right. Liveness returns 200 if the process responds. Readiness returns 200 when required checks pass or 503 when a required check fails. App Service evaluates readiness results against its failure threshold and instance exclusion limits before changing traffic routing.
:::image-end:::

### App Service integration

Configure [App Service Health check](/azure/app-service/monitor-instances-health-check) to use `/healthz/ready`, and enable HTTPS Only. App Service probes each instance every minute and accepts responses from 200 through 299. After the configured number of consecutive failures, it can remove an unhealthy instance from load balancing, subject to its instance exclusion limits. Use at least two active application replicas and enough App Service plan capacity to support rerouting.

If all instances are unhealthy, App Service doesn't exclude all of them from traffic routing. A shared dependency outage can therefore require application-level degradation or recovery rather than instance removal. An instance that stays unhealthy for one hour can be replaced, subject to platform limits and the health of other apps on the same plan. A single-instance app can also have its unhealthy instance replaced, but doesn't receive the rerouting benefit.

App Service Health check integrates with built-in App Service authentication. If you use custom application authentication, follow the [Health check authentication and security guidance](/azure/app-service/monitor-instances-health-check#authentication-and-security) to allow and validate platform probes without exposing sensitive health information.

For information about endpoint registration, readiness and liveness separation, and dependency checks, see [Health checks in ASP.NET Core](/aspnet/core/host-and-deploy/health-checks) and the [ASP.NET Core health check samples](https://github.com/dotnet/AspNetCore.Docs/tree/main/aspnetcore/host-and-deploy/health-checks/samples).

### Other implementation options

- [Azure Container Apps health probes](/azure/container-apps/health-probes) provide startup, liveness, and readiness checks without requiring you to manage a Kubernetes cluster. Match each probe to the corresponding application endpoint and allow for initialization time.

- [Azure Kubernetes Service (AKS) workload probes](/azure/aks/best-practices-app-cluster-reliability#readiness-liveness-and-startup-probes) provide readiness, liveness, and startup signals for containers. Configure application-specific behavior and timing in workload manifests, even when you use AKS Automatic.

- [Application Insights Standard availability tests](/azure/azure-monitor/app/availability) send recurring requests from multiple locations. Use them to observe endpoint availability from outside the hosting platform and configure alerts for failures.

- [Azure Traffic Manager endpoint monitoring](/azure/traffic-manager/traffic-manager-monitoring#configure-endpoint-monitoring) accepts 200 (OK) by default for HTTP and HTTPS probes. You can configure expected status code ranges, such as 200-299 or 301-301. Choose ranges that represent application health, and account for the probe timeout and tolerated failure count. DNS caching adds delay before clients use a different endpoint.

## Next steps

- [Health modeling for workloads](/azure/well-architected/design-guides/health-modeling) explains how to combine health endpoint results with other signals to represent the health of workload components and critical flows.
- [Health monitoring in microservices-based applications](/dotnet/architecture/microservices/implement-resilient-applications/monitor-app-health) describes how to implement health checks in service-based applications.

## Related resources

- [Monitoring and diagnostics best practices](../best-practices/monitoring.md) provides guidance for collecting, analyzing, and acting on telemetry across a workload.
- [Circuit Breaker pattern](./circuit-breaker.md) prevents repeated calls to a failing dependency and can provide a signal that a health check uses to report degraded service.
- [Bulkhead pattern](./bulkhead.md) isolates workload components so that a failure detected by a health check doesn't consume resources needed by healthy components.
- [Gateway Routing pattern](./gateway-routing.yml) provides a single endpoint that can route requests to separate health endpoints for different services.
