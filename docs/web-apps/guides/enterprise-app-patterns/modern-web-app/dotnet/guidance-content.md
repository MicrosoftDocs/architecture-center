[!INCLUDE [intro](../includes/mwa-intro.md)]

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) This article is backed by a [reference implementation](https://aka.ms/eap/rwa/dotnet) of the Reliable Web App pattern, which features a production grade web app on Azure. Use this sample web app to guide your implementation of Reliable Web App pattern.

## Choose the right services

The Modern Web App pattern introduces containerization, asynchronous communication, and queue-based scaling. The services you selected for the implementation of the Reliable Web App pattern might not support these implementation techniques. You likely need to adopt new Azure services for the portion of the application that you want to modernize. For the Modern Web App pattern, you need an application platform that supports containerization and a container image repository. You need a messaging system to support asynchronous messaging.

### Choose a container service

For the parts of your application that you want to containerize, you need an application platform that supports containers. Azure has three principle container services: Azure Container Apps, Azure Kubernetes Service, and App Service.

- *Azure Container Apps (ACA)*: Choose ACA if you need a serverless platform that automatically scales and manages containers in event-driven applications.
- *Azure Kubernetes Service (AKS)*: Choose AKS if you need detailed control over Kubernetes configurations and advanced features for scaling, networking, and security.
- *Web Apps for Container*: Choose Web App for Containers on Azure App Service for the simplest PaaS experience.

For more information, see [Choose an Azure container service](/azure/architecture/guide/choose-azure-container-service).

### Choose a container repository

When using any container-based compute service, it’s necessary to have a repository to store the container images. You can use a public container registry like Docker Hub or a managed registry like Azure Container Registry. For more information, see [Introduction to Container registries in Azure](/azure/container-registry/container-registry-intro).

### Choose a messaging system

A messaging system is an important piece of service-oriented architectures. It decouples message senders and receivers to enable [asynchronous messaging](/azure/architecture/guide/technology-choices/messaging). Pick an Azure messaging system that supports your design message queues and publish-subscribe methods.

Azure has three messaging services: Azure Event Grid, Azure Event Hub, and Azure Service Bus.

- *Azure Event Grid*: Choose Azure Event Grid when you need a highly scalable service to react to status changes through a publish-subscribe model.
- *Azure Event Hubs*: Choose Azure Event Hubs for large-scale data ingestion, especially when dealing with telemetry and event streams that require real-time processing.
- *Azure Service Bus*: Choose Azure Service Bus for reliable, ordered, and possibly transactional delivery of high-value messages in enterprise applications.

For more information, see [Choose between Azure messaging services](https://learn.microsoft.com/azure/service-bus-messaging/compare-messaging-services).

## Design the architecture

- *Design network topology.* Choose the right network topology for your web and networking requirements. A [hub and spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology) is standard configuration in Azure. It provides cost, management, and security benefits with hybrid connectivity options to on-premises networks.

- *Design for availability.* Determine how many availability zones and regions you need to meet your availability needs. Define a target SLO for your web app, such as 99.9% uptime. Then, calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) for all the services that affect the availability of your web app. Add availability zones and regions until the composite SLA meets your SLO.

- *Design for resiliency.* Design your infrastructure to support your [recovery metrics](/azure/well-architected/reliability/metrics#recovery-metrics), such as recovery time objective (RTO) and recovery point objective (RPO). The RTO affects availability and must support your SLO. Determine an recovery point objective (RPO) and configure [data redundancy](/azure/well-architected/reliability/redundancy#data-resources) to meet the RPO. A multi-region, active-active approach requires code updates to synchronize data across regions.

- *Configure private endpoints.* Use [private endpoints](/azure/architecture/framework/security/design-network-endpoints) in all production environments for all supported Azure services. Private endpoints help secure access to PaaS services and don't require any code changes, app configurations, or connection strings.

## Update the code and configuration

The following sections details essential the code and configuration updates you need to make to your web app. It follows the pillars of the Well-Architected Framework and covers the design patterns and key updates of the Modern Web App pattern.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Modern Web App pattern uses two design patterns to improve web app reliability:

- *Queue-Based Load Leveling pattern* improves message-based communication.
- *Retry pattern* improves request-response communication.

#### Implement the Queue-Based Load Leveling pattern

The [Queue-Based Load Leveling pattern](/azure/architecture/patterns/queue-based-load-leveling) improves the reliability of code by separating tasks and services with a queue. Unlike synchronous methods, such HTTP, this pattern prevents the workload spikes from directly affecting services. The queue smooths out workload demand and allows services to process tasks at a consistent rate, enhancing the reliability of the system.

- The task that is queueing messages should not block waiting for messages to be handled. If the task makes use of the result of the queued operation, have a ‘standby’ code path that can be used until the data is available.

  The reference implementation uses Azure Service Bus to establish a messaging queue between a web API and its ticket rendering service. By using the `await` keyword with `messageSender.PublishAsync()`, the web API asynchronously publishes messages without blocking the calling thread. This approach prevents delays in sending messages to the queue and does not require waiting for the rendering service to process the messages. Consequently, the web API remains responsive and can handle incoming web requests without interruption (*see example code*):

    ```csharp
    // Publish a message to request that the ticket be rendered.
    await messageSender.PublishAsync(new TicketRenderRequestMessage(Guid.NewGuid(), ticket, null, DateTime.Now), CancellationToken.None);
    ```

- Queued messages that cannot be processed successfully should be retried and, if failures persist, removed from the queue. Azure Service Bus’s built-in retry and dead letter queue features address this need.

- Logic processing messages from the queue must be idempotent in case a message is processed more than once.

    The reference implementation ticket rendering service pulls messages from Service Bus using `ServiceBusClient.CreateProcessor`, which sets up a dedicated message processing service. It allows the ticket rendering service to pull messages from the messaging service and prevents an overload. `AutoCompleteMessages = true` completes messages post-successful processing and ensures messages are only processed once. The `ReceiveMode = ServiceBusReceiveMode.PeekLock` locks messages for processing without removal from the queue and enables reprocessing on failures, supporting idempotent operations (*see following code*).
  
    ```csharp
    // Create a processor for the given queue that will process incoming messages
    var processor = serviceBusClient.CreateProcessor(path, new ServiceBusProcessorOptions
    {
        // Allow the messages to be auto-completed if processing finishes without failure
        AutoCompleteMessages = true,
    
        // PeekLock mode provides reliability in that unsettled messages will be redelivered on failure
        ReceiveMode = ServiceBusReceiveMode.PeekLock,
    
        // Containerized processors can scale at the container level and need not scale via the processor options
        MaxConcurrentCalls = 1,
        PrefetchCount = 0
    });
    ```

### Implement the Retry Pattern

Update the use of the [Retry pattern](/azure/architecture/patterns/retry) to apply to new services.

- *Configure retry options.* When integrating with a message queue, ensure that the client responsible for interactions with the queue is configured with appropriate retry settings. This involves specifying parameters such as the maximum number of retries, delay between retries, and maximum delay.
- *Use exponential backoff.* Implement exponential backoff strategy for retry attempts. This means increasing the time between each retry exponentially, which helps reduce the load on the system during periods of high failure rates.
- *Use SDK Retry functionality.* For services with specialized SDKs, like Azure Service Bus or Azure Blob Storage, use the built-in retry functionalities. These are optimized for the service's typical use cases and can handle retries more effectively with less configuration required on your part.

The reference implementation uses the built-in retry functionality of the Azure Service Bus SDK (`ServiceBusClient` and `ServiceBusRetryOptions`). The `ServiceBusRetryOptions` fetches settings from `MessageBusOptions` to configures retry settings such as MaxRetries, Delay, MaxDelay, and TryTimeout. The Mode property of `ServiceBusRetryOptions` implements an exponential backoff strategy using `ServiceBusRetryMode.Exponential`.

```csharp
// ServiceBusClient is thread-safe and can be reused for the lifetime of the application.
services.AddSingleton(sp =>
{
    var options = sp.GetRequiredService<IOptions<MessageBusOptions>>().Value;
    var clientOptions = new ServiceBusClientOptions
    {
        RetryOptions = new ServiceBusRetryOptions
        {
            Mode = ServiceBusRetryMode.Exponential,
            MaxRetries = options.MaxRetries,
            Delay = TimeSpan.FromSeconds(options.BaseDelaySecondsBetweenRetries),
            MaxDelay = TimeSpan.FromSeconds(options.MaxDelaySeconds),
            TryTimeout = TimeSpan.FromSeconds(options.TryTimeoutSeconds)
        }
    };
    return new ServiceBusClient(options.Host, azureCredential ?? new DefaultAzureCredential(), clientOptions);
});
```

- *Adopt Standard Resilience Libraries for HTTP Clients.* For HTTP communications, integrate a standard resilience library such as Polly or `Microsoft.Extensions.Http.Resilience`. These libraries offer comprehensive retry mechanisms, including exponential backoff, circuit breaker patterns, and more, which are crucial for managing communications with external web services.
- *Handle message locking.* For message-based systems, implement message handling strategies that support retries without data loss, such as using "peek-lock" modes where available. Ensure that failed messages are retried effectively and moved to a dead-letter queue after repeated failures.
- *Use a dead-letter queue.* Implement a mechanism to handle messages that repeatedly fail processing. Move such messages to a dead-letter queue to prevent them from blocking the main processing queue. Regularly review messages in the dead-letter queue to identify and address underlying issues.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). The Modern Web App pattern applies security best practices to new services extracted from the web app.

### Configure service authentication and authorization

- *Use managed identities for each new service.* Each microservice should have its own identity and use managed identities for service-to-service authentication. Managed identities eliminate the need to manage credentials in your code and reduce the risk of credential leakage. It helps you avoid putting sensitive information like connection strings in your code or configuration files.
- *Grant least privilege to each new service.* Assign only necessary permissions to each new service identity. For example, if an identity only needs to push to a container registry, don’t give it pull permissions. Review these permissions regularly and adjust as necessary. Use different identities for different roles, such as deployment and the application. This limits the potential damage if one identity is compromised.
- *Adopt infrastructure as code (IaC).* Use Azure Bicep or similar IaC tools to define and manage your cloud resources. This ensures consistent application of security configurations in your deployments and allows you to version control your infrastructure setup.
- *Update firewall rules.* Update your firewall rules to account for the new network traffic patterns that results from the extraction of the microservice.

The reference implementation uses IaC to assign managed identities to added services and specific roles to each identity. It defines roles and permissions access for deployment (`containerRegistryPushRoleId`), application owner (`containerRegistryPushRoleId`), and Azure Container Apps application (`containerRegistryPullRoleId`) (*see following code*).

```bicep
roleAssignments: \[
    {
    principalId: deploymentSettings.principalId
    principalType: deploymentSettings.principalType
    roleDefinitionIdOrName: containerRegistryPushRoleId
    }
    {
    principalId: ownerManagedIdentity.outputs.principal_id
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: containerRegistryPushRoleId
    }
    {
    principalId: appManagedIdentity.outputs.principal_id
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: containerRegistryPullRoleId
    }
\]
```

The reference implementation assigns the managed identity the new Azure Container App identity at deployment (*see following code*).

```bicep
module renderingServiceContainerApp 'br/public:avm/res/app/container-app:0.1.0' = {
  name: 'application-rendering-service-container-app'
  scope: resourceGroup()
  params: {
    // Other parameters omitted for brevity
    managedIdentities: {
      userAssignedResourceIds: [
        managedIdentity.id
      ]
    }
  }
}
```

## Configure user authentication and authorization

- *Grant least privilege to users.* Just like with services, ensure that users are given only the permissions they need to perform their tasks. Regularly review and adjust these permissions.
- *Conduct regular security audits.* Regularly review and audit your security setup. Look for any misconfigurations or unnecessary permissions and rectify them immediately.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Modern Web App pattern implements independent autoscaling to optimize cost.

### Autoscaling container

Automatic horizontal scaling adds and removes service instances automatically based on relevant demand metrics. It scales the service to perform more work when demand is high and to save cost when demand is low. By scaling automatically based on metrics relevant to the application’s scenario, scale operations can be performed quickly and without any need for manual intervention.

- *Use stateless services.* Ensure your services are stateless. If your .NET application contains in-process session state, externalize it to a distributed cache like Redis or a database like SQL Server.
- *Configure autoscaling rules.* Consider [event-based scaling](/azure/well-architected/cost-optimization/optimize-scaling-costs#consider-event-based-scaling), such as Kubernetes Event-Driven Autoscaler (KEDA). [Azure Container Apps](/azure/container-apps/scale-app) and Azure Kubernetes Service support KEDA scalers. Configure the KEDA scalers to scale your deployments based on event metrics. Develop custom KEDA scaler as needed. When deploying to Azure App Service, use [Azure Monitor Autoscaling](https://learn.microsoft.com/azure/azure-monitor/autoscale/autoscale-get-started) to scale based on metrics-based rules or [Azure App Service Automatic Scaling](https://learn.microsoft.com/azure/app-service/manage-automatic-scaling) to scale based on HTTP traffic.
- *Configure minimum replicas.* To prevent a cold start, configure autoscaling settings to maintain a minimum of 1 replica at all times. A cold start is when you initialize a service from a stopped state, which often creates a delayed response. If minimizing costs is a priority and you can tolerate cold start delays, set the minimum replica count to 0 when configuring autoscaling.
- *Configure a cooldown period.* Apply an appropriate cooldown period to introduce a delay between scaling events. The goal is to [prevent excessive scaling](/azure/well-architected/cost-optimization/optimize-scaling-costs#optimize-autoscaling) activities triggered by temporary load spikes.
- *Configure queue-based scaling.* If your application uses a message queue like Azure Service Bus, configure your autoscaling settings to scale based on the length of the queue with request messages. The scaler aims to maintain one replica of the service for every N messages in the queue (rounded up).

The reference implementation uses the [Azure Service Bus KEDA scaler](/azure/container-apps/scale-app) to scale the Container App based on the length of the queue with request messages. The `service-bus-queue-length-rule` scales the service based on the length of a specified Azure Service Bus queue. The `messageCount` parameter is set to ‘10’, meaning the scaler will aim to have one replica of the service for every ten messages in the queue. The `scaleMaxReplicas` and `scaleMinReplicas` parameters set the maximum and minimum number of replicas for the service, respectively. The `queue-connection-string secret`, which contains the connection string for the Service Bus queue, is retrieved from Key Vault. This secret is used to authenticate the scaler to the Service Bus.

```yml
scaleRules: [
  {
    name: 'service-bus-queue-length-rule'
    custom: {
      type: 'azure-servicebus'
      metadata: {
        messageCount: '10'
        namespace: renderRequestServiceBusNamespace
        queueName: renderRequestServiceBusQueueName
      }
      auth: [
        {
          secretRef: 'render-request-queue-connection-string'
          triggerParameter: 'connection'
        }
      ]
    }
  }
]

scaleMaxReplicas: 5
scaleMinReplicas: 0
```

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Moving from the reliable web app pattern to the modern web app pattern includes separating logically independent pieces of the application into their own services. This improves operational efficiency by making it possible for these different services to version and update independently. While making these changes, it’s important to also continue abiding by the reliable web app’s patterns of infrastructure-as-code and automated deployments so that infrastructure design and updates are manageable and environments are easily reproduceable.

### Implement the Strangler Fig pattern

The [Strangler fig](/azure/architecture/patterns/strangler-fig) pattern allows you to separate larger services into more granular services. It allows you to move specific logical components to new services. The strangler fig pattern is useful for making incremental progress on large modernization tasks that would be intractable if they had to be completed all at once. Dividing a monolithic solution into finer-grained services allows services to version and scale independently. A service-oriented architecture in which each service is self-contained makes it easy for different teams in an organization to own different services and innovate at the pace that makes sense for them. And when load increases, only the services that represent the performance bottleneck need to scale out. The strangler fig pattern is a useful pattern for transitioning gradually into such an architecture.

- *Identify services to extract.* Start by identifying the services that can be extracted according to domain boundaries. These services should be logically separate pieces of functionality that can benefit from independent scaling, versioning, or deployment. For example, in an e-commerce application, services like user management, product catalog, and order processing can be identified as separate domains.
- *Use a façade service if necessary.* In some cases, a strangler fig façade service is used to route requests to the various backend solutions while the pattern is being applied. This is particularly useful when you have multiple services running in parallel during the transition period. However, if the extracted service doesn’t have any public-facing APIs, such a façade service might not be necessary.
- *Unify the API surface area.* If your application exposes an API to callers, consider using a management platform like [Azure API Management](/azure/api-management/api-management-key-concepts). It can help unify the surface area of multiple services which have been extracted from one another, making it easier for clients to consume your services.
- *Manage feature rollout.* If you want an extracted service to be rolled out gradually, use ASP.NET Core feature management and [staged rollout](/azure/azure-app-configuration/howto-targetingfilter-aspnet-core). This allows you to use the new service for only a portion of requests initially, and then increase its usage over time as you gain confidence in its stability and performance.

The reference implementation extracts the ticket rendering functionality from a web API into a standalone service, which can be toggled via a feature flag. The Strangler Fig pattern allows for a gradual transition from the old in-process implementation to the new service. The extracted service was also updated to run in a Linux container and shows how services can be upgraded during extraction.

### Implement the Health Endpoint Monitoring pattern

The [Health Endpoint Monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring) is useful for tracking the health of application endpoints. This is especially important in services that are managed by an orchestrator such as those deployed in Azure Kubernetes Service or Azure Container Apps. These orchestrators can poll health endpoints to make sure services are running properly and restart instances that are not healthy. ASP.NET Core apps can add dedicated [health check middleware](/aspnet/core/host-and-deploy/health-checks) to efficiently serve endpoint health data, including checking the health of key dependencies.

#### HEM pattern implementation recommendations for .NET developers

- *Implement health checks.* Use ASP.NET Core [Health Checks Middleware](/aspnet/core/host-and-deploy/health-checks) to provide health check endpoints.
- *Validate dependencies.* Ensure that your health checks validate the availability of key dependencies, such as the database, storage, and messaging system. The non-Microsoft package, [AspNetCore.Diagnostics.HealthChecks](https://github.com/Xabaril/AspNetCore.Diagnostics.HealthChecks), can implement health check dependency checks for many common app dependencies.

    The reference implementation uses [ASP.NET Core health check middleware](/aspnet/core/host-and-deploy/health-checks) to expose health check endpoints, using the `AddHealthChecks()` method on the `builder.Services` object. The code validates the availability of key dependencies, Azure Blob Storage and Azure Service Bus Queue with the `AddAzureBlobStorage()` and `AddAzureServiceBusQueue()` methods, which are part of the AspNetCore.Diagnostics.HealthChecks package. Azure Container Apps allow configuration of [health probes](https://learn.microsoft.com/azure/container-apps/health-probes) that are monitored to gauge whether apps are healthy or in need of recycling.

```C#
// Add health checks, including health checks for Azure services that are used by this service.
// The Blob Storage and Service Bus health checks are provided by AspNetCore.Diagnostics.HealthChecks
// (a popular open source project) rather than by Microsoft. https://github.com/Xabaril/AspNetCore.Diagnostics.HealthChecks
builder.Services.AddHealthChecks()
.AddAzureBlobStorage(options =>
{
    // AddAzureBlobStorage will use the BlobServiceClient registered in DI
    // We just need to specify the container name
    options.ContainerName = builder.Configuration.GetRequiredConfigurationValue("App:StorageAccount:Container");
})
.AddAzureServiceBusQueue(
    builder.Configuration.GetRequiredConfigurationValue("App:ServiceBus:Host"),
    builder.Configuration.GetRequiredConfigurationValue("App:ServiceBus:RenderRequestQueueName"),
    azureCredentials);

// Further app configuration omitted for brevity
app.MapHealthChecks("/health");
```

- *Configure Azure resources.* Configure the Azure resource to use the app’s health check URLs to confirm liveness and readiness.

    The reference implementation uses Bicep to configure the health check URLs to confirm the liveness and readiness of the Azure resource. A liveness probe to hits the `/health` endpoint every 10 seconds after an initial delay of 2 seconds.

    ```bicep
    probes: [
      {
        type: 'liveness'
        httpGet: {
          path: '/health'
          port: 8080
        }
        initialDelaySeconds: 2
        periodSeconds: 10
      }
    ]
    
    ```

### Containerize service deployment

An important part of the modern web app pattern is dividing services according to domain boundaries (as discussed in the strangler fig pattern).

#### Containerizing implementations recommendations for .NET developers

- When creating Docker images for .NET apps, you should use chiseled base images to minimize package size and attack surface area.

- You should use multistage Dockerfiles to separate build-time assets from the runtime container image.

- You should run .NET containers as [the non-root user “App”](https://devblogs.microsoft.com/dotnet/securing-containers-with-rootless/) (via that users name or UID, $APP_UID) to align with the principle of least privilege. 

- When running as a non-root user, you application should listen on port 8080.

**Example - Implementing containerized service deployment**: The reference implementation publishes the new ticket rendering service as a [Docker container image](https://learn.microsoft.com/dotnet/core/docker/introduction). This means that all dependencies for the app to function are encapsulated in a lightweight image that can be reliably deployed to a wide range of hosts including, in the case of the reference implementation, Azure Container Apps. The reference implementation uses a [multi-stage](https://docs.docker.com/build/building/multi-stage/) Dockerfile which first builds the solution in a Docker container (based on a mcr.microsoft.com/dotnet/sdk image) and then publishes the final service in a separate smaller container.

```dockerfile
# Build in a separate stage to avoid copying the SDK into the final image
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Restore packages
COPY ["Relecloud.TicketRenderer/Relecloud.TicketRenderer.csproj", "Relecloud.TicketRenderer/"]
COPY ["Relecloud.Messaging/Relecloud.Messaging.csproj", "Relecloud.Messaging/"]
COPY ["Relecloud.Models/Relecloud.Models.csproj", "Relecloud.Models/"]
RUN dotnet restore "./Relecloud.TicketRenderer/Relecloud.TicketRenderer.csproj"

# Build and publish
COPY . .
WORKDIR "/src/Relecloud.TicketRenderer"
RUN dotnet publish "./Relecloud.TicketRenderer.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Chiseled images contain only the minimal set of packages needed for .NET 8.0
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled AS final
WORKDIR /app
EXPOSE 8080

# Copy the published app from the build stage
COPY --from=build /app/publish .

# Run as non-root user
USER $APP_UID
ENTRYPOINT ["dotnet", "./Relecloud.TicketRenderer.dll"]
```

The ticket rendering service uses a chiseled base image (mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled) so that only the minimal set of packages needed for ASP.NET Core to run are included. This reduces the size of the container image and improves security by reducing attack surface area. The service’s Dockerfile also specifies that the container should run with [a non-root user](https://devblogs.microsoft.com/dotnet/securing-containers-with-rootless/) in keeping with the principle of least privilege.

The ticket rendering service is built on Linux-based .NET base images, but .NET Docker containers can be built on either Windows or Linux base images. Because the reference implementation uses Azure Container Apps, however, Linux Docker images are required for this scenario.

## Performance efficiency

Performance represents the ability of a solution to function efficiently even as workload demands change. As applications move from the reliable web app pattern to the modern web app pattern, it should be possible to improve performance because of increased decoupling of application services. In a modern web app, one component slowing down should not negatively affect the performance of other components. One pattern supporting the pillar of performance that has already been discussed is queue-based load leveling. Queue-based load leveling provides both reliability benefits (for the worker service) and performance benefits (for the calling task). Another related pattern which is often paired with queue-based load leveling which can improve performance in the worker service is the competing consumers pattern.

### Competing Consumers pattern

The [Competing Consumers pattern](https://learn.microsoft.com/azure/architecture/patterns/competing-consumers) allows incoming work to be efficiently handled by multiple parallel workers. This pattern enables handling bursts of demand by temporarily scaling workers horizontally which are designed such that they can all consume work requests from a message queue in parallel. This pattern can be used if your solution is designed so that message ordering doesn’t matter, malformed messages don’t block the queue, and processing is idempotent so that messages that aren’t successfully handled by one worker can be picked up by another without fear of errors due to processing the message more than once.

#### Competing Consumers implementation recommendations for .NET developers

- When receiving messages from a Service Bus queue, you should set MaxConncurrentCalls to 1 and PrefetchCount to 0 because multiple messages will be handled by multiple consumers.

- When receiving messages from a Service Bus queue, you should use PeekLock mode rather than ReceiveAndDelete mode to automatically retry processing messages that fail.

- Consumers should move malformed messages to the dead letter queue so that they are not needlessly retried.

- Consumers should be architected such that they function even when messages are received out-of-order. Even if messages are queued in order, having multiple parallel consumers means that messages may be processed out of order. 

- Services consuming Service Bus messages should auto-scale based on queue length in order to efficiently process spikes of incoming messages.

- If the consumer service needs to notify the sender when a message is processed, it should use a dedicated message reply queue.

*Simulate the pattern:* You can simulate the benefits of competing consumers in the Relecloud modern web app reference implementation by purchasing many tickets at once (100 or more). This will cause many ticket rendering requests to be queue in Azure Service Bus. The requests are quickly handled, though, because the ticket rendering service will automatically scale out and handle the requests in parallel.

**Example - Implementing the Competing Consumers pattern**: The reference implementation uses a stateless Azure Container App to process ticket rendering requests from an Azure Service Bus queue.

```C#
// Create a processor for the given queue that will process incoming messages
var processor = serviceBusClient.CreateProcessor(path, new ServiceBusProcessorOptions
{
    // Allow the messages to be auto-completed if processing finishes without failure
    AutoCompleteMessages = true,
    // PeekLock mode provides reliability in that unsettled messages will be redelivered on failure
    ReceiveMode = ServiceBusReceiveMode.PeekLock,
    // Containerized processors can scale at the container level and need not scale via the processor options
    MaxConcurrentCalls = 1,
    PrefetchCount = 0
});

// Called for each message received by the processor
processor.ProcessMessageAsync += async args =>
{
    logger.LogInformation("Processing message {MessageId} from {ServiceBusNamespace}/{Path}", args.Message.MessageId, args.FullyQualifiedNamespace, args.EntityPath);
    // Unhandled exceptions in the handler will be caught by the processor and result in abandoning and dead-lettering the message
    try
    {
        var message = args.Message.Body.ToObjectFromJson<T>();
        await messageHandler(message, args.CancellationToken);
        logger.LogInformation("Successfully processed message {MessageId} from {ServiceBusNamespace}/{Path}", args.Message.MessageId, args.FullyQualifiedNamespace, args.EntityPath);
    }
    catch (JsonException)
    {
        logger.LogError("Invalid message body; could not be deserialized to {Type}", typeof(T));
        await args.DeadLetterMessageAsync(args.Message, $"Invalid message body; could not be deserialized to {typeof(T)}", cancellationToken: args.CancellationToken);
    }
};
```

Important items to note in the implementation of the Service Bus processor are:

- Work is retrieved from Service Bus using **peek-lock** receive mode so that if a worker fails while processing a request, the request will simply be returned to the queue and handled by a different worker. Also, the ticket rendering service is implemented such that processing a request twice will not cause any problems. This avoids errors in the case of a worker failing after already completing some or all of the processing work.

- Persistent errors such as malformed JSON in messages are handled by sending messages to a **dead-letter queue**. This prevents malformed messages from clogging the queue.

- **MaxConcurrentCalls** is set to 1 and **PrefetchCount** is set to 0 since scaling is expected to happen in Azure Container Apps, so it’s not necessary for an individual worker to optimize for handling many messages at once.

Also important is that images are written to Blob Storage in such a way that writing to the same blob twice will simply overwrite the older one rather than causing a failure. This is important when using peek-lock receive mode since it’s possible that in rare circumstances the same rendering request might be processed twice. Scaling is performed automatically based on queue length, as described in the cost optimization section.

## Next steps

You can deploy the reference implementation by following the instructions in the [modern web app pattern for .NET repository](https://github.com/azure/modern-web-app-pattern-dotnet). There are instructions for both development and production deployment of the reference implementation. Once deployed, you can observe the patterns described in this document in action.
