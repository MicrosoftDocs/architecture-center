---
ms.custom:
  - devx-track-dotnet
---
The reliable web app pattern provides essential guidance to move web apps to the cloud. The pattern is a set of principles and implementation techniques. They define how you should update (replatform) your web app to be successful in the cloud.

This article provides code and architecture guidance for the reliable web app pattern. The companion article provides **[planning guidance](plan-implementation.yml)**. There's a **[reference implementation](https://aka.ms/eap/rwa/dotnet)** in GitHub that you can deploy.

## Architecture

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-dotnet.svg)](../../_images/reliable-web-app-dotnet.svg)
*Figure 1. Target reference implementation architecture. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet.vsdx) of this architecture. For the estimated cost of this architecture, see the [production environment cost](https://azure.com/e/26f1165c5e9344a4bf814cfe6c85ed8d) and [nonproduction environment cost](https://azure.com/e/8a574d4811a74928b55956838db71093).*

## Reliability

The reliable web app pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Use the Retry pattern

The [Retry pattern](/azure/architecture/patterns/retry) addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults), which usually resolve within seconds. These faults often result from service throttling, dynamic load distribution, and network issues in cloud environments. Implementing the Retry pattern involves resending failed requests, allowing configurable delays and attempts before conceding failure.

Applications using the Retry pattern should integrate Azure's client software development kits (SDKs) and service-specific retry mechanisms for enhanced efficiency. Applications lacking this pattern should adopt it using the following guidance.

#### Try the Azure service and client SDKs first

Most Azure services and client SDKs have a [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific). You should use the built-in retry mechanism for Azure services to expedite the implementation.

*Reference implementation:* The reference implementation uses the connection resiliency mechanism in Entity Framework Core to apply the Retry pattern in requests to [Azure SQL Database](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core). See [Connection Resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency).

```csharp
services.AddDbContextPool<ConcertDataContext>(options => options.UseSqlServer(sqlDatabaseConnectionString,
    sqlServerOptionsAction: sqlOptions =>
    {
        sqlOptions.EnableRetryOnFailure(
        maxRetryCount: 5,
        maxRetryDelay: TimeSpan.FromSeconds(3),
        errorNumbersToAdd: null);
    }));
```

#### Use the Polly library when the client library doesn't support retries

You might need to make calls to a dependency that isn't an Azure service or doesn't support the Retry pattern natively. In that case, you should use the Polly library to implement the Retry pattern. [Polly](https://github.com/App-vNext/Polly) is a .NET resilience and transient-fault-handling library. With it, you can use fluent APIs to describe behavior in a central location of the application.

*Reference implementation:* The reference implementation uses Polly to set up the ASP.NET Core dependency injection. Polly enforces the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object. In the Polly framework, that behavior is known as a *policy*. The code extracts this policy in the `GetRetryPolicy` method, and the `GetRetryPolicy` method applies the Retry pattern every time the front-end web app calls web API services. The following code applies the Retry pattern to all service calls to the concert search service.

```csharp
private void AddConcertSearchService(IServiceCollection services)
{
    var baseUri = Configuration["App:RelecloudApi:BaseUri"];
    if (string.IsNullOrWhiteSpace(baseUri))
    {
        services.AddScoped<IConcertSearchService, MockConcertSearchService>();
    }
    else
    {
        services.AddHttpClient<IConcertSearchService, RelecloudApiConcertSearchService>(httpClient =>
        {
            httpClient.BaseAddress = new Uri(baseUri);
            httpClient.DefaultRequestHeaders.Add(HeaderNames.Accept, "application/json");
            httpClient.DefaultRequestHeaders.Add(HeaderNames.UserAgent, "Relecloud.Web");
        })
        .AddPolicyHandler(GetRetryPolicy())
        .AddPolicyHandler(GetCircuitBreakerPolicy());
    }
}

private static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    var delay = Backoff.DecorrelatedJitterBackoffV2(TimeSpan.FromMilliseconds(500), retryCount: 3);
    return HttpPolicyExtensions
      .HandleTransientHttpError()
      .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
      .WaitAndRetryAsync(delay);
}
```

The policy handler for the `RelecloudApiConcertSearchService` instance applies the Retry pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry and then to retry the request based on the configuration. It includes some randomness to smooth out potential bursts in traffic to the API if an error occurs.

You can simulate the Retry pattern in the reference implementation. For instructions, see [Simulate the Retry pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#retry-pattern).

### Use the Circuit Breaker pattern

You should pair the Retry pattern with the Circuit Breaker pattern. The Circuit Breaker pattern handles faults that aren't transient. The goal is to prevent an application from repeatedly invoking a service that is down. The Circuit Breaker pattern releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users. For more information, see the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker).

*Reference implementation:* The reference implementation adds the Circuit Breaker pattern in the `GetCircuitBreakerPolicy` method (*see code for an example*).

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

In the code, the policy handler for the `RelecloudApiConcertSearchService` instance applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time. For more information, see [Implement the Circuit Breaker pattern](/dotnet/architecture/microservices/implement-resilient-applications/implement-circuit-breaker-pattern#implement-circuit-breaker-pattern-with-ihttpclientfactory-and-polly).

You can simulate the Circuit Breaker pattern in the reference implementation. For instructions, see [Simulate the Circuit Breaker pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#circuit-breaker-pattern).

## Security

The reliable web app pattern uses managed identities to implement identity-centric security. Private endpoints, web application firewall, and restricted access to the web app provide a secure ingress.

### Use managed identities

Managed identities allow Azure resources to securely access resources without hard-coded credentials. Use managed identities where possible to automate authentication processes. Managed identities are similar to trusted connections and integrated security in on-premises applications that permit database authentication without exposing credentials in configuration files. Managed identities provide a more traceable way to control access to Azure resources than connection strings stored in Azure Key Vault. For more information, see:

- [Managed identities for developers](/entra/identity/managed-identities-azure-resources/overview-for-developers)
- [Monitoring managed identities](/entra/identity/managed-identities-azure-resources/how-to-view-managed-identity-activity)
- [Managed identity overview](/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure services supporting managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identities-status)
- [Web app managed identity](/azure/active-directory/develop/multi-service-web-app-access-storage)

Managed identities have two components. There's a code component and the infrastructure component. You should use the `DefaultAzureCredential` class from the Azure SDK library to set up the code and infrastructure as code (IaC) to deploy the infrastructure.

#### Use DefaultAzureCredential to set up code

Use `DefaultAzureCredential` to provide credentials for local development and managed identities in the cloud. `DefaultAzureCredential` generates a `TokenCredential` for OAuth token acquisition. It handles most Azure SDK scenarios and Microsoft client libraries. It detects the application's environment to use the correct identity and requests access tokens as needed. `DefaultAzureCredential` streamlines authentication for Azure-deployed applications For more information, see [DefaultAzureCredential](/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet).

*Reference implementation:* The reference implementation uses the `DefaultAzureCredential` class during start up to enable the use of managed identity between the web API and Key Vault (*see code for an example*).

```csharp
builder.Configuration.AddAzureAppConfiguration(options =>
{
     options
        .Connect(new Uri(builder.Configuration["Api:AppConfig:Uri"]), new DefaultAzureCredential())
        .ConfigureKeyVault(kv =>
        {
            // Some of the values coming from Azure App Configuration are stored Key Vault. Use
            // the managed identity of this host for the authentication.
            kv.SetCredential(new DefaultAzureCredential());
        });
});
```

#### Use infrastructure as code to create managed identities

You should use Bicep templates to create and configure the Azure infrastructure to support managed identities. Managed identities don't use secrets or passwords, so you don't need Key Vault or a secret rotation strategy to ensure integrity. You can store the connection strings in the App Configuration Service.

*Reference implementation:* The reference implementation uses Bicep templates to (1) create the managed identity, (2) associate the identity with the web app, and (3) grant the identity permission to access the SQL database. The `Authentication` argument in the connection string tells the Microsoft client library to connect with a managed identity (*see code for an example*).

```csharp
    Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default
 ```

For more information, see [Connect to SQL database from .NET App Service](/azure/app-service/tutorial-connect-msi-sql-database).

#### Use a central secrets store to manage secrets

For Azure services not compatible with managed identities, store application secrets in Azure Key Vault as a central repository. Azure Key Vault enables secure storage, key rotation, and access auditing of secrets. Additionally, Key Vault supports monitoring for enhanced security oversight. Store application configurations in Azure App Configuration.

*Reference implementation:*

- Microsoft Entra client secret: The reference implementation uses Key Vault to store the Microsoft Entra client secret. The web app's on-behalf-of authentication flow requires it. To update the secret, generate a new one in Key Vault and restart the web app restart to apply the change. Remove the old secret.

- Azure Cache for Redis secret: Azure Cache for Redis doesn't support managed identities. Rotate the key and update Key Vault with the new connection string. Restart the web app for changes to take effect. Key regeneration is managed through the Azure CLI or portal.

### Use private endpoints

By default, service communication to most Azure services crosses the public internet. Use private endpoints to secure Azure service endpoints. Private endpoints don't require any app configuration, connection string, or code changes. Putting the web app platform behind a private endpoint requires extra configuration for app code deployment. For more information, see [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario) and [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints).

*Reference implementation:* Azure App Configuration, Azure SQL Database, Azure Cache for Redis, Azure Storage, Azure App Service, and Key Vault use a private endpoint.

### Use web application firewall and restrict inbound internet traffic

All inbound internet traffic to the web app must pass through a web application firewall to protect against common web exploits. Force all inbound internet traffic to pass through the public load balancer, if you have one, and the web application firewall.

*Reference implementation:* The reference implementation forces all inbound internet traffic through Front Door and Azure Web Application Firewall. In production, [preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

## Cost optimization

The reliable web app pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize resources for each environment

Understand the different performance tiers of Azure services and only use the appropriate SKU for the needs of each environment. Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Nonproduction environments typically don't need the same capabilities. For extra savings, consider [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview), [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

*Reference implementation:* The reference implementation uses Bicep parameters to trigger resource deployment configurations. One of these parameters tells Azure Resource Manager which SKUs to deploy. The following code gives Azure Cache for Redis different SKUs for production and nonproduction environments:

```bicep
var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
var redisCacheFamilyName = isProd ? 'C' : 'C'
var redisCacheCapacity = isProd ? 1 : 0
```

The web app uses the more performant and expensive SKU for the production environment (Standard C1 SKU) and the cheaper SKU (Basic C0 SKU) for the nonproduction environment.

### Use autoscale

Autoscale automates horizontal scaling for production environments. Autoscale based on performance metrics. CPU utilization performance triggers are a good starting point if you don't understand the scaling criteria of your application. You need to configure and adapt scaling triggers (CPU, RAM, network, and disk) to correspond to the behavior of your web application. Don't scale vertically to meet frequent changes in demand. It's less cost efficient. For more information, see [Scaling in Azure App Service](/azure/app-service/manage-scale-up) and [Autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview).

*Reference implementation:* The reference implementation uses the following configuration in the Bicep template. It creates an autoscale rule for the Azure App Service. The rule scales up to 10 instances and defaults to one instance. It uses CPU usage as the trigger for scaling in and out. The web app hosting platform scales out at 85% CPU usage and scales in at 60%. The scale-out setting of 85%, rather than a percentage closer to 100%, provides a buffer to protect against accumulated user traffic caused by sticky sessions. It also protects against high bursts of traffic by scaling early to avoid maximum CPU usage. These autoscale rules aren't universal.

```csharp
resource autoScaleRule 'Microsoft.Insights/autoscalesettings@2022-10-01' = if (autoScaleSettings != null) { 
  name: '${name}-autoscale' 
  location: location 
  tags: tags 
  properties: { 
    targetResourceUri: appServicePlan.id 
    enabled: true 
    profiles: [ 
      { 
        name: 'Auto created scale condition' 
        capacity: { 
          minimum: string(zoneRedundant ? 3 : autoScaleSettings!.minCapacity) 
          maximum: string(autoScaleSettings!.maxCapacity) 
          default: string(zoneRedundant ? 3 : autoScaleSettings!.minCapacity) 
        } 
        rules: [ 
          ... 
        ] 
      } 
    ] 
  } 
}
```

### Use resources efficiently

- *Use shared services.* Centralizing and sharing certain resources provides cost optimization and lower management overhead. Place shared network resources in the hub virtual network.

    *Reference implementation.* The reference implementation places Azure Firewall, Azure Bastion, and Key Vault in the hub virtual network.

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the Bicep template. Use the what-if operation to preview the changes before they take effect. Back up data you need later. Understand the dependencies on the resource you're deleting. If there are dependencies, you might need to update or remove those resources as well. For more information, see [Bicep deployment what-if operation](/azure/azure-resource-manager/bicep/deploy-what-if).

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

    *Reference implementation:* The reference implementation uses a single Azure Cache for Redis instance for session management in both front-end (storing cart and MSAL tokens) and back-end (holding Upcoming Concerts data) web apps. It opts for the smallest Redis SKU, offering more than needed capacity, efficiently utilized by employing multiple data types to control costs.

## Operational excellence

The reliable web app pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Automate deployment

Use a CI/CD pipeline to deploy changes from source control to production. If you're using Azure DevOps, you should use Azure Pipelines. If you're using GitHub, use GitHub actions. Azure supports ARM template (JSON), Bicep, and Terraform and has templates for every Azure resource For more information, see [Bicep, ARM, and Terraform templates](/azure/templates/) and [Repeatable infrastructure](/azure/architecture/framework/devops/automation-infrastructure).

*Reference implementation:* The reference implementation uses Azure Dev CLI and infrastructure as code (Bicep templates) to create Azure resources, setup configuration, and deploy the required resources.  

### Configure monitoring

To monitor your web app, collect and analyze metrics and logs from your application code, infrastructure (runtime), and the platform (Azure resources). Add a diagnostic setting for every Azure resource in your architecture. Each Azure service has a different set of logs and metrics you can capture. For more information, see [Monitor the platform](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#monitoring) and [Monitor App Service](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service-2).

#### Monitor baseline metrics

Use Azure Application Insights to track baseline metrics, such as request throughput, average request duration, errors, and dependency monitoring. Use `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable telemetry collection. For more information, see [Enable Application Insights telemetry](/azure/azure-monitor/app/asp-net-core) and [Dependency injection in .NET](/dotnet/core/extensions/dependency-injection).

*Reference implementation:* The reference implementation uses the following code to configure baseline metrics in Application Insights.

```csharp
public void ConfigureServices(IServiceCollection services)
{
   ...
   services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
   ...
}
```

#### Create custom telemetry as needed

Use Application Insights to gather custom telemetry to better understand your web app users. Create an instance of the `TelemetryClient` class and use the `TelemetryClient` methods to create the right metric. For more information, see:

- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics#trackevent)
- [TelemetryClient class](/dotnet/api/microsoft.applicationinsights.telemetryclient)
- [Telemetry client methods](/dotnet/api/microsoft.applicationinsights.telemetryclient)

*Reference implementation:* The reference implementation augments the web app with metrics that help the operations team identify that the web app is completing transactions successfully. It validates that the web app is online by monitoring whether customers can place orders, not by measuring the number of requests or CPU usage. The reference implementation uses `TelemetryClient` via dependency injection and the `TrackEvent` method to gather telemetry on events related to cart activity. The telemetry tracks the tickets that users add, remove, and purchase.

- `AddToCart` counts how many times users add a certain ticket (`ConcertID`) to the cart.
- `RemoveFromCart` records tickets that users remove from the cart.
- `CheckoutCart` records an event every time a user buys a ticket.

The following code uses `this.telemetryClient.TrackEvent` to count the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies the output (a dictionary that has the `concertId` and `count`). You should turn the query into an Azure Dashboard widget.

```csharp
this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
    { "ConcertId", concertId.ToString() },
    { "Count", count.ToString() }
});
```

For more information, see [Application Insights TrackEvent](/azure/azure-monitor/app/api-custom-events-metrics#trackevent).

#### Gather log-based metrics

Track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. For more information, see [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics) and [Log-based and preaggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics).

## Performance efficiency

The reliable web app pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Use the Cache-Aside pattern

The [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) is a caching strategy that improves in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. When the web app receives a data request, it first searches the cache. If the data is missing, it retrieves it from the database, responds to the request, and updates the cache accordingly. This approach shortens response times and enhances throughput and reduces the need for more scaling. It also bolsters service availability by reducing the load on the primary datastore and minimizing outage risks.

*Reference implementation:* The reference implementation enhances application efficiency by caching critical data, such as information for upcoming concerts crucial for ticket sales. It uses ASP.NET Core's distributed memory cache for in-memory item storage. The application automatically uses Azure Cache for Redis when it finds a specific connection string. It also supports local development environments without Redis to simplify setup and reduce costs and complexity. The following method (`AddAzureCacheForRedis`) configures the application to use Azure Cache for Redis.

```csharp
private void AddAzureCacheForRedis(IServiceCollection services)
{
    if (!string.IsNullOrWhiteSpace(Configuration["App:RedisCache:ConnectionString"]))
    {
        services.AddStackExchangeRedisCache(options =>
        {
            options.Configuration = Configuration["App:RedisCache:ConnectionString"];
        });
    }
    else
    {
        services.AddDistributedMemoryCache();
    }
}
```

For more information, see [Distributed caching in ASP.NET Core](/aspnet/core/performance/caching/distributed) and [AddDistributedMemoryCache method](/dotnet/api/microsoft.extensions.dependencyinjection.memorycacheservicecollectionextensions.adddistributedmemorycache). You can simulate the Cache-Aside pattern in the reference implementation. For instructions, see [Simulate the Cache-Aside pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#cache-aside-pattern).

#### Cache high-need data

Prioritize caching for the most frequently accessed data. Identify key data points that drive user engagement and system performance. Implement caching strategies specifically for these areas to optimize the effectiveness of the Cache-Aside pattern, significantly reducing latency and database load.

*Reference implementation:* The reference implementation caches the data that supports the Upcoming Concerts. The Upcoming Concerts page creates the most queries to SQL Database and produces a consistent output for each visit. The Cache-Aside pattern caches the data after the first request for this page to reduce the load on the database. The following code uses the `GetUpcomingConcertsAsync` method to pull data into the Redis cache from SQL Database. The method populates the cache with the latest concerts. The method filters by time, sorts the data, and returns the data to the controller to display the results.

```csharp
public async Task<ICollection<Concert>> GetUpcomingConcertsAsync(int count)
{
    IList<Concert>? concerts;
    var concertsJson = await this.cache.GetStringAsync(CacheKeys.UpcomingConcerts);
    if (concertsJson != null)
    {
        // There is cached data. Deserialize the JSON data.
        concerts = JsonSerializer.Deserialize<IList<Concert>>(concertsJson);
    }
    else
    {
        // There's nothing in the cache. Retrieve data from the repository and cache it for one hour.
        concerts = await this.database.Concerts.AsNoTracking()
            .Where(c => c.StartTime > DateTimeOffset.UtcNow && c.IsVisible)
            .OrderBy(c => c.StartTime)
            .Take(count)
            .ToListAsync();
        concertsJson = JsonSerializer.Serialize(concerts);
        var cacheOptions = new DistributedCacheEntryOptions {
            AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1)
        };
        await this.cache.SetStringAsync(CacheKeys.UpcomingConcerts, concertsJson, cacheOptions);
    }
    return concerts ?? new List<Concert>();
}
```

#### Keep cache data fresh

Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information.

*Reference implementation:* The reference implementation caches data only for one hour. It has a process for clearing the cache key when the data changes. The following code from the `CreateConcertAsync` method clears the cache key.

```csharp
public async Task<CreateResult> CreateConcertAsync(Concert newConcert)
{
    database.Add(newConcert);
    await this.database.SaveChangesAsync();
    this.cache.Remove(CacheKeys.UpcomingConcerts);
    return CreateResult.SuccessResult(newConcert.Id);
}
```

#### Ensure data consistency

Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

*Reference implementation:* The reference implementation uses the `UpdateConcertAsync` method to keep the data in the cache consistent.

```csharp
public async Task<UpdateResult> UpdateConcertAsync(Concert existingConcert), 
{
   database.Update(existingConcert);
   await database.SaveChangesAsync();
   this.cache.Remove(CacheKeys.UpcomingConcerts);
   return UpdateResult.SuccessResult();
}
```

## Next steps

Deploy the reference implementation by following the instructions in the [reliable web app pattern for .NET repository](https://aka.ms/eap/rwa/dotnet). Use the following resources to learn more about .NET applications, web apps, cloud best practices, and migration.

### Upgrading .NET Framework applications

The reference implementation deploys to an App Service that runs Windows, but it can run on Linux. The App Service Windows platform enables you to move .NET Framework web apps to Azure without upgrading to newer framework versions. For information about Linux App Service plans or new features and performance improvements added to the latest versions of .NET, see the following guidance.

- [Overview of porting from .NET Framework to .NET](/dotnet/core/porting/). Get guidance based on your specific type of .NET app.
- [Overview of the .NET Upgrade Assistant](/dotnet/core/porting/upgrade-assistant-overview). Learn about a console tool that can help you automate many of the tasks associated with upgrading .NET Framework projects.
- [Migrating from ASP.NET to ASP.NET Core in Visual Studio](https://devblogs.microsoft.com/dotnet/introducing-project-migrations-visual-studio-extension/). Learn about a Visual Studio extension that can help you with incremental migrations of web apps.

### Introduction to web apps on Azure

For a hands-on introduction to .NET web applications on Azure, see this [guidance for deploying a basic .NET web application](https://github.com/Azure-Samples/app-templates-dotnet-azuresql-appservice).

### Cloud best practices

For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). Can help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that can be used to improve the quality of a workload.

For applications that require a higher SLO than the reliable web app pattern, see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.