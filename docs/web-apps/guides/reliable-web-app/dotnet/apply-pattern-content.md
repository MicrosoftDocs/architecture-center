---
ms.custom: devx-track-dotnet
---
This article shows you how to apply the Reliable Web App pattern. The Reliable Web App pattern is a set of [principles and implementation techniques](../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/dotnet)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-dotnet.svg)](../../_images/reliable-web-app-dotnet.svg)
*Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To apply the Reliable Web App pattern, follow these recommendations aligned to the pillars of the Well-Architected Framework:

## Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Use the Retry pattern

The [Retry pattern](/azure/architecture/patterns/retry) addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults), which usually resolve within seconds. These faults often result from service throttling, dynamic load distribution, and network issues in cloud environments. Implementing the Retry pattern involves resending failed requests, allowing configurable delays and attempts before conceding failure.

Applications using the Retry pattern should integrate Azure's client software development kits (SDKs) and service-specific retry mechanisms for enhanced efficiency. Applications lacking this pattern should adopt it using the following guidance.

#### Try the Azure service and client SDKs first

Most Azure services and client SDKs have a [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific). You should use the built-in retry mechanism for Azure services to expedite the implementation.

*Example:* The reference implementation uses the [connection resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency) to apply the Retry pattern in requests to [Azure SQL Database](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core) (*see the following code*).

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

*Example:* The reference implementation uses Polly to set up the ASP.NET Core dependency injection. Polly enforces the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object. In the Polly framework, that behavior is known as a *policy*. The code extracts this policy in the `GetRetryPolicy` method, and the `GetRetryPolicy` method applies the Retry pattern every time the front-end web app calls web API concert search services  (*see the following code*).

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

### Use the Circuit Breaker pattern

Pairing the Retry and Circuit Breaker patterns expands an application's capability to handle service disruptions that aren't related to transient faults. The [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) prevents an application from continuously attempting to access a nonresponsive service. The Circuit Breaker pattern releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users.

*Example:* The reference implementation adds the Circuit Breaker pattern in the `GetCircuitBreakerPolicy` method (*see the following code*).

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

In the code, the policy handler for the `RelecloudApiConcertSearchService` instance applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). The Reliable Web App pattern uses managed identities to implement identity-centric security. Private endpoints, web application firewall, and restricted access to the web app provide a secure ingress.

### Enforce least privileges

To ensure security and efficiency, only grant users (user identities) and Azure services (workload identities) the permissions they need.

#### Assign permissions to user identities

Assess your application's needs to define a set of roles that cover all user actions without overlap. Map each user to the most appropriate role. Ensure they receive access only to what's necessary for their duties.

#### Assign permissions to workload identities

Grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities.

- *Prefer role-based access control (RBAC).* Always start with [Azure RBAC](/azure/role-based-access-control/overview) to assign permissions. It offers precise control, ensuring access is both auditable and granular. Use Azure RBAC to grant only the permissions necessary for the service to perform its intended functions.

- *Supplement with Azure service-level access controls.* If Azure RBAC doesn't cover a specific scenario, supplement with Azure-service level access policies.

### Configure user authentication and authorization

Authentication and authorization are critical aspects of web application security. *Authentication* is the process of verifying the identity of a user. *Authorization* specifies the actions a user is allowed to perform within the application. The goal is to implement authentication and authorization without weakening your security posture. To meet this goal, you need to use the features of the Azure application platform (Azure App Service) and identity provider (Microsoft Entra ID).

#### Configure user authentication

Secure your web app by enabling user authentication through your platform's features. [Azure App Service](/azure/app-service/overview-authentication-authorization) supports authentication with identity providers like Microsoft Entra ID, offloading the authentication workload from your code.

### Configure service authentication and authorization

Configure service authentication and authorization so the services in your environment have the permissions to perform necessary functions. Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) in Microsoft Entra ID to automate the creation and management of service identities, eliminating manual credential management. A managed identity allows your web app to securely access Azure services, like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments to Azure App Service. However, in scenarios like hybrid deployments or with legacy systems, continue using your on-premises authentication solutions to simplify migration. Transition to managed identities when your system is ready for a modern identity management approach. For more information, see [Monitoring managed identities](/entra/identity/managed-identities-azure-resources/how-to-view-managed-identity-activity).

#### Use DefaultAzureCredential to set up code

Use `DefaultAzureCredential` to provide credentials for local development and managed identities in the cloud. `DefaultAzureCredential` generates a `TokenCredential` for OAuth token acquisition. It handles most Azure SDK scenarios and Microsoft client libraries. It detects the application's environment to use the correct identity and requests access tokens as needed. `DefaultAzureCredential` streamlines authentication for Azure-deployed applications For more information, see [DefaultAzureCredential](/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet).

*Example:* The reference implementation uses the `DefaultAzureCredential` class during start up to enable the use of managed identity between the web API and Key Vault  (*see the following code*).

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

*Example:* The reference implementation uses Bicep templates to (1) create the managed identity, (2) associate the identity with the web app, and (3) grant the identity permission to access the SQL database. The `Authentication` argument in the connection string tells the Microsoft client library to connect with a managed identity  (*see the following code*).

```csharp
    Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default
 ```

For more information, see [Connect to SQL database from .NET App Service](/azure/app-service/tutorial-connect-msi-sql-database).

### Use a central secrets store to manage secrets

When you move your application to the cloud, use [Azure Key Vault](/azure/key-vault/secrets/about-secrets) to securely store all such secrets. This centralized repository offers secure storage, key rotation, access auditing, and monitoring for services not supporting managed identities. For application configurations, [Azure App Configuration](/azure/azure-app-configuration/overview) is recommended.

*Example:* The reference implementation stores the following secrets in Key Vault: (1) PostgreSQL database username and password, (2) Redis Cache password, and (3) the client secret for Microsoft Entra ID associated with the Microsoft Authentication Library (MSAL) implementation.

#### Don't put Key Vault in the HTTP-request flow

Load secrets from Key Vault at application startup instead of during each HTTP request. Key Vault is intended for securely storing and retrieving sensitive data during deployment. High-frequency access within HTTP requests can exceed Key Vault's throughput capabilities, leading to request limitations and HTTP status code 429 errors. For more information, see [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions).

#### Use one method to access secrets in Key Vault

When configuring a web app to access secrets in Key Vault, you have two primary options:

- *App Service App setting:* Use an app setting in App Service to inject the secret directly as an [environment variable](/azure/app-service/app-service-key-vault-references#azure-resource-manager-deployment).

- *Direct secret reference:* Directly reference the secret within your application code. Add a specific reference in your application's properties file, such as `application.properties` for Java applications, so your app to communicate with Key Vault.

It's important to choose one of these methods and stick with it for simplicity and to avoid unnecessary complexity.

#### Prefer temporary access methods

Use temporary permissions to safeguard against unauthorized access and breaches. Use [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature) for temporary access. Use User Delegation SAS to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra credentials and doesn't require a storage account key.

### Use private endpoints

Use private endpoints in all production environments for all supported Azure services. Private endpoints provide private connections between resources in an Azure virtual network and Azure services. By default, communication to most Azure services crosses the public internet. Private endpoints don't require any code changes, app configurations, or connection strings. For more information, see [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario) and [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints).

*Example:* Azure App Configuration, Azure SQL Database, Azure Cache for Redis, Azure Storage, Azure App Service, and Key Vault use a private endpoint.

### Use web application firewall and restrict inbound internet traffic

All inbound internet traffic to the web app must pass through a web application firewall to protect against common web exploits. Force all inbound internet traffic to pass through the public load balancer, if you have one, and the web application firewall.

*Example:* The reference implementation forces all inbound internet traffic through Front Door and Azure Web Application Firewall. In production, [preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

### Configure database security

Administrator-level access to the database grants permissions to perform privileged operations. Privileged operations include creating and deleting databases, modifying table schemas, or changing user permissions. Developers often need administrator-level access to maintain the database or troubleshoot issues.

- *Avoid permanent elevated permissions.* You should only grant the developers just-in-time access to perform privileged operations. With just-in-time access, users receive temporary permissions to perform privileged tasks

- *Don't give application elevated permissions.* You shouldn't grant administrator-level access to the application identity. You should configure least-privileged access for the application to the database. It limits the blast radius of bugs and security breaches.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize resources for each environment

Understand the different performance tiers of Azure services and only use the appropriate SKU for the needs of each environment. Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Nonproduction environments typically don't need the same capabilities. For extra savings, consider [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview), [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

*Example:* The reference implementation uses Bicep parameters to trigger resource deployment configurations. One of these parameters indicates the resource tiers (SKUs) to deploy. The web app uses the more performant and expensive SKUs for the production environments and the cheaper SKUs for the nonproduction environment (*see the following code*).

```bicep
var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
var redisCacheFamilyName = isProd ? 'C' : 'C'
var redisCacheCapacity = isProd ? 1 : 0
```

### Use autoscale

Autoscale automates horizontal scaling for production environments. Autoscale based on performance metrics. CPU utilization performance triggers are a good starting point if you don't understand the scaling criteria of your application. You need to configure and adapt scaling triggers (CPU, RAM, network, and disk) to correspond to the behavior of your web application. Don't scale vertically to meet frequent changes in demand. It's less cost efficient. For more information, see [Scaling in Azure App Service](/azure/app-service/manage-scale-up) and [Autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview).

*Example:* The reference implementation uses the following configuration in the Bicep template. It creates an autoscale rule for the Azure App Service. The rule scales up to 10 instances and defaults to one instance. It uses CPU usage as the trigger for scaling in and out. The web app hosting platform scales out at 85% CPU usage and scales in at 60%. The scale-out setting of 85%, rather than a percentage closer to 100%, provides a buffer to protect against accumulated user traffic caused by sticky sessions. It also protects against high bursts of traffic by scaling early to avoid maximum CPU usage. These autoscale rules aren't universal (*see the following code*).

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

    *Example:* The reference implementation places Azure Firewall, Azure Bastion, and Key Vault in the hub virtual network.

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the Bicep template. Use the what-if operation to preview the changes before they take effect. Back up data you need later. Understand the dependencies on the resource you're deleting. If there are dependencies, you might need to update or remove those resources as well. For more information, see [Bicep deployment what-if operation](/azure/azure-resource-manager/bicep/deploy-what-if).

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

    *Example:* The reference implementation uses a single Azure Cache for Redis instance for session management in both front-end (storing cart and MSAL tokens) and back-end (holding Upcoming Concerts data) web apps. It opts for the smallest Redis SKU, offering more than needed capacity, efficiently utilized by employing multiple data types to control costs.

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). The Reliable Web App pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Automate deployment

Use a CI/CD pipeline to deploy changes from source control to production. If you're using Azure DevOps, you should use Azure Pipelines. If you're using GitHub, use GitHub actions. Azure supports ARM template (JSON), Bicep, and Terraform and has templates for every Azure resource For more information, see [Bicep, Azure Resource Manager, and Terraform templates](/azure/templates/) and [Repeatable infrastructure](/azure/architecture/framework/devops/automation-infrastructure).

*Example:* The reference implementation uses Azure Dev CLI and infrastructure as code (Bicep templates) to create Azure resources, setup configuration, and deploy the required resources.  

### Configure monitoring

To monitor your web app, collect and analyze metrics and logs from your application code, infrastructure (runtime), and the platform (Azure resources). Add a diagnostic setting for every Azure resource in your architecture. Each Azure service has a different set of logs and metrics you can capture. For more information, see [Monitor the platform](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#monitoring) and [Monitor App Service](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#app-service-2).

#### Monitor baseline metrics

Use Azure Application Insights to track baseline metrics, such as request throughput, average request duration, errors, and dependency monitoring. Use `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable telemetry collection. For more information, see [Enable Application Insights telemetry](/azure/azure-monitor/app/asp-net-core) and [Dependency injection in .NET](/dotnet/core/extensions/dependency-injection).

*Example:* The reference implementation uses code to configure baseline metrics in Application Insights (*see the following code*).

```csharp
public void ConfigureServices(IServiceCollection services)
{
   ...
   services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
   ...
}
```

#### Create custom telemetry as needed

Use Application Insights to gather custom telemetry to better understand your web app users. Create an instance of the `TelemetryClient` class and use the `TelemetryClient` methods to create the right metric. Turn the query into an Azure Dashboard widget.

*Example:* The reference implementation adds metrics that help the operations team identify that the web app is completing transactions successfully. It validates that the web app is online by monitoring whether customers can place orders, not by measuring the number of requests or CPU usage. The reference implementation uses `TelemetryClient` via dependency injection and the `TrackEvent` method to gather telemetry on events related to cart activity. The telemetry tracks the tickets that users add, remove, and purchase (*see the following code*).

- `AddToCart` counts how many times users add a certain ticket (`ConcertID`) to the cart.
- `RemoveFromCart` records tickets that users remove from the cart.
- `CheckoutCart` records an event every time a user buys a ticket.

`this.telemetryClient.TrackEvent` counts the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies a dictionary that has the `concertId` and `count` (*see the following code*).

```csharp
this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
    { "ConcertId", concertId.ToString() },
    { "Count", count.ToString() }
});
```

For more information, see:

- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics#trackevent)
- [TelemetryClient class](/dotnet/api/microsoft.applicationinsights.telemetryclient)
- [Telemetry client methods](/dotnet/api/microsoft.applicationinsights.telemetryclient)

#### Gather log-based metrics

Track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. For more information, see [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics) and [Log-based and preaggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics).

#### Enable platform diagnostics

A diagnostic setting in Azure allows you to specify the platform logs and metrics you want to collect and where to store them. Platform logs are built-in logs that provide diagnostic and auditing information. You can enable platform diagnostics for most Azure services, but each service defines its own log categories. Different Azure services have log categories to choose.

- *Enable diagnostics for all supported services.* Azure services create platform logs automatically, but the service doesn't store them automatically. You must enable the diagnostic setting for each service, and you should enable it for every Azure service that supports diagnostics.

- *Send diagnostics to same destination as the application logs.* When you enable diagnostics, you pick the logs you want to collect and where to send them. You should send the platform logs to the same destination as the application logs so you can correlate the two datasets.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist). The Reliable Web App pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Use the Cache-Aside pattern

The [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) is a caching strategy that improves in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. When the web app receives a data request, it first searches the cache. If the data is missing, it retrieves it from the database, responds to the request, and updates the cache accordingly. This approach shortens response times and enhances throughput and reduces the need for more scaling. It also bolsters service availability by reducing the load on the primary datastore and minimizing outage risks.

*Example:* The reference implementation enhances application efficiency by caching critical data, such as information for upcoming concerts crucial for ticket sales. It uses ASP.NET Core's distributed memory cache for in-memory item storage. The application automatically uses Azure Cache for Redis when it finds a specific connection string. It also supports local development environments without Redis to simplify setup and reduce costs and complexity. The method (`AddAzureCacheForRedis`) configures the application to use Azure Cache for Redis (*see the following code*).

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

For more information, see [Distributed caching in ASP.NET Core](/aspnet/core/performance/caching/distributed) and [AddDistributedMemoryCache method](/dotnet/api/microsoft.extensions.dependencyinjection.memorycacheservicecollectionextensions.adddistributedmemorycache).

#### Cache high-need data

Prioritize caching for the most frequently accessed data. Identify key data points that drive user engagement and system performance. Implement caching strategies specifically for these areas to optimize the effectiveness of the Cache-Aside pattern, significantly reducing latency and database load. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU.

*Example:* The reference implementation caches the data that supports the Upcoming Concerts. The Upcoming Concerts page creates the most queries to SQL Database and produces a consistent output for each visit. The Cache-Aside pattern caches the data after the first request for this page to reduce the load on the database. The following code uses the `GetUpcomingConcertsAsync` method to pull data into the Redis cache from SQL Database. The method populates the cache with the latest concerts. The method filters by time, sorts the data, and returns the data to the controller to display the results (*see the following code*).

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

*Example:* The reference implementation caches data only for one hour. It has a process for clearing the cache key when the data changes. The `CreateConcertAsync` method clears the cache key (*see the following code*).

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

*Example:* The reference implementation uses the `UpdateConcertAsync` method to keep the data in the cache consistent (*see the following code*).

```csharp
public async Task<UpdateResult> UpdateConcertAsync(Concert existingConcert), 
{
   database.Update(existingConcert);
   await database.SaveChangesAsync();
   this.cache.Remove(CacheKeys.UpcomingConcerts);
   return UpdateResult.SuccessResult();
}
```

### Test database performance

Database performance can affect the performance and scalability of an application. It's important to test the performance of your database to ensure it's optimized. Some key considerations include choosing the right cloud region, connection pooling, cache-aside pattern, and optimizing queries.

- *Test network hops.* Moving an application to the cloud can introduce extra network hops and latency to your database. You should test for extra hops that the new cloud environment introduces.

- *Establish a performance baseline.* You should use on-premises performance metrics as the initial baseline to compare application performance in the cloud.

## Next steps

Deploy the **[reference implementation](https://aka.ms/eap/rwa/dotnet)** by following the instructions in the GitHub repository. Use the following resources to learn more about .NET applications, web apps, cloud best practices, and migration.

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

For applications that require a higher SLO than the Reliable Web App pattern, see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.
- [Azure Migrate application and code assessment](/azure/migrate/appcat/dotnet)
