---
ms.custom: devx-track-dotnet
---

[!INCLUDE [intro](../includes/intro.md)]

### Update architecture

[!INCLUDE [reliable web app pattern architecture updates](../includes/architecture-updates.md)]

### Update code

[!INCLUDE [Code updates](../includes/code-updates.md)]

#### Implement the Retry pattern

[!INCLUDE [Retry pattern intro](../includes/retry.md)]

Use [Resilience4j](https://github.com/resilience4j/resilience4j), a lightweight, fault-tolerance library, to implement the Retry pattern in Java. For example, the reference implementation adds the Retry pattern by decorating the Service Plan Controller's *listServicePlans* method with Retry annotations. The code retries the call to a list of service plans from the database if the initial call fails. The reference implementation configures the retry policy including maximum attempts, wait duration, and which exceptions should be retried. The retry policy is configured in `application.properties`.

```java
    @GetMapping("/list")
    @PreAuthorize("hasAnyAuthority('APPROLE_AccountManager')")
    @CircuitBreaker(name = SERVICE_PLAN)
    @Retry(name = SERVICE_PLAN)
    public String listServicePlans(Model model) {
        List<serviceplandto> servicePlans = planService.getServicePlans();
        model.addAttribute("servicePlans", servicePlans);
        return "pages/plans/list";
    }
```

#### Implement the Circuit Breaker pattern

[!INCLUDE [Circuit-breaker pattern intro](../includes/circuit-breaker.md)] 

Use [Spring Circuit Breaker](https://docs.spring.io/spring-cloud-circuitbreaker/docs/current/reference/html/#usage-documentation) and [Resilience4j documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3) to implement the Circuit-Breaker pattern. For example, the reference implementation implements the Circuit Breaker pattern by decorating methods with the Circuit Breaker attribute.

#### Implement the Cache-Aside pattern

[!INCLUDE [Cache-aside pattern intro](../includes/cache-aside.md)]

- *Configure application to use a cache.* Production apps should use the Distributed Redis Cache because it's the most performant.

- *Cache high-need data.* Apply the Cache-Aside pattern on high-need data to amplify its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after applying the Cache-Aside pattern.

- *Keep cache data fresh.* Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information.

- *Ensure data consistency.* Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

### Update configurations

The following sections provide guidance on implementing the configurations updates. Each section align with one or more pillars of the Well-Architected Framework.

#### Configure user authentication and authorization

[!INCLUDE [User authN and authZ](../includes/user-auth.md)]

- *Use an identity platform.* Use the [Microsoft Identity platform](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). This platform supports both single-tenant and multi-tenant applications, allowing users to sign in with their Microsoft identities or social accounts.

    The [Spring Boot Starter for Microsoft Entra ID](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide?tabs=SpringCloudAzure4x) streamlines this process, utilizing [Spring Security](/azure/developer/java/spring-framework/spring-security-support) and Spring Boot for easy setup. It offers varied authentication flows, automatic token management, and customizable authorization policies, along with integration capabilities with Spring Cloud components. This enables straightforward Microsoft Entra ID and OAuth 2.0 integration into Spring Boot applications without manual library or settings configuration.

    For example, the reference implementation uses the Microsoft identity platform (Microsoft Entra ID) as the identity provider for the web app. It uses the OAuth 2.0 authorization code grant to sign in a user with a Microsoft Entra account. The following XML snippet defines the two required dependencies of the OAuth 2.0 authorization code grant flow. The dependency `com.azure.spring: spring-cloud-azure-starter-active-directory` enables Microsoft Entra authentication and authorization in a Spring Boot application. The dependency `org.springframework.boot: spring-boot-starter-oauth2-client` supports OAuth 2.0 authentication and authorization in a Spring Boot application.

    ```xml
    <dependency>
        <groupid>com.azure.spring</groupid>
        <artifactid>spring-cloud-azure-starter-active-directory</artifactid>
    </dependency>
    <dependency>
        <groupid>org.springframework.boot</groupid>
        <artifactid>spring-boot-starter-oauth2-client</artifactid>
    </dependency>
    ```

- *Create an app registration.* Microsoft Entra ID requires an application registration in the primary tenant. The application registration ensures the users that get access to the web app have identities in the primary tenant. For example, the reference implementation uses Terraform to create an Microsoft Entra ID app registration along with an app specific Account Manager role.

    ```terraform
    resource "azuread_application" "app_registration" {
      display_name     = "${azurecaf_name.app_service.result}-app"
      owners           = [data.azuread_client_config.current.object_id]
      sign_in_audience = "AzureADMyOrg"  # single tenant
    
      app_role {
        allowed_member_types = ["User"]
        description          = "Account Managers"
        display_name         = "Account Manager"
        enabled              = true
        id                   = random_uuid.account_manager_role_id.result
        value                = "AccountManager"
      }
    }
    ```

- *Enforce authorization in the application.* Use role-based access controls (RBAC) to assign least privileges to [application roles](/entra/identity-platform/custom-rbac-for-developers). Define specific roles for different user actions to avoid overlap and ensure clarity. Map users to the appropriate roles and ensure they only have access to necessary resources and actions. Configure Spring Security to use Spring Boot Starter for Microsoft Entra ID. This library allows integration with Microsoft Entra ID and helps you ensure that users are authenticated securely. Configuring and enabling the Microsoft Authentication Library (MSAL) provides access to more security features. These features include token caching and automatic token refreshing.

    For example, the reference implementation creates app roles reflecting the types of user roles in Contoso Fiber's account management system. Roles translate into permissions during authorization. Examples of app-specific roles in CAMS include the account manager, Level one (L1) support representative, and Field Service representative. The Account Manager role has permissions to add new app users and customers. A Field Service representative can create support tickets. The `PreAuthorize` attribute restricts access to specific roles.

    ```java
        @GetMapping("/new")
        @PreAuthorize("hasAnyAuthority('APPROLE_AccountManager')")
        public String newAccount(Model model) {
            if (model.getAttribute("account") == null) {
                List<ServicePlan> servicePlans = accountService.findAllServicePlans();
                ServicePlan defaultServicePlan = servicePlans.stream().filter(sp -> sp.getIsDefault() == true).findFirst().orElse(null);
                NewAccountRequest accountFormData = new NewAccountRequest();
                accountFormData.setSelectedServicePlanId(defaultServicePlan.getId());
                model.addAttribute("account", accountFormData);
                model.addAttribute("servicePlans", servicePlans);
            }
            model.addAttribute("servicePlans", accountService.findAllServicePlans());
            return "pages/account/new";
        }
        ...
    ```

    To [integrate with Microsoft Entra ID](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide?tabs=SpringCloudAzure5x#access-a-web-application), the reference implementation uses the [OAuth 2.0 authorization](/azure/active-directory/develop/v2-oauth2-auth-code-flow) code grant flow. This flow enables a user to sign in with a Microsoft account. The following code snippet shows you how to configure the `SecurityFilterChain` to use Microsoft Entra ID for authentication and authorization.

    ```java
    @Configuration(proxyBeanMethods = false)
    @EnableWebSecurity
    @EnableMethodSecurity
    public class AadOAuth2LoginSecurityConfig {
        @Bean
        SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
            http.apply(AadWebApplicationHttpSecurityConfigurer.aadWebApplication())
                .and()
                    .authorizeHttpRequests()
                .requestMatchers(EndpointRequest.to("health")).permitAll()
                .anyRequest().authenticated()
                .and()
                    .logout(logout -> logout
                                .deleteCookies("JSESSIONID", "XSRF-TOKEN")
                                .clearAuthentication(true)
                                .invalidateHttpSession(true));
            return http.build();
        }
    }
    ...
    ```

    For more information, see:
    
    - [Register an application with the Microsoft identity platform](/azure/active-directory/develop/quickstart-register-app)
    - [AppRoles attribute](/azure/active-directory/develop/reference-app-manifest#approles-attribute)
    - [Spring Boot Starter for Microsoft Entra developer's guide](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide)
    - [Add sign-in with Microsoft Entra account to a Spring web app](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory)
    - [Add app roles to your application and receive them in the token](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)
    - [Configurable token lifetimes in the Microsoft identity platform](/azure/active-directory/develop/active-directory-configurable-token-lifetimes)

- *Prefer temporary access to storage.* Use temporary permissions to safeguard against unauthorized access and breaches, such as [shared access signatures (SASs)](/rest/api/storageservices/delegate-access-with-shared-access-signature). Use User Delegation SASs to maximize security when granting temporary access. It's the only SAS that uses Microsoft Entra ID credentials and doesn't require a permanent storage account key.

- *Enforce authorization in Azure.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to assign least privileges to user identities. Azure RBAC determines what Azure resources identities can access, what they can do with those resources, and what areas they have access to.

- *Avoid permanent elevated permissions.* Use [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time access for privileged operations. For example, developers often need administrator-level access to create/delete databases, modify table schemas, and change user permissions. With just-in-time access, user identities receive temporary permissions to perform privileged tasks.

#### Implement managed identities

[!INCLUDE [Managed identity intro](../includes/managed-id.md)]

- *Use managed identities for service authentication.* Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) to automate the creation and management of Azure services ([workload identities](/entra/workload-id/workload-identities-overview)). A managed identity allows Azure services to access other Azure services like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments. Hybrid and legacy systems can keep on-premises authentication solutions to simplify the migration but should transition to managed identities as soon as possible.

- *Configure least privileges.* Use [Azure RBAC](/azure/role-based-access-control/best-practices) to grant only the permissions that are critical for the operations, such as CRUD actions in databases or accessing secrets. Workload identity permissions are persistent, so you can't provide just-in-time or short-term permissions to workload identities. If Azure RBAC doesn't cover a specific scenario, supplement Azure RBAC with Azure-service level access policies.

- *Secure remaining secrets.* Store any remaining secrets in [Azure Key Vault](/azure/key-vault/secrets/about-secrets). Load secrets from Key Vault at application startup instead of during each HTTP request. High-frequency access within HTTP requests can exceed [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions). Store application configurations in [Azure App Configuration](/azure/azure-app-configuration/overview).

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Right size environments

[!INCLUDE [Right size environments intro](../includes/rightsize.md)] For example, the reference implementation has an optional parameter that deploys different SKUs. An environment parameter instructs the Terraform template to select development SKUs.

    ```azurecli
    azd env set APP_ENVIRONMENT prod
    ```

### Use autoscale

- *Automate scale-out.* Use [autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to automate horizontal scaling in production environments. Scale based on performance metrics.

- *Refine scaling triggers.* Start with CPU utilization performance triggers if you don't understand the scaling criteria of your application. Configure and adapt scaling triggers (CPU, RAM, network, and disk) to match the behavior of your web application.

- *Provide a scale out buffer.* Trigger scaling 10-15% before your web app reaches maximum capacity. For example, scale out at 85% CPU usage rather than 100%.

### Optimize resource usage

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from the template.

- *Use shared services.* Centralize and share network resources in a hub virtual network.

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

    The reference implementation uses a single Azure Cache for Redis instance for session management in the front-end (shopping cart tokens and MSAL tokens) and back-end (upcoming concerts data) web apps.

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

## Next steps

Deploy the **[reference implementation](https://aka.ms/eap/rwa/dotnet)** by following the instructions in the GitHub repository.

[![Diagram showing the architecture of the reference implementation.](../../../_images/reliable-web-app-dotnet.svg)](../../../_images/reliable-web-app-dotnet.svg)
*Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-dotnet-1.1.vsdx) of this architecture.*

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

[reference implementation]: https://aka.ms/eap/rwa/java