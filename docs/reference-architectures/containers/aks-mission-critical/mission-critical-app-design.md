---
title: Application design considerations for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - App Design.
author: msimecek
ms.author: msimecek
ms.date: 06/05/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
- azure-kubernetes-service
- azure-front-door
ms.category:
- containers
- networking
- database
- monitoring
categories: featured
---

# Application design considerations for mission-critical workloads

The [baseline mission-critical reference architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro) uses a simple online catalog application to describe a highly reliable workload. Users can browse through a catalog of items, review item details, and post ratings and comments for items. This article focuses on the reliability and resiliency aspects of a mission-critical application, such as asynchronous request processing and how to achieve high throughput within a solution.

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is supported by a production-grade [reference implementation](https://github.com/Azure/Mission-Critical-Online) that showcases mission-critical application development on Azure. You can use this implementation as a basis for further solution development in your first step toward production.

## Application composition

For high-scale mission-critical applications, it's essential to optimize the architecture for end-to-end scalability and resilience. You can optimize the architecture by separating components into functional units that can operate independently. Apply this separation at all levels on the application stack. Separation at all levels enables each part of the system to scale independently and to meet changes in demand. The implementation demonstrates this approach.

The application uses stateless API endpoints that decouple long-running write requests asynchronously through a messaging broker. The workload is composed in a way that lets you always delete and recreate whole AKS clusters and other dependencies in the stamp. The main components of the application are:

- **User interface (UI)**: A single-page web application that users can access. The UI is hosted in Azure Storage account's static website hosting.

- **API (`CatalogService`)**: REST API that's called by the UI application but still available for other potential client applications.

- **Worker (`BackgroundProcessor`)**: A background worker that processes write requests to the database by listening to new events on the message bus. This component doesn't expose any APIs.

- **Health service API* (`HealthService`)**: Reports the health of the application by checking if critical components are working, such as the database or messaging bus.

:::image type="content" source="./images/application-design-flow.png" alt-text="Diagram that shows the Application flow." lightbox="./images/application-design-flow.png":::

The API, worker, and health check applications are referred to as *workload* and hosted as containers in a dedicated AKS namespace called `workload`. There's no direct communication between the pods. The pods are stateless and can scale independently.

:::image type="content" source="./images/application-design-workload-composition.png" alt-text="Diagram that shows the Detailed composition of the workload." lightbox="./images/application-design-workload-composition.png":::

There are other supporting components that run in the cluster:

1. **Nginx Ingress Controller**: Routes incoming requests to the workload and load balance between pods. It's exposed through Azure Load Balancer with a public IP address but can only be accessed through Azure Front Door.

1. **Cert manager**: Jetstack's `cert-manager` autoprovisions SSL/TLS certificates by using Let's Encrypt for the ingress rules.

1. **CSI secrets driver**: The Azure Key Vault provider for Secrets Store CSI Driver reads secrets securely, such as connection strings from Key Vault.

1. **Monitoring agent**: The default Azure Log Analytics agent configuration is adjusted to reduce the amount of monitoring data sent to the Log Analytics workspace.

## Database connection

Due to the ephemeral nature of deployment stamps, avoid persisting state within the stamp as much as possible. State should be persisted in an externalized data store. Data stores need to be resilient to support the reliability service-level objective (SLO). We recommend that you use managed platform as a service (PaaS) services in combination with native SDK libraries that automatically handle timeouts, disconnects, and other failure states.

In the reference implementation, Azure Cosmos DB serves as the main data store for the application. [Azure Cosmos DB](/azure/cosmos-db/) provides multi-region writes. Each stamp can write to the Azure Cosmos DB replica in the same region with Azure Cosmos DB internally handling data replication and synchronization between regions. Azure Cosmos DB for NoSQL supports all capabilities of the database engine.

For more information, see [Data platform for mission-critical workloads](./mission-critical-data-platform.md#database).

For mission-critical applications that prioritize availability over performance, we recommend single-region write and multi-region read with *Strong consistency* level.

> [!NOTE]
> Use Azure Cosmos DB for NoSQL for new applications. For legacy applications that use another NoSQL protocol, evaluate the migration path to Azure Cosmos DB.

In this architecture, state needs to be stored temporarily in the stamp for Event Hubs checkpointing. Storage is used for that purpose.

All workload components use the Azure Cosmos DB .NET Core SDK to communicate with the database. The SDK includes robust logic to maintain database connections and handle failures. Here are some key configuration settings:

- **Direct connectivity mode**: The default setting for .NET SDK v3 because it offers better performance. There are fewer network hops compared to Gateway mode, which uses HTTP.

- **Return content response on write**: This approach is disabled to prevent the Azure Cosmos DB client from returning the document from Create, Upsert, and Patch and Replace operations to reduce network traffic. This isn't needed for further processing on the client.

- **Custom serialization**: This process sets the JSON property naming policy to `JsonNamingPolicy.CamelCase` to translate .NET-style properties to standard JSON-style and vice-versa. The default ignore condition ignores properties with null values during serialization, such as `JsonIgnoreCondition.WhenWritingNull`.

- **ApplicationRegion**: This property is set to the region of the stamp, which enables the SDK to find the closest connection endpoint. The endpoint should preferably be in the same region.

```csharp
//
// /src/app/AlwaysOn.Shared/Services/CosmosDbService.cs
//
CosmosClientBuilder clientBuilder = new CosmosClientBuilder(sysConfig.CosmosEndpointUri, sysConfig.CosmosApiKey)
    .WithConnectionModeDirect()
    .WithContentResponseOnWrite(false)
    .WithRequestTimeout(TimeSpan.FromSeconds(sysConfig.ComsosRequestTimeoutSeconds))
    .WithThrottlingRetryOptions(TimeSpan.FromSeconds(sysConfig.ComsosRetryWaitSeconds), sysConfig.ComsosMaxRetryCount)
    .WithCustomSerializer(new CosmosNetSerializer(Globals.JsonSerializerOptions));

if (sysConfig.AzureRegion != "unknown")
{
    clientBuilder = clientBuilder.WithApplicationRegion(sysConfig.AzureRegion);
}

_dbClient = clientBuilder.Build();
```

## Asynchronous messaging

Loose coupling enables services to be designed so that they don’t have dependencies on other services. The *loose* aspect enables a service to operate independently. The *coupling* aspect enables inter-service communication through well-defined interfaces. In the context of a mission-critical application, loose coupling facilitates high-availability by preventing downstream failures from cascading to frontends or different deployment stamps.

The key characteristics of asynchronous messaging are:

- Services aren't constrained to use the same compute platform, programming language, or operating system.

- Services scale independently.

- End-to-end tracing requires more complex orchestration.

- Downstream failures don't affect client transactions.

  - Transactional integrity is difficult to maintain because data creation and persistence happen in separate services. Transactional integrity is a challenge across messaging and persistence services. For more information, see the [guidance on idempotent message processing](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-data-platform#idempotent-message-processing).

We recommend that you use well-known design patterns, such as the [Queue-Based Load Leveling pattern](/azure/architecture/patterns/queue-based-load-leveling) and [Competing Consumers pattern](/azure/architecture/patterns/competing-consumers). These patterns distribute the load from the producer to the consumers and enable asynchronous processing by consumers. For example, the worker lets the API to accept the request and quickly return to the caller while processing a database write operation separately.

Azure Event Hubs brokers messages between the API and worker.

> [!IMPORTANT]
> The message broker shouldn't be used as a persistent data store for long periods of time. The Event Hubs service supports the [capture feature](/azure/event-hubs/event-hubs-capture-enable-through-portal). The capture feature enables an event hub to automatically write a copy of the messages to a linked Storage account. This keeps usage in-check and serves as a mechanism to back up messages.

### Write operations implementation details

Write operations, such as *post rating and post comment*, are processed asynchronously. The API first sends a message with all relevant information, such as type of action and comment data, to the message queue and immediately returns `HTTP 202 (Accepted)` with the additional `Location` header of the to-be-created object.

`BackgroundProcessor` instances process messages in the queue that handle the actual database communication for write operations. `BackgroundProcessor` scales in and scales out dynamically based on queue message volume. The scale-out limit of processor instances is defined by the [maximum number of Event Hubs partitions](/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers), which is 32 for Basic tiers and Standard tiers, 100 for Premium tiers, and 1024 for Dedicated tiers.

:::image type="content" source="./images/application-design-operations-2.png" alt-text="Diagram that shows the asynchronous nature of the post rating feature in the implementation." lightbox="./images/application-design-operations-2.png":::

The Event Hubs Processor library in `BackgroundProcessor` uses Azure Blob Storage to manage partition ownership, load balance between different worker instances, and use checkpoints to track progress. Writing the checkpoints to blob storage doesn't happen after every event because it would add a prohibitively expensive delay for every message. Instead, the checkpoint writing happens on a timer-loop, which is a configurable duration with a current setting of 10 seconds:

```csharp
while (!stoppingToken.IsCancellationRequested)
{
    await Task.Delay(TimeSpan.FromSeconds(_sysConfig.BackendCheckpointLoopSeconds), stoppingToken);
    if (!stoppingToken.IsCancellationRequested && !checkpointEvents.IsEmpty)
    {
        string lastPartition = null;
        try
        {
            foreach (var partition in checkpointEvents.Keys)
            {
                lastPartition = partition;
                if (checkpointEvents.TryRemove(partition, out ProcessEventArgs lastProcessEventArgs))
                {
                    if (lastProcessEventArgs.HasEvent)
                    {
                        _logger.LogDebug("Scheduled checkpointing for partition {partition}. Offset={offset}", partition, lastProcessEventArgs.Data.Offset);
                        await lastProcessEventArgs.UpdateCheckpointAsync();
                    }
                }
            }
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Exception during checkpointing loop for partition={lastPartition}", lastPartition);
        }
    }
}
```

If the processor application encounters an error or is stopped before it can process the message, then another instance picks up the message for reprocessing because it wasn't properly checkpointed in Storage.

- If the previous worker managed to persist the document in the database before it failed, a conflict happens because the same ID and partition key is used. The processor can safely ignore the message because it's already persisted.

- If the previous worker was terminated before writing to the database, the new instance repeats the steps and finalizes persistence.

### Read operations implementation details

The API directly processes read operations and immediately returns data back to the user.

:::image type="content" source="./images/application-design-operations-1.png" alt-text="Diagram of list Catalog Items that reads from the database directly." lightbox="./images/application-design-operations-1.png":::

There's no back channel that communicates to the client if the operation completes successfully. The client application has to proactively poll the API for updates of the item specified in the `Location` HTTP header.

## Scalability

Individual workload components should scale out independently because each component has different load patterns. The scaling requirements depend on the functionality of the service. Certain services directly affect users and must scale out aggressively to ensure fast responses and a positive user experience.

In the implementation, the services are packaged as Docker containers and deployed by using Helm charts to each stamp. They're configured to have the expected Kubernetes requests and limits and a preconfigured automatic scaling rule in place. The `CatalogService` and the `BackgroundProcessor` workload components can scale in and scale out individually because both services are stateless.

Users interact directly with the `CatalogService`, so this part of the workload must respond under any load. There are a minimum of three instances for each cluster to spread across three availability zones in an Azure region. The horizontal pod autoscaler (HPA) in AKS automatically adds more pods as needed. Azure Cosmos DB automatic scale can dynamically increase and reduce request units (RUs) available for the collection. The `CatalogService` and Azure Cosmos DB combine to form a scale unit within a stamp.

HPA is deployed with a Helm chart with configurable maximum number and minimum number of replicas. The values are configured as:

The load test determined that each instance is expected to handle about 250 requests per second with a standard usage pattern.

The `BackgroundProcessor` service has different requirements and is considered a background worker that has limited effect on the user experience. This limited effect means that `BackgroundProcessor` has a different automatic scaling configuration from `CatalogService` and it can scale between 2 and 32 instances. This limit should be based on the number of partitions that are used in the Event Hubs. There's no benefit in having more workers than partitions.

|Component           |`minReplicas`  |`maxReplicas`      |
|--------------------|---------------|-------------------|
|CatalogService      |3              |20                 |
|BackgroundProcessor |2              |32                  |

Each component of the workload that includes dependencies like `ingress-nginx` has [Pod Disruption Budgets (PDBs)](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets) configured to ensure that a minimum number of instances is always available when changes are rolled out on clusters.

```yml
#
# /src/app/charts/healthservice/templates/pdb.yaml
# Example pod distribution budget configuration.
#
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ .Chart.Name }}-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
```

> [!NOTE]
> Determine the actual minimum number and maximum number of pods for each component through load testing. The number of pods can differ for each workload.

## Instrumentation

Instrumentation is an important mechanism in evaluating performance bottle necks and health problems that workload components can introduce into the system. To help you quantify decisions, each component should emit sufficient information through metrics and trace logs. The following key considerations are for instrumenting your application:

- Send logs, metrics, and additional telemetry to the stamp's log system.
- Use structured logging instead of plain text so that you can query information.
- Implement event correlation to ensure end-to-end transaction view. In the RI, every API response contains Operation ID as an HTTP header for traceability.
- Don't rely only on *stdout*, or console logging. You can use these logs to immediately troubleshoot a failing pod.

This architecture implements distributed tracing with Application Insights backed by Log Analytics workspace for all application monitoring data. Use Azure Monitor Logs for logs and metrics of all workload and infrastructure components. The workload implements full end-to-end tracing of requests that come from the API, through Event Hubs, to Azure Cosmos DB.

> [!IMPORTANT]
> Stamp monitoring resources are deployed to a separate monitoring resource group and have a different lifecycle than the stamp itself. For more information, see [Monitoring data for stamp resources](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-app-platform#monitoring-data-for-stamp-resources).

:::image type="content" source="./images/mission-critical-monitoring-resources.svg" alt-text="Diagram of separate global services, monitoring services, and stamp deployment." lightbox="./images/mission-critical-monitoring-resources.svg":::

### Application monitoring implementation details

The `BackgroundProcessor` component uses the `Microsoft.ApplicationInsights.WorkerService` NuGet package to get out-of-the-box instrumentation from the application. Serilog is also used for all logging inside the application with Azure Application Insights configured as a sink and next to the console sink. A `TelemetryClient` instance for Application Insights is used directly only when it's necessary to track additional metrics.

```csharp
//
// /src/app/AlwaysOn.BackgroundProcessor/Program.cs
//
public static IHostBuilder CreateHostBuilder(string[] args) =>
    Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        Log.Logger = new LoggerConfiguration()
                            .ReadFrom.Configuration(hostContext.Configuration)
                            .Enrich.FromLogContext()
                            .WriteTo.Console(outputTemplate: "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} {Level:u3}] {Message:lj} {Properties:j}{NewLine}{Exception}")
                            .WriteTo.ApplicationInsights(hostContext.Configuration[SysConfiguration.ApplicationInsightsConnStringKeyName], TelemetryConverter.Traces)
                            .CreateLogger();
    }
```

:::image type="content" source="./images/application-design-end-to-end-tracing.png" alt-text="Screenshot of the end-to-end tracing capability." lightbox="./images/application-design-end-to-end-tracing.png":::

To demonstrate practical request traceability, every successful and unsuccessful API request returns the Correlation ID header to the caller. The application support team can search Application Insights with this identifier and get a detailed view of the full transaction.

```csharp
//
// /src/app/AlwaysOn.CatalogService/Startup.cs
//
app.Use(async (context, next) =>
{
    context.Response.OnStarting(o =>
    {
        if (o is HttpContext ctx)
        {
            // ... code omitted for brevity
            context.Response.Headers.Add("X-Server-Location", sysConfig.AzureRegion);
            context.Response.Headers.Add("X-Correlation-ID", Activity.Current?.RootId);
            context.Response.Headers.Add("X-Requested-Api-Version", ctx.GetRequestedApiVersion()?.ToString());
        }
        return Task.CompletedTask;
    }, context);
    await next();
});
```

> [!NOTE]
> Adaptive sampling is enabled by default in Application Insights SDK. Adaptive sampling means that not every request is sent to the cloud and searchable by ID. Mission-critical application teams need to reliably trace every request, which is why the reference implementation has adaptive sampling disabled in the production environment.

### Kubernetes monitoring implementation details

Besides the use of diagnostic settings to send AKS logs and metrics to Log Analytics, AKS is also configured to use Container Insights. Enabling Container Insights deploys the OMSAgentForLinux through a Kubernetes DaemonSet on each of the nodes in AKS clusters. The OMSAgentForLinux can collect additional logs and metrics from within the Kubernetes cluster and sends them to its corresponding Log Analytics workspace. This workspace contains more granular data about pods, deployments, services, and health of the overall.

Extensive logging can negatively affect cost and provide no benefits. For this reason, stdout log collection and Prometheus scraping is disabled for the workload pods in the Container Insights configuration because all traces are already captured through Application Insights, which generates duplicate records.

```yaml
#
# /src/config/monitoring/container-azm-ms-agentconfig.yaml
# This is just a snippet showing the relevant part.
#
[log_collection_settings]
    [log_collection_settings.stdout]
        enabled = false

        exclude_namespaces = ["kube-system"]
```

For more information, see the [full configuration file](https://github.com/Azure/Mission-Critical-Online/blob/ae62624a9aaf3e5673ec39bdfadb25a257278dde/src/config/monitoring/container-azm-ms-agentconfig.yaml).

## Application health monitoring

Application monitoring and observability are frequently used to quickly identify problems with a system and inform the [health model](/azure/architecture/framework/mission-critical/mission-critical-health-modeling) about the current application state. Health monitoring surfaced through *health endpoints* and used by *health probes* provides information, which is immediately actionable - typically instructing the main load balancer to take the unhealthy component out of rotation.

In the architecture, health monitoring is applied at these levels:

- Workload pods that run on AKS. These pods have health and liveness probes, therefore AKS can manage their lifecycle.

- Health service is a dedicated component on the cluster. Azure Front Door is configured to probe health services in each stamp and remove unhealthy stamps from automatically load balancing.

### Health service implementation details

`HealthService` is a workload component that runs alongside the `CatalogService` and `BackgroundProcessor` services on the compute cluster. `HealthService` provides a REST API that is called by Azure Front Door health check to determine the availability of a stamp. Unlike basic liveness probes, health service is a more complex component that adds the state of dependencies in addition to its own.

:::image type="content" source="./images/application-design-health-service.png" alt-text="Diagram of the health service querying Azure Cosmos DB, Event Hubs, and Storage." lightbox="./images/application-design-health-service.png":::

The health service doesn't respond if the AKS cluster is down, which renders the workload unhealthy. When the service runs, it performs periodic checks against critical components of the solution. All checks are done asynchronously and in parallel. If any of the checks fail, the whole stamp is considered unavailable.

> [!WARNING]
> Azure Front Door health probes can impose significant load on the health service because requests come from multiple point of presence (PoP) locations. To prevent overloading the downstream components, implement effective caching.

The health service is also used for explicitly configured URL ping tests with each stamp's Application Insights resource.

## Next steps

For more information about the `HealthService` implementation, see [Application Health Service](./mission-critical-health-modeling.md#application-health-service).
