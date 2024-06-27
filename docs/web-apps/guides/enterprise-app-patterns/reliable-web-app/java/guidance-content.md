---
ms.custom: devx-track-dotnet
---

[!INCLUDE [intro](../includes/intro.md)]

### Architecture guidance

[!INCLUDE [reliable web app pattern architecture updates](../includes/architecture-updates.md)]

### Code guidance

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

- *Configure application to use a cache.* To enable caching, add the `spring-boot-starter-cache` package as a dependency in your `pom.xml` file. This package provides default configurations for Redis cache.

- *Cache high-need data.* Apply the Cache-Aside pattern on high-need data to amplify its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after applying the Cache-Aside pattern. To cache specific data in your code, add the `@Cacheable` annotation. This annotation tells Spring which methods to cache the results of.

- *Keep cache data fresh.* Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information. The default cache settings might not  suit your web application. You can customize these settings in the `application.properties` file or the environment variables. For instance, you can modify the `spring.cache.redis.time-to-live` value (expressed in milliseconds) to control how long data should remain in the cache before it’s evicted.

- *Ensure data consistency.* Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

## Configuration guidance

[!INCLUDE [configuration guidance intro](../includes/configuration.md)]

### Configure user authentication and authorization

[!INCLUDE [AuthN and AuthZ intor](../includes/authn-authz.md)]

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

[!INCLUDE [User authN and authZ](../includes/authn-authz.md)]

### Implement managed identities

[!INCLUDE [Managed identity intro](../includes/managed-id.md)]

### Right size environments

[!INCLUDE [Right size environments intro and guidance](../includes/rightsize.md)] For example, the reference implementation has an optional parameter that deploys different SKUs. An environment parameter instructs the Terraform template to select development SKUs.

    ```azurecli
    azd env set APP_ENVIRONMENT prod
    ```

### Implement autoscaling

[!INCLUDE [Autoscaling guidance](../includes/autoscaling.md)]

### Automate resource deployment

[!INCLUDE [Automate deployment guidance](../includes/automate-deployment.md)]

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

## Deploy the reference implementation

The reference implementation guides developers through a simulated migration from an on-premises Java application to Azure, highlighting necessary changes during the initial adoption phase. This example uses a Customer Account Management System (CAMS) web app application for the fictional company Contoso Fibre. Contoso Fiber set the following goals for their web application:

- Implement low-cost, high-value code changes
- Achieve a service level objective (SLO) of 99.9%
- Adopt DevOps practices
- Create cost-optimized environments
- Enhance reliability and security

Contoso Fiber determined that their on-premises infrastructure wasn't a cost-effective solution to meet these goals. They decided that migrating their CAMS web application to Azure was the most cost effective way to achieve their immediate and future goals. The following architecture represents the end-state of Contoso Fiber's Reliable Web App pattern implementation.

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-java.svg)](../../_images/reliable-web-app-java.svg#lightbox)
*Figure 4. Architecture of the reference implementation. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java-1.1.vsdx) of this architecture.*

>[!div class="nextstepaction"]
>[Reliable Web App pattern for Java reference implementation](reference-implementation)

[reference-implementation]: https://aka.ms/eap/rwa/java