---
title: Application design considerations for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - App Design.
author: msimecek
ms.author: zarhods
ms.date: 07/20/2022
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

The Azure Mission-critical reference architecture considers a simple web shop catalog workflow where end users can browse through a catalog of items, see details of an item, and post ratings and comments for items. Although fairly straight forward, this application enables the **Reference Implementation (RI)** to demonstrate the asynchronous processing of requests and how to achieve high throughput within a solution. The application's design also focuses on reliability and resiliency.

## Application composition

For high-scale mission-critical applications it's essential to **optimize the architecture for end-to-end scalability and resilience**. This can be achieved through separation of components into functional units that can operate independently. This split should be applied at all levels on the application stack, allowing each part of the system to scale independently and meet changes in demand.

The reference implementation (RI) sample flow uses stateless API endpoints, which communicate asynchronously through a messaging bus. The workload is composed in a way that the whole AKS cluster and other dependencies in the stamp can be deleted and recreated at any time.

The RI application consists of four components:

1. **User interface (UI):** single-page application accessed by end users is hosted in Azure Storage Account's static website hosting.
1. **API** (`CatalogService`): .NET Core REST API called by the UI application, but available for other potential client applications.
1. **Worker** (`BackgroundProcessor`): .NET Core background worker, which processes write requests to the database by listening to new events on the message bus. This component does not expose any APIs.
1. **Health service API** (`HealthService`): used to report the health of the application by checking if critical components (database, messaging bus) are working.

![Application flow](./images/application-design-flow.png)

The API, worker and health check applications are referred to as **workload** and hosted as containers in a dedicated AKS namespace (called `workload`). There's **no direct communication** between the pods, they're **stateless** and able to **scale independently**.

![Detailed composition of the workload](./images/application-design-workload-composition.png)

In addition to the workload there are other, supporting components running on the cluster:

1. **Ingress controller** - Nginx in a container is used to incoming requests to the workload and load balance between pods. It has a public IP address.
1. **Cert manager** - Jetstack's `cert-manager` is used to auto-provision SSL/TLS certificates (using Let's Encrypt) for ingress rules.
1. **CSI secrets driver** - To securely read secrets such as connection strings from Azure Key Vault, the open-source Azure Key Vault Provider for Secrets Store CSI Driver is used.
1. **Monitoring agent** - The default OMSAgent configuration is adjusted to reduce the amount of monitoring data sent to the Log Analytics workspace.

## Database connection

Mission-critical workloads shouldn't persist any state within stamps and should use an externalized data store.....

No state is persisted within stamps and Cosmos DB serves as the main data store for the application.

The application has the following **data access characteristics**:

- Read pattern:
  - Point reads, e.g. fetching a single record. These use item ID and partition key directly for maximum optimization (1 RU per request).
  - List reads, e.g. getting catalog items to display in a list. `FeedIterator` with limit on number of results is used.
- Write pattern:
  - Small writes e.g. requests which usually insert a single or a very small number of records in a transaction.
- Designed to handle high traffic from end-users with the ability to scale to handle traffic demand in the order of millions of users.
- Small payload or dataset size - usually in order of KB.
- Low response time (in order of milliseconds).
- Low latency (in order of milliseconds).

[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) was chosen as the main database as it provides the ability of **multi-region writes**: each stamp can write to the Cosmos DB replica in the same region with Cosmos DB internally handling data replication and synchronization between regions.

> [!TIP]
> For applications that prioritize availability before performance **single-region write and multi-region read** with *Strong consistency* level are recommended.

Data model of the Mission-critical reference implementation is designed so that it doesn't require features offered by traditional relational databases (i.e. foreign keys, strict row/column schema, views, etc.) and is fully compatible with the NoSQL nature of Cosmos DB. **SQL API** is used, because it's feature rich and supports all capabilities of the database engine.

> [!NOTE]
> New applications should use the Cosmos DB SQL API. For legacy applications that already use another NoSQL protocol (Mongo DB) the migration to Cosmos DB SQL API should be at least evaluated.

Cosmos DB is configured as follows:

- **Consistency level** is set to the default *Session consistency* as the most widely used level for single region and globally distributed applications. Azure Mission-critical does not use weaker consistency with higher throughput because the asynchronous nature of write processing doesn't require low latency on database write.

- **Partition key** is set to `/id` for all collections. This decision is based on the usage pattern which is mostly *"writing new documents with random GUID as ID"* and *"reading wide range of documents by ID"*. Providing the application code maintains its ID uniqueness, new data will be evenly distributed into partitions by Cosmos DB, enabling virtually infinite scale.

- **Indexing policy** is configured on collections to optimize queries. To optimize RU cost and performance a custom indexing policy is used and this only indexes properties used in query predicates. For example, the application doesn't use the comment text field as a filter in queries and so it was excluded from the custom indexing policy.

```
// Example of setting indexing policy in Terraform:

indexing_policy {

  excluded_path {
    path = "/description/?"
  }

  excluded_path {
    path = "/comments/text/?"
  }

  included_path {
    path = "/*"
  }

}
```

All workload components use the Cosmos DB .NET Core SDK to communicate with the database. The SDK includes robust logic to maintain database connections and handle failures. The configuration is as follows:

- Uses **Direct connectivity mode** (default for .NET SDK v3) as this offers better performance because there are fewer network hops compared to Gateway mode which uses HTTP.
- **`EnableContentResponseOnWrite`** is set to **`false`** to prevent the Cosmos DB client from returning the document from Create, Upsert, Patch and Replace operations to reduce network traffic and because this is not needed for further processing on the client.
- **Custom serialization** is used to set the JSON property naming policy to `JsonNamingPolicy.CamelCase` (to translate .NET-style properties to standard JSON-style and vice-versa) and the default ignore condition to ignore properties with null values when serializing (`JsonIgnoreCondition.WhenWritingNull`).
- **Application region** is set to the region of the stamp, because the application is using multi-region writes.

```csharp
//
// CosmosDbService.cs
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

## Identity and access management

On the application level this reference architecture uses a simple authentication scheme based on API keys for some restricted operations, such as creating new catalog items or deleting comments. More advanced scenarios such as user authentication and user roles are not in scope.

### Managed identities

**Managed identities should be used** to access Azure resources from the AKS cluster. The reference implementation is using managed identity of the AKS agent pool ("Kubelet identity") to access the global Azure Container Registry and stamp Azure Key Vault.

Example of assigning the `AcrPull` role to the Kubelet identity in Terraform (stamp deployment):

```
resource "azurerm_role_assignment" "acrpull_role" {
  scope                = data.azurerm_container_registry.global.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.stamp.kubelet_identity.0.object_id
}
```

https://docs.microsoft.com/azure/aks/use-managed-identity

### Secrets

Each deployment stamp has its dedicated instance of Azure Key Vault. Some parts of the workload still use **keys** to access Azure resources (e.g. Cosmos DB) - those are created during deployment and stored in Key Vault with Terraform. With the exception of end-to-end environments for developers, **no human operator ever interacts with these secrets** as they're generated automatically and handled in Terraform. In addition, Key Vault access policies are configured in a way that **no user accounts are permitted to access** secrets.

> [!NOTE]
> This workload doesn't use certificates, but the same principles would apply.

The [**Azure Key Vault Provider for Secrets Store**](https://docs.microsoft.com/azure/aks/csi-secrets-store-driver) is used in order for the application to consume secret. The CSI driver loads keys from Azure Key Vault and mounts them into individual pods' as files.

```yml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kv
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: {{ .Values.azure.managedIdentityClientId | quote }}
    keyvaultName: {{ .Values.azure.keyVaultName | quote }}
    tenantId: {{ .Values.azure.tenantId | quote }}
    objects: |
      array:
        {{- range .Values.kvSecrets }}
        - |
          objectName: {{ . | quote }}
          objectAlias: {{ . | lower | replace "-" "_" | quote }}
          objectType: secret
        {{- end }}
```

The reference implementation uses Helm in conjunction with Azure DevOps Pipelines to deploy the CSI driver containing all key names from Azure Key Vault. The driver is also responsible to renew secrets if they change in Key Vault.

On the consuming end, both .NET applications use the built-in capability to read configuration from files (`AddKeyPerFile`):

```csharp
//
// Program.cs
// using Microsoft.Extensions.Configuration;
//
public static IHostBuilder CreateHostBuilder(string[] args) =>
    Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration((context, config) =>
    {
        // Load values from k8s CSI Key Vault driver mount point.
        config.AddKeyPerFile(directoryPath: "/mnt/secrets-store/", optional: true, reloadOnChange: true);
        
        // More configuration if needed...
    })
    .ConfigureWebHostDefaults(webBuilder =>
    {
        webBuilder.UseStartup<Startup>();
    });
```

The combination of CSI driver's auto reload and `reloadOnChange: true` ensures that when keys change in Key Vault new values will make it to AKS. **This alone doesn't guarantee secret rotation in the application** though - the reference implementation uses singleton Cosmos DB client instance which means that pod restart is necessary for the app to apply the change.

> For secret rotation procedures see the ops article..... (link)

## Configuration

**All application runtime configuration is stored in Azure Key Vault** - this applies to both secrets (e.g. Cosmos DB API key) and non-sensitive settings (e.g. Cosmos DB database name). Using Key Vault for runtime configuration simplifies the overall implementation by removing dependency on another configuration store (i.e. Azure App Configuration).

As mentioned earlier, **Key Vaults are only populated by Terraform deployment** - required values are either sourced directly from Terraform (such as database connection strings) or passed through as Terraform variables from the deployment pipeline.

**Infrastructure and deployment configuration** of individual environments (e2e, int, prod) is stored in variable files and made part of the source code repository. This has two benefits:

1. All changes in environment sizing, number of instances etc. are tracked and need to go through deployment pipelines before being applied to the environment.
1. Individual e2e environments can be configured differently, because deployment is based on code in a branch.

One exception are **sensitive values** for pipelines, which aren't stored in source files, but rather as secrets in Azure DevOps variable groups.

## Asynchronous messaging

Loose coupling allows services to be designed in a way that **each service has little or no knowledge of surrounding services**. The *loose* aspect allows a service to operate independently. The *coupling* aspect allows for inter-service communication through well-defined interfaces. In the context of a mission critical application it further facilitates high-availability by preventing downstream failures from cascading to frontends or different deployment stamps.

Key characteristics:

- Services aren't constrained to use the same compute platform, programming language, or operating system.
- Services scale independently.
- Downstream failures don't affect client transactions.
- Transactional integrity is more difficult to maintain, because data creation and persistence happens in separate services.
- End-to-end tracing requires more complex orchestration.

Azure Mission-critical RI uses the [Queue-Based Load leveling pattern](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling) combined with [Competing Consumers pattern](https://docs.microsoft.com/azure/architecture/patterns/competing-consumers) where multiple producer instances (`CatalogService` in our case) generate messages which are then asynchronously processed by consumers (`BackgroundProcessor`). This allows the API to accept the request and return to the caller quickly whilst the more demanding database write operation is processed separately.

**Azure Event Hubs** is used as the message queue between the API service and background worker. It was chosen because it's capable of handling higher throughput than Azure Service Bus (with the tradeoff of missing functionality). There are interfaces in code, which enable the use of other messaging services if required. **ASP.NET Core API** is used to implement the producer REST API, and **.NET Core Worker Service** is used to implement the consumer service.

Besides standard user flow messages (database CRUD operations - `AddCatalogItem`, `AddComment`, `AddRating`, `DeleteObject`...),there are also health check messages identified by the `HEALTHCHECK=TRUE` metadata value. Currently health check messages are dropped by the worker and not processed further. The same applies to any other messages that don't specify the `action` property.

> [!IMPORTANT]
> Messaging queue is not intended to be used as a persistent data store for an long periods of time. The Event Hubs service supports [capture feature](https://docs.microsoft.com/azure/event-hubs/event-hubs-capture-enable-through-portal) which allows an Event Hub to automatically write a copy of messages to a linked Azure Storage account. This keeps utilization in-check but it also serves as a mechanism to backup messages.

### Write operations

Write operations, such as *post rating and post comment* are processed asynchronously. The API first sends a message with all relevant information, such as type of action and comment data, to the message queue and immediately returns `HTTP 202 (Accepted)` with additional `Location` header of the to-be-created object.

Messages in the queue are then processed by `BackgroundProcessor` instances which handle the actual database communication for write operations. `BackgroundProcessor` scales in and out dynamically based on message volume on the queue. The scale out limit of processor instances is defined by the [maximum number of Event Hub partitions](https://docs.microsoft.com/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers) (which is 32 for Basic and Standard tiers, 100 for Premium tier and 1024 for Dedicated tier).

![Post rating is asynchronous](./images/application-design-operations-2.png)

The Azure EventHub Processor library in `BackgroundProcessor` uses Azure Blob Storage to manage partition ownership, load balance between different worker instances and to track progress using checkpoints. **Writing the checkpoints to the blob storage does not happen after every event** as this would add a prohibitively expensive delay for every message. Instead the checkpoint writing happens on a timer-loop (configurable duration with a current setting of 10 seconds):

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

In case the processor application encounters an error or is stopped before processing the message, then the following will occur:

1. **Another instance will pick up the message for reprocessing**, because it wasn't properly checkpointed in Storage.
1. **If the previous worker managed to persist the document** in the database before failing, a conflict will happen (because the same ID and partition key is used) and the processor can safely ignore the message, as it has been already persisted.
1. **If the previous worker was terminated before writing to the database**, new instance will repeat the steps and finalize persistence.

### Read operations

Read operations are processed directly by the API and immediately return data back to the user.

![List games reaches to database directly](./images/application-design-operations-1.png)

There is no back channel which communicates to the client if the operation completed successfully. The client application has to proactively poll the API to for updates of the item specified in the `Location` HTTP header.

## Instrumentation

Azure Mission-critical RI uses Azure Log Analytics for logs and metrics of all workload and infrastructure components, and Azure Application Insights for all application monitoring data. The workload implements **full end-to-end tracing** of requests coming from the API, through Event Hubs, to Cosmos DB.

Key principles of instrumentation:

1. Workload components don't rely only on *stdout* (console) logging, although it can be used for immediate troubleshooting of a failing pod.
1. Workload components send logs, metrics and additional telemetry to stamp's log system - Application Insights backed by Log Analytics Workspace.
1. Structured logging is used, instead of plain text.
1. Event correlation is in place to ensure end-to-end transaction view. Every API response contains **Operation ID** for traceability.

> [!IMPORTANT]
> Stamp monitoring resources are deployed to a separate monitoring resource group and have different lifecycle than the stamp itself. See (LINK TO application platform?) for more details.

![Diagram of separate global services, monitoring services and stamp deployment](./images/application-design-monitoring-overview.png)

### Application monitoring

The `BackgroundProcessor` component uses the `Microsoft.ApplicationInsights.WorkerService` NuGet package to get out-of-the-box instrumentation from the application. Also, Serilog is used for all logging inside the application with Azure Application Insights configured as a sink (next to the console sink). Only when needed to track additional metrics, a `TelemetryClient` instance for Application Insights is used directly.

```csharp
//
// Program.cs
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

![End-to-end tracing](./images/application-design-end-to-end-tracing.png)

To demonstrate practical request traceability, every API request (successful or not) returns the Correlation ID header to the caller. With this identifier the **application support team is able to search Application Insights** and get a detailed view of the full transaction.

```csharp
//
// Startup.cs
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
> The Application Insights SDK has adaptive sampling enabled by default. That means that not every request is sent to the cloud and searchable by ID. The reference implementation has **adaptive sampling disabled in production environment**.

### Kubernetes monitoring

Besides the use of diagnostic settings to send AKS logs and metrics to Log Analytics, AKS is also configured to use **Container Insights**. Enabling Container Insights deploys the OMSAgentForLinux via a Kubernetes DaemonSet on each of the nodes in AKS clusters. The OMSAgentForLinux is capable of collecting additional logs and metrics from within the Kubernetes cluster and sends them to its corresponding Log Analytics workspace. This contains more granular data about pods, deployments, services and the overall cluster health.

Extensive logging can negatively affect cost while providing no benefit. For this reason, **stdout log collection and Prometheus scraping is disabled** in the Container Insights configuration, because all traces are already captured through Application Insights - generating duplicate records.

```yaml
#
# container-azm-ms-agentconfig.yaml
# This is just a snippet showing the relevant part.
#
[log_collection_settings]
    [log_collection_settings.stdout]
        enabled = false

        exclude_namespaces = ["kube-system"]
```

See the [full configuration file](https://github.com/Azure/Mission-Critical-Online/blob/ae62624a9aaf3e5673ec39bdfadb25a257278dde/src/config/monitoring/container-azm-ms-agentconfig.yaml) for reference.

## Health monitoring

Application monitoring and observability are commonly used to quickly identify issues with a system and inform the [health model](https://docs.microsoft.com/azure/architecture/framework/mission-critical/mission-critical-health-modeling) about current application state. Health monitoring, surfaced through *health endpoints* and used by *health probes* provides information, which is immediately actionable - typically instructing the main load balancer to take the unhealthy component out of rotation.

There are multiple levels of health monitoring in the Mission-critical RI:

- Workload pods running on AKS have health and liveness probes, therefore AKS is able to manage their lifecycle.
- There's a dedicated component on the cluster, called **Health service**. Azure Front Door is configured to probe health services in each stamp and remove unhealthy stamps from load balancing automatically.

### Health service

`HealthService` is a workload component that is running along other components (`CatalogService` and `BackgroundProcessor`) on the compute cluster. It provides a REST API that is called by Azure Front Door health check to determine the availability of a stamp. Unlike basic liveness probes, health service is a more complex component which adds the state of dependencies in addition to its own.

![Conceptual diagram of the health service querying Cosmos DB, Event Hub and Storage](./images/application-design-health-service.png)

First of all, if the AKS cluster is down, the health service wouldn't respond, rendering the workload unhealthy. When the service is running, it performs periodic checks against critical components of the solution:

1. Perform a simple query to **Cosmos DB**.
1. Send a message to **Event Hub** (filtered out by the backend worker).
1. Lookup a specific file on the **Storage Account** (also serves as a kill switch).

All checks are done **asynchronously and in parallel**. If any of them fails, the whole stamp will be considered unavailable.

Check results are **cached in memory**, using the standard, non-distributed ASP.NET Core `MemoryCache`. Cache expiration is controlled by `SysConfig.HealthServiceCacheDurationSeconds` and is set to 10 seconds by default. There's not need for external cache in this case.

> [!WARNING]
> Azure Front Door health probes can generate significant load on the health service, because requests come from multiple pop locations. To prevent overloading the downstream components, appropriate caching needs to take place.

The health service is also used for explicitly configured URL ping tests with each stamp's Application Insights resounrce

#### Cosmos DB check

To minimize impact on the overall load, the read check is a simple query which doesn't manipulate with data:

```sql
SELECT GetCurrentDateTime()
```

The write request creates a dummy document with minimum content and short time-to-live (TTL):

```csharp
var testRating = new ItemRating()
{
    Id = Guid.NewGuid(),
    CatalogItemId = Guid.NewGuid(), // create some random (= non-existing) item id
    CreationDate = DateTime.UtcNow,
    Rating = 1,
    TimeToLive = 10 // will be auto-deleted after 10 seconds
};

await AddNewRatingAsync(testRating);
```

### Event Hub check

The health service reports healthy if it's able to send a message to Event Hub. It contains additional property `HEALTHCHECK=TRUE` and the background processor ignores it.

### Blob check

The blob check serves two purposes:

1. Test if it's possible to reach Blob Storage. This storage account is also used by other components in the stamp and hence considered a critical resource.
1. Manually "turn off" a region by manipulating (i.e. deleting) the state file.

The reference implementation looks for presence of the state file in the specified Blob Container. If it cannot connect to the Storage Account, or if the file is not found, stamp is considered unhealthy.

**Remove** the file to disable a stamp.

## Scalability

Individual workload services should be able to scale out independently, because they each have different load patterns. The scaling requirements depend on the functionality of the service. Some services have a direct impact on end user and are expected to be able to scale out agressively to provide fast response for a positive user experience and performance at any time.

 In this RI the services are packaged as Docker containers and deployed by using Helm charts to each stamp. They are configured to have the expected Kubernetes requests and limits and a pre-configured auto-scaling rule in place. The `CatalogService` as well as the `BackgroundProcessor` workload component can scale in and out individually, both services are stateless.

End users interact directly with the `CatalogService`,....

 (what is preconfigured? like built-in?) 



`CatalogService` performance has a direct impact on the end user experience. The service is expected to be able to scale out automatically to provide a positive user experience and performance at any time.

The `CatalogService` has at least 3 instances per cluster to spread automatically across three Availability Zones per Azure Region. Each instance requests one CPU core and a given amount of memory based on upfront load testing. Each instance is expected to serve ~250 requests/second based on a standardized usage pattern. `CatalogService` has a 3:1 relationship to the nginx-based Ingress controller.

The `BackgroundProcessor` service has very different requirements and is considered a background worker which has no direct impact on the user experience. As such, `BackgroundProcessor` has a different auto-scaling configuration than `CatalogService` and it can scale between 2 and 32 instances (which matches the max. no. of EventHub partitions). The ratio between `CatalogService` and `BackgroundProcessor` is around 20:2.

All workload components as well as supporting services like the `HealthService` and dependencies like `ingress-nginx` are configured with at least 3 or in case of the `HealthService` 2 instances (replicas) per cluster. This is supposed to prevent certain availability issues and to ensure that the service is always available. The instances are automatically spread across nodes and therefore also across Availability Zones.

In addition to that, each component of the workload including dependencies like `ingress-nginx` has [Pod Disruption Budgets (PDBs)](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets) configured to ensure that a minimum number of instances is always available.






In this reference architecture, the `CatalogService` has at least 3 instances per cluster to spread automatically across three Availability Zones per Azure Region. Each instance requests one CPU core and a given amount of memory based on upfront load testing. Each instance is expected to serve approximately 250 requests per second based on a standardized usage pattern. `CatalogService` has a 3:1 relationship to `Ingress`.

In other cases, the service might not have negative impact on user experience but may cause performance bottlenecks. For instance, the `BackgroundProcessor` service is a background worker that should be able  to<ask Martin what the requirement is>. It can scale between 3 and 32 instances, which matches the maximum number of event hub partitions. The ratio between `CatalogService` and `BackgroundProcessor` is around 10:1.

There are also overall scalability considerations that are applicable to all workload services to prevent availability issues and ensure that the service is always available. For example, supporting services like the `HealthService` and `Ingress` are configured with minimum of three replicas.  The instances are automatically spread across nodes and therefore also across Availability Zones.

In addition, each component of the workload has [Pod Disruption Budgets (PDBs)](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets) configured to ensure that a minimum number of instances is always available.

The actual minimum and maximum number of pods for each component should be determined through load testing, while still respecting the ratios defined in this section.


The CatalogService application is packaged and deployed as a Helm chart. The chart is stored in the `src/app/charts` directory. It offers a set of parameters that can be used to customize the deployment (see `values.yaml` for all).

| Parameter | Description |
| --- | --- |
| scale.minReplicas | Minimum number of replicas to deploy |
| scale.maxReplicas | Maximum number of replicas to deploy |
| networkPolicy.enabled | Whether to enable network policies |
| networkPolicy.egressRange | Allowed egress range - defaults to `0.0.0.0/0` |


----
----

DUMP ZONE


## Service discoverablity
- Service object and ClusterIP
- Cluster DNS
- Service-to-service communication through APIs

## Networking path within the cluster
- Load balancing
- Ingress to service
- Network policies


## Scalability
- Independent scaling
    - HPA
- How to determine scale values


