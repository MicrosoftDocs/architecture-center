---
ms.custom: devx-track-dotnet
---
[!INCLUDE [intro](../includes/intro.md)]

[!INCLUDE [define goals and choose azure services](../includes/goals-services.md)]

| Web app component | Recommendation | Reference implementation | Guidance |
| ----------------- | -------------- | ------------------------ | -------- |
| **Application platform** | Support current web app | Azure App Service | [Compute decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree)|
| **Database** | Support current database engine | Azure SQL Database | [Data store decision tree](/azure/architecture/guide/technology-choices/data-store-decision-tree) |
| **Load balancer** | Support architecture requirements | Azure Front Door | [Load balancer options](/azure/architecture/guide/technology-choices/load-balancing-overview) |
| **Storage** | Support storage requirements | Azure Storage | [Storage options](/azure/architecture/guide/technology-choices/storage-options) |
| **Identity management** | Microsoft Entra ID | Microsoft Entra ID | [Microsoft Entra ID](/entra/identity/enterprise-apps/migration-resources) |
| **App monitoring** | Application Insights | Application Insights | [Application Insights](/azure/azure-monitor/app/app-insights-overview) |
| **Cache** | Azure Cache for Redis | Azure Cache for Redis | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |
| **Secrets manager** | Azure Key Vault | Azure Key Vault | [Azure Key Vault](/azure/key-vault/general/overview) |
| **Web application firewall** | Azure Web Application Firewall | Azure Web Application Firewall | [Azure Web Application Firewall](/azure/web-application-firewall/overview) |
| **Configuration storage** | Azure App Configuration | Azure App Configuration | [Azure App Configuration](/azure/azure-app-configuration/overview) |
| **Endpoint security** | Azure Private Link | Azure Private Link | [Azure Private Link](/azure/private-link/private-link-overview) |
| **Network firewall** | Azure Firewall | Azure Firewall | [Azure Firewall](/azure/firewall/overview) |
| **Remote access** | Azure Bastion | Azure Bastion | [Azure Bastion](/azure/bastion/bastion-overview) |

[!INCLUDE [web app architecture](../includes/design-web-app-architecture.md)]

## Update code 



### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Implement the Retry pattern

:::row:::
    :::column:::
        ***Well-Architected Framework pillar support: Reliability***
    :::column-end:::
:::row-end:::

Add the [Retry pattern](/azure/architecture/patterns/retry) to your application code to addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults). Transient faults usually resolve themselves within seconds. The Retry pattern allows you to resend failed requests and configure the request delays and attempts before conceding failure.

- *Use built-in retry mechanisms.* Use the [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific) that most Azure services have to expedite the implementation.

    The reference implementation uses the [connection resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency) to apply the Retry pattern in requests to [Azure SQL Database](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core) (*see the following code*).

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

- *Use programming libraries.* For services that don't have built-in support for the Retry pattern, use programming libraries that support the Retry pattern, such as [Polly](https://github.com/App-vNext/Polly)

    The reference implementation uses Polly to enforce the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object (*see the following code*).

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

#### Use the Circuit Breaker pattern

|Well-Architected Framework pillar support: | Reliability, Performance Efficiency |
| --- | --- |

Use the [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) to handle service disruptions that aren't transient faults. The Circuit Breaker pattern prevents an application from continuously attempting to access a nonresponsive service. It releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users.

The reference implementation applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time (*see the following code*).

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

### Configure user authentication and authorization

- *Use an identity platform.* Use the [Microsoft Identity platform](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). It allows developers to build single-tenant, line-of-business (LOB) applications and multi-tenant software-as-a-service (SaaS) applications, so users and customers can sign in to using their Microsoft identities or social accounts.

- *Use platform features.* Where possible, enable user identity authentication using platform features. For example, [App Service](/azure/app-service/overview-authentication-authorization) provides built-in authentication support, so you can sign in users and access data by writing minimal or no code in your web app.

- *Enforce authorization in the application.* Use RBAC to assign least privileges to [application roles](/entra/identity-platform/custom-rbac-for-developers). Assess your application's needs to define a set of roles that cover all user actions without overlap. Map each user to the most appropriate role. Ensure they receive access only to what's necessary for their duties.

- *Prefer temporary access to storage.* Use temporary permissions to safeguard against unauthorized access and breaches, such as [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature). Use User Delegation SASs to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

- *Enforce authorization in Azure.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to assign least privileges to user identities. Azure RBAC determines what Azure resources identities can access, what they can do with those resources, and what areas they have access to.

- *Avoid permanent elevated permissions.* Use [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time access for privileged operations. For example, developers often need administrator-level access to create/delete databases, modify table schemas, and change user permissions. With just-in-time access, user identities receive temporary permissions to perform privileged tasks.

### Configure service authentication and authorization

- *Use managed identities for service authentication.* Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) to automate the creation and management of Azure services ([workload identities](/entra/workload-id/workload-identities-overview)). A managed identity allows Azure services to access other Azure services like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments. Hybrid and legacy systems can keep on-premises authentication solutions to simplify the migration but should transition to managed identities as soon as possible.

    The reference implementation uses the `Authentication` argument in the SQL database connection string so App Service can [connect to the SQL database](/azure/app-service/tutorial-connect-msi-sql-database) with a managed identity: `Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default`

    The reference implementation uses the `DefaultAzureCredential` to allow the web API to connect to Key Vault using a managed identity (*see the following code*).

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

- *Configure service authentication.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities. If Azure RBAC doesn't cover a specific scenario, supplement Azure RBAC with Azure-service level access policies.

- *Secure secrets.* Store any remaining secrets in [Azure Key Vault](/azure/key-vault/secrets/about-secrets). Load secrets from Key Vault at application startup instead of during each HTTP request. High-frequency access within HTTP requests can exceed [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions). Store application configurations in [Azure App Configuration](/azure/azure-app-configuration/overview).

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize environments

- *Optimize all environments.* Use the performance tiers (SKUs) of Azure services that meets the needs of [each environment](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments).

- *Optimize production.* Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production.

- [Prepoduction environments](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments) should b the right balance of lower-cost resources, turning off unneeded services, and applying discounts offered for preproduction usage, such as [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview). Make sure to [balance similarity with production](/azure/well-architected/cost-optimization/optimize-environment-costs#balance-similarity-with-production) to avoid creating production risks.

    The reference implementation uses Bicep parameters to deploy more expensive tiers (SKUs) to the production environment (*see the following code*).

    ```bicep
    var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
    var redisCacheFamilyName = isProd ? 'C' : 'C'
    var redisCacheCapacity = isProd ? 1 : 0
    ```

### Use autoscale

- *Automate scale-out.* Use [autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Scale based on performance metrics.

- *Refine scaling triggers.* Start with CPU utilization performance triggers if you don't understand the scaling criteria of your application. Configure and adapt scaling triggers (CPU, RAM, network, and disk) to match the behavior of your web application.

- *Provide a scale out buffer.* Trigger scaling 10-15% before your web app reaches maximum capacity. For example, scale out at 85% CPU usage rather than 100%.

### Optimize resource usage

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the template.

- *Use shared services.* Centralize and share network resources in a hub virtual network.

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types. The reference implementation uses a single Azure Cache for Redis instance for session management in the front-end (shopping cart tokens and MSAL tokens) and back-end (upcoming concerts data) web apps.

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). The Reliable Web App pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Automate deployment

Use [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) and deploy through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource.

The reference implementation uses Bicep to deploy and configure all Azure resources.

### Configure monitoring

- *Collect application telemetry.* Use [autoinstrumentation](/azure/azure-monitor/app/codeless-overview) in Azure Application Insights to collect application [telemetry](/azure/azure-monitor/app/data-model-complete), such as request throughput, average request duration, errors, and dependency monitoring, with no code changes.

    The reference implementation uses `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable [telemetry collection](/azure/azure-monitor/app/asp-net-core) (*see the following code*).

    ```csharp
    public void ConfigureServices(IServiceCollection services)
    {
       ...
       services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
       ...
    }
    ```

- *Create custom application metrics.* Use code-based instrumentation for [custom application telemetry](/azure/azure-monitor/app/api-custom-events-metrics). Add the Application Insights SDK to your code and use the Application Insights API.

    The reference implementation gathers telemetry on events related to cart activity. `this.telemetryClient.TrackEvent` counts the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies a dictionary that has the `concertId` and `count` (*see the following code*).

    ```csharp
    this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
        { "ConcertId", concertId.ToString() },
        { "Count", count.ToString() }
    });
    ```

- *Monitor the platform.* Enable diagnostics for all supported services and Send diagnostics to same destination as the application logs for correlation. Azure services create platform logs automatically but only stores them when you enable diagnostics. Enable diagnostic settings for each service that supports diagnostics.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist). The Reliable Web App pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Use the Cache-Aside pattern

Add [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) to your web app to improve in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. It shortens response times, enhances throughput, and reduces the need for more scaling. It also reduce the load on the primary datastore, improving reliability and cost optimization.

The reference implementation caches upcoming concerts. The `AddAzureCacheForRedis` method configures the application to use Azure Cache for Redis (*see the following code*).

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

- *Cache high-need data.* Apply the Cache-Aside pattern on high-need data to amplify its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after applying the Cache-Aside pattern.

    The reference implementation caches high-need data that supports the Upcoming Concerts. The `GetUpcomingConcertsAsync` method pulls data into the Redis cache from the SQL Database and populates the cache with the latest concerts data (*see following code*).

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

- *Keep cache data fresh.* Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information.

    The reference implementation caches data only for one hour and uses the `CreateConcertAsync` method to clear the cache key when the data changes (*see the following code*).

    ```csharp
    public async Task<CreateResult> CreateConcertAsync(Concert newConcert)
    {
        database.Add(newConcert);
        await this.database.SaveChangesAsync();
        this.cache.Remove(CacheKeys.UpcomingConcerts);
        return CreateResult.SuccessResult(newConcert.Id);
    }
    ```

- *Ensure data consistency.* Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

    The reference implementation uses the `UpdateConcertAsync` method to keep the data in the cache consistent (*see the following code*).

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

Moving an application to the cloud can introduce extra network hops and latency to your database. Test for extra hops that the new cloud environment introduces. Use on-premises performance metrics as the initial baseline to compare performance in the cloud. Follow recommendations for [optimizing data performance](/azure/well-architected/performance-efficiency/optimize-data-performance).

## Deploy this scenario

[GitHub logo](../../../../../_images/github.svg) Deploy the reference implementation of the [Modern Web App Pattern for .NET](https://github.com/azure/modern-web-app-pattern-dotnet). There are instructions for both development and production deployment in the repository. Once deployed, you can observe the patterns described in this document in action. The reference implementation simulates the migration efforts of a fictional company, Relecloud. the reference implementation is a production-grade web app that allows customers to buy concert tickets online.

[![Diagram showing the architecture of the reference implementation.](../../../_images/reliable-web-app-dotnet.svg)](../../../_images/reliable-web-app-dotnet.svg)
*Figure 2. Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

>[!div class="nextstepaction"]
>[Modern Web App pattern for .NET reference implementation](https://github.com/azure/modern-web-app-pattern-dotnet)

## Next steps

Use the following resources to learn more about .NET applications, web apps, cloud best practices, and migration.

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