---
ms.custom: devx-track-dotnet
---

[!INCLUDE [intro](../includes/intro.md)]

## Implement architecture updates

The following guidance provides recommendations for implementing architecture updates on your web app.

[!INCLUDE [implement PaaS services](../includes/choose-services.md)]

- *Secure ingress.* Force all inbound internet traffic to through the external load balancer and web application firewall to protect against common web exploits. Azure Web Application Firewall integrates with with Azure Application Gateway, Azure Front Door, and Azure Content Delivery Network (CDN).

- *Implement network topology.* Choose the right network topology for your web and networking requirements. A [hub and spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology) is standard configuration in Azure. It provides cost, management, and security benefits with hybrid connectivity options to on-premises networks.

- *Implement infrastructure reliability.* Determine how many availability zones and regions you need to meet your availability needs. Define a target SLO for your web app, such as 99.9% uptime. Then, calculate the [composite SLA](/azure/well-architected/reliability/metrics#slos-and-slas) for all the services that affect the availability of your web app. Add availability zones and regions until the composite SLA meets your SLO.

    Design your infrastructure to support your [recovery metrics](/azure/well-architected/reliability/metrics#recovery-metrics), such as recovery time objective (RTO) and recovery point objective (RPO). The RTO affects availability and must support your SLO. Determine an recovery point objective (RPO) and configure [data redundancy](/azure/well-architected/reliability/redundancy#data-resources) to meet the RPO.

- *Implement private endpoints.* Use [private endpoints](/azure/architecture/framework/security/design-network-endpoints) in all production environments for all supported Azure services. Private endpoints help secure access to PaaS services and don't require any code changes, app configurations, or connection strings.

## Implement code updates

The following sections provide guidance on implementing the design patterns to your code. Each design pattern provides workload design benefits that align with one of more pillars of the Well-Architected Framework.

### Implement the Retry pattern

:::row:::
    :::column:::
        ***Well-Architected Framework pillars: Reliability ([RE:07](/azure/well-architected/reliability/self-preservation))***
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

### Implement the Circuit Breaker pattern

:::row:::
    :::column:::
        ***Well-Architected Framework pillar alignment: Reliability ([RE:03](/azure/well-architected/reliability/failure-mode-analysis), [RE:07](/azure/well-architected/reliability/handle-transient-faults)), Performance Efficiency ([PE:07](/azure/well-architected/performance-efficiency/optimize-code-infrastructure), [PE:11](/azure/well-architected/performance-efficiency/respond-live-performance-issues))***
    :::column-end:::
:::row-end:::

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

### Implement the Cache-Aside pattern

:::row:::
    :::column:::
        ***Well-Architected Framework pillar alignment: Reliability ([RE:05](/azure/well-architected/reliability/redundancy)), Performance Efficiency ([PE:08](/azure/well-architected/performance-efficiency/optimize-data-performance), [PE:12](/azure/well-architected/performance-efficiency/continuous-performance-optimize))***
    :::column-end:::
:::row-end:::

Add [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) to your web app to improve in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. It shortens response times, enhances throughput, and reduces the need for more scaling. It also reduce the load on the primary datastore, improving reliability and cost optimization.

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

## Implement configuration updates

The following sections provide guidance on implementing the configurations updates. Each section align with one or more pillars of the Well-Architected Framework.

### Implement user authentication and authorization

:::row:::
    :::column:::
        ***Well-Architected Framework alignment: Security ([SE:05](/azure/well-architected/security/identity-access)), Operational Excellence ([OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization))***
    :::column-end:::
:::row-end:::

- *Use an identity platform.* Use the [Microsoft Identity platform](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). It allows developers to build single-tenant, line-of-business (LOB) applications and multi-tenant software-as-a-service (SaaS) applications, so users and customers can sign in to using their Microsoft identities or social accounts.

- *Use platform features.* Where possible, enable user identity authentication using platform features. For example, [App Service](/azure/app-service/overview-authentication-authorization) provides built-in authentication support, so you can sign in users and access data by writing minimal or no code in your web app.

- *Enforce authorization in the application.* Use RBAC to assign least privileges to [application roles](/entra/identity-platform/custom-rbac-for-developers). Assess your application's needs to define a set of roles that cover all user actions without overlap. Map each user to the most appropriate role. Ensure they receive access only to what's necessary for their duties.

- *Prefer temporary access to storage.* Use temporary permissions to safeguard against unauthorized access and breaches, such as [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature). Use User Delegation SASs to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

- *Enforce authorization in Azure.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to assign least privileges to user identities. Azure RBAC determines what Azure resources identities can access, what they can do with those resources, and what areas they have access to.

- *Avoid permanent elevated permissions.* Use [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time access for privileged operations. For example, developers often need administrator-level access to create/delete databases, modify table schemas, and change user permissions. With just-in-time access, user identities receive temporary permissions to perform privileged tasks.

### Implement managed identities

:::row:::
    :::column:::
        ***Well-Architected Framework alignment: Security ([SE:05](/azure/well-architected/security/identity-access)), Operational Excellence ([OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization))***
    :::column-end:::
:::row-end:::

Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) to automate the creation and management of Azure services ([workload identities](/entra/workload-id/workload-identities-overview)). A managed identity allows Azure services to access other Azure services like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments. Hybrid and legacy systems can keep on-premises authentication solutions to simplify the migration but should transition to managed identities as soon as possible.

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

:::row:::
    :::column:::
        ***Well-Architected Framework alignment: Cost optimization ([CO:05](/azure/well-architected/cost-optimization/get-best-rates), [CO:06](/azure/well-architected/cost-optimization/align-usage-to-billing-increments))***
    :::column-end:::
:::row-end:::

Use the performance tiers (SKUs) of Azure services that meet the needs of each environment without excess. To right-size your environments, follow these recommendations:

- *Cost optimize production environments.* Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Continuously monitor resource usage and adjust SKUs to align with actual performance needs.
- *Cost optimize preproduction environments.* [Prepoduction environments](/azure/well-architected/cost-optimization/optimize-environment-costs#optimize-preproduction-environments) should use lower-cost resources, disable unneeded services, and apply discounts such as [Azure Dev/Test pricing](https://azure.microsoft.com/pricing/dev-test/#overview). Ensure [preproduction environments are sufficiently similar to production](/azure/well-architected/cost-optimization/optimize-environment-costs#balance-similarity-with-production) to avoid introducing risks. This balance ensures that testing remains effective without incurring unnecessary costs.
- *Define SKUs using infrastructure as code (IaC).* Implement IaC to dynamically select and deploy the correct SKUs based on the environment. This approach enhances consistency and simplifies management. For example, the reference implementation uses Bicep parameters to deploy more expensive tiers (SKUs) to the production environment (*see the following code*).

    ```bicep
    var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
    var redisCacheFamilyName = isProd ? 'C' : 'C'
    var redisCacheCapacity = isProd ? 1 : 0
    ```

### Implement autoscaling

:::row:::
    :::column:::
        ***Well-Architected Framework pillar support: Reliability ([RE:06](/azure/well-architected/reliability/scaling)), Cost Optimization ([CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs)), Performance Efficiency ([PE:05](/azure/well-architected/performance-efficiency/scale-partition))***
    :::column-end:::
:::row-end:::

Autoscaling ensures web app remain resilient, responsive, and capable of handling dynamic workloads efficiently. To implement autoscaling, follow these recommendations:

- *Automate scale-out.* Use [Azure autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Configure autoscaling rules to scale out based on key performance metrics, so your application can handle varying loads.

- *Refine scaling triggers.* Begin with CPU utilization as your initial scaling trigger if you are unfamiliar with your application’s scaling requirements. Refine your scaling triggers to include other metrics such as RAM, network throughput, and disk I/O to better match your web application's behavior and ensure optimal performance.

- *Provide a scale out buffer.* Set your scaling thresholds to trigger before reaching maximum capacity. For example, configure scaling to occur at 85% CPU utilization rather than waiting until it reaches 100%. This proactive approach helps maintain performance and avoid potential bottlenecks.

### Implement infrastructure as code

:::row:::
    :::column:::
        ***Well-Architected Framework pillar support: Operational Excellence ([OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design))***
    :::column-end:::
:::row-end:::

Use [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) and deploy through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource. The reference implementation uses Bicep to deploy and configure all Azure resources.

### Implement monitoring

:::row:::
    :::column:::
        ***Well-Architected Framework pillar support: Operational Excellence ([OE:07](/azure/well-architected/operational-excellence/observability)), Performance Efficiency ([PE:04](/azure/well-architected/performance-efficiency/collect-performance-data)***
    :::column-end:::
:::row-end:::

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