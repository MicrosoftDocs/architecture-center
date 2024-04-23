---
title: Modern web app pattern for .NET – Apply the pattern
---
This article shows you how to apply the Modern web app pattern. [!INCLUDE [mwa-intro](../includes/mwa-apply-intro.md)]

[!INCLUDE [reference-implementation-dotnet](../includes/reference-implementation-dotnet.md)] To apply the Modern Web App pattern, follow these recommendations aligned to the pillars of the Well-Architected Framework:

## Reliability

[Reliability](/azure/well-architected/reliability/checklist) ensures your application can meet the commitments you make to your customers.

The Modern Web App pattern uses two design patterns to improve web app reliability: queue-based load leveling and the retry pattern. The Queue-Based Load Leveling pattern improves message-based communication. The Retry pattern improves request-response communication.

### Implement the Queue-Based Load Leveling pattern

The [Queue-Based Load Leveling pattern](/azure/architecture/patterns/queue-based-load-leveling) improves the reliability of code by separating tasks and services with a queue. Unlike synchronous methods, such HTTP, this pattern prevents the workload spikes from directly affecting services. The queue smooths out workload demand and allows services to process tasks at a consistent rate, enhancing the reliability of the system.

**ADD RECOMMENDATIONS for implementing QBLL in .NET web apps**

---
**Example**: The reference implementation is a ticket rendering application. It uses Azure Service Bus as a queue between a web API and its ticket rendering service. The ticket-creation logic creates a request to for ticket rendering rather than rendering it directly.

```csharp
// Publish a message to request that the ticket be rendered.

await messageSender.PublishAsync(new TicketRenderRequestMessage(Guid.NewGuid(), ticket, null, DateTime.Now), CancellationToken.None);
```

The code path waits for the message to be sent, but it does not block waiting for the message to be received and handled. This way, if there are many tickets to be rendered, the web app will remain responsive while waiting for that work to be done. Instead, the Relecloud front end view which displays tickets displays a placeholder message if no image is available yet for a ticket it’s trying to display. This allows the performance of the Relecloud front end and web API to be decoupled from the performance of the ticket rendering service.

```csharp
@if (string.IsNullOrEmpty(ticket.ImageName))

{

    \<div class="offset-top-md alert alert-warning"\>The customer's ticket is being generated, please check back later.\</div\>

}
```

The new ticket rendering service is implemented as an ASP.NET Core hosted service. It doesn’t receive messages via incoming HTTP requests. Instead, it pulls messages from Service Bus using ServiceBusClient.CreateProcessor to create a message processing service. This pattern of pulling work instead of having it pushed allows the ticket rendering service to serve ticket rendering requests as quickly as possible without being overloaded by incoming requests since they will accumulate in the queue rather than in the service itself.

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

---

### Modify the Retry Pattern

The [retry pattern](https://learn.microsoft.com/azure/architecture/patterns/retry) is used extensively in the [reliable web app pattern](https://learn.microsoft.com/azure/architecture/web-apps/guides/reliable-web-app/dotnet/apply-pattern#use-the-retry-pattern) but also shows up in new ways in the modern web app pattern. The retry pattern is a technique for handling transient faults during service-to-service communication and is an important part of any cloud solution. Retry patterns account for connectivity issues, throttling issues, and other temporary outages of dependencies by retrying failed connections, typically with increasing amounts of backoff time. While queue-based load leveling and competing consumers can help improve reliability of message-based communication, the retry pattern is essential for improving reliability of request-response communication.



*Example:* The reference implementation uses retry functionality built into the .NET Azure SDK when configuring connections to both Azure Service Bus and Azure Storage.

While configuring Azure services using the AzureClientFactoryBuilder type, the modern web app reference implementation configures the retry settings by calling ConfigureDefaults and setting retry settings. The default retry settings will be used by all HTTP-based Azure clients, including the blob storage client.

builder.Services.AddAzureClients(clientConfiguration =\>

    {

        // ... Other configuration omitted here for brevity

        clientConfiguration.AddBlobServiceClient(new Uri(storageOptions.Uri));

        clientConfiguration.ConfigureDefaults(options =\>

        {

            options.Retry.Mode = RetryMode.Exponential;

            options.Retry.Delay = TimeSpan.FromSeconds(resilienceOptions.BaseDelaySecondsBetweenRetries);

            options.Retry.MaxRetries = resilienceOptions.MaxRetries;

            options.Retry.MaxDelay = TimeSpan.FromSeconds(resilienceOptions.MaxDelaySeconds);

            options.Retry.NetworkTimeout = TimeSpan.FromSeconds(resilienceOptions.MaxNetworkTimeoutSeconds);

        });

    });

In addition to this configuration, the modern web app reference implementation also specifies retry options to be used by the Azure Service Bus client. These retry settings need to be configured separately from the defaults since the Azure Service Bus Client communicates via AMQP instead of HTTP.

// ServiceBusClient is thread-safe and can be reused for the lifetime of the application.

services.AddSingleton(sp =\>

    {

        var options = sp.GetRequiredService\<IOptions\<MessageBusOptions\>\>().Value;

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

Because the Azure SDK handles retries automatically using the configured settings, no explicit retries are necessary in the reference implementation’s ticket rendering service.

Implementing the retry pattern for the ticket rendering service’s handling of rendering request messages works a bit differently. Because these messages are processed from an Azure Service Bus queue (instead of received via HTTP), the retry pattern is implemented by ensuring that messages are read from the queue using the “[peek-lock](https://learn.microsoft.com/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock)” receive mode. This means that the service will lock messages in the queue while processing them but won’t actually remove them from the queue until processing succeeds. Therefore, if there’s an unexpected error while processing the message, it will be returned to the queue automatically (when the lock expires) and the service will retry processing it. To avoid a malformed message from blocking the queue by continually causing the handler to fail, messages that repeatedly fail to be processed will be moved to a [dead-letter queue](https://learn.microsoft.com/azure/service-bus-messaging/service-bus-dead-letter-queues) for later review.

## Security

Security is a primary pillar of the Well Architected Framework. As you adopt the modern web app pattern, more and more components will be introduced to your solution architecture. New services will be created as monoliths are split into multiple services and new dependencies will be added for message queues or container image repositories. The modern web app pattern doesn’t introduce any new security patterns beyond those already present in the Reliable Web App pattern, but those existing patterns (managed identities, secrets management, and private endpoints) are applied to many new resources.

### Use managed identities

Like the retry pattern, the pattern of using managed identities for authentication and authorization is common in [the reliable web app pattern](https://learn.microsoft.com/en-us/azure/architecture/web-apps/guides/reliable-web-app/dotnet/apply-pattern#use-managed-identities). In the modern web app pattern reference implementation, managed identity use is expanded to all new services – Azure Container Apps, Azure Service Bus, and Azure Container Registry. Managed identity is a secure password-less mechanism for services in Relecloud to authenticate with one another.

*Example:*

The reference implementation makes use of managed identities by configuring the Azure Container Registry resource and the Azure Service Bus resource to allow access to several identities. It configures access for the identity performing the deployment, the user-assigned managed identity corresponding to the application owner, and the user-assigned managed identity corresponding to the application. This is done in infrastructure-as-code using role assignments in bicep as shown here.

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

When creating the Azure Container App resource in bicep, the user-assigned managed identity representing the application is assigned to the ticket renderer’s Azure Container App so that it runs with that identity and is able to access necessary resources. The ASP.NET Core app run in the Container App can retrieve the identity for use programmatically by using DefaultAzureCredential as detailed in [reliable web app pattern documentation](https://learn.microsoft.com/azure/architecture/web-apps/guides/reliable-web-app/dotnet/apply-pattern#use-managed-identities).

module renderingServiceContainerApp 'br/public:avm/res/app/container-app:0.1.0' = {

  name: 'application-rendering-service-container-app'

  scope: resourceGroup()

  params: {

    // Other parameters omitted for brevity

    managedIdentities: {

      userAssignedResourceIds: \[

        managedIdentity.id

      \]

    }

  }

}

## Cost optimization

A modern web app needs to consider costs of services used in order to maximize the business’s return on investment. This doesn’t necessarily mean using only low cost services, but it does mean minimizing unnecessary expenses, improving operational efficiency, and paying only for necessary capacity. One of the benefits as you transition from the reliable web app pattern to the modern web app pattern is that services will become more finely divided and easier to scale in and out so you can better optimize cost by paying for only the capacity and performance needed for your solution even in the face of changing or upredictable demand.

### Automatic horizontal scaling

Automatic horizontal scaling means adding and removing replicas of services automatically based on relevant demand metrics. This allows the service to perform more work when demand is high and to save cost when demand is low. By scaling automatically based on metrics relevant to the application’s scenario, scale operations can be performed quickly and without any need for manual intervention.

*Simulate the pattern:* You can simulate autoscaling under heavy load in the reference implementation by purchasing many tickets at once. The default Relecloud web frontend only allows buying up to 20 tickets in one transaction, but by editing the front end to allow more or by editing the HTML of the site at runtime using browser dev tools, you can purchase 100 or more tickets in one transaction. Purchasing that many tickets at once will trigger the ticket rendering service’s autoscaling rules and additional instances of the service will be added. You will also notice that after five minutes of low traffic, instances are removed as the service automatically scales in.

*Example:* In order to optimize costs, the reference implementation uses [Azure Container Apps autoscaling](https://learn.microsoft.com/azure/container-apps/scale-app). Autoscaling in Azure Container Apps can add or remove instances of Azure Container App replicas based on the number of concurrent HTTP requests, the number of concurrent TCP requests, or on custom [Kubernetes Event-Driven Autoscaler (KEDA)](https://keda.sh/docs/2.13/) scalers. Support for KEDA scalers allows Azure Container Apps to scale based on triggers from dozens of different metrics-based scalers. You can even write your own external KEDA scaler implementations to scale based on metrics custom to your solution.

Autoscaling allows Azure Container Apps to dynamically add or remove instances, potentially even scaling down to zero active instances. Scaling to zero will minimize costs when no work needs done, but developers should be aware that scaling to zero means that there will be a small delay (often several seconds) in spinning the service back up from zero once more work needs to be done. If this delay is not acceptable, you can scale down to one replica instead which will ensure that there’s always a worker ready to handle incoming requests. Azure Container Apps scaling has [cooldown and stabilization window times](https://learn.microsoft.com/azure/container-apps/scale-app?pivots=azure-cli#scale-behavior) so that the scaler pauses after scale operations and does not continually add and remove instances in scenarios of frequently fluctuating demand.

The reference implementation uses the Azure Service Bus KEDA scaler to automatically scale the ticket rendering Container App based on the length of the queue with rendering request messages. The Service Bus KEDA scaler accepts parameters for the namespace and queue to trigger from as well as a messageCount which is set to 10 in the reference implementation. This means that the scaler will aim to have one replica of the service for every ten messages in the queue (rounded up). Azure Container Apps scale settings also allow setting minimum and maximum numbers of replicas that the service can scale to.

Scaling rules can be configured in bicep as part of defining a new Azure Container App. In the reference implementation, minimum replicas is set to zero so that that service can scale in to have no instances running and maximum replicas is set to five. The scaleRules list includes KEDA scale rules. This collection includes the Service Bus scaler. The rule also includes an auth property containing an Azure Container Apps secret that contains the Service Bus queue’s connection string. This secret retrieves its value from Azure Key Vault.

scaleRules: \[

  {

    name: 'service-bus-queue-length-rule'

    custom: {

      type: 'azure-servicebus'

      metadata: {

        messageCount: '10'

        namespace: renderRequestServiceBusNamespace

        queueName: renderRequestServiceBusQueueName

      }

      auth: \[

        {

          secretRef: 'render-request-queue-connection-string'

          triggerParameter: 'connection'

        }

      \]

    }

  }

\]

scaleMaxReplicas: 5

scaleMinReplicas: 0

## Operational excellence

Moving from the reliable web app pattern to the modern web app pattern includes separating logically independent pieces of the application into their own services. This improves operational efficiency by making it possible for these different services to version and update independently. While making these changes, it’s important to also continue abiding by the reliable web app’s patterns of infrastructure-as-code and automated deployments so that infrastructure design and updates are manageable and environments are easily reproduceable.

### Strangler fig

A useful pattern for separating larger services into more granular services is the [strangler fig](https://learn.microsoft.com/azure/architecture/patterns/strangler-fig) pattern. This pattern incrementally modernizes a solution by gradually moving specific logical components to new services. The strangler fig pattern is useful for making incremental progress on large modernization tasks that would be intractable if they had to be completed all at once. Dividing a monolithic solution into finer-grained services allows services to version and scale independently. A service-oriented architecture in which each service is self-contained makes it easy for different teams in an organization to own different services and innovate at the pace that makes sense for them. And when load increases, only the services that represent the performance bottleneck need to scale out. The strangler fig pattern is a useful pattern for transitioning gradually into such an architecture.

In some cases, a strangler fig [façade service](https://learn.microsoft.com/azure/architecture/patterns/strangler-fig#solution) is used to route requests to the various backend solutions while the pattern is being applied. In the case of the reference implementation, such a façade service is not necessary because the ticket rendering service which is separated out doesn’t have any public-facing APIs. However, there is an internal interface used in the solution’s code that allows the web API to consult [a feature flag](https://learn.microsoft.com/azure/azure-app-configuration/manage-feature-flags) and either send messages to its previous in-process ticket rendering implementation or, via an Azure Service Bus message, to the new standalone ticket rendering service.

*Simulate the pattern:* The modern web app reference implementation uses [a feature flag](https://learn.microsoft.com/azure/azure-app-configuration/manage-feature-flags) to enable or disable the standalone ticket rendering service. By default, ticket rendering work is done in a separate service that was implemented according to the strangler fig pattern. To simulate switching between this solution and one without the strangler fig pattern applied, you can navigate to the solution’s Azure App Configuration resource in the Azure Portal and change the value of the DistributedTicketRendering feature flag from true to false (in the feature manager blade). Within 30 seconds, the application should begin rendering tickets in the web API instead of using the separate ticket rendering service (which will scale in to zero active replicas). You can set the feature flag back to true to switch back to using the standalone service for ticket rendering.

*Example:* In the modern web app reference implementation, you can see the new ticket rendering service in the src/Relecloud.TicketRenderer folder of the solution. It takes functionality that was previously part of the web API and implements it in a standalone service. Because the goal of the modern web app reference implementation is to demonstrate moving toward a micro-service architecture, the ticket rendering service does not share data storage with the web API except for the blob container where ticket images are stored. The ticket rendering service does not interact with the web API’s SQL database. Instead, the Service Bus message requesting ticket rendering includes the data necessary to perform the rendering and, once the rendering is completed (as indicated by another Service Bus message queued by the rendering service and received by the web API), the web API updates its database with details on where the ticket image can be retrieved from.

The modern web app reference implementation enables both the old (in-process) and new (separate service) behaviors for ticket rendering so that you can simulate the change from the previous architecture to the new one through the application of the strangler fig pattern. Because of this, an interface is used in the reference web API and different implementations are chosen to render tickets depending on the state of the feature flag.

You will also note that the ticket rendering logic that was moved to the new service was updated to run in a Linux container instead of on Windows. For example, System.Drawing APIs were replaced with cross-platform SkiaSharp alternatives. This was done because Azure Container Apps only supports running Linux Docker containers. As part of the strangler fig pattern, extracted services are often upgraded or updated in some way. The specifics of how they are updated, though, will vary based on your specific context and environment. Updating to run in Linux containers is a detail of the reference implementation’s choice to use Azure Container Apps.

### Health endpoint monitoring

The [health endpoint monitoring pattern](https://learn.microsoft.com/azure/architecture/patterns/health-endpoint-monitoring) is useful for tracking the liveness of services. This is especially important in services that are managed by an orchestrator such as those deployed in Azure Kubernetes Service or Azure Container Apps. These orchestrators can poll health endpoints to make sure services are running properly and restart instances that are not healthy. Both ASP.NET Core and Azure Container Apps support this pattern. ASP.NET Core apps can add dedicated [health check middleware](https://learn.microsoft.com/aspnet/core/host-and-deploy/health-checks) to efficiently serve liveness data, including checking the health of key dependencies. Azure Container Apps allow configuration of [health probes](https://learn.microsoft.com/azure/container-apps/health-probes) that are monitored to gauge whether apps are healthy or in need of recycling.

*Example:* The modern web app reference implementation uses [ASP.NET Core health check middleware](https://learn.microsoft.com/aspnet/core/host-and-deploy/health-checks) to expose endpoints for checking application liveness. It also uses extensions from the popular [AspNetCore.Diagnostics.HealthChecks](https://github.com/Xabaril/AspNetCore.Diagnostics.HealthChecks) open source project so that the service’s health checks will include validating that key dependencies (Azure Service Bus and Azure blob storage) are available.

// Add health checks, including health checks for Azure services that are used by this service.

// The Blob Storage and Service Bus health checks are provided by AspNetCore.Diagnostics.HealthChecks

// (a popular open source project) rather than by Microsoft. https://github.com/Xabaril/AspNetCore.Diagnostics.HealthChecks

builder.Services.AddHealthChecks()

    .AddAzureBlobStorage(options =\>

    {

        // AddAzureBlobStorage will use the BlobServiceClient registered in DI

        // We just need to specify the container name

        options.ContainerName = builder.Configuration.GetRequiredConfigurationValue("App:StorageAccount:Container");

    })

    .AddAzureServiceBusQueue(

        builder.Configuration.GetRequiredConfigurationValue("App:ServiceBus:Host"),

        builder.Configuration.GetRequiredConfigurationValue("App:ServiceBus:RenderRequestQueueName"),

        azureCredentials);

 

// Further app configuraiton omitted for brevity

app.MapHealthChecks("/health");

These health checks are used by the Azure Container App to monitor the liveness of service replicas. The health check endpoint configuration is defined for the ticket rendering service Container App in the app’s bicep template.

probes: \[

  {

    type: 'liveness'

    httpGet: {

      path: '/health'

      port: 8080

    }

    initialDelaySeconds: 2

    periodSeconds: 10

  }

\]

### Containerized service deployment

An important part of the modern web app pattern is dividing services according to domain boundaries (as discussed in the strangler fig pattern). As new services are created by these divisions, containerization of the new services provides many benefits:

- **Dependency encapsulation**. Containers provide consistent, encapsulated environments for running workloads, so that you can have confidence that a service will always run the same way regardless of the host environment. All necessary dependencies are included in the container itself so there’s no need to configure dependencies for the container to work in a new environment.

- **Portability**. Containers are supported across a wide range of hosting services. Azure App Service, Azure Kubernetes Service, and Azure Container Apps all run Docker containers so an application deployed as a Docker container can easily deploy into any of these environments or into any other environment that runs the Docker engine.

- **Efficiency and scalability**. Because containers share the host system’s kernel, they consume fewer resources than other isolation solutions such as virtual machines. They can be more tightly packed on a host and start up quickly. This makes them ideal for implementing other patterns discussed in this guidance such as the competing consumers pattern.

*Example:* The reference implementation publishes the new ticket rendering service as a [Docker container image](https://learn.microsoft.com/dotnet/core/docker/introduction). This means that all dependencies for the app to function are

encapsulated in a lightweight image that can be reliably deployed to a wide range of hosts including, in the case of the reference implementation, Azure Container Apps. The reference implementation uses a [multi-stage](https://docs.docker.com/build/building/multi-stage/) Dockerfile which first builds the solution in a Docker container (based on a mcr.microsoft.com/dotnet/sdk image) and then publishes the final service in a separate smaller container.

\## Build Stage

\# Build in a separate stage to avoid copying the SDK into the final image

FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build

ARG BUILD_CONFIGURATION=Release

WORKDIR /src

\# Restore packages

COPY \["Relecloud.TicketRenderer/Relecloud.TicketRenderer.csproj", "Relecloud.TicketRenderer/"\]

COPY \["Relecloud.Messaging/Relecloud.Messaging.csproj", "Relecloud.Messaging/"\]

COPY \["Relecloud.Models/Relecloud.Models.csproj", "Relecloud.Models/"\]

RUN dotnet restore "./Relecloud.TicketRenderer/Relecloud.TicketRenderer.csproj"

\# Build and publish

COPY . .

WORKDIR "/src/Relecloud.TicketRenderer"

RUN dotnet publish "./Relecloud.TicketRenderer.csproj" -c \$BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

\## Runtime Stage

\# Chiseled images contain only the minimal set of packages needed for .NET 8.0

FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled AS final

WORKDIR /app

EXPOSE 8080

\# Copy the published app from the build stage

COPY --from=build /app/publish .

\# Run as non-root user

USER \$APP_UID

ENTRYPOINT \["dotnet", "./Relecloud.TicketRenderer.dll"\]

The ticket rendering service uses a chiseled base image (mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled) so that only the minimal set of packages needed for ASP.NET Core to run are included. This reduces the size of the container image and improves security by reducing attack surface area. The service’s Dockerfile also specifies that the container should run with [a non-root user](https://devblogs.microsoft.com/dotnet/securing-containers-with-rootless/) in keeping with the principle of least privilege.

The ticket rendering service is built on Linux-based .NET base images, but .NET Docker containers can be built on either Windows or Linux base images. Because the reference implementation uses Azure Container Apps, however, Linux Docker images are required for this scenario.

## Performance efficiency

Performance represents the ability of a solution to function efficiently even as workload demands change. As applications move from the reliable web app pattern to the modern web app pattern, it should be possible to improve performance because of increased decoupling of application services. In a modern web app, one component slowing down should not negatively affect the performance of other components. One pattern supporting the pillar of performance that has already been discussed is queue-based load leveling. Queue-based load leveling provides both reliability benefits (for the worker service) and performance benefits (for the calling task). Another related pattern which is often paired with queue-based load leveling which can improve performance in the worker service is the competing consumers pattern.

### Competing consumers

The [competing consumers pattern](https://learn.microsoft.com/azure/architecture/patterns/competing-consumers) allows incoming work to be efficiently handled by multiple parallel workers. This pattern enables handling bursts of demand by temporarily scaling workers horizontally which are designed such that they can all consume work requests from a message queue in parallel. This pattern can be used if your solution is designed so that message ordering doesn’t matter, malformed messages don’t block the queue, and processing is idempotent so that messages that aren’t successfully handled by one worker can be picked up by another without fear of errors due to processing the message more than once.

*Simulate the pattern:* You can simulate the benefits of competing consumers in the Relecloud modern web app reference implementation by purchasing many tickets at once (100 or more). This will cause many ticket rendering requests to be queue in Azure Service Bus. The requests are quickly handled, though, because the ticket rendering service will automatically scale out and handle the requests in parallel.

*Example:* The reference implementation uses a stateless Azure Container App to process ticket rendering requests from an Azure Service Bus queue.

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

processor.ProcessMessageAsync += async args =\>

{

    logger.LogInformation("Processing message {MessageId} from {ServiceBusNamespace}/{Path}", args.Message.MessageId, args.FullyQualifiedNamespace, args.EntityPath);

    // Unhandled exceptions in the handler will be caught by the processor and result in abandoning and dead-lettering the message

    try

    {

        var message = args.Message.Body.ToObjectFromJson\<T\>();

        await messageHandler(message, args.CancellationToken);

        logger.LogInformation("Successfully processed message {MessageId} from {ServiceBusNamespace}/{Path}", args.Message.MessageId, args.FullyQualifiedNamespace, args.EntityPath);

    }

    catch (JsonException)

    {

        logger.LogError("Invalid message body; could not be deserialized to {Type}", typeof(T));

        await args.DeadLetterMessageAsync(args.Message, \$"Invalid message body; could not be deserialized to {typeof(T)}", cancellationToken: args.CancellationToken);

    }

};

Important items to note in the implementation of the Service Bus processor are:

- Work is retrieved from Service Bus using **peek-lock** receive mode so that if a worker fails while processing a request, the request will simply be returned to the queue and handled by a different worker. Also, the ticket rendering service is implemented such that processing a request twice will not cause any problems. This avoids errors in the case of a worker failing after already completing some or all of the processing work.

- Persistent errors such as malformed JSON in messages are handled by sending messages to a **dead-letter queue**. This prevents malformed messages from clogging the queue.

- **MaxConcurrentCalls** is set to 1 and **PrefetchCount** is set to 0 since scaling is expected to happen in Azure Container Apps, so it’s not necessary for an individual worker to optimize for handling many messages at once.

Also important is that images are written to Blob Storage in such a way that writing to the same blob twice will simply overwrite the older one rather than causing a failure. This is important when using peek-lock receive mode since it’s possible that in rare circumstances the same rendering request might be processed twice. Scaling is performed automatically based on queue length, as described in the cost optimization section.

# Next steps

You can deploy the reference implementation by following the instructions in the [modern web app pattern for .NET repository](https://github.com/azure/modern-web-app-pattern-dotnet). There are instructions for both development and production deployment of the reference implementation. Once deployed, you can observe the patterns described in this document in action.

For additional learning, consult the resources below.

## Cloud best practices

- [Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/). A set of guiding tenets for architecting cloud workloads, the principles of the Well-Architected Framework underly both the reliable web app pattern and the modern web app pattern.

- [Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/overview). Can help your organization prepare and execute a strategy to build solutions on Azure.

- [Mission-Critical Workloads](https://learn.microsoft.com/en-us/azure/architecture/framework/mission-critical/mission-critical-overview). Useful guidance for scenarios that require a higher SLO than the modern web app pattern.

## Azure migration guidance

- [Azure Migrate](https://learn.microsoft.com/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.

- [Azure Database Migration Guides](https://learn.microsoft.com/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.

- [Azure Migrate Application and Code Assessment](https://learn.microsoft.com/azure/migrate/appcat/) is a set of static analysis tools for .NET and Java that assess the readiness of applications to run in Azure platform-as-a-service environments like Azure App Service, Azure Kubernetes Service, Azure Container Apps, and Azure Spring Apps. Azure Migrate Application and Code Assessment differs from other Azure Migrate tooling by focusing specifically on the source code of applications for deep application-level guidance.

## .NET upgrade guidance

When applying the modern web app pattern, it’s common to begin running in containers. As part of this transition, you may want to run on Linux which requires upgrading from .NET Framework to more recent versions of .NET. This can be a non-trivial process, especially for ASP.NET apps. But guidance and tooling as available to help.

- [Overview of porting from .NET Framework to .NET](https://learn.microsoft.com/dotnet/core/porting/). Get guidance based on your specific type of .NET app.

- [.NET Upgrade Assistant](https://learn.microsoft.com/dotnet/core/porting/upgrade-assistant-overview) is a tool (available as a Visual Studio extension or a command line tool) that helps identify and, in many cases, automatically fix issues associated with .NET upgrade scenarios.

- [Incremental ASP.NET to ASP.NET Core upgrade](https://learn.microsoft.com/aspnet/core/migration/inc/overview) is the recommended approach to upgrading large web applications which can be difficult to modernize.
