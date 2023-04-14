The reliable web app pattern provides implementation guidance to replatform web applications that are transitioning to the cloud. The pattern focuses on the minimal changes you should make to be successful in the cloud. For more information, see [Overview of the reliable web app pattern](../overview.md) and the [Reliable web app pattern video series (YouTube)](https://aka.ms/eap/rwa/dotnet/videos).

This article describes how to apply the reliable web app pattern for .NET. The companion article describes how to [plan the implementation of the reliable web app pattern for .NET](plan-implementation.yml). A [reference implementation](https://aka.ms/eap/rwa/dotnet) is available for you to deploy.

## Architecture and code

A well-architected web application needs quality code, and quality code needs a well-architected solution. The reliable web app pattern situates code changes within the pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/) to reinforce the close relationship between code and architecture. The following diagram illustrates the architecture of the reference implementation.

[![Diagram showing the architecture of the reference implementation.](images/reliable-web-app-dotnet.png)](images/reliable-web-app-dotnet.png)

*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet.vsdx) of this architecture. For the estimated cost, see:*

- [Production environment estimated cost](https://azure.com/e/26f1165c5e9344a4bf814cfe6c85ed8d)
- [Non-production environment estimated cost](https://azure.com/e/8a574d4811a74928b55956838db71093)

The following table lists the principles of the reliable web app pattern and how the reference implementation applies these principles.

| Reliable web app principles | Implementation for .NET |
| --- | --- |
|▪ Follow Azure Well-Architected Framework principles<br>▪ Low-cost, high-value wins<br>▪ Minimal code changes to:<ol>▫ Meet security best practices<br>▫ Apply reliability design patterns<br>▫ Improve operational excellence</ol>▪ Cost-optimized environment(s)<br>▪ Business-driven service level objective |▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Right-size resource <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Repeatable infrastructure <br>▪ Telemetry, logging, monitoring |

## Reliability

A reliable web application is one that is both resilient and available. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is a measure of whether your users can access your web application when they need to. You should use the Retry and Circuit Breaker patterns as critical first steps toward improving application reliability. These design patterns introduce self-healing qualities and help your application maximize the reliability features of the cloud. Here are our reliability recommendations.

### Use the Retry pattern

The Retry pattern is a technique for handling temporary service interruptions. These temporary service interruptions are known as *transient faults* and typically resolve themselves in a few seconds. In the cloud, the leading causes of transient faults are service throttling, dynamic load distribution, and network connectivity. The Retry pattern handles transient faults by resending failed requests to the service. You can configure the amount of time between retries and how many retries to attempt before throwing an exception.

*Simulate the Retry pattern:* You can simulate the Retry pattern in the reference implementation. For instructions, see [Simulate the Retry pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#retry-pattern).

If your code already uses the Retry pattern, you should update your code to use the retry mechanisms available in Azure services and client SDKs. If your application doesn't have a Retry pattern, you should add one based on the following guidance. For more information, see:

- [Transient fault handling](/azure/architecture/best-practices/transient-faults)
- [Retry pattern](/azure/architecture/patterns/retry)

**Try the Azure service and client SDKs first.** Most Azure services and client SDKs have a built-in retry mechanism. You should use the built-in retry mechanism for Azure services to expedite the implementation. For more information, see [Azure service retry guidance](/azure/architecture/best-practices/retry-service-specific).

*Reference implementation:* The reference implementation uses the connection resiliency mechanism in Entity Framework Core to apply the Retry pattern in requests to Azure SQL Database. For more information, see:

- [SQL Database using Entity Framework Core](/azure/architecture/best-practices/retry-service-specific#sql-database-using-entity-framework-core)
- [Connection Resiliency in Entity Framework Core](/ef/core/miscellaneous/connection-resiliency)

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

**Use the Polly library when the client library doesn't support retries.** You might need to make calls to a dependency that isn't an Azure service or doesn't support the Retry pattern natively. In that case, you should use the Polly library to implement the Retry pattern. [Polly](https://github.com/App-vNext/Polly) is a .NET resilience and transient-fault-handling library. With it, you can use fluent APIs to describe behavior in a central location of the application.

*Reference implementation:* The reference implementation uses Polly to set up the ASP.NET Core dependency injection. Polly enforces the Retry pattern every time the code constructs an object that calls the `IConcertSearchService` object. In the Polly framework, that behavior is known as a *policy*. The code extracts this policy in the `GetRetryPolicy` method, and the `GetRetryPolicy` method applies the Retry pattern every time the front-end web app calls web API services. The following code applies the Retry pattern to all service calls to the concert search service.

```csharp
private void AddConcertSearchService(IServiceCollection services)
{
    var baseUri = Configuration["App:RelecloudApi:BaseUri"];
    if (string.IsNullOrWhiteSpace(baseUri))
    {
        services.AddScoped<IConcertSearchService, DummyConcertSearchService>();
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

You should pair the Retry pattern with the Circuit Breaker pattern. The Circuit Breaker pattern handles faults that aren't transient. The goal is to prevent an application from repeatedly invoking a service that is down. The Circuit Breaker pattern releases the application from the task to avoid wasting CPU cycles and improves application performance. For more information, see [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker).

*Simulate the Circuit Breaker pattern:* You can simulate the Circuit Breaker pattern in the reference implementation. For instructions, see [Simulate the Circuit Breaker pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#circuit-breaker-pattern).

*Reference implementation:* The reference implementation adds the Circuit Breaker pattern in the `GetCircuitBreakerPolicy` method, as you can see in the following code snippet.

```csharp
private static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .CircuitBreakerAsync(5, TimeSpan.FromSeconds(30));
}
```

The policy handler for the `RelecloudApiConcertSearchService` instance applies the Circuit Breaker pattern on all requests to the API. It uses the `HandleTransientHttpError` logic to detect HTTP requests that it can safely retry but limits the number of aggregate faults over a specified period of time. For more information, see [Implement the Circuit Breaker pattern](/dotnet/architecture/microservices/implement-resilient-applications/implement-circuit-breaker-pattern#implement-circuit-breaker-pattern-with-ihttpclientfactory-and-polly).

## Security

Cloud applications are often composed of multiple Azure services. Communication between those services needs to be secure. Enforcing secure authentication, authorization, and accounting practices in your application is essential to your security posture. At this phase in the cloud journey, you should use managed identities, secrets management, and private endpoints.

### Use managed identities

You should use managed identities for all supported Azure services. They make identity management easier and more secure, providing benefits for authentication, authorization, and accounting.

#### Overview

**Authentication:** Managed identities provide an automatically managed identity in Azure Active Directory (Azure AD) that applications can use when they connect to resources that support Azure AD authentication. Application code can use the application platform's managed identity to obtain Azure AD tokens without having to access static credentials from configuration.

Managed identities are similar to the identity component in connection strings in typical on-premises applications. On-premises apps use connection strings to prove an application's identity to a database. Trusted connection and integrated security features hide the database user name and password from the config file. The application connects to the database via an Active Directory account.

**Authorization:** When you grant managed identities access to a resource, you should always grant the least permissions needed.

*Reference implementation:* The reference implementation grants the managed identity of App Service elevated access to Azure SQL Database because the deployed code uses Entity Framework Code First Migrations to manage the schema. You should grant the managed identities only the permissions necessary to support the needs of the code, such as the ability to read or write data.

**Accounting:** Accounting in cybersecurity refers to the process of tracking and logging actions within an environment. With managed identities in Azure, you can gain better visibility into which supported Azure resources are accessing other resources and set appropriate permissions for each resource or service. Although connection strings with secrets stored in Azure Key Vault can provide secure access to a resource, they don't offer the same level of accounting visibility. As a result, it can be more challenging to govern and control access using only connection strings. Managed identities provide a traceable way to control access to Azure resources. For more information, see:

- [Developer introduction and guidelines for credentials](/azure/active-directory/managed-identities-azure-resources/overview-for-developers)
- [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure services supporting managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identities-status)
- [Web app managed identity](/azure/active-directory/develop/multi-service-web-app-access-storage)

#### How to set up managed identities

Managed identities have two components. There's a code component and the infrastructure component. You should use the `DefaultAzureCredential` class from the Azure SDK library to set up the code and infrastructure as code (IaC) to deploy the infrastructure.

**1. Use DefaultAzureCredential to set up code.** The `DefaultAzureCredential` creates a default `TokenCredential` (credentials that provide an OAuth token) capable of handling most Azure SDK authentication scenarios. It starts the authentication flow for applications that deploy to Azure. The identity it uses depends on the environment. When an access token is needed, it requests a token from its application platform host. For more information, see [DefaultAzureCredential](/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet).

*Reference implementation:* The reference implementation uses the `DefaultAzureCredential` class during start up to enable the use of managed identity between the web API and Key Vault.

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

The `DefaultAzureCredential` class works with Microsoft client libraries to provide credentials for local development and managed identities in the cloud.

**2. Automate infrastructure build.** You should use Bicep templates to create and configure the Azure infrastructure to support managed identities. Managed identities don't use secrets or passwords, so you don't need Key Vault or a secret rotation strategy to ensure integrity. You can store the connection strings in the App Configuration Service.

*Reference implementation:* The reference implementation uses Bicep templates to accomplish the following tasks:

1. Create the managed identity.
1. Associate the identity with the web app.
1. Grant the identity permission to access the SQL database.
1. The `Authentication` argument in the following connection string tells the Microsoft client library to connect with a managed identity.

    ```csharp
    Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-sql-database;Authentication=Active Directory Default
    ```

For more information, see [Connect to SQL database from .NET App Service](/azure/app-service/tutorial-connect-msi-sql-database).

### Use a central secrets store

Not every service supports managed identities, so sometimes you have to use secrets. In these situations, you must externalize the application configurations and put the secrets in a central secret store. In Azure, the central secret store is Azure Key Vault.

Many on-premises environments don't have a central secrets store. The absence makes key rotation uncommon and auditing to see who has access to a secret difficult. However, with Key Vault you can store secrets, rotate keys, and audit key access. You can also enable monitor in Key Vault. For more information, see [Monitoring Azure Key Vault](/azure/key-vault/general/monitor-key-vault).

*Reference implementation:* The reference implementation doesn't use Key Vault monitoring, and it also uses external secrets for three services.

- *Azure AD client secret:* There are different authorization processes. To provide the API with an authenticated employee, the web app uses an on-behalf-of flow. The on-behalf-of flow needed a client secret from Azure AD and stored in Key Vault. To rotate the secret, generate a new client secret and then save the new value to Key Vault. In the reference implementation, restart the web app so the code starts using the new secret. After the web app has been restarted, the team can delete the previous client secret.

- *Azure Cache for Redis secret:* The service doesn't currently support managed identity. To rotate the key in the connection string, you need to change the value in Key Vault to the secondary connection string for Azure Cache for Redis. After changing the value, you must restart the web app to use the new settings. Use the Azure CLI or the Azure portal to regenerate the access key for Azure Cache for Redis.

- *Azure Storage Account secret:* The web app uses shared access signature (SAS) URLs and generates SAS URLs with each ticket. The reference implementation makes ticket images publicly available to users from Azure storage. The primary Storage Account access key creates the SAS URL and grants access to the ticket image for a limited time of 30-days. For more information, see [Manage account access keys](/azure/storage/common/storage-account-keys-manage).

### Secure communication with private endpoints

You should use private endpoints to provide more secure communication between your web app and Azure services. By default, service communication to most Azure services crosses the public internet. In the reference implementation, these services include Azure SQL Database, Azure Cache for Redis, and Azure App Service. Azure Private Link enables you to add security to that communication via private endpoints in a virtual network to avoid the public internet.

This improved network security is transparent from the code perspective. It doesn't involve any app configuration, connection string, or code changes. For more information, see:

- [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario)
- [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints)

### Use a web application firewall

You should protect web applications with a web application firewall. The web application firewall provides a level protection against common security attacks and botnets. To take full advantage of the web application firewall, you must prevent traffic from bypassing it. You should restrict access on the application platform (App Service) to only accept inbound communication from Azure Front Door.

*Reference implementation:* The reference implementation uses Front Door as the host name URL. In production, you should use your own host name and follow the guidance in [Preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

## Cost optimization

Cost optimization principles balance business goals with budget justification to create a cost-effective web application. Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For a web app converging on the cloud, here are our recommendations for cost optimization. The code changes optimize for horizontal scale to reduce costs rather than optimizing existing business processes. The latter can lead to higher risks.

*Reference implementation:* The checkout process in the reference implementation has a hot path of rendering ticket images during request processing. You can isolate the checkout process to improve cost optimization and performance efficiency, but this change is beyond the scope of the reliable web app pattern. You should address it in future modernizations.

### Rightsize resources for each environment

Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. But non-production environments don't normally need the same capabilities. You can optimize costs in non-production environments by using cheaper SKUs that have lower capacity and SLAs. You should consider Azure Dev/Test pricing and Azure Reservations. How or whether you use these cost-saving methods depends on your environment.

**Consider Azure Dev/Test pricing.** Azure Dev/Test pricing gives you access to select Azure services for non-production environments at discounted pricing under the Microsoft Customer Agreement. The plan reduces the costs of running and managing applications in development and testing environments, across a range of Microsoft products. For more information, see [Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview).

**Consider Azure Reservations or an Azure savings plan.** You can combine an Azure savings plan with Azure Reservations to optimize compute cost and flexibility. Azure Reservations help you save by committing to one-year or three-year plans for multiple products. The Azure savings plan for compute is the most flexible savings plan. It generates savings on pay-as-you-go prices. Pick a one-year or three-year commitment for compute services, regardless of region, instance size, or operating system. Eligible compute services include virtual machines, dedicated hosts, container instances, Azure Functions Premium, and Azure app services. For more information, see:

- [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations)
- [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview)

*Reference implementation:* The reference implementation uses Bicep parameters to trigger resource deployment configurations. One of these parameters tells Azure Resource Manager which SKUs to select. The following code gives Azure Cache for Redis different SKUs for production and non-production environments:

```bicep
var redisCacheSkuName = isProd ? 'Standard' : 'Basic'
var redisCacheFamilyName = isProd ? 'C' : 'C'
var redisCacheCapacity = isProd ? 1 : 0
```

The web app uses the Standard C1 SKU for the production environment and the Basic C0 SKU for the non-production environment. The Basic C0 SKU costs less than the Standard C1 SKU. It provides the behavior needed for testing without the data capacity or availability targets needed for the production environment (see following table). For more information, see [Azure Cache for Redis pricing](https://azure.microsoft.com/pricing/details/cache/).

|   | Standard C1 SKU | Basic C0 SKU|
| --- | --- | --- |
|**SKU Features**| 1-GB cache <br> Dedicated service <br> Availability SLA <br> As many as 1,000 connections |250-MB cache <br> Shared infrastructure <br> No SLA <br> As many as 256 connections

### Automate scaling the environment

You should use autoscale to automate horizontal scaling for production environments. Autoscaling adapts to user demand to save you money. Horizontal scaling automatically increases compute capacity to meet user demand and decreases compute capacity when demand drops. Don't increase the size of your application platform (vertical scaling) to meet frequent changes in demand. It's less cost efficient. For more information, see:

- [Scaling in Azure App Service](/azure/app-service/manage-scale-up)
- [Autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview)

*Reference implementation:* The reference implementation uses the following configuration in the Bicep template. It creates an autoscale rule for the Azure App Service. The rule scales up to 10 instances and defaults to one instance.

```csharp
resource webAppScaleRule 'Microsoft.Insights/autoscalesettings@2021-05-01-preview' = if (isProd) {
  name: '${resourceToken}-web-plan-autoscale'
  location: location
  properties: {
    targetResourceUri: webAppServicePlan.id
    enabled: true
    profiles: [
      {
        name: 'Auto scale from one to ten'
        capacity: {
          maximum: '10'
          default: '1'
          minimum: '1'
        }
        rules: [
          ...
        ]
      }
    ]
  }
}
```

### Delete non-production environments

To optimize cost, it is recommended that you delete non-production environments during periods of low activity such as business hours or holidays. Additionally, it is important to ensure that any unused environments are deleted in a controlled and repeatable process. One way to achieve this is by building a deployment pipeline that includes steps for deleting environments in an automated and standardized manner.

### Use cache to support multiple data types

You should use a single cache instance to support multiple data types rather than using a single instance for each data type.

*Reference implementation:* The reference implementation uses a single Azure Cache for Redis instance to store session state for the front-end web app and the back-end web app. The front-end web app stores two pieces of data in session state. It stores the cart and the Microsoft Authentication Library (MSAL) token. The back-end web app stores the Upcoming Concerts page data. The reference implementation uses the smallest Redis SKU to handle these requirements. This SKU still provides more capacity than the web API needs. To manage costs, the extra capacity uses multiple data types.

## Operational excellence

A DevOps methodology provides a greater return on investment for application teams in the cloud. IaC is a key tenet of DevOps. The reliable web app pattern requires the use of IaC to deploy application infrastructure, configure services, and set up application telemetry. Monitoring operational health requires telemetry to measure security, cost, reliability, and performance gains. The cloud offers built-in features to capture telemetry. When this telemetry is fed into a DevOps framework, it can help you rapidly improve your application.

### Automate deployments

You should use a DevOps pipeline to deploy changes from source control to production. If you're using Azure DevOps, you should use Azure Pipelines. If you're using GitHub, you should explore GitHub actions.  Automating deployments with IaC offers the following benefits:

- **Resolves production issues faster.** IaC creates consistent environments that foster predictable behaviors in production. The development team can automate the creation of a copy of the production environment to troubleshot production issues.
- **Applies changes consistently across environments.** You should use IaC to consistently apply a change to every environment. You can use a GitHub action to create a deployment workflow that has separate pipelines for different environments. You can use environment variables to differentiate between the environments. When you deploy a fix to the development environment, you can manually trigger a deployment of the same code to the production environment.
- **Maximizes productivity.** Use automation to set up new environments and reduce the operational overhead managing environments manually.
- **Improves governance.** IaC makes it easier to audit and review production changes deployed to Azure because they're checked in to source control.

For more information, see [Repeatable infrastructure](/azure/architecture/framework/devops/automation-infrastructure).

*Reference implementation:* The reference implementation uses Azure Dev CLI and IaC (Bicep templates) to create Azure resources, setup configuration, and deploy the required resources from a GitHub Action.  

### Logging and application telemetry

You should enable logging to diagnose when any request fails for tracing and debugging. The telemetry you gather on your application should cater to the operational needs of the web application. At a minimum, you must collect telemetry on baseline metrics. Gather information on user behavior that can help you apply targeted improvements. Here are our recommendations for collecting application telemetry:

**Monitor baseline metrics.** The workload should monitor baseline metrics. Important metrics to measure include request throughput, average request duration, errors, and dependency monitoring. You should use Application Insights to gather this telemetry. You can use `AddApplicationInsightsTelemetry` from the NuGet package `Microsoft.ApplicationInsights.AspNetCore` to enable telemetry collection. For more information, see:

- [Enable Application Insights telemetry](/azure/azure-monitor/app/asp-net-core)
- [Dependency injection in .NET](/dotnet/core/extensions/dependency-injection)

*Reference implementation:* The reference implementation uses the following code to configure baseline metrics in Application Insights.

```csharp
public void ConfigureServices(IServiceCollection services)
{
   ...
   services.AddApplicationInsightsTelemetry(Configuration["App:Api:ApplicationInsights:ConnectionString"]);
   ...
}
```

**Create custom telemetry as needed.** You should augment baseline metrics with information that helps you understand your users. You can use Application Insights to gather custom telemetry. To create custom telemetry, you need to create an instance of the `TelemetryClient` class and use the `TelemetryClient` methods to create the right metric. For more information, see:

- [Application Insights API for custom events and metrics](/azure/azure-monitor/app/api-custom-events-metrics#trackevent)
- [TelemetryClient class](/dotnet/api/microsoft.applicationinsights.telemetryclient)
- [Telemetry client methods](/dotnet/api/microsoft.applicationinsights.telemetryclient)

*Reference implementation:* The reference implementation augments the web app with metrics that help the operations team identify that the web app is completing transactions successfully. It validates that the web app is online by monitoring whether customers can place orders, not by measuring the number of requests or CPU usage. The reference implementation uses `TelemetryClient` via dependency injection and the `TrackEvent` method to gather telemetry on events related to cart activity. The telemetry tracks the tickets that users add, remove, and purchase.

- `AddToCart` counts how many times users add a certain ticket (`ConcertID`) to the cart.
- `RemoveFromCart` records tickets that users remove from the cart.
- `CheckoutCart` records an event every time a user buys a ticket.

You can find the telemetry from `TelemetryClient` in the Azure portal. Go to Application Insights. Under **Usage**, select **Events**. For more information, see [Application Insights TrackEvent](/azure/azure-monitor/app/api-custom-events-metrics#trackevent).

The following code uses `this.telemetryClient.TrackEvent` to count the tickets added to the cart. It supplies the event name (`AddToCart`) and specifies the output (a dictionary that has the `concertId` and `count`). You should turn the query into an Azure Dashboard widget.

```csharp
this.telemetryClient.TrackEvent("AddToCart", new Dictionary<string, string> {
    { "ConcertId", concertId.ToString() },
    { "Count", count.ToString() }
});
```

**Gather log-based metrics.** You should track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. You can run these queries in the portal. Under **Monitoring**, select **Logs** to run your queries. For more information, see:

- [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics)
- [Log-based and pre-aggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics)

## Performance efficiency

Performance efficiency is the ability of a workload to scale and meet the demands placed on it by users in an efficient manner. In cloud environments, a workload should anticipate increases in demand to meet business requirements. You should use the Cache-Aside pattern to manage application data while improving performance and optimizing costs.

### Use the Cache-Aside pattern

The Cache-Aside pattern is a technique that's used to manage in-memory data caching. The Cache-Aside pattern makes the application responsible for managing data requests and data consistency between the cache and a persistent data store, like a database. When a data request reaches the application, the application first checks the cache to see if the cache has the data in memory. If it doesn't, the application queries the database, replies to the requester, and stores that data in the cache. For more information, see [Cache-Aside pattern overview](/azure/architecture/patterns/cache-aside).

*Simulate the Cache-Aside pattern:* You can simulate the Cache-Aside pattern in the reference implementation. For instructions, see [Simulate the Cache-Aside pattern](https://github.com/Azure/reliable-web-app-pattern-dotnet/blob/main/simulate-patterns.md#cache-aside-pattern).

The Cache-Aside pattern introduces a few benefits to the web application. It reduces the request response time and can lead to increased response throughput. This efficiency reduces the number of horizontal scaling events, making the app more capable of handling traffic bursts. It also improves service availability by reducing the load on the primary data store and decreasing the likelihood of service outages.

*Reference implementation:* The reference implementation uses the Cache-Aside pattern to improve the performance of the Azure SQL database, minimize cost, and increase application performance. It caches the upcoming concert data, which is part of the ticket purchase hot path. The distributed memory cache is a framework provided by ASP.NET Core that stores items in memory.

When the application starts, it configures itself to use Azure Cache for Redis if it detects a connection string. The configuration also supports local development scenarios when you don't need Redis. This configuration can save you money and reduce complexity. For more information, see:

- [Distributed caching in ASP.NET Core](/aspnet/core/performance/caching/distributed?view=aspnetcore-6.0)
- [AddDistributedMemoryCache method](/dotnet/api/microsoft.extensions.dependencyinjection.memorycacheservicecollectionextensions.adddistributedmemorycache)

The following method (`AddAzureCacheForRedis`) configures the application to use Azure Cache for Redis.

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

**Cache high-need data.** Most applications have pages that get more viewers than other pages. You should cache data that supports the most-viewed pages of your application to improve responsiveness for the end user and reduce demand on the database. You should use Azure Monitor and Azure SQL Analytics to track the CPU, memory, and storage of the database. You can use these metrics to determine whether you can use a smaller database SKU.

*Reference implementation:* The reference implementation caches the data that supports the Upcoming Concerts. The Upcoming Concerts page creates the most queries to SQL Database and produces a consistent output for each visit. The Cache-Aside pattern caches the data after the first request for this page to reduce the load on the database. The following code uses the `GetUpcomingConcertsAsync` method to pull data into the Redis cache from SQL Database.

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

The method populates the cache with the latest concerts. The method filters by time, sorts the data, and returns the data to the controller to display the results.

**Keep cache data fresh.** You should periodically refresh the data in the cache to keep it relevant. The process involves getting the latest version of the data from the database to ensure that the cache has the most requested data and the most current information. The goal is to ensure that users get current data fast. The frequency of the refreshes depends on the application.

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

**Ensure data consistency.** You need to change cached data whenever a user makes an update. An event-driven system can make these updates. Another option is to ensure that cached data is only accessed directly from the repository class that's responsible for handling the create and edit events.

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

### Autoscale by performance metrics

Autoscale based on performance metrics so that users aren't affected by SKU constraints. CPU utilization performance triggers are a good starting point if you don't understand the scaling criteria of your application. You need to configure and adapt scaling triggers (CPU, RAM, network, and disk) to correspond to the behavior of your web application.

*Reference implementation:* The reference implementation uses CPU usage as the trigger for scaling in and out. The web app hosting platform scales out at 85% CPU usage and scales in at 60%. The scale-out setting of 85%, rather than a percentage closer to 100%, provides a buffer to protect against accumulated user traffic caused by sticky sessions. It also protects against high bursts of traffic by scaling early to avoid maximum CPU usage. These autoscale rules aren't universal.

## Deploy the reference implementation

The reference implementation is a concert ticketing web app that uses the reliable web app pattern for .NET. You can deploy the reference implementation by following the instructions in the [reliable web app pattern for .NET repository](https://aka.ms/eap/rwa/dotnet). The repository has everything you need.  Follow the deployment guidelines to deploy the code to Azure and local development.

## Next steps

The following resources can help you learn cloud best practices, discover migration tools, and learn about .NET.

### Introduction to web apps on Azure

For a hands-on introduction to .NET web applications on Azure, see this [guidance for deploying a basic .NET web application](https://github.com/Azure-Samples/app-templates-dotnet-azuresql-appservice).

### Cloud best practices

For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). A framework to help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that you can use to improve the quality of a workload.

For applications that require a higher service level objective (SLO), see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for various database types, and tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.

### Upgrading .NET Framework applications

The reference implementation deploys to an App Service that runs Windows, but it can run on Linux. The App Service Windows platform enables you to move .NET Framework web apps to Azure without upgrading to newer framework versions. For information about Linux App Service plans or new features and performance improvements added to the latest versions of .NET, see the following guidance.

- [Overview of porting from .NET Framework to .NET](/dotnet/core/porting/). Get guidance based on your specific type of .NET app.
- [Overview of the .NET Upgrade Assistant](/dotnet/core/porting/upgrade-assistant-overview). Learn about a console tool that can help you automate many of the tasks associated with upgrading .NET Framework projects.
- [Migrating from ASP.NET to ASP.NET Core in Visual Studio](https://devblogs.microsoft.com/dotnet/introducing-project-migrations-visual-studio-extension/). Learn about a Visual Studio extension that can help you with incremental migrations of web apps.
