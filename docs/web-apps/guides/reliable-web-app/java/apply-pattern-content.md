---
ms.custom: devx-track-extended-java
---

This article shows you how to apply the Reliable Web App pattern. The Reliable Web App pattern is a set of [principles and implementation techniques](../overview.md) that define how you should modify web apps (replatform) when migrating to the cloud. It focuses on the minimal code updates you need to make to be successful in the cloud.

To facilitate the application of this guidance, there's a **[reference implementation](https://aka.ms/eap/rwa/java)** of the Reliable Web App pattern that you can deploy.

[![Diagram showing the architecture of the reference implementation.](../../_images/reliable-web-app-java.svg)](../../_images/reliable-web-app-java.svg#lightbox)
*Architecture of reference implementation architecture. Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java-1.1.vsdx) of this architecture.*

The following guidance uses the reference implementation as an example throughout. To apply the Reliable Web App pattern, follow these recommendations aligned to the pillars of the Well-Architected Framework:

## Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see the [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). The Reliable Web App pattern introduces two key design patterns at the code level to enhance reliability: the Retry pattern and the Circuit Breaker pattern.

### Use the Retry pattern

The [Retry pattern](/azure/architecture/patterns/retry) addresses temporary service disruptions, termed [transient faults](/azure/architecture/best-practices/transient-faults), which usually resolve within seconds. These faults often result from service throttling, dynamic load distribution, and network issues in cloud environments. Implementing the Retry pattern involves resending failed requests, allowing configurable delays and attempts before throwing an exception.

Use [Resilience4j](https://github.com/resilience4j/resilience4j) to implement the Retry pattern in Java. Resilience4j is a lightweight, fault-tolerance library. It provides higher-order functions (decorators) to enhance functional interfaces, lambda expressions, and method references with a Circuit Breaker, Rate Limiter, Retry, or Bulkhead design pattern.

*Example:* The reference implementation adds the Retry pattern by decorating the Service Plan Controller's *listServicePlans* method with Retry annotations. The code retries the call to a list of service plans from the database if the initial call fails.

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

The reference implementation configures the retry policy including maximum attempts, wait duration, and which exceptions should be retried. The retry policy is configured in `application.properties`. For more information, see the [Resilience4j documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3). You can [simulate the Retry pattern](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/simulate-patterns.md#retry-and-circuit-break-pattern) in the reference implementation.

### Use the Circuit Breaker pattern

Pairing the Retry and Circuit Breaker patterns expands an application's capability to handle service disruptions that aren't related to transient faults. The [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) prevents an application from continuously attempting to access a nonresponsive service. The Circuit Breaker pattern releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users. For more information, see [Spring Circuit Breaker](https://docs.spring.io/spring-cloud-circuitbreaker/docs/current/reference/html/#usage-documentation), and [Resilience4j documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3).

*Example:* The reference implementation implements the Circuit Breaker pattern by decorating methods with the Circuit Breaker attribute. You can [simulate the circuit breaker pattern](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/simulate-patterns.md#retry-and-circuit-break-pattern) in the reference implementation.

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

For more information, see:

- [Access to Azure Storage](/azure/storage/blobs/authorize-access-azure-active-directory)
- [Access to Key Vault](/azure/key-vault/general/rbac-guide)
- [Access to Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-azure-ad-authentication)

### Configure user authentication and authorization

Authentication and authorization are critical aspects of web application security. *Authentication* is the process of verifying the identity of a user. *Authorization* specifies the actions a user is allowed to perform within the application. The goal is to implement authentication and authorization without weakening your security posture. To meet this goal, you need to use the features of the Azure application platform (Azure App Service) and identity provider (Microsoft Entra ID).

#### Configure user authentication

Secure your web app by enabling user authentication through your platform's features. [Azure App Service](/azure/app-service/overview-authentication-authorization) supports authentication with identity providers like Microsoft Entra ID, offloading the authentication workload from your code.

*Example:* The reference implementation uses Microsoft Entra ID as the identity platform. Microsoft Entra ID requires an application registration in the primary tenant. The application registration ensures the users that get access to the web app have identities in the primary tenant. The following Terraform code the creation of an Entra ID app registration along with an app specific Account Manager role.

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

Key Vault securely stores our client configuration data and the App Service platform exposes the information to our app as environment variables.

#### Integrate with the identity provider

Integrate your web application with Microsoft Entra ID for secure authentication and authorization. The [Spring Boot Starter for Microsoft Entra ID](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide?tabs=SpringCloudAzure4x) streamlines this process, utilizing Spring Security and Spring Boot for easy setup. It offers varied authentication flows, automatic token management, and customizable authorization policies, along with integration capabilities with Spring Cloud components. This enables straightforward Microsoft Entra ID and OAuth 2.0 integration into Spring Boot applications without manual library or settings configuration.

*Example:* The reference implementation uses the Microsoft identity platform (Microsoft Entra ID) as the identity provider for the web app. It uses the OAuth 2.0 authorization code grant to sign in a user with a Microsoft Entra account. The following XML snippet defines the two required dependencies of the OAuth 2.0 authorization code grant flow. The dependency `com.azure.spring: spring-cloud-azure-starter-active-directory` enables Microsoft Entra authentication and authorization in a Spring Boot application. The dependency `org.springframework.boot: spring-boot-starter-oauth2-client` supports OAuth 2.0 authentication and authorization in a Spring Boot application.

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

For more information, see [Spring Cloud Azure support for Spring Security](https://learn.microsoft.com/azure/developer/java/spring-framework/spring-security-support).

#### Implement authentication and authorization business rules

Implementing authentication and authorization business rules involves defining the access control policies and permissions for various application functionalities and resources. You need to configure Spring Security to use Spring Boot Starter for Microsoft Entra ID. This library allows integration with Microsoft Entra ID and helps you ensure that users are authenticated securely. Configuring and enabling the Microsoft Authentication Library (MSAL) provides access to more security features. These features include token caching and automatic token refreshing.

*Example:* The reference implementation creates app roles reflecting the types of user roles in Contoso Fiber's account management system. Roles translate into permissions during authorization. Examples of app-specific roles in CAMS include the account manager, Level one (L1) support representative, and Field Service representative. The Account Manager role has permissions to add new app users and customers. A Field Service representative can create support tickets. The `PreAuthorize` attribute restricts access to specific roles.

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

### Configure service authentication and authorization

Configure service authentication and authorization so the services in your environment have the permissions to perform necessary functions. Use [Managed Identities](/entra/identity/managed-identities-azure-resources/overview-for-developers) in Microsoft Entra ID to automate the creation and management of service identities, eliminating manual credential management. A managed identity allows your web app to securely access Azure services, like Azure Key Vault and databases. It also facilitates CI/CD pipeline integrations for deployments to Azure App Service. However, in scenarios like hybrid deployments or with legacy systems, continue using your on-premises authentication solutions to simplify migration. Transition to managed identities when your system is ready for a modern identity management approach. For more information, see [Monitoring managed identities](/entra/identity/managed-identities-azure-resources/how-to-view-managed-identity-activity).

*Example:* The reference implementation keeps the on-premises authentication mechanism for the database (username and password). As a result, the reference implementation stores the database secret in Key Vault. The web app uses a managed identity (system assigned) to retrieve secrets from Key Vault.

### Use a central secrets store to manage secrets

When you move your application to the cloud, use [Azure Key Vault](/azure/key-vault/secrets/about-secrets) to securely store all such secrets. This centralized repository offers secure storage, key rotation, access auditing, and monitoring for services not supporting managed identities. For application configurations, [Azure App Configuration](/azure/azure-app-configuration/overview) is recommended.

*Example:* The reference implementation stores the following secrets in Key Vault: (1) PostgreSQL database username and password, (2) Redis Cache password, and (3) the client secret for Microsoft Entra ID associated with the MSAL implementation.

#### Don't put Key Vault in the HTTP-request flow

Load secrets from Key Vault at application startup instead of during each HTTP request. Key Vault is intended for securely storing and retrieving sensitive data during deployment. High-frequency access within HTTP requests can exceed Key Vault's throughput capabilities, leading to request limitations and HTTP status code 429 errors. For more information, see [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions).

#### Use one method to access secrets in Key Vault

When configuring a web app to access secrets in Key Vault, you have two primary options:

- *App Service App setting:* Use an app setting in App Service to inject the secret directly as an [environment variable](/azure/app-service/app-service-key-vault-references#azure-resource-manager-deployment).

- *Direct secret reference:* Directly reference the secret within your application code. Add a specific reference in your application's properties file, such as `application.properties` for Java applications, so your app to communicate with Key Vault.

It's important to choose one of these methods and stick with it for simplicity and to avoid unnecessary complexity. For integrating Key Vault with a Spring application, the process involves:

1. Add the Azure Spring Boot Starter for Azure Key Vault Secrets dependency in your pom.xml file.
2. Configure a Key Vault endpoint in your application. This can be done either through the application.properties file or as an environment variable.

*Example:* The reference implementation uses an app setting in App Service and injects secrets.

### Use private endpoints

Use private endpoints in all production environments for all supported Azure services. Private endpoints provide private connections between resources in an Azure virtual network and Azure services. By default, communication to most Azure services crosses the public internet. Private endpoints don't require any code changes, app configurations, or connection strings. For more information, see [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario) and [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints).

*Example:* The reference implementation uses private endpoints for Key Vault, Azure Cache for Redis, and Azure Database for PostgreSQL.

### Use a web application firewall

All inbound internet traffic to the web app must pass through a web application firewall to protect against common web exploits. Force all inbound internet traffic to pass through the public load balancer, if you have one, and the web application firewall. You can (1) [use Azure Front Door private endpoint](/azure/frontdoor/private-link), or (2) you can filter requests by the `X-Azure-FDID` header value. 

The App Service platform and Java Spring can filter by header value. You should use App Service as the first option. Filtering at the platform level prevents unwanted requests from reaching your code. You need to configure what traffic you want to pass through your web application firewall. You can filter based on the host name, client IP, and other values. For more information, see [Preserve the original HTTP host name.](/azure/architecture/best-practices/host-name-preservation)

*Example:* The reference implementation uses a private endpoint in the production environment and the `X-Azure-FDID` header value in the development environment.

### Configure database security

Administrator-level access to the database grants permissions to perform privileged operations. Privileged operations include creating and deleting databases, modifying table schemas, or changing user permissions. Developers often need administrator-level access to maintain the database or troubleshoot issues.

- *Avoid permanent elevated permissions.* Grant the developers just-in-time access to perform privileged operations. With just-in-time access, users receive temporary permissions to perform privileged tasks.

- *Don't give application elevated permissions.* Don't grant administrator-level access to the application identity. Configure least-privileged access for the application to the database. It limits the blast radius of bugs and security breaches. You have two primary methods to access the Azure PostgreSQL database. You can use Microsoft Entra authentication or PostgreSQL authentication. For more information, see [JDBC with Azure PostgreSQL](/azure/developer/java/spring-framework/configure-spring-data-jdbc-with-azure-postgresql).

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and management overhead. For more information, see the [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist). The Reliable Web App pattern implements rightsizing techniques, autoscaling, and efficient resource usage for a more cost optimized web app.

### Rightsize resources for each environment

Understand the different performance tiers of Azure services and only use the appropriate SKU for the needs of each environment. Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. Nonproduction environments typically don't need the same capabilities. For extra savings, consider [Azure Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview), [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans for compute](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

*Example:* The reference implementation doesn't use Azure Dev/Test pricing since Azure Dev/Test pricing didn't cover any of the components. Azure Database for PostgreSQL is a prime candidate for a reserved instance based on the plan to stick with this database engine for at least a year after this initial convergence on the cloud phase. The reference implementation has an optional parameter that deploys different SKUs. An environment parameter instructs the Terraform template to select development SKUs. The following code shows this environment parameter.

```azurecli
azd env set APP_ENVIRONMENT prod
```

Contoso Fiber uses infrastructure-as-code (IaC) templates for development and production deployments. The development environment is cost-optimized, using the least expensive SKUs necessary for app development. The production environment uses SKUs that meet the application's production service level objective requirements.

### Use autoscale

Autoscale automates horizontal scaling for production environments. Autoscale based on performance metrics. CPU utilization performance triggers are a good starting point if you don't understand the scaling criteria of your application. You need to configure and adapt scaling triggers (CPU, RAM, network, and disk) to correspond to the behavior of your web application. Don't scale vertically to meet frequent changes in demand. It's less cost efficient. For more information, see [Scaling in Azure App Service](/azure/app-service/manage-scale-up) and [Autoscale in Microsoft Azure](/azure/azure-monitor/autoscale/autoscale-overview).

### Use resources efficiently

Efficient resource usage involves the strategic management and allocation of cloud resources to meet organizational needs without waste. It minimizes unnecessary resource expenditure and management overhead. To improve resource efficiency, follow these recommendations:

- *Use shared services.* Centralizing and sharing certain resources provides cost optimization and lower management overhead. For example, place shared network resources in the hub virtual network.

- *Delete unused environments.* Delete nonproduction environments after hours or during holidays to optimize cost. You can use infrastructure as code to delete Azure resources and entire environments. Remove the declaration of the resource that you want to delete from your infrastructure-as-code template. Back up data you need later. Understand the dependencies on the resource you're deleting. If there are dependencies, you might need to update or remove those resources as well.

- *Colocate functionality.* Where there's spare capacity, colocate application resources and functionality on a single Azure resource. For example, multiple web apps can use a single server (App Service Plan) or a single cache can support multiple data types.

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see the [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist). The Reliable Web App pattern implements infrastructure as code for infrastructure deployments and monitoring for observability.

### Configure monitoring

For tracing and debugging, you should enable logging to diagnose when any request fails. The telemetry you gather from your application should cater to its operational needs. At a minimum, you must collect telemetry on baseline metrics. You should gather information on user behavior that can help you apply targeted improvements.

#### Monitor baseline metrics

The workload should monitor baseline metrics. Important metrics to measure include request throughput, average request duration, errors, and monitoring dependencies. We recommend that you use Application Insights to gather this telemetry.

*Example:* The reference implementation uses Application Insights. Application Insights is enabled through Terraform as part of the App Service's app_settings configuration.

```terraform
app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    ...
}
```

Spring Boot registers several core metrics in Application Insights such as Java virtual machine (JVM), CPU, Tomcat, and others. Application Insights automatically collects from logging frameworks such as Log4j and Logback. For more information, see:

- [Configure Azure Monitor Application Insights for Spring Boot](/azure/azure-monitor/app/java-spring-boot#enabling-programmatically)
- [Configuration options - Azure Monitor Application Insights for Java - Azure Monitor](/azure/azure-monitor/app/java-standalone-config#auto-collected-logging)
- [Enable Azure Monitor OpenTelemetry for Java applications](https://learn.microsoft.com/azure/azure-monitor/app/java-in-process-agent)
- [Using Azure Monitor Application Insights with Spring Boot](https://learn.microsoft.com/azure/azure-monitor/app/java-spring-boot).

#### Create custom telemetry and metrics as needed

In addition to the baseline metrics in Application Insights, you should create custom telemetry to better understand your users and their interactions with your application. Application Insights allows you to gather custom telemetry, and you can also collect custom metrics through Micrometer. The goal is to gain deeper insights into your application's performance and user behavior, so you can make more informed decisions and improvements.

#### Gather log-based metrics

Track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. For more information, see [Azure Application Insights log-based metrics](/azure/azure-monitor/essentials/app-insights-metrics) and [Log-based and preaggregated metrics in Application Insights](/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics).

#### Enable platform diagnostics

A diagnostic setting in Azure allows you to specify the platform logs and metrics you want to collect and where to store them. Platform logs are built-in logs that provide diagnostic and auditing information. You can enable platform diagnostics for most Azure services, but each service defines its own log categories. Different Azure services have log categories to choose.

- *Enable diagnostics for all supported services.* Azure services create platform logs automatically, but the service doesn't store them automatically. You must enable the diagnostic setting for each service, and you should enable it for every Azure service that supports diagnostics.

- *Send diagnostics to same destination as the application logs.* When you enable diagnostics, you pick the logs you want to collect and where to send them. You should send the platform logs to the same destination as the application logs so you can correlate the two datasets.

*Example:* The reference implementation uses Terraform to enable Azure diagnostics on all supported services. The following Terraform code configures the diagnostic settings for the App Service.

```terraform
# Configure Diagnostic Settings for App Service
resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostic" {
  name                           = "app-service-diagnostic-settings"
  target_resource_id             = azurerm_linux_web_app.application.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  #log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category_group = "allLogs"

  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
```

### Use a CI/CD pipeline

To automate your deployments, integrate a continuous integration/continuous deployment (CI/CD) pipeline. This automation should extend from source control directly to your various App Service environments, including test, staging, and production. Utilize Azure Pipelines if you're working with Azure DevOps or GitHub Actions for GitHub projects.

- *Integrate unit testing.* Prioritize the execution and passing of all unit tests (using JUnit) within your pipeline before any deployment to App Services. Incorporate code quality and coverage tools like SonarQube and JaCoCo to achieve comprehensive testing coverage.

- *Adopt Java mocking framework.* For testing involving external endpoints, utilize Java mocking frameworks (Mockito, EasyMock). These frameworks allow you to create simulated endpoints. They eliminate the need to configure real external endpoints and ensuring uniform testing conditions across environments.

- *Perform security scans.* Employ static application security testing (SAST) to find security flaws and coding errors in your source code. Additionally, conduct software composition analysis (SCA) to examine third-party libraries and components for security risks. Tools for these analyses are readily integrated into both GitHub and Azure DevOps.

#### Govern production deployments

You need to establish guidelines for deploying code to production and create an approval process for all production deployments.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see the [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist). The Reliable Web App pattern uses the Cache-Aside pattern to minimize the latency for highly requested data.

### Use the Cache-Aside pattern

The [Cache-Aside pattern](/azure/architecture/patterns/cache-aside) is a caching strategy that improves in-memory data management. The pattern assigns the application the responsibility of handling data requests and ensuring consistency between the cache and a persistent storage, such as a database. When the web app receives a data request, it first searches the cache. If the data is missing, it retrieves it from the database, responds to the request, and updates the cache accordingly. This approach shortens response times and enhances throughput and reduces the need for more scaling. It also bolsters service availability by reducing the load on the primary datastore and minimizing outage risks.

#### Enable caching

To enable caching, add the `spring-boot-starter-cache` package as a dependency in your `pom.xml` file. The `spring-boot-starter-cache` package configures the Redis cache with default values. You should update those values in `application.properties` file or the environment variables to meet the needs of your web app. For example, the `spring.cache.redis.time-to-live` (represented in milliseconds) determines the amount of time that data remains in the cache before eviction. You need to provide a value that meets the needs of your web app. Finally, you need to cache the required data in your code by using the `@Cacheable` annotation.

#### Cache high-need data

Prioritize caching for the most frequently accessed data. Identify key data points that drive user engagement and system performance. Implement caching strategies specifically for these areas to optimize the effectiveness of the Cache-Aside pattern, significantly reducing latency and database load. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU.

#### Keep cache data fresh

Schedule regular cache updates to sync with the latest database changes. Determine the optimal refresh rate based on data volatility and user needs. This practice ensures the application uses the Cache-Aside pattern to provide both rapid access and current information.

#### Ensure data consistency

Implement mechanisms to update the cache immediately after any database write operation. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

*Example:* The following code adds the `spring-boot-starter-cache` package as a dependency to the `pom.xml` file to enable caching.

```xml
<dependency>
    <groupid>org.springframework.boot</groupid>
    <artifactid>spring-boot-starter-cache</artifactid>
</dependency>
```

The reference implementation enables Redis in the `application.properties` file.

```java
# Redis
spring.data.redis.ssl.enabled=true
spring.session.redis.namespace=spring:session
```

The following code defines a method called `getAccountDetail`. The method retrieves the user settings associated with a given username. The `@Cacheable(value="account-details", key="#id")` annotates the `getAccountDetail`method and tells the web app to cache the user settings in a cache.

```java
    @Cacheable(value="account-details", key="#id")
    public AccountDetail getAccountDetail(Long id) {
        Optional<Account> optionalAccount = accountRepository.findById(id);
        if (optionalAccount.isEmpty()) {
            throw new IllegalArgumentException("Account ID " + id + " does not exist");
        }

        Account account = optionalAccount.get();
        AccountDetail accountDetail = mapToAccountDetail(account);

        return accountDetail;
    }
```

### Database performance

Database performance can affect the performance and scalability of an application. It's important to test the performance of your database to ensure it's optimized. Some key considerations include choosing the right cloud region, connection pooling, cache-aside pattern, and optimizing queries.

- *Test network hops.* Moving an application to the cloud can introduce extra network hops and latency to your database. You should test for extra hops that the new cloud environment introduces.

- *Establish a performance baseline.* You should use on-premises performance metrics as the initial baseline to compare application performance in the cloud.

- *Use Application Insights.* Application Insights provides detailed metrics on database queries and any JDBC interfaces. You should use it to ensure a ported database is meeting its SLAs or to find queries that you need to tune. You should never use Dynamic SQL because it creates security and performance issues.

- *Use connection pools.* You should use JDBC connection pools and fine-tune them based on the transactions per second (TPS) metrics and SLAs. You should use database performance monitoring tools to test and evaluate database performance under load.

## Next steps

Deploy the **[reference implementation](https://aka.ms/eap/rwa/java)** by following the instructions in the GitHub repository. Use the following resources to learn more about cloud best practices and migration.

**Cloud best practices.** For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). A framework to help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that you can use to improve the quality of a workload.

For applications that require a higher service level objective (SLO), see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

**Migration guidance.** The following tools and resources can help you migrate on-premises resources to Azure:

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for various database types, and tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.