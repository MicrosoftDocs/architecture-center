---
ms.custom: devx-track-dotnet
---

[!INCLUDE [intro](../includes/intro.md)]

## Architecture guidance

[!INCLUDE [reliable web app pattern architecture updates](../includes/architecture-updates.md)]

## Code guidance

[!INCLUDE [Code updates](../includes/code-updates.md)]

### Implement the Retry pattern

[!INCLUDE [Retry pattern intro](../includes/retry.md)]

- *Use built-in retry mechanisms.* Use the [built-in retry mechanism](/azure/architecture/best-practices/retry-service-specific) that most Azure services have to expedite the implementation. For example, the reference implementation uses the [connection resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency) to apply the Retry pattern in requests to [Azure SQL Database](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core) (*see the following code*).

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

- *Use programming libraries.* For services that don't have built-in support for the Retry pattern, use programming libraries that support the Retry pattern, such as [Polly](https://github.com/App-vNext/Polly). For example, the reference implementation uses Polly to enforce the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object (*see the following code*).

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

### Implement the Circuit Breaker pattern

[!INCLUDE [Circuit-breaker pattern intro](../includes/circuit-breaker.md)]

For example, the reference implementation applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time (*see the following code*).

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.NotFound)
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

### Implement the Cache-Aside pattern

[!INCLUDE [Cache-aside pattern intro](../includes/cache-aside.md)]

- *Configure application to use a cache.* Production apps should use the Distributed Redis Cache because it's the most performant. For example, the reference implementation uses distributed Redis cache. The [`AddAzureCacheForRedis` method](/dotnet/api/microsoft.extensions.dependencyinjection.memorycacheservicecollectionextensions.adddistributedmemorycache) configures the application to use Azure Cache for Redis (*see the following code*).

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

- *Cache high-need data.* Apply the Cache-Aside pattern on high-need data to amplify its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after applying the Cache-Aside pattern. For example, the reference implementation caches high-need data that supports the Upcoming Concerts page. The `GetUpcomingConcertsAsync` method pulls data into the Redis cache from the SQL Database and populates the cache with the latest concerts data (*see following code*).

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

- *Keep cache data fresh.* Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information. For example, the reference implementation caches data only for one hour and uses the `CreateConcertAsync` method to clear the cache key when the data changes (*see the following code*).

    ```csharp
    public async Task<CreateResult> CreateConcertAsync(Concert newConcert)
    {
        database.Add(newConcert);
        await this.database.SaveChangesAsync();
        this.cache.Remove(CacheKeys.UpcomingConcerts);
        return CreateResult.SuccessResult(newConcert.Id);
    }
    ```

- *Ensure data consistency.* Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern. For example, the reference implementation uses the `UpdateConcertAsync` method to keep the data in the cache consistent (*see the following code*).

    ```csharp
    public async Task<UpdateResult> UpdateConcertAsync(Concert existingConcert), 
    {
       database.Update(existingConcert);
       await database.SaveChangesAsync();
       this.cache.Remove(CacheKeys.UpcomingConcerts);
       return UpdateResult.SuccessResult();
    }
    ```

## Configuration guidance

The following sections provide guidance on implementing the configurations updates. Each section align with one or more pillars of the Well-Architected Framework.

|Configuration|Reliability|Security|Cost Optimization|Operational Excellence|Performance Efficiency|
|---|---|---|---|---|---|
|[Configure user authentication and authorization](#configure-user-authentication-and-authorization)||✔||✔||
|[Implement managed identities](#implement-managed-identities)||✔||✔||
|[Right size environments](#right-size-environments)|||✔|||
|[Implement autoscaling](#implement-autoscaling)|✔||✔||✔|
|[Implement infrastructure as code](#implement-infrastructure-as-code)|||||✔|
|[Implement monitoring](#implement-monitoring)|||✔|✔|✔|

### Configure user authentication and authorization

[!INCLUDE [User authN and authZ](../includes/user-auth.md)]

- *Use an identity platform.* Use the [Microsoft Identity platform](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). This platform supports both single-tenant and multi-tenant applications, allowing users to sign in with their Microsoft identities or social accounts.

- *Create an app registration.* Microsoft Entra ID requires an application registration in the primary tenant. The application registration ensures the users that get access to the web app have identities in the primary tenant.

- *Use platform features.* Minimize the need for custom authentication code by using platform capabilities to authenticate users and access data. For example, [App Service](/azure/app-service/overview-authentication-authorization) provides built-in authentication support, so you can sign in users and access data by writing minimal or no code in your web app.

- *Enforce authorization in the application.* Use role-based access controls (RBAC) to assign least privileges to [application roles](/entra/identity-platform/custom-rbac-for-developers). Define specific roles for different user actions to avoid overlap and ensure clarity. Map users to the appropriate roles and ensure they only have access to necessary resources and actions.

- *Prefer temporary access to storage.* Use temporary permissions to safeguard against unauthorized access and breaches, such as [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature). Use User Delegation SASs to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

- *Enforce authorization in Azure.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to assign least privileges to user identities. Azure RBAC determines what Azure resources identities can access, what they can do with those resources, and what areas they have access to.

- *Avoid permanent elevated permissions.* Use [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time access for privileged operations. For example, developers often need administrator-level access to create/delete databases, modify table schemas, and change user permissions. With just-in-time access, user identities receive temporary permissions to perform privileged tasks.

### Implement managed identities

[!INCLUDE [Managed identity intro](../includes/managed-id.md)]

For example, the reference implementation uses the `Authentication` argument in the SQL database connection string so App Service can [connect to the SQL database](/azure/app-service/tutorial-connect-msi-sql-database) with a managed identity: `Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default`. It uses the `DefaultAzureCredential` to allow the web API to connect to Key Vault using a managed identity (*see the following code*).

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

- *Configure least privileges.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities. If Azure RBAC doesn't cover a specific scenario, supplement Azure RBAC with Azure-service level access policies.

- *Secure remaining secrets.* Store any remaining secrets in [Azure Key Vault](/azure/key-vault/secrets/about-secrets). Load secrets from Key Vault at application startup instead of during each HTTP request. High-frequency access within HTTP requests can exceed [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions). Store application configurations in [Azure App Configuration](/azure/azure-app-configuration/overview).

### Right size environments

[!INCLUDE [Right size environments intro](../includes/rightsize.md)] For example, the reference implementation uses Bicep parameters to deploy more expensive tiers (SKUs) to the production environment.
    
    ```bicep
        var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
        var redisCacheFamilyName = isProd ? 'C' : 'C'
        var redisCacheCapacity = isProd ? 1 : 0
    ```

### Implement autoscaling

:::row:::
    :::column:::
        ***Well-Architected Framework alignment - Reliability ([RE:06](/azure/well-architected/reliability/scaling)), Cost Optimization ([CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs)), Performance Efficiency ([PE:05](/azure/well-architected/performance-efficiency/scale-partition))***
    :::column-end:::
:::row-end:::
---

Autoscaling ensures web app remain resilient, responsive, and capable of handling dynamic workloads efficiently. To implement autoscaling, follow these recommendations:

- *Automate scale-out.* Use [Azure autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Configure autoscaling rules to scale out based on key performance metrics, so your application can handle varying loads.

- *Refine scaling triggers.* Begin with CPU utilization as your initial scaling trigger if you are unfamiliar with your application’s scaling requirements. Refine your scaling triggers to include other metrics such as RAM, network throughput, and disk I/O to better match your web application's behavior and ensure optimal performance.

- *Provide a scale out buffer.* Set your scaling thresholds to trigger before reaching maximum capacity. For example, configure scaling to occur at 85% CPU utilization rather than waiting until it reaches 100%. This proactive approach helps maintain performance and avoid potential bottlenecks.

### Implement infrastructure as code

:::row:::
    :::column:::
        ***Well-Architected Framework alignment - Operational Excellence ([OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design))***
    :::column-end:::
:::row-end:::
---

Use [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) and deploy through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource. The reference implementation uses Bicep to deploy and configure all Azure resources.

### Implement monitoring

:::row:::
    :::column:::
        ***Well-Architected Framework alignment - Operational Excellence ([OE:07](/azure/well-architected/operational-excellence/observability)), Performance Efficiency ([PE:04](/azure/well-architected/performance-efficiency/collect-performance-data)***
    :::column-end:::
:::row-end:::
---

Implement monitoring to enhance the operational excellence and performance efficiency of your web app. To implement monitoring, follow these recommendations:

- *Collect application telemetry.* Use [autoinstrumentation](/azure/azure-monitor/app/codeless-overview) in Azure Application Insights to collect application [telemetry](/azure/azure-monitor/app/data-model-complete), such as request throughput, average request duration, errors, and dependency monitoring, with no code changes. For example, the reference implementation uses `AddApplicationInsightsTelemetry` to enable [telemetry collection](/azure/azure-monitor/app/asp-net-core) (*see the following code*).

    ```csharp
    public void ConfigureServices(IServiceCollection services)
    {
       ...
       services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
       ...
    }
    ```

- *Create custom application metrics.* Implement code-based instrumentation to capture [custom application telemetry](/azure/azure-monitor/app/api-custom-events-metrics) by adding the Application Insights SDK and using its API. For example, the reference implementation gathers telemetry on events related to cart activity (*see the following code*).

    ```csharp
    this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
        { "ConcertId", concertId.ToString() },
        { "Count", count.ToString() }
    });
    ```

- *Monitor the platform.* Enable diagnostics for all supported services and Send diagnostics to same destination as the application logs for correlation. Azure services create platform logs automatically but only stores them when you enable diagnostics. Enable diagnostic settings for each service that supports diagnostics.

## Deploy the reference implementation

![GitHub logo](../../../../../_images/github.svg) Deploy the reference implementation of the [Modern Web App Pattern for .NET](https://github.com/azure/modern-web-app-pattern-dotnet). There are instructions for both development and production deployment in the repository. After you deploy, you can simulate and observe design patterns.

[![Diagram showing the architecture of the reference implementation.](../../../_images/reliable-web-app-dotnet.svg)](../../../_images/reliable-web-app-dotnet.svg)
*Figure 3. Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

>[!div class="nextstepaction"]
>[Reliable Web App pattern for .NET reference implementation](reference-implementation)

## More resources

Use the following resources to learn more about .NET applications, web apps, cloud best practices, and migration.

**Upgrading .NET Framework applications**:

- [Overview of porting from .NET Framework to .NET](/dotnet/core/porting/). Get guidance based on your specific type of .NET app.
- [Overview of the .NET Upgrade Assistant](/dotnet/core/porting/upgrade-assistant-overview). Learn about a console tool that can help you automate many of the tasks associated with upgrading .NET Framework projects.
- [Migrating from ASP.NET to ASP.NET Core in Visual Studio](https://devblogs.microsoft.com/dotnet/introducing-project-migrations-visual-studio-extension/). Learn about a Visual Studio extension that can help you with incremental migrations of web apps.

**Introduction to web apps on Azure**: For a hands-on introduction to .NET web applications on Azure, see this [guidance for deploying a basic .NET web application](https://github.com/Azure-Samples/app-templates-dotnet-azuresql-appservice).

**Migration guidance**: The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.
- [Azure Migrate application and code assessment](/azure/migrate/appcat/dotnet)

[reference-implementation]: https://aka.ms/eap/rwa/dotnet