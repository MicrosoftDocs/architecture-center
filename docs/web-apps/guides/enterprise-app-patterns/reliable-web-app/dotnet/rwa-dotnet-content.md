---
ms.custom: devx-track-dotnet
---

This article shows you how to apply the Reliable Web App pattern.

The Reliable Web App pattern is a set of [principles and implementation techniques](../../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the essential changes you need to make to be successful in the cloud.

> [!TIP]
> ![GitHub logo](../../_images/github.svg) This article is backed by a [reference implementation](https://aka.ms/eap/rwa/dotnet) of the Reliable Web App pattern, which features a production grade web app on Azure. Use implementation to apply the Reliable Web App pattern to your web app.

## Choose a web app architecture

### Choose the right managed services

Select managed, Azure services that support the needs of you web app. Prefer managed services to improve security and reduce management overhead. To minimize the replaforming effort, choose services that support the features of your web app, such as the same runtime and database engine. Azure has multiple service options for several web app components. Use the following table to find guidance to choose the right service for each web app component.

| Web app component | Recommendation | Reference implementation selection | Guidance |
| ----------------- | -------------- | ---------------------------------- | ----------------- |
| **Application platform** | Support current web framework | Azure App Service | [Compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree)|
| **Database** | Support current database engine | Azure SQL Database | [Data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree) |
| **Load balancer** | Support cloud architecture requirements | Azure Front Door | [Load balancer options](/azure/architecture/guide/technology-choices/load-balancing-overview) |
| **Storage** | Support storage requirements | Azure Storage | [Storage options](/azure/architecture/guide/technology-choices/storage-options) |

For other web app components, Azure has a single recommended service (*see following table*).

| Web app component | Recommendation | Reference implementation | Guidance |
| ----------------- | -------------- | ---------------------------------- |
| Identity management | Microsoft Entra ID | Microsoft Entra ID | [Migrate to Microsoft Entra ID](/entra/identity/enterprise-apps/migration-resources) |
| Application performance monitoring | Application Insights | Application Insights | [Application Insights overview](/azure/azure-monitor/app/app-insights-overview) |
| Cache | Azure Cache for Redis | Azure Cache for Redis | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |
| Secrets manager | Azure Key Vault | Azure Key Vault | [Azure Key Vault](/azure/key-vault/general/overview) |
| Web application firewall | Azure Web Application Firewall | [Azure Web Application Firewall](/azure/web-application-firewall/overview) |
| Configuration storage | Azure App Configuration | [Azure App Configuration](/azure/azure-app-configuration/overview) |
| Endpoint security | Azure Private Link | [Azure Private Link](/azure/private-link/private-link-overview) |
| Network firewall | Azure Firewall | [Azure Firewall](/azure/firewall/overview) |
| Remote access | Azure Bastion | Azure Bastion | [Azure Bastion](/azure/bastion/bastion-overview) |

### Design a network topology

Choose the right network topology for your web and networking requirements. A [hub and spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology) is standard configuration in Azure. It provides cost, management, and security benefits with hybrid connectivity options to on-premises networks.

### Design infrastructure redundancy

Determine how many availability zones and regions you need to meet your availability needs. Define a target SLO for your web app, such as 99.9% uptime. Then, calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) for all the services that affect the availability of your web app. Add availability zones and regions until the composite SLA meets your SLO.

Make sure your infrastructure also supports your [recovery metrics](/azure/well-architected/reliability/metrics#recovery-metrics), such as recovery time objective (RTO) and recovery point objective (RPO). The RTO affects availability and must support your SLO. Determine an recovery point objective (RPO) and configure [data redundancy](/azure/well-architected/reliability/redundancy#data-resources) to meet the RPO.

## Update web app

Follow these recommendations aligned to the pillars of the Well-Architected Framework:

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Apply the Retry pattern

Add the [Retry pattern](/azure/architecture/patterns/retry) to your application code to addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults). Transient faults usually resolve themselves within seconds. The Retry pattern allows you to resend failed requests and configure the request delays and attempts before conceding failure.

#### Use the built-in retry mechanism to apply the Retry pattern

Use the [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific) that most Azure services have to expedite the implementation.

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

#### Use programming libraries to apply the Retry pattern

Use programming libraries that support the Retry pattern, such as [Polly](https://github.com/App-vNext/Polly), on services that don't have built-in support for the Retry pattern.

*Example:* The reference implementation uses Polly to enforce the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object (*see the following code*).

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

### Use the Circuit Breaker pattern

Use the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) to handle service disruptions that aren't transient faults. The Circuit Breaker pattern prevents an application from continuously attempting to access a nonresponsive service. It releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users.

*Example:* The reference implementation applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time (*see the following code*).

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). The Reliable Web App pattern covers role-based access control, managed identities, private endpoints, secrets management, and web application firewall.

### Configure authentication and authorization

Only grant users (user identities) and Azure services ([workload identities](/entra/workload-id/workload-identities-overview)) the permissions they need. Use [Azure RBAC](/azure/role-based-access-control/overview) to grant only the permissions necessary for user and workload identities and follow [Azure RBAC best practices](/azure/role-based-access-control/best-practices).

### Configure user identity authentication

Enable user identity authentication through your platform's features, when possible. For example, [Azure App Service](/azure/app-service/overview-authentication-authorization) authentication with identity providers like Microsoft Entra ID, offloading the authentication workload from your code.

- *Assign least privileges to user identities.* Assess your application's needs to define a set of roles that cover all user actions without overlap. Map each user to the most appropriate role. Ensure they receive access only to what's necessary for their duties.

- *Avoid permanent elevated permissions.* Only grant just-in-time access to perform privileged operations. For example, developers often need administrator-level access to maintain the database or troubleshoot issues. Administrator-level access to the database grants permissions to perform privileged operations. Privileged operations include creating and deleting databases, modifying table schemas, or changing user permissions. With just-in-time access, users receive temporary permissions to perform privileged tasks.

#### Configure workload identity authentication

Configure authentication for workload identities so the services in your environment perform necessary functions. Use Azure RBAC to grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities. If Azure RBAC doesn't cover a specific scenario, supplement Azure RBAC with Azure-service level access policies.

#### Use managed identities

Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) to automate the creation and management of service identities and eliminate manual credential management. A managed identity allows your web app to securely access Azure services like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments. Hybrid and legacy systems can keep on-premises authentication solutions for the migration and should transition to managed identities quickly.

*Example:* The reference implementation uses Bicep templates to (1) create the managed identity, (2) associate the identity with the web app, and (3) grant the identity permission to access the SQL database. The `Authentication` argument in the connection string tells the Microsoft client library to connect with a managed identity (*see the following code*).

```csharp
    Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default
 ```

For more information, see [Connect to SQL database from .NET App Service](/azure/app-service/tutorial-connect-msi-sql-database).

#### Use DefaultAzureCredential to set up code

Use [`DefaultAzureCredential`](/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet) to provide credentials for local development and managed identities in the cloud. `DefaultAzureCredential` generates a `TokenCredential` for OAuth token acquisition. It handles most Azure SDK scenarios and Microsoft client libraries. It detects the application's environment to use the correct identity and requests access tokens as needed. `DefaultAzureCredential` streamlines authentication for Azure-deployed applications.

*Example:* The reference implementation uses the `DefaultAzureCredential` class during start up to enable the use of managed identity between the web API and Key Vault (*see the following code*).

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

### Store secrets in Azure Key Vault

Store all secrets in [Azure Key Vault](/azure/key-vault/secrets/about-secrets). It provides centralized secure storage, key rotation, access auditing, and monitoring for services not supporting managed identities. For application configurations, use [Azure App Configuration](/azure/azure-app-configuration/overview).

Don't put Key Vault in the HTTP-request flow. Load secrets from Key Vault at application startup instead of during each HTTP request. High-frequency access within HTTP requests can exceed [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions).

### Prefer temporary access methods

Use temporary permissions to safeguard against unauthorized access and breaches, such as [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature). Use User Delegation SASs to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

### Configure private endpoints

 in all production environments for all supported Azure services. Private endpoints help secure access to PaaS services and don't require any code changes, app configurations, or connection strings. [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints).

### Use a web application firewall

Force all inbound internet traffic to through a web application firewall to protect against common web exploits.

*Example:* The reference implementation forces all inbound internet traffic through Azure Front Door and Azure Web Application Firewall. In production, [preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize resources for each environment

Understand the different performance tiers of Azure services and only use the appropriate SKU for the needs of each environment. Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Nonproduction environments typically don't need the same capabilities. For extra savings, consider [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview), [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

*Example:* The reference implementation uses Bicep parameters to deploy higher resource tiers (SKUs) to production (*see the following code*).

```bicep
var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
var redisCacheFamilyName = isProd ? 'C' : 'C'
var redisCacheCapacity = isProd ? 1 : 0
```

### Use autoscale

Use [autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Scale based on performance metrics.

- *Refine scaling triggers.* Start with CPU utilization performance triggers if you don't understand the scaling criteria of your application. Configure and adapt scaling triggers (CPU, RAM, network, and disk) to match the behavior of your web application.
- *Provide a scale out buffer.* Trigger scaling 10-15% before your web app reaches maximum capacity. For example, scale out at 85% CPU usage rather than 100%.

*Example:* The reference implementation uses the following configuration in the Bicep template (*see the following code*).

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

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the template.

- *Use shared services.* Centralize and share network resources in a hub virtual network.

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

    *Example:* The reference implementation uses a single Azure Cache for Redis instance for session management in the front-end (shopping cart tokens and MSAL tokens) and back-end (upcoming concerts data) web apps.

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). The Reliable Web App pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Automate deployment

Use [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) and deploy through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource.

### Configure monitoring

Collect metrics and logs from application code, infrastructure (runtime), and the platform (Azure resources). Add a diagnostic setting for every Azure resource in your architecture. Each Azure service has a different set of logs and metrics you can capture. To configure monitoring, follow these recommendations

#### Monitor baseline metrics

Use Azure Application Insights to track baseline application metrics, such as request throughput, average request duration, errors, and dependency monitoring. Use `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable telemetry collection. For more information, see [Enable Application Insights telemetry](/azure/azure-monitor/app/asp-net-core) and [Dependency injection in .NET](/dotnet/core/extensions/dependency-injection).

*Example:* The reference implementation configures baseline metrics in Application Insights (*see the following code*).

```csharp
public void ConfigureServices(IServiceCollection services)
{
   ...
   services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
   ...
}
```

#### Create custom telemetry

Use Application Insights to gather custom telemetry to better understand your web app users. Create an instance of the `TelemetryClient` class and use the `TrackEvent` methods to create the right metric. Turn the query into an Azure Dashboard widget.

*Example:* The reference implementation uses `TelemetryClient` and `TrackEvent` method to gather telemetry on events related to cart activity. `this.telemetryClient.TrackEvent` counts the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies a dictionary that has the `concertId` and `count` (*see the following code*).

```csharp
this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
    { "ConcertId", concertId.ToString() },
    { "Count", count.ToString() }
});
```

For more information, see, [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics#trackevent), [TelemetryClient class](/dotnet/api/microsoft.applicationinsights.telemetryclient), and [Telemetry client methods](/dotnet/api/microsoft.applicationinsights.telemetryclient)

#### Gather log-based metrics

Track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. For more information, see [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics) and [Log-based and preaggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics).

#### Enable platform diagnostics

- *Enable diagnostics for all supported services.* Azure services create platform logs automatically but only stores them when you enable diagnostics. Enable diagnostic settings for each service that supports diagnostics.

- *Send diagnostics to same destination as the application logs.* Send the platform logs to the same destination as the application logs so you can correlate the two datasets.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist). The Reliable Web App pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Add the Cache-Aside pattern

Add [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) to your web app to improve in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. It shortens response times, enhances throughput, and reduces the need for more scaling. It also reduce the load on the primary datastore, improving reliability and cost optimization.

*Example:* The reference implementation caches upcoming concerts. The  `AddAzureCacheForRedis` method configures the application to use Azure Cache for Redis (*see the following code*).

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

Identify data that drives user engagement and system performance. Apply the Cache-Aside pattern on high-need data to amplify its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after applying the Cache-Aside pattern.

*Example:* The reference implementation caches the data that supports the Upcoming Concerts. The Upcoming Concerts page creates the most queries to SQL Database and produces a consistent output for each visit. The Cache-Aside pattern caches the data after the first request for this page to reduce the load on the database. The `GetUpcomingConcertsAsync` method pulls data into the Redis cache from the SQL Database. The method populates the cache with the latest concerts data. The method filters by time, sorts the data, and returns the data to the controller to display the results (*see the following code*).

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

*Example:* The reference implementation caches data only for one hour and uses the `CreateConcertAsync` method to clear the cache key when the data changes (*see the following code*).

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

